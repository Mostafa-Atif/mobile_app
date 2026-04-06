// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:mobile_app/l10n/app_localizations.dart';
import 'package:mobile_app/screens/hotels/hotel_results.dart';
import 'guests_picker.dart';

class HotelSearch extends StatefulWidget {
  @override
  _HotelSearchState createState() => _HotelSearchState();
}

class _HotelSearchState extends State<HotelSearch> {
  static const Color _dark = Color(0xFF0D3B38);
  static const Color _teal = Color(0xFF1f93a0);
  static const Color _light = Color(0xFF7ECECA);

  String selectedDestination = '';
  String searchType = 'country';
  DateTime checkInDate = DateTime.now();
  DateTime checkOutDate = DateTime.now().add(Duration(days: 1));
  Map<String, List<String>> countryCityMap = {};
  List<RoomData> roomsList = [RoomData(adults: 2, children: 0)];

  @override
  void initState() {
    super.initState();
    loadDestinations();
  }

  Future<void> loadDestinations() async {
    final String jsonString = await rootBundle.loadString('assets/hotels.json');
    final List<dynamic> jsonData = json.decode(jsonString);
    Map<String, List<String>> map = {};
    for (var hotel in jsonData) {
      final country = hotel["country"]["en"].toString();
      final city = hotel["city"]["en"].toString();
      if (!map.containsKey(country)) map[country] = [];
      if (!map[country]!.contains(city)) map[country]!.add(city);
    }
    setState(() {
      countryCityMap = map;
      selectedDestination = map.keys.first;
      searchType = 'country';
    });
  }

  void showDestinationPicker(AppLocalizations l) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: BoxDecoration(
            color: _dark,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              SizedBox(height: 12),
              Container(width: 40, height: 4,
                  decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(l.whereToQuestion,
                      style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                ),
              ),
              SizedBox(height: 12),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  children: countryCityMap.entries.expand((entry) {
                    return [
                      ListTile(
                        title: Text(entry.key,
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        leading: Icon(Icons.public, color: _light),
                        onTap: () {
                          setState(() { selectedDestination = entry.key; searchType = 'country'; });
                          Navigator.pop(context);
                        },
                      ),
                      ...entry.value.map((city) => ListTile(
                        contentPadding: EdgeInsets.only(left: 32),
                        title: Text(city, style: TextStyle(color: Colors.white70, fontSize: 15)),
                        leading: Icon(Icons.location_city, color: Colors.white38, size: 20),
                        onTap: () {
                          setState(() { selectedDestination = city; searchType = 'city'; });
                          Navigator.pop(context);
                        },
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
  }

  Future<void> selectDate(BuildContext context, bool isCheckIn) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isCheckIn ? checkInDate : checkOutDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: ColorScheme.dark(primary: _teal, surface: _dark),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          checkInDate = picked;
          if (checkOutDate.isBefore(checkInDate) || checkOutDate.isAtSameMomentAs(checkInDate))
            checkOutDate = checkInDate.add(Duration(days: 1));
        } else {
          checkOutDate = picked;
        }
      });
    }
  }

  String formatDate(DateTime date) {
    List<String> months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }

  String formatGuests() {
    int totalAdults = roomsList.fold(0, (sum, r) => sum + r.adults);
    int totalChildren = roomsList.fold(0, (sum, r) => sum + r.children);
    return '${roomsList.length} ${roomsList.length > 1 ? 'Rooms' : 'Room'}, $totalAdults ${totalAdults > 1 ? 'Adults' : 'Adult'}, $totalChildren Children';
  }

  void showGuestsPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return GuestsPicker(
          initialRooms: roomsList,
          onDone: (newRooms) => setState(() => roomsList = newRooms),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_dark, _teal, _light],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(12)),
                        child: Icon(Icons.arrow_back, color: Colors.white, size: 20),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(l.searchStays,
                            style: TextStyle(color: Colors.white, fontSize: 18,
                                fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                      ),
                    ),
                    SizedBox(width: 36),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.overOneMillion, style: TextStyle(color: Colors.white60, fontSize: 13)),
                  ],
                ),
              ),

              SizedBox(height: 28),

              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(width: 40, height: 4,
                              decoration: BoxDecoration(color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(2))),
                        ),
                        SizedBox(height: 24),

                        // Destination
                        Text(l.destination,
                            style: TextStyle(fontSize: 12, color: Colors.grey[500],
                                fontWeight: FontWeight.w600, letterSpacing: 1)),
                        SizedBox(height: 8),
                        GestureDetector(
                          onTap: () => showDestinationPicker(l),
                          child: Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.grey[200]!),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(color: Color(0xFFE0F5F7),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Icon(Icons.location_on, color: _teal, size: 20),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(selectedDestination.isEmpty ? '...' : selectedDestination,
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,
                                              color: Colors.black87)),
                                      Text(searchType == 'country' ? l.entireCountry : l.cityOnly,
                                          style: TextStyle(fontSize: 12, color: _teal)),
                                    ],
                                  ),
                                ),
                                Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 20),

                        // Dates
                        Text(l.dates,
                            style: TextStyle(fontSize: 12, color: Colors.grey[500],
                                fontWeight: FontWeight.w600, letterSpacing: 1)),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => selectDate(context, true),
                                child: Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: Colors.grey[200]!),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(children: [
                                        Icon(Icons.login, size: 14, color: _teal),
                                        SizedBox(width: 4),
                                        Text(l.checkIn,
                                            style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                                      ]),
                                      SizedBox(height: 4),
                                      Text(formatDate(checkInDate),
                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,
                                              color: Colors.black87)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Icon(Icons.arrow_forward, color: Colors.grey[400], size: 18),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => selectDate(context, false),
                                child: Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: Colors.grey[200]!),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(children: [
                                        Icon(Icons.logout, size: 14, color: _teal),
                                        SizedBox(width: 4),
                                        Text(l.checkOut,
                                            style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                                      ]),
                                      SizedBox(height: 4),
                                      Text(formatDate(checkOutDate),
                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,
                                              color: Colors.black87)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 20),

                        // Guests
                        Text(l.guests,
                            style: TextStyle(fontSize: 12, color: Colors.grey[500],
                                fontWeight: FontWeight.w600, letterSpacing: 1)),
                        SizedBox(height: 8),
                        GestureDetector(
                          onTap: showGuestsPicker,
                          child: Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.grey[200]!),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(color: Color(0xFFE0F5F7),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Icon(Icons.people_outline, color: _teal, size: 20),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text(formatGuests(),
                                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600,
                                          color: Colors.black87)),
                                ),
                                Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 32),

                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => HotelResults(
                                destination: selectedDestination,
                                searchType: searchType,
                                checkIn: checkInDate,
                                checkOut: checkOutDate,
                                numRooms: roomsList.length,
                                numAdults: roomsList.fold(0, (sum, r) => sum + r.adults),
                                numChildren: roomsList.fold(0, (sum, r) => sum + r.children),
                              ),
                            ));
                          },
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 18),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [_dark, _teal]),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(color: _teal.withValues(alpha: 0.4),
                                    blurRadius: 16, offset: Offset(0, 6)),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.search, color: Colors.white, size: 22),
                                SizedBox(width: 10),
                                Text(l.searchProperties,
                                    style: TextStyle(color: Colors.white, fontSize: 16,
                                        fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}