// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app/l10n/app_localizations.dart';
import 'package:mobile_app/screens/flights/flight_results.dart';
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

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: hasError
            ? _buildError(l)
            : SingleChildScrollView(
                child: Column(
                  children: [
                    // Header
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              icon: Icon(Icons.arrow_back),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                          Center(
                            child: Text(l.searchFlights,
                                style: TextStyle(fontSize: 24,
                                    fontWeight: FontWeight.bold, color: Colors.black)),
                          ),
                        ],
                      ),
                    ),

                    // Trip type
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          _tripTypeButton(l.oneWay, 'oneway', l),
                          SizedBox(width: 12),
                          _tripTypeButton(l.roundTrip, 'roundtrip', l),
                        ],
                      ),
                    ),

                    SizedBox(height: 20),

                    loadingCities
                        ? Padding(
                            padding: EdgeInsets.symmetric(vertical: 40),
                            child: Center(child: CircularProgressIndicator()))
                        : Padding(
                            padding: EdgeInsets.all(16),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(color: Colors.grey.withValues(alpha: 0.3),
                                      spreadRadius: 2, blurRadius: 8, offset: Offset(0, 3)),
                                ],
                              ),
                              padding: EdgeInsets.all(20),
                              child: Column(children: _buildFlightFields(l)),
                            ),
                          ),

                    Padding(
                      padding: EdgeInsets.all(16),
                      child: ElevatedButton(
                        onPressed: loadingCities ? null : () => _handleSearch(l),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red, foregroundColor: Colors.white,
                          minimumSize: Size(double.infinity, 56),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(l.searchFlights,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildError(AppLocalizations l) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off, size: 60, color: Colors.grey[300]),
          SizedBox(height: 16),
          Text(l.unableToConnect,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[700])),
          SizedBox(height: 8),
          Text(l.checkConnectionRetry,
              style: TextStyle(color: Colors.grey[500], fontSize: 13),
              textAlign: TextAlign.center),
          SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: fetchCities,
            icon: Icon(Icons.refresh),
            label: Text(l.retry),
            style: ElevatedButton.styleFrom(
                shape: StadiumBorder(), backgroundColor: Colors.red, foregroundColor: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _tripTypeButton(String label, String value, AppLocalizations l) {
    bool isSelected = selectedTripType == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() {
          selectedTripType = value;
          if (value == 'oneway') returnDate = null;
        }),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.redAccent : Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(label, textAlign: TextAlign.center,
              style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 14)),
        ),
      ),
    );
  }

  List<Widget> _buildFlightFields(AppLocalizations l) {
    return [
      GestureDetector(
        onTap: () => _showCityPicker(true, l),
        child: Row(
          children: [
            Icon(Icons.flight_takeoff, color: Colors.grey, size: 28),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.from, style: TextStyle(fontSize: 14, color: Colors.grey)),
                SizedBox(height: 4),
                Text(fromCity ?? l.selectDepartureCity,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
              ],
            ),
          ],
        ),
      ),

      SizedBox(height: 16),
      Divider(color: Colors.grey[300], thickness: 1),
      SizedBox(height: 16),

      GestureDetector(
        onTap: () => _showCityPicker(false, l),
        child: Row(
          children: [
            Icon(Icons.flight_land, color: Colors.grey, size: 28),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.to, style: TextStyle(fontSize: 14, color: Colors.grey)),
                SizedBox(height: 4),
                Text(toCity ?? l.selectArrivalCity,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
              ],
            ),
          ],
        ),
      ),

      SizedBox(height: 16),
      Divider(color: Colors.grey[300], thickness: 1),
      SizedBox(height: 16),

      Row(
        children: [
          Icon(Icons.calendar_today_outlined, color: Colors.grey, size: 28),
          SizedBox(width: 16),
          Expanded(
            child: GestureDetector(
              onTap: () => _selectFlightDate(true),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l.departure, style: TextStyle(fontSize: 14, color: Colors.grey)),
                  SizedBox(height: 4),
                  Text(_formatDate(departureDate),
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                ],
              ),
            ),
          ),
          if (selectedTripType == 'roundtrip') ...[
            Icon(Icons.arrow_forward, color: Colors.grey, size: 20),
            SizedBox(width: 16),
            Expanded(
              child: GestureDetector(
                onTap: () => _selectFlightDate(false),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.returnDate, style: TextStyle(fontSize: 14, color: Colors.grey)),
                    SizedBox(height: 4),
                    Text(returnDate != null ? _formatDate(returnDate!) : l.selectDate,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,
                            color: returnDate != null ? Colors.black : Colors.grey)),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),

      SizedBox(height: 16),
      Divider(color: Colors.grey[300], thickness: 1),
      SizedBox(height: 16),

      GestureDetector(
        onTap: () => _showPassengersPicker(l),
        child: Row(
          children: [
            Icon(Icons.person_outline, color: Colors.grey, size: 28),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l.passengersAndClass, style: TextStyle(fontSize: 14, color: Colors.grey)),
                  SizedBox(height: 4),
                  Text('${adults + children + infants} ${l.passengers}, $cabinClass',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                ],
              ),
            ),
          ],
        ),
      ),
    ];
  }

  void _showCityPicker(bool isFrom, AppLocalizations l) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isFrom ? l.selectDepartureCity : l.selectArrivalCity),
        content: Container(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: cities.length,
            itemBuilder: (context, i) => ListTile(
              title: Text(cities[i]),
              onTap: () {
                setState(() { if (isFrom) fromCity = cities[i]; else toCity = cities[i]; });
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectFlightDate(bool isDeparture) async {
    DateTime initialDate = isDeparture ? departureDate : (returnDate ?? departureDate.add(Duration(days: 1)));
    DateTime firstDate = isDeparture ? DateTime.now() : departureDate.add(Duration(days: 1));
    if (initialDate.isBefore(firstDate)) initialDate = firstDate;

    final DateTime? picked = await showDatePicker(
      context: context, initialDate: initialDate,
      firstDate: firstDate, lastDate: DateTime(2030),
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

  void _showPassengersPicker(AppLocalizations l) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: EdgeInsets.all(20),
          height: 500,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(l.passengers, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  IconButton(icon: Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                ],
              ),
              SizedBox(height: 20),
              _passengerCounter(l.adults, l.age12Plus, adults,
                  () => setModalState(() => adults > 1 ? adults-- : null),
                  () => setModalState(() => adults++)),
              Divider(height: 30),
              _passengerCounter(l.children, l.age211, children,
                  () => setModalState(() => children > 0 ? children-- : null),
                  () => setModalState(() => children++)),
              Divider(height: 30),
              _passengerCounter(l.infants, l.underTwo, infants,
                  () => setModalState(() => infants > 0 ? infants-- : null),
                  () => setModalState(() => infants < adults ? infants++ : null)),
              SizedBox(height: 20),
              Text(l.cabinClass, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Wrap(
                spacing: 10,
                children: cabinClasses.map((c) {
                  bool isSelected = cabinClass == c;
                  return ChoiceChip(
                    label: Text(c), selected: isSelected,
                    onSelected: (_) => setModalState(() => cabinClass = c),
                    selectedColor: Colors.redAccent,
                    labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                  );
                }).toList(),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () { setState(() {}); Navigator.pop(context); },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: Text(l.done, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _passengerCounter(String label, String subtitle, int value,
      VoidCallback onDec, VoidCallback onInc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            Text(subtitle, style: TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
        Row(
          children: [
            IconButton(icon: Icon(Icons.remove_circle_outline), color: Colors.green,
                iconSize: 32, onPressed: onDec),
            SizedBox(width: 40,
                child: Text('$value', textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            IconButton(icon: Icon(Icons.add_circle_outline), color: Colors.green,
                iconSize: 32, onPressed: onInc),
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
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.selectCitiesError)));
      return;
    }
    if (selectedTripType == 'roundtrip' && returnDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.selectReturnDate)));
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