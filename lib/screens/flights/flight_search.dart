// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app/l10n/app_localizations.dart';
import 'package:mobile_app/screens/flights/flight_results.dart';
import 'package:mobile_app/services/flight_translation_service.dart';
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
  int selectedCabinIndex = 0;
  Map<String, List<String>> flightCtryCityMap = {};

  List<String> cities = [];
  bool loadingCities = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    fetchCities();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _buildFlightCityMap();
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
          fromCity = sorted.isNotEmpty ? sorted[16] : null;
          toCity = sorted.length > 1 ? sorted[3] : null;
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

  void _buildFlightCityMap() async {
    String lang = Localizations.localeOf(context).languageCode;
    final jsonString = await rootBundle.loadString('data/countries.json');
    final json = jsonDecode(jsonString);
    
    flightCtryCityMap.clear();
    
    json['cities'].forEach((cityAr, data) {
      final country = lang == 'ar' ? data['country_ar'] : data['country_en'];
      final city = lang == 'ar' ? cityAr : data['city_en'];
      
      flightCtryCityMap.putIfAbsent(country, () => []).add(city);
    });
    
    setState(() {});
  }

  String formatDate(DateTime date) {
    final locale = Localizations.localeOf(context).languageCode;
    final pattern = locale == 'ar' ? 'd MMM y' : 'd MMM, y';
    return DateFormat(pattern, locale).format(date);
  }

  int get totalPassengers => adults + children + infants;

  String formatPassengers(AppLocalizations l, List<String> cabinClasses) {
    return '$totalPassengers ${totalPassengers > 1 ? l.passengers : l.passenger}, ${cabinClasses[selectedCabinIndex]}';
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

  void _handleSearch(AppLocalizations l, List<String> cabinClasses) {
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
          cabinClass: cabinClasses[selectedCabinIndex],
        ),
      ),
    );
  }

  void showCityPicker(bool isFrom, AppLocalizations l) {
    String lang = Localizations.localeOf(context).languageCode;
    // Flatten all cities from the map
    final allCities = flightCtryCityMap.values.expand((cities) => cities).toList();
    final searchController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          (isFrom ? l.from : l.to).toUpperCase(),
                          style: TextStyle(
                            color: _t.accent,
                            fontSize: 10,
                            letterSpacing: 2,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
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
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12),
                  // Search bar
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: searchController,
                      onChanged: (query) {
                        setModalState(() {
                          allCities
                              .where((city) =>
                                  city.toLowerCase().contains(query.toLowerCase()))
                              .toList();
                        });
                      },
                      decoration: InputDecoration(
                        hintText: l.searchCity,
                        prefixIcon: Icon(Icons.search, color: _t.label),
                        filled: true,
                        fillColor: _t.label.withOpacity(0.07),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      children: flightCtryCityMap.entries.expand((entry) {
                        final countryCities = entry.value
                            .where((city) =>
                                city.toLowerCase().contains(searchController.text.toLowerCase()))
                            .toList();

                        if (countryCities.isEmpty) return <Widget>[];

                        return [
                          // Country header (not tappable)
                          Padding(
                            padding: EdgeInsets.only(top: 18, bottom: 6, left: 4, right: 4),
                            child: Text(
                              entry.key.toUpperCase(),
                              style: TextStyle(
                                color: _t.label.withOpacity(0.5),
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                          // Cities under this country
                          ...countryCities.map((city) => _cityTile(
                                city: city,
                                selected: (isFrom ? fromCity : toCity) == city,
                                onTap: () {
                                  setState(() {
                                    if (isFrom)
                                      fromCity = city;
                                    else
                                      toCity = city;
                                  });
                                  Navigator.pop(context);
                                },
                                lang: lang,
                              )),
                        ];
                      }).toList(),
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
  void showPassengersPicker(AppLocalizations l, List<String> cabinClasses) {
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
                      final isSelected = cabinClasses[selectedCabinIndex] == c;
                      return GestureDetector(
                        onTap: () => setModalState(() => selectedCabinIndex = cabinClasses.indexOf(c)),
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
    String lang = Localizations.localeOf(context).languageCode;
    final List<String> cabinClasses = [
      l.economy,
      l.premiumEconomy,
      l.business,
      l.firstClass,
    ];

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
                                        title: lang == 'en' && fromCity != null
                                          ? FlightTranslationService.translateCity(fromCity!)
                                          : (fromCity ?? '...'),
                                        subtitle: l.from,
                                        onTap: () => showCityPicker(true, l),
                                        trailing: Icons.keyboard_arrow_down_rounded,
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
                                        title: lang == 'en' && toCity != null
                                          ? FlightTranslationService.translateCity(toCity!)
                                          : (toCity ?? '...'),
                                        subtitle: l.to,
                                        onTap: () => showCityPicker(false, l),
                                        trailing: Icons.keyboard_arrow_down_rounded,
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
                                        title: formatPassengers(l, cabinClasses),
                                        subtitle:
                                            '$adults ${l.adults}, $children ${l.children}, $infants ${l.infants}',
                                        onTap: () => showPassengersPicker(l, cabinClasses),
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
                                          onPressed: () => _handleSearch(l, cabinClasses),
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
    required String lang,
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
                    lang == 'en' ? FlightTranslationService.translateCity(city) : city,  // ← CHANGE THIS
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