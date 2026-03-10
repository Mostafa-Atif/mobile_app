// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CarsSearch extends StatefulWidget {
  @override
  _CarsSearchState createState() => _CarsSearchState();
}

class _CarsSearchState extends State<CarsSearch> {
  List<dynamic> cars = [];
  bool isLoading = true;
  bool isSubmitting = false;
  int visibleCount = 3;

  // Selected car
  Map<String, dynamic>? selectedCar;

  // Form fields
  String? pickupLocation;
  String? dropoffLocation;
  DateTime? pickupDateTime;
  DateTime? dropoffDateTime;
  bool privateDriver = false;

  // User info from shared prefs
  String firstName = '';
  String lastName = '';
  String email = '';
  String phone = '';
  String userId = '';
  String token = '';

  final List<String> locations = [
    'Dubai',
    'Abu Dhabi',
    'Riyadh',
    'Jeddah',
    'Cairo'
  ];

  @override
  void initState() {
    super.initState();
    fetchCars();
    loadUserInfo();
  }

  Future<void> loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      firstName = prefs.getString('firstName') ?? '';
      lastName = prefs.getString('lastName') ?? '';
      email = prefs.getString('email') ?? '';
      phone = prefs.getString('phone') ?? '';
      userId = prefs.getString('userId') ?? '';
      token = prefs.getString('token') ?? '';
    });
  }

  Future<void> fetchCars() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:5000/api/cars'));
      if (response.statusCode == 200) {
        setState(() {
          cars = json.decode(response.body);
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching cars: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> _pickDateTime(bool isPickup) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null) return;

    final combined =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);
    setState(() {
      if (isPickup)
        pickupDateTime = combined;
      else
        dropoffDateTime = combined;
    });
  }

  String _formatDateTime(DateTime? dt) {
    if (dt == null) return 'Select date & time';
    return '${dt.day}/${dt.month}/${dt.year} at ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  int get totalDays {
    if (pickupDateTime == null || dropoffDateTime == null) return 0;
    return dropoffDateTime!.difference(pickupDateTime!).inDays;
  }

  Future<void> _submitBooking() async {
    if (selectedCar == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please select a car first')));
      return;
    }
    if (pickupLocation == null || dropoffLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Please select pickup and dropoff locations')));
      return;
    }
    if (pickupDateTime == null || dropoffDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Please select pickup and dropoff date & time')));
      return;
    }
    if (dropoffDateTime!.isBefore(pickupDateTime!)) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Dropoff must be after pickup')));
      return;
    }
    if (token.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please sign in first')));
      return;
    }

    setState(() => isSubmitting = true);

    try {
      final pricePerDay = (selectedCar!['pricePerDay'] ?? 0).toDouble();
      final driverCost = privateDriver ? totalDays * 100.0 : 0.0;
      final totalPrice = (pricePerDay * totalDays) + driverCost;

      final response = await http.post(
        Uri.parse('http://localhost:5000/api/car-bookings'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'carId': selectedCar!['_id'],
          'pickupLocation': pickupLocation,
          'dropoffLocation': dropoffLocation,
          'pickupDateTime': pickupDateTime!.toIso8601String(),
          'dropoffDateTime': dropoffDateTime!.toIso8601String(),
          'privateDriver': privateDriver,
          'lang': 'en',
        }),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Booking confirmed! 🎉'),
              backgroundColor: Colors.green),
        );
        // Reset form
        setState(() {
          selectedCar = null;
          pickupLocation = null;
          dropoffLocation = null;
          pickupDateTime = null;
          dropoffDateTime = null;
          privateDriver = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Booking failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }

    setState(() => isSubmitting = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Car Rent',
          style: TextStyle(
            color: Colors.black,
            fontSize: 26,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            fontFamily: 'serif',
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Rent a car at the best rates',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text(
                      'Tap a car to select it, then fill in the booking details below',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                ],
              ),
            ),

            // Cars list
            isLoading
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(child: CircularProgressIndicator()))
                : cars.isEmpty
                    ? Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                            child: Text('No cars available',
                                style: TextStyle(color: Colors.grey))))
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: visibleCount.clamp(0, cars.length),
                        itemBuilder: (context, index) {
                          final car = cars[index];
                          final isSelected = selectedCar != null &&
                              selectedCar!['_id'] == car['_id'];
                          return GestureDetector(
                            onTap: () => setState(() => selectedCar = car),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Color(0xFFE8F5E9)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.green
                                        : Colors.grey[300]!,
                                    width: isSelected ? 2 : 1,
                                  ),
                                ),
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(car['name'] ?? '',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        if (isSelected)
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 4),
                                            decoration: BoxDecoration(
                                                color: Colors.green,
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: Text('Selected',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                      ],
                                    ),
                                    SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Icon(Icons.person_outline,
                                            size: 24, color: Colors.grey[700]),
                                        SizedBox(width: 8),
                                        Text('${car['seats'] ?? '-'}',
                                            style: TextStyle(fontSize: 16)),
                                        SizedBox(width: 24),
                                        Icon(Icons.work_outline,
                                            size: 24, color: Colors.grey[700]),
                                        SizedBox(width: 8),
                                        Text('${car['bags'] ?? '-'}',
                                            style: TextStyle(fontSize: 16)),
                                        SizedBox(width: 24),
                                        Icon(Icons.settings,
                                            size: 24, color: Colors.grey[700]),
                                        SizedBox(width: 8),
                                        Text(car['transmission'] ?? '-',
                                            style: TextStyle(fontSize: 16)),
                                        Spacer(),
                                        car['image'] != null
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.network(
                                                    car['image'],
                                                    width: 100,
                                                    height: 60,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (_, __,
                                                            ___) =>
                                                        Container(
                                                          width: 100,
                                                          height: 60,
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .blue[50],
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8)),
                                                          child: Icon(
                                                              Icons
                                                                  .directions_car,
                                                              size: 45,
                                                              color: Colors
                                                                  .blue[400]),
                                                        )))
                                            : Container(
                                                width: 100,
                                                height: 60,
                                                decoration: BoxDecoration(
                                                    color: Colors.blue[50],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                                child: Icon(
                                                    Icons.directions_car,
                                                    size: 45,
                                                    color: Colors.blue[400]),
                                              ),
                                      ],
                                    ),
                                    SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Text(car['brand'] ?? '',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey[700])),
                                        Spacer(),
                                        Column(children: [
                                          Text('Per day',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey)),
                                          Text('﷼ ${car['pricePerDay']}',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold)),
                                        ]),
                                        SizedBox(width: 32),
                                        Column(children: [
                                          Text('Per week',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey)),
                                          Text(
                                              '﷼ ${(car['pricePerDay'] * 7).toStringAsFixed(0)}',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold)),
                                        ]),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Text('*The prices are inclusive of VAT',
                                        style: TextStyle(
                                            fontSize: 11, color: Colors.grey)),
                                    SizedBox(height: 16),
                                    Divider(color: Colors.grey[300]),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),

            // Show more button
            if (!isLoading && visibleCount < cars.length)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: OutlinedButton(
                  onPressed: () => setState(() => visibleCount += 7),
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28)),
                    side: BorderSide(color: Colors.red),
                    foregroundColor: Colors.red,
                  ),
                  child: Text('Show more',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),

            SizedBox(height: 24),

            // ── Booking Form ──
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Booking Details',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),

                  // Selected car indicator
                  if (selectedCar != null)
                    Container(
                      margin: EdgeInsets.only(top: 8, bottom: 16),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.green),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.directions_car, color: Colors.green),
                          SizedBox(width: 10),
                          Text(
                              '${selectedCar!['name']} — ﷼${selectedCar!['pricePerDay']}/day',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[800])),
                          Spacer(),
                          GestureDetector(
                            onTap: () => setState(() => selectedCar = null),
                            child: Icon(Icons.close,
                                color: Colors.green, size: 18),
                          ),
                        ],
                      ),
                    )
                  else
                    Padding(
                      padding: EdgeInsets.only(top: 8, bottom: 16),
                      child: Text('↑ Select a car from the list above',
                          style: TextStyle(color: Colors.grey, fontSize: 13)),
                    ),

                  // Pickup location
                  Text('Pickup location',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8)),
                    child: DropdownButtonFormField<String>(
                      value: pickupLocation,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12)),
                      hint: Text('Select location'),
                      items: locations
                          .map(
                              (l) => DropdownMenuItem(value: l, child: Text(l)))
                          .toList(),
                      onChanged: (val) => setState(() => pickupLocation = val),
                    ),
                  ),

                  SizedBox(height: 20),

                  // Dropoff location
                  Text('Dropoff location',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8)),
                    child: DropdownButtonFormField<String>(
                      value: dropoffLocation,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12)),
                      hint: Text('Select location'),
                      items: locations
                          .map(
                              (l) => DropdownMenuItem(value: l, child: Text(l)))
                          .toList(),
                      onChanged: (val) => setState(() => dropoffLocation = val),
                    ),
                  ),

                  SizedBox(height: 20),

                  // Pickup date & time
                  Text('Pickup date & time',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: () => _pickDateTime(true),
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      side: BorderSide(color: Colors.grey[300]!),
                      foregroundColor:
                          pickupDateTime != null ? Colors.black : Colors.grey,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(_formatDateTime(pickupDateTime)),
                    ),
                  ),

                  SizedBox(height: 20),

                  // Dropoff date & time
                  Text('Dropoff date & time',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: () => _pickDateTime(false),
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      side: BorderSide(color: Colors.grey[300]!),
                      foregroundColor:
                          dropoffDateTime != null ? Colors.black : Colors.grey,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(_formatDateTime(dropoffDateTime)),
                    ),
                  ),

                  SizedBox(height: 20),

                  // Total days
                  if (totalDays > 0)
                    Text('Total: $totalDays day${totalDays != 1 ? 's' : ''}',
                        style:
                            TextStyle(color: Colors.grey[600], fontSize: 13)),

                  SizedBox(height: 20),

                  // Private driver
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8)),
                    child: SwitchListTile(
                      title: Text('Private driver',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                      subtitle: Text('Extra ﷼100/day',
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                      value: privateDriver,
                      onChanged: (val) => setState(() => privateDriver = val),
                      activeColor: Colors.red,
                    ),
                  ),

                  SizedBox(height: 20),

                  // Price summary
                  if (selectedCar != null && totalDays > 0)
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey[200]!)),
                      child: Column(
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Car rental (${totalDays} days)'),
                                Text(
                                    '﷼ ${(selectedCar!['pricePerDay'] * totalDays).toStringAsFixed(0)}'),
                              ]),
                          if (privateDriver) ...[
                            SizedBox(height: 8),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Private driver'),
                                  Text(
                                      '﷼ ${(totalDays * 100).toStringAsFixed(0)}'),
                                ]),
                          ],
                          Divider(),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Total',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                                Text(
                                    '﷼ ${((selectedCar!['pricePerDay'] * totalDays) + (privateDriver ? totalDays * 100 : 0)).toStringAsFixed(0)}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.red)),
                              ]),
                        ],
                      ),
                    ),

                  SizedBox(height: 24),

                  // Submit button
                  ElevatedButton(
                    onPressed: isSubmitting ? null : _submitBooking,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28)),
                      elevation: 2,
                    ),
                    child: isSubmitting
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text('Confirm Booking',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                  ),

                  SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
