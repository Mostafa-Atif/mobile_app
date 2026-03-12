// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../config.dart';

class HotelBooking extends StatefulWidget {
  final String hotelName;
  final DateTime checkIn;
  final DateTime checkOut;
  final int numRooms;
  final int numAdults;
  final int numChildren;
  final int pricePerNight;
  final int nights;

  const HotelBooking({
    super.key,
    required this.hotelName,
    required this.checkIn,
    required this.checkOut,
    required this.numRooms,
    required this.numAdults,
    required this.numChildren,
    required this.pricePerNight,
    required this.nights,
  });

  @override
  State<HotelBooking> createState() => _HotelBookingState();
}

class _HotelBookingState extends State<HotelBooking> {
  static const Color _teal = Color(0xFF1f93a0);
  static const Color _red = Color(0xFFE84545);

  bool isSubmitting = false;
  bool summaryExpanded = false;
  String token = '';
  List<Map<String, dynamic>> guestList = [];

  @override
  void initState() {
    super.initState();
    _initGuests();
  }

  int get numPeople => widget.numAdults + widget.numChildren;
  int get totalPrice => widget.pricePerNight * widget.nights * widget.numRooms;

  Future<void> _initGuests() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';

    final List<Map<String, dynamic>> list = [
      {
        'filled': false,
        'name':
            '${prefs.getString('firstName') ?? ''} ${prefs.getString('lastName') ?? ''}'
                .trim(),
        'email': prefs.getString('email') ?? '',
        'phone': prefs.getString('phone') ?? '',
        'address': '',
      }
    ];

    for (int i = 1; i < numPeople; i++) {
      list.add({
        'filled': false,
        'name': '',
        'email': '',
        'phone': '',
        'address': ''
      });
    }

    setState(() => guestList = list);
  }

  String _formatDate(DateTime date) {
    List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  void _openGuestSheet(int index) {
    final g = Map<String, dynamic>.from(guestList[index]);
    final nameCtrl = TextEditingController(text: g['name']);
    final emailCtrl = TextEditingController(text: g['email']);
    final phoneCtrl = TextEditingController(text: g['phone']);
    final addressCtrl = TextEditingController(text: g['address']);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (sheetContext) {
        bool showError = false;
        return StatefulBuilder(
          builder: (sheetContext, setSheet) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(sheetContext).viewInsets.bottom),
              child: Container(
                height: MediaQuery.of(sheetContext).size.height * 0.75,
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Guest ${index + 1}${index == 0 ? ' (You)' : ''}',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () => Navigator.pop(sheetContext),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: 8),
                            _field(nameCtrl, 'Full name *'),
                            SizedBox(height: 12),
                            _field(emailCtrl, 'Email *',
                                keyboardType: TextInputType.emailAddress),
                            SizedBox(height: 12),
                            _field(phoneCtrl, 'Phone *',
                                keyboardType: TextInputType.phone),
                            SizedBox(height: 12),
                            _field(addressCtrl, 'Address'),
                            SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                    if (showError)
                      Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                          'Please fill in all required fields',
                          style: TextStyle(color: Colors.red, fontSize: 13),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (nameCtrl.text.isEmpty ||
                              emailCtrl.text.isEmpty ||
                              phoneCtrl.text.isEmpty) {
                            setSheet(() => showError = true);
                            return;
                          }
                          setState(() {
                            guestList[index] = {
                              'filled': true,
                              'name': nameCtrl.text.trim(),
                              'email': emailCtrl.text.trim(),
                              'phone': phoneCtrl.text.trim(),
                              'address': addressCtrl.text.trim(),
                            };
                          });
                          Navigator.pop(sheetContext);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _teal,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          elevation: 0,
                        ),
                        child: Text('Save Guest ${index + 1}',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _submitBooking() async {
    final unfilled = guestList.where((g) => !g['filled']).length;
    if (unfilled > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Please fill in details for all $unfilled remaining guest${unfilled > 1 ? 's' : ''}')),
      );
      return;
    }

    setState(() => isSubmitting = true);

    try {
      final response = await http.post(
        Uri.parse('${Config.baseUrl}/api/hotels'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'hotelName': widget.hotelName,
          'checkInDate': widget.checkIn.toIso8601String(),
          'checkOutDate': widget.checkOut.toIso8601String(),
          'checkInTime': '15:00',
          'checkOutTime': '12:00',
          'numRooms': widget.numRooms,
          'numPeople': numPeople,
          'guests': guestList
              .map((g) => {
                    'name': g['name'],
                    'email': g['email'],
                    'phone': g['phone'],
                    'address': g['address'],
                  })
              .toList(),
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Hotel booked successfully! 🏨'),
              backgroundColor: Colors.green),
        );
        Navigator.pop(context);
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Booking failed. Please try again.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }

    setState(() => isSubmitting = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Guest details',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: guestList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Collapsible summary
                  GestureDetector(
                    onTap: () =>
                        setState(() => summaryExpanded = !summaryExpanded),
                    child: Container(
                      padding: EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(widget.hotelName,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15)),
                                  SizedBox(height: 4),
                                  Text('SAR $totalPrice',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: _teal)),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                      summaryExpanded
                                          ? 'Hide summary'
                                          : 'View summary',
                                      style: TextStyle(
                                          fontSize: 13, color: _teal)),
                                  Icon(
                                      summaryExpanded
                                          ? Icons.keyboard_arrow_up
                                          : Icons.keyboard_arrow_down,
                                      color: _teal),
                                ],
                              ),
                            ],
                          ),
                          if (summaryExpanded) ...[
                            SizedBox(height: 14),
                            Divider(),
                            SizedBox(height: 10),
                            _summaryRow(Icons.calendar_today_outlined,
                                'Check-in', _formatDate(widget.checkIn)),
                            _summaryRow(Icons.calendar_today_outlined,
                                'Check-out', _formatDate(widget.checkOut)),
                            _summaryRow(Icons.nights_stay_outlined, 'Nights',
                                '${widget.nights}'),
                            _summaryRow(Icons.bed_outlined, 'Rooms',
                                '${widget.numRooms}'),
                            _summaryRow(Icons.people_outline, 'Guests',
                                '$numPeople'),
                            Divider(),
                            SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Price per night',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 13)),
                                Text('SAR ${widget.pricePerNight}',
                                    style: TextStyle(fontSize: 13)),
                              ],
                            ),
                            SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Total',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15)),
                                Text('SAR $totalPrice',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: _teal)),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 24),
                  Text('Guest details',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 12),

                  ...List.generate(guestList.length, (i) {
                    final g = guestList[i];
                    final filled = g['filled'] as bool;
                    return Container(
                      margin: EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.person_outline,
                                  color: filled ? _teal : Colors.black87,
                                  size: 22),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'Guest ${i + 1}${i == 0 ? ' (You)' : ''}',
                                      style: TextStyle(fontSize: 15)),
                                  if (filled && g['name'].isNotEmpty)
                                    Text(g['name'],
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade600)),
                                ],
                              ),
                            ],
                          ),
                          ElevatedButton.icon(
                            onPressed: () => _openGuestSheet(i),
                            icon:
                                Icon(filled ? Icons.edit : Icons.add, size: 18),
                            label: Text(filled ? 'Edit' : 'Add',
                                style: TextStyle(fontSize: 14)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  filled ? Colors.grey.shade100 : _teal,
                              foregroundColor:
                                  filled ? Colors.black87 : Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              elevation: 0,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),

                  SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isSubmitting ? null : _submitBooking,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _red,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        elevation: 0,
                      ),
                      child: isSubmitting
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text('Confirm Booking',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  Widget _summaryRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          SizedBox(width: 8),
          Text('$label: ',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
          Text(value,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _field(TextEditingController ctrl, String label,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: ctrl,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade400)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade400)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: _teal, width: 1.5)),
        contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
    );
  }
}
