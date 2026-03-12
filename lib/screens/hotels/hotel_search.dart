// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:mobile_app/screens/hotels/hotel_results.dart';
import 'guests_picker.dart';

class HotelSearch extends StatefulWidget {
  @override
  _HotelSearchState createState() => _HotelSearchState();
}

class _HotelSearchState extends State<HotelSearch> {
  String selectedDestination = '';
  String searchType = 'country';
  DateTime checkInDate = DateTime.now();
  DateTime checkOutDate = DateTime.now().add(Duration(days: 1));
  Map<String, List<String>> countryCityMap = {};

  List<RoomData> roomsList = [
    RoomData(adults: 2, children: 0),
  ];

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

  void showDestinationPicker() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select Destination'),
          content: Container(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: countryCityMap.entries.expand((entry) {
                return [
                  ListTile(
                    title: Text(entry.key,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    leading: Icon(Icons.public, color: Color(0xFF1f93a0)),
                    onTap: () {
                      setState(() {
                        selectedDestination = entry.key;
                        searchType = 'country';
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ...entry.value.map((city) => ListTile(
                    contentPadding: EdgeInsets.only(left: 32),
                    title: Text(city, style: TextStyle(fontSize: 15)),
                    leading: Icon(Icons.location_city, color: Colors.grey, size: 20),
                    onTap: () {
                      setState(() {
                        selectedDestination = city;
                        searchType = 'city';
                      });
                      Navigator.pop(context);
                    },
                  )),
                ];
              }).toList(),
            ),
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
    );

    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          checkInDate = picked;
          if (checkOutDate.isBefore(checkInDate) ||
              checkOutDate.isAtSameMomentAs(checkInDate)) {
            checkOutDate = checkInDate.add(Duration(days: 1));
          }
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
    return '${roomsList.length} Room${roomsList.length > 1 ? 's' : ''}, $totalAdults Adult${totalAdults > 1 ? 's' : ''}, $totalChildren Children';
  }

  void showGuestsPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return GuestsPicker(
          initialRooms: roomsList,
          onDone: (newRooms) {
            setState(() {
              roomsList = newRooms;
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
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
                    child: Column(
                      children: [
                        Text('Search stays',
                            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                        Text('Over 1M properties at your fingertips',
                            style: TextStyle(fontSize: 14, color: Colors.grey)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: showDestinationPicker,
                      child: Row(
                        children: [
                          Icon(Icons.location_on_outlined, color: Colors.grey, size: 28),
                          SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Destination',
                                  style: TextStyle(color: Colors.grey, fontSize: 14)),
                              SizedBox(height: 4),
                              Text(
                                selectedDestination.isEmpty ? 'Loading...' : selectedDestination,
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              if (selectedDestination.isNotEmpty)
                                Text(
                                  searchType == 'country' ? 'Entire country' : 'City only',
                                  style: TextStyle(fontSize: 12, color: Color(0xFF1f93a0)),
                                ),
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
                            onTap: () => selectDate(context, true),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Check in',
                                    style: TextStyle(fontSize: 14, color: Colors.grey)),
                                SizedBox(height: 4),
                                Text(formatDate(checkInDate),
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                        Icon(Icons.arrow_forward, color: Colors.grey, size: 20),
                        SizedBox(width: 16),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => selectDate(context, false),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Check out',
                                    style: TextStyle(color: Colors.grey, fontSize: 14)),
                                SizedBox(height: 4),
                                Text(formatDate(checkOutDate),
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 16),
                    Divider(color: Colors.grey[300], thickness: 1),
                    SizedBox(height: 16),

                    GestureDetector(
                      onTap: showGuestsPicker,
                      child: Row(
                        children: [
                          Icon(Icons.people_outline, color: Colors.grey, size: 28),
                          SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Guests',
                                  style: TextStyle(color: Colors.grey, fontSize: 14)),
                              SizedBox(height: 4),
                              Text(formatGuests(),
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HotelResults(
                        destination: selectedDestination,
                        searchType: searchType,
                        checkIn: checkInDate,
                        checkOut: checkOutDate,
                        numRooms: roomsList.length,
                        numAdults: roomsList.fold(0, (sum, r) => sum + r.adults),
                        numChildren: roomsList.fold(0, (sum, r) => sum + r.children),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search, size: 24),
                    SizedBox(width: 8),
                    Text('Search properties',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}