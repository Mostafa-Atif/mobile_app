// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app/l10n/app_localizations.dart';
import 'package:mobile_app/screens/flights/flight_results.dart';
import 'package:mobile_app/theme.dart';
import '../../config.dart';

class FlightSearch extends StatefulWidget {
  @override
  _FlightSearchState createState() => _FlightSearchState();
}

class _FlightSearchState extends State<FlightSearch> {
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

  List<String> cabinClasses = ['Economy', 'Premium Economy', 'Business', 'First Class'];

  @override
  void initState() {
    super.initState();
    fetchCities();
  }

  Future<void> fetchCities() async {
    setState(() { loadingCities = true; hasError = false; });
    try {
      final response = await http.get(Uri.parse('${Config.baseUrl}/api/flights'));
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
        setState(() { loadingCities = false; hasError = true; });
      }
    } catch (e) {
      setState(() { loadingCities = false; hasError = true; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final t = Theme.of(context).extension<AppThemeExtension>()!;

    return Scaffold(
      backgroundColor: t.bg,
      body: SafeArea(
        child: hasError
            ? _buildError(l, t)
            : SingleChildScrollView(
                child: Column(
                  children: [
                    // Header
                    _buildHeader(context, l, t),

                    const SizedBox(height: 8),

                    // Trip type
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          _tripTypeButton(l.oneWay, 'oneway', t),
                          const SizedBox(width: 10),
                          _tripTypeButton(l.roundTrip, 'roundtrip', t),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    loadingCities
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 60),
                            child: Center(child: CircularProgressIndicator(color: t.accent)),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Container(
                              decoration: BoxDecoration(
                                color: t.card,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: t.cardBorder.withOpacity(0.5)),
                                boxShadow: [
                                  BoxShadow(
                                    color: t.cardBorder.withOpacity(0.2),
                                    blurRadius: 16,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(20),
                              child: Column(children: _buildFlightFields(l, t)),
                            ),
                          ),

                    const SizedBox(height: 24),

                    // Search button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GestureDetector(
                        onTap: loadingCities ? null : () => _handleSearch(l),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: t.btnGradient,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: t.accent.withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Text(
                            l.searchFlights,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l, AppThemeExtension t) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 12, 20, 8),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: t.backIcon),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Text(
              l.searchFlights,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: t.title,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildError(AppLocalizations l, AppThemeExtension t) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off, size: 60, color: t.label),
          const SizedBox(height: 16),
          Text(l.unableToConnect,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: t.title)),
          const SizedBox(height: 8),
          Text(l.checkConnectionRetry,
              style: TextStyle(color: t.label, fontSize: 13), textAlign: TextAlign.center),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: fetchCities,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: t.btnGradient),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.refresh, color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Text(l.retry, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tripTypeButton(String label, String value, AppThemeExtension t) {
    bool isSelected = selectedTripType == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() {
          selectedTripType = value;
          if (value == 'oneway') returnDate = null;
        }),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? t.accent : t.card,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: isSelected ? t.accent : t.cardBorder.withOpacity(0.5)),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : t.label,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFlightFields(AppLocalizations l, AppThemeExtension t) {
    return [
      _fieldRow(
        icon: Icons.flight_takeoff_rounded,
        label: l.from,
        value: fromCity ?? l.selectDepartureCity,
        onTap: () => _showCityPicker(true, l, t),
        t: t,
        hasValue: fromCity != null,
      ),

      _divider(t),

      _fieldRow(
        icon: Icons.flight_land_rounded,
        label: l.to,
        value: toCity ?? l.selectArrivalCity,
        onTap: () => _showCityPicker(false, l, t),
        t: t,
        hasValue: toCity != null,
      ),

      _divider(t),

      // Dates row
      Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: t.accentLight, borderRadius: BorderRadius.circular(10)),
            child: Icon(Icons.calendar_today_outlined, color: t.accent, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: GestureDetector(
              onTap: () => _selectFlightDate(true),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l.departure, style: TextStyle(fontSize: 12, color: t.label)),
                  const SizedBox(height: 2),
                  Text(_formatDate(departureDate),
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: t.title)),
                ],
              ),
            ),
          ),
          if (selectedTripType == 'roundtrip') ...[
            Icon(Icons.arrow_forward, color: t.label, size: 18),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () => _selectFlightDate(false),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.returnDate, style: TextStyle(fontSize: 12, color: t.label)),
                    const SizedBox(height: 2),
                    Text(
                      returnDate != null ? _formatDate(returnDate!) : l.selectDate,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: returnDate != null ? t.title : t.label,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),

      _divider(t),

      GestureDetector(
        onTap: () => _showPassengersPicker(l, t),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: t.accentLight, borderRadius: BorderRadius.circular(10)),
              child: Icon(Icons.person_outline, color: t.accent, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l.passengersAndClass, style: TextStyle(fontSize: 12, color: t.label)),
                  const SizedBox(height: 2),
                  Text(
                    '${adults + children + infants} ${l.passengers}, $cabinClass',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: t.title),
                  ),
                ],
              ),
            ),
            Icon(Icons.keyboard_arrow_down, color: t.label),
          ],
        ),
      ),
    ];
  }

  Widget _fieldRow({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
    required AppThemeExtension t,
    required bool hasValue,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: t.accentLight, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: t.accent, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 12, color: t.label)),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: hasValue ? t.title : t.label,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.keyboard_arrow_down, color: t.label),
        ],
      ),
    );
  }

  Widget _divider(AppThemeExtension t) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Divider(color: t.divider, thickness: 1, height: 1),
    );
  }

  void _showCityPicker(bool isFrom, AppLocalizations l, AppThemeExtension t) {
    showModalBottomSheet(
      context: context,
      backgroundColor: t.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isFrom ? l.selectDepartureCity : l.selectArrivalCity,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: t.title),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: t.label),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Divider(color: t.divider),
          Expanded(
            child: ListView.builder(
              itemCount: cities.length,
              itemBuilder: (context, i) => ListTile(
                leading: Icon(Icons.location_on_outlined, color: t.accent, size: 20),
                title: Text(cities[i], style: TextStyle(color: t.title, fontSize: 14)),
                onTap: () {
                  setState(() { if (isFrom) fromCity = cities[i]; else toCity = cities[i]; });
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectFlightDate(bool isDeparture) async {
    DateTime initialDate = isDeparture ? departureDate : (returnDate ?? departureDate.add(Duration(days: 1)));
    DateTime firstDate = isDeparture ? DateTime.now() : departureDate.add(Duration(days: 1));
    if (initialDate.isBefore(firstDate)) initialDate = firstDate;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        if (isDeparture) {
          departureDate = picked;
          if (returnDate != null && returnDate!.isBefore(departureDate))
            returnDate = departureDate.add(Duration(days: 1));
        } else {
          returnDate = picked;
        }
      });
    }
  }

  void _showPassengersPicker(AppLocalizations l, AppThemeExtension t) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: t.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: const EdgeInsets.all(20),
          height: 500,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(l.passengers, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: t.title)),
                  IconButton(icon: Icon(Icons.close, color: t.label), onPressed: () => Navigator.pop(context)),
                ],
              ),
              const SizedBox(height: 16),
              _passengerCounter(l.adults, l.age12Plus, adults, t,
                  () => setModalState(() => adults > 1 ? adults-- : null),
                  () => setModalState(() => adults++)),
              Divider(color: t.divider, height: 30),
              _passengerCounter(l.children, l.age211, children, t,
                  () => setModalState(() => children > 0 ? children-- : null),
                  () => setModalState(() => children++)),
              Divider(color: t.divider, height: 30),
              _passengerCounter(l.infants, l.underTwo, infants, t,
                  () => setModalState(() => infants > 0 ? infants-- : null),
                  () => setModalState(() => infants < adults ? infants++ : null)),
              const SizedBox(height: 20),
              Text(l.cabinClass, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: t.title)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: cabinClasses.map((c) {
                  bool isSelected = cabinClass == c;
                  return GestureDetector(
                    onTap: () => setModalState(() => cabinClass = c),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? t.accent : t.accentLight,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(c, style: TextStyle(
                        color: isSelected ? Colors.white : t.accent,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        fontSize: 13,
                      )),
                    ),
                  );
                }).toList(),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () { setState(() {}); Navigator.pop(context); },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: t.btnGradient),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(l.done, textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _passengerCounter(String label, String subtitle, int value, AppThemeExtension t,
      VoidCallback onDec, VoidCallback onInc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: t.title)),
            Text(subtitle, style: TextStyle(fontSize: 13, color: t.label)),
          ],
        ),
        Row(
          children: [
            GestureDetector(
              onTap: onDec,
              child: Container(
                width: 32, height: 32,
                decoration: BoxDecoration(
                  color: t.accentLight,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.remove, color: t.accent, size: 18),
              ),
            ),
            SizedBox(
              width: 40,
              child: Text('$value', textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: t.title)),
            ),
            GestureDetector(
              onTap: onInc,
              child: Container(
                width: 32, height: 32,
                decoration: BoxDecoration(
                  color: t.accentLight,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.add, color: t.accent, size: 18),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    List<String> months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }

  void _handleSearch(AppLocalizations l) {
    if (fromCity == null || toCity == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.selectCitiesError)));
      return;
    }
    if (selectedTripType == 'roundtrip' && returnDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.selectReturnDate)));
      return;
    }

    Navigator.push(context, MaterialPageRoute(
      builder: (context) => FlightResults(
        fromCity: fromCity!,
        toCity: toCity!,
        tripType: selectedTripType == 'oneway' ? 'One-way' : 'Round trip',
        departureDate: departureDate,
        returnDate: selectedTripType == 'roundtrip' ? returnDate : null,
        passengers: adults + children + infants,
        cabinClass: cabinClass,
      ),
    ));
  }
}