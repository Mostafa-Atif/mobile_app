// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app/l10n/app_localizations.dart';
import 'package:mobile_app/screens/flights/flight_results.dart';
import 'package:mobile_app/theme.dart';
import '../../config.dart';

class FlightSearch extends StatefulWidget {
  const FlightSearch({super.key});

  @override
  _FlightSearchState createState() => _FlightSearchState();
}

class _FlightSearchState extends State<FlightSearch> {
  AppThemeExtension get _t => Theme.of(context).extension<AppThemeExtension>()!;

  String selectedTripType = 'oneway';
  String? fromCity;
  String? toCity;
  DateTime departureDate = DateTime.now().add(Duration(days: 1));
  DateTime? returnDate;
  int adults = 1;
  int children = 0;
  int infants = 0;
  String cabinClass = 'Economy';

  List<String> cities = [];
  bool loadingCities = true;
  bool hasError = false;

  final List<String> cabinClasses = [
    'Economy',
    'Premium Economy',
    'Business',
    'First Class',
  ];

  @override
  void initState() {
    super.initState();
    fetchCities();
  }

  Future<void> fetchCities() async {
    setState(() {
      loadingCities = true;
      hasError = false;
    });
    try {
      final response =
          await http.get(Uri.parse('${Config.baseUrl}/api/flights'));
      if (response.statusCode == 200) {
        final List<dynamic> flights = json.decode(response.body);
        final Set<String> citySet = {};
        for (var flight in flights) {
          if (flight['fromCity'] != null) citySet.add(flight['fromCity']);
          if (flight['toCity'] != null) citySet.add(flight['toCity']);
        }
        final sorted = citySet.toList()..sort();
        setState(() {
          cities = sorted;
          fromCity = sorted.isNotEmpty ? sorted.first : null;
          toCity = sorted.length > 1 ? sorted[1] : null;
          loadingCities = false;
        });
      } else {
        setState(() {
          loadingCities = false;
          hasError = true;
        });
      }
    } catch (e) {
      setState(() {
        loadingCities = false;
        hasError = true;
      });
    }
  }

  String formatDate(DateTime date) {
    final locale = Localizations.localeOf(context).languageCode;
    final pattern = locale == 'ar' ? 'd MMM y' : 'd MMM, y';
    return DateFormat(pattern, locale).format(date);
  }

  int get totalPassengers => adults + children + infants;

  String formatPassengers(AppLocalizations l) {
    return '$totalPassengers ${l.passengers}, $cabinClass';
  }

  Future<void> selectDate(BuildContext context, bool isDeparture) async {
    final DateTime initialDate = isDeparture
        ? departureDate
        : (returnDate ?? departureDate.add(Duration(days: 1)));
    final DateTime firstDate =
        isDeparture ? DateTime.now() : departureDate.add(Duration(days: 1));
    final adjusted = initialDate.isBefore(firstDate) ? firstDate : initialDate;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: adjusted,
      firstDate: firstDate,
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: _t.accent,
                surface: _t.card,
                onSurface: _t.title,
              ),
          dialogTheme: DialogThemeData(backgroundColor: _t.card),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      setState(() {
        if (isDeparture) {
          departureDate = picked;
          if (returnDate != null && !returnDate!.isAfter(departureDate)) {
            returnDate = departureDate.add(Duration(days: 1));
          }
        } else {
          returnDate = picked;
        }
      });
    }
  }

  void _handleSearch(AppLocalizations l) {
    if (fromCity == null || toCity == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l.selectCitiesError)));
      return;
    }
    if (selectedTripType == 'roundtrip' && returnDate == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l.selectReturnDate)));
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FlightResults(
          fromCity: fromCity!,
          toCity: toCity!,
          tripType: selectedTripType == 'oneway' ? 'One-way' : 'Round trip',
          departureDate: departureDate,
          returnDate: selectedTripType == 'roundtrip' ? returnDate : null,
          passengers: totalPassengers,
          cabinClass: cabinClass,
        ),
      ),
    );
  }

  void showCityPicker(bool isFrom, AppLocalizations l) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: BoxDecoration(
            color: _t.bg,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              SizedBox(height: 12),
              Container(
                width: 42,
                height: 5,
                decoration: BoxDecoration(
                  color: _t.label.withOpacity(0.35),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              SizedBox(height: 18),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (isFrom ? l.from : l.to).toUpperCase(),
                      style: TextStyle(
                        color: _t.accent,
                        fontSize: 10,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      isFrom ? l.selectDepartureCity : l.selectArrivalCity,
                      style: TextStyle(
                        color: _t.title,
                        fontSize: 28,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'DM Serif Display',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: cities.length,
                  itemBuilder: (context, i) {
                    final city = cities[i];
                    final isSelected =
                        isFrom ? fromCity == city : toCity == city;
                    return _cityTile(
                      city: city,
                      selected: isSelected,
                      onTap: () {
                        setState(() {
                          if (isFrom)
                            fromCity = city;
                          else
                            toCity = city;
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void showPassengersPicker(AppLocalizations l) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 32),
              decoration: BoxDecoration(
                color: _t.bg,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 12),
                  Container(
                    width: 42,
                    height: 5,
                    decoration: BoxDecoration(
                      color: _t.label.withOpacity(0.35),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l.passengers.toUpperCase(),
                            style: TextStyle(
                              color: _t.accent,
                              fontSize: 10,
                              letterSpacing: 2,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            l.passengersAndClass,
                            style: TextStyle(
                              color: _t.title,
                              fontSize: 28,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'DM Serif Display',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  _passengerCounterRow(
                    label: l.adults,
                    subtitle: l.age12Plus,
                    value: adults,
                    onDecrease: () {
                      if (adults > 1) setModalState(() => adults--);
                    },
                    onIncrease: () => setModalState(() => adults++),
                  ),
                  SizedBox(height: 14),
                  Divider(color: _t.cardBorder.withOpacity(0.4), height: 1),
                  SizedBox(height: 14),
                  _passengerCounterRow(
                    label: l.children,
                    subtitle: l.age211,
                    value: children,
                    onDecrease: () {
                      if (children > 0) setModalState(() => children--);
                    },
                    onIncrease: () => setModalState(() => children++),
                  ),
                  SizedBox(height: 14),
                  Divider(color: _t.cardBorder.withOpacity(0.4), height: 1),
                  SizedBox(height: 14),
                  _passengerCounterRow(
                    label: l.infants,
                    subtitle: l.underTwo,
                    value: infants,
                    onDecrease: () {
                      if (infants > 0) setModalState(() => infants--);
                    },
                    onIncrease: () {
                      if (infants < adults) setModalState(() => infants++);
                    },
                  ),
                  SizedBox(height: 20),
                  _fieldLabel(l.cabinClass),
                  SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: cabinClasses.map((c) {
                      final isSelected = cabinClass == c;
                      return GestureDetector(
                        onTap: () => setModalState(() => cabinClass = c),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 180),
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected ? _t.accent : _t.accentLight,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isSelected
                                  ? _t.accent
                                  : _t.cardBorder.withOpacity(0.4),
                            ),
                          ),
                          child: Text(
                            c,
                            style: TextStyle(
                              color: isSelected ? Colors.white : _t.accent,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 24),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: _t.btnGradient),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: _t.accent.withOpacity(0.28),
                          blurRadius: 18,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {});
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        minimumSize: Size(double.infinity, 54),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        l.done,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: _t.bg,
      body: SafeArea(
        child: hasError
            ? _buildError(l)
            : Column(
                children: [
                  // Header
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: Row(
                      children: [
                        _iconShell(
                          icon: Icons.chevron_left_rounded,
                          onTap: () => Navigator.pop(context),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                l.searchFlights,
                                style: TextStyle(
                                  color: _t.title,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                l.overOneMillion,
                                style: TextStyle(
                                  color: _t.label,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 42),
                      ],
                    ),
                  ),

                  Expanded(
                    child: loadingCities
                        ? Center(
                            child: CircularProgressIndicator(color: _t.accent),
                          )
                        : SingleChildScrollView(
                            padding: EdgeInsets.fromLTRB(16, 18, 16, 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l.searchFlights,
                                  style: TextStyle(
                                    color: _t.label,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: 18),

                                // Trip type toggle
                                Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: _t.card,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                        color: _t.cardBorder.withOpacity(0.45)),
                                  ),
                                  child: Row(
                                    children: [
                                      _tripTypeButton(l.oneWay, 'oneway'),
                                      SizedBox(width: 4),
                                      _tripTypeButton(l.roundTrip, 'roundtrip'),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 14),

                                // Main search card
                                Container(
                                  padding: EdgeInsets.all(18),
                                  decoration: BoxDecoration(
                                    color: _t.card,
                                    borderRadius: BorderRadius.circular(28),
                                    border: Border.all(
                                        color: _t.cardBorder.withOpacity(0.45)),
                                    boxShadow: _cardShadows(),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _sectionHeader(
                                          l.destination, l.searchFlights),
                                      SizedBox(height: 16),

                                      // From
                                      _searchTile(
                                        icon: Icons.flight_takeoff_rounded,
                                        title: fromCity ?? '...',
                                        subtitle: l.from,
                                        onTap: () => showCityPicker(true, l),
                                        trailing:
                                            Icons.keyboard_arrow_down_rounded,
                                      ),
                                      SizedBox(height: 10),

                                      // Swap indicator
                                      Center(
                                        child: Container(
                                          width: 36,
                                          height: 36,
                                          decoration: BoxDecoration(
                                            color: _t.accentLight,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                                color: _t.cardBorder
                                                    .withOpacity(0.45)),
                                          ),
                                          child: Icon(
                                            Icons.swap_vert_rounded,
                                            color: _t.accent,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10),

                                      // To
                                      _searchTile(
                                        icon: Icons.flight_land_rounded,
                                        title: toCity ?? '...',
                                        subtitle: l.to,
                                        onTap: () => showCityPicker(false, l),
                                        trailing:
                                            Icons.keyboard_arrow_down_rounded,
                                      ),

                                      SizedBox(height: 14),
                                      _fieldLabel(l.dates),
                                      SizedBox(height: 8),

                                      // Date row
                                      Row(
                                        children: [
                                          Expanded(
                                            child: _dateTile(
                                              label: l.departure,
                                              value: formatDate(departureDate),
                                              icon:
                                                  Icons.flight_takeoff_rounded,
                                              onTap: () =>
                                                  selectDate(context, true),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8),
                                            child: Container(
                                              width: 34,
                                              height: 34,
                                              decoration: BoxDecoration(
                                                color: _t.accentLight,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Icon(
                                                Icons.arrow_forward_rounded,
                                                color: _t.accent,
                                                size: 18,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: selectedTripType ==
                                                    'roundtrip'
                                                ? _dateTile(
                                                    label: l.returnDate,
                                                    value: returnDate != null
                                                        ? formatDate(
                                                            returnDate!)
                                                        : l.selectDate,
                                                    icon: Icons
                                                        .flight_land_rounded,
                                                    onTap: () => selectDate(
                                                        context, false),
                                                  )
                                                : _disabledDateTile(
                                                    label: l.returnDate),
                                          ),
                                        ],
                                      ),

                                      SizedBox(height: 14),
                                      _fieldLabel(l.passengersAndClass),
                                      SizedBox(height: 8),

                                      // Passengers summary
                                      _summaryTile(
                                        icon: Icons.people_alt_outlined,
                                        title: formatPassengers(l),
                                        subtitle:
                                            '$adults ${l.adults}, $children ${l.children}, $infants ${l.infants}',
                                        onTap: () => showPassengersPicker(l),
                                      ),

                                      SizedBox(height: 18),

                                      // Search button
                                      DecoratedBox(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              colors: _t.btnGradient),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  _t.accent.withOpacity(0.28),
                                              blurRadius: 18,
                                              offset: Offset(0, 8),
                                            ),
                                          ],
                                        ),
                                        child: ElevatedButton(
                                          onPressed: () => _handleSearch(l),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.transparent,
                                            shadowColor: Colors.transparent,
                                            minimumSize:
                                                Size(double.infinity, 58),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.search_rounded,
                                                  color: Colors.white,
                                                  size: 22),
                                              SizedBox(width: 10),
                                              Text(
                                                l.searchFlights,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                ],
              ),
      ),
    );
  }

  // ── Reusable Widgets (matching HotelSearch style) ──────────────────────────

  Widget _tripTypeButton(String label, String value) {
    final isSelected = selectedTripType == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() {
          selectedTripType = value;
          if (value == 'oneway') returnDate = null;
        }),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? _t.accent : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : _t.label,
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _searchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    IconData? trailing,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Ink(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _t.card,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: _t.cardBorder.withOpacity(0.45)),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: _t.accentLight,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: _t.accent),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: _t.title,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: _t.accent,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing != null) Icon(trailing, color: _t.label),
            ],
          ),
        ),
      ),
    );
  }

  Widget _summaryTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Ink(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _t.card,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: _t.cardBorder.withOpacity(0.45)),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: _t.accentLight,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: _t.accent),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: _t.title,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: _t.label,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.keyboard_arrow_down_rounded, color: _t.label),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dateTile({
    required String label,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Ink(
          padding: EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: _t.card,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: _t.cardBorder.withOpacity(0.45)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 14, color: _t.accent),
                  SizedBox(width: 4),
                  Text(
                    label,
                    style: TextStyle(
                      color: _t.label,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  color: _t.title,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _disabledDateTile({required String label}) {
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _t.card.withOpacity(0.5),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _t.cardBorder.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.flight_land_rounded,
                  size: 14, color: _t.label.withOpacity(0.4)),
              SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  color: _t.label.withOpacity(0.4),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            '—',
            style: TextStyle(
              color: _t.label.withOpacity(0.4),
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _cityTile({
    required String city,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Ink(
            padding: EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: selected ? _t.accentLight : _t.card,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: _t.cardBorder.withOpacity(0.45)),
            ),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: _t.accentLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.location_city_rounded,
                      color: _t.accent, size: 20),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    city,
                    style: TextStyle(
                      color: _t.title,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                if (selected)
                  Icon(Icons.check_circle_rounded, color: _t.accent, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _passengerCounterRow({
    required String label,
    required String subtitle,
    required int value,
    required VoidCallback onDecrease,
    required VoidCallback onIncrease,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: _t.title,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  color: _t.label,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        _counterButton(Icons.remove_rounded, onDecrease),
        SizedBox(
          width: 36,
          child: Text(
            '$value',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _t.title,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        _counterButton(Icons.add_rounded, onIncrease),
      ],
    );
  }

  Widget _counterButton(IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Ink(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: _t.accentLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 18, color: _t.accent),
        ),
      ),
    );
  }

  Widget _fieldLabel(String label) {
    return Text(
      label.toUpperCase(),
      style: TextStyle(
        color: _t.label,
        fontSize: 9,
        letterSpacing: 1.6,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _sectionHeader(String title, String subtitle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: _t.title,
            fontSize: 20,
            fontWeight: FontWeight.w400,
            fontFamily: 'DM Serif Display',
          ),
        ),
        Text(
          subtitle,
          style: TextStyle(
            color: _t.accent,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _iconShell({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        onTap: onTap,
        child: Ink(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: _t.card.withOpacity(0.9),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _t.cardBorder.withOpacity(0.25)),
          ),
          child: Icon(icon, color: _t.backIcon, size: 24),
        ),
      ),
    );
  }

  Widget _buildError(AppLocalizations l) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off_rounded, size: 60, color: _t.label),
          SizedBox(height: 16),
          Text(
            l.unableToConnect,
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: _t.title),
          ),
          SizedBox(height: 8),
          Text(
            l.checkConnectionRetry,
            style: TextStyle(color: _t.label, fontSize: 13),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: _t.btnGradient),
              borderRadius: BorderRadius.circular(20),
            ),
            child: ElevatedButton.icon(
              onPressed: fetchCities,
              icon: Icon(Icons.refresh_rounded, color: Colors.white, size: 18),
              label: Text(
                l.retry,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<BoxShadow> _cardShadows() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return [
      BoxShadow(
        color: isDark
            ? Colors.black.withOpacity(0.22)
            : _t.cardBorder.withOpacity(0.16),
        blurRadius: isDark ? 18 : 22,
        offset: Offset(0, 10),
      ),
    ];
  }
}

class SuccessScreen extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onContinue;

  const SuccessScreen({
    super.key,
    this.title = 'Success!',
    this.message = 'Your request has been completed.\nEverything is set!',
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<AppThemeExtension>()!;

    return Scaffold(
      backgroundColor: t.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // ── Circle + Check ──
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: t.successBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_rounded,
                  color: t.success,
                  size: 48,
                ),
              ),

              const SizedBox(height: 28),

              // ── Title ──
              Text(
                title,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: t.title,
                ),
              ),

              const SizedBox(height: 12),

              // ── Message ──
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: t.label,
                  height: 1.6,
                ),
              ),

              const Spacer(),

              // ── Continue Button ──
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: t.btnGradient),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: t.accent.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: onContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
