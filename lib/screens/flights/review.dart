// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:mobile_app/screens/flights/flight_booking.dart';
import '../../config.dart';

class Review extends StatelessWidget {
  final Map<String, dynamic> flight;
  final int passengers;

  const Review({super.key, required this.flight, required this.passengers});

  @override
  Widget build(BuildContext context) {
    final String airline = flight['airline'] ?? '';
    final String fromCity = flight['fromCity'] ?? '';
    final String toCity = flight['toCity'] ?? '';
    final String fromCode = flight['fromCode'] ?? '';
    final String toCode = flight['toCode'] ?? '';
    final String departTime = flight['departTime'] ?? '--:--';
    final String arrivalTime = flight['arrivalTime'] ?? '--:--';
    final String duration = flight['duration'] ?? '';
    final String stops = flight['stops'] ?? '';
    final String flightClass = flight['flightClass'] ?? '';
    final String currency = flight['currency'] ?? '';
    final num price = flight['price'] ?? 0;
    final bool hasLuggage = flight['hasLuggage'] ?? false;
    final String tripType = flight['tripType'] ?? '';
    final String returnTime = flight['returnTime'] ?? '';

    String? departDateStr = flight['departDate'];
    String formattedDate = '';
    if (departDateStr != null) {
      final date = DateTime.tryParse(departDateStr);
      if (date != null) {
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
        List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
        formattedDate =
            '${days[date.weekday - 1]}, ${date.day} ${months[date.month - 1]} ${date.year}';
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Review your trip',
          style: TextStyle(
              fontSize: 17, fontWeight: FontWeight.w500, color: Colors.black87),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),

                  // Route title
                  Text(
                    '$fromCity → $toCity',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(duration,
                          style:
                              TextStyle(fontSize: 13, color: Colors.black54)),
                      Text(formattedDate,
                          style:
                              TextStyle(fontSize: 13, color: Colors.black54)),
                    ],
                  ),

                  SizedBox(height: 24),

                  // Timeline
                  _buildTimeline(fromCity, toCity, fromCode, toCode, departTime,
                      arrivalTime, airline, stops),

                  SizedBox(height: 24),

                  // Flight info card
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Flight Details',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        SizedBox(height: 12),
                        _infoRow(Icons.airline_seat_recline_normal, 'Class',
                            flightClass),
                        SizedBox(height: 10),
                        _infoRow(Icons.swap_calls, 'Trip Type',
                            tripType == 'roundtrip' ? 'Round Trip' : 'One Way'),
                        SizedBox(height: 10),
                        _infoRow(Icons.luggage, 'Checked Baggage',
                            hasLuggage ? 'Included' : 'Not included'),
                        if (tripType == 'roundtrip' &&
                            returnTime.isNotEmpty) ...[
                          SizedBox(height: 10),
                          _infoRow(
                              Icons.flight_land, 'Return Flight', returnTime),
                        ],
                      ],
                    ),
                  ),

                  SizedBox(height: 16),

                  // Price breakdown
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFFE3F0FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Price Summary',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1565C0))),
                        SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Base fare',
                                style: TextStyle(color: Color(0xFF1565C0))),
                            Text('$currency $price',
                                style: TextStyle(
                                    color: Color(0xFF1565C0),
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Taxes & fees',
                                style: TextStyle(color: Color(0xFF1565C0))),
                            Text('Included',
                                style: TextStyle(color: Color(0xFF1565C0))),
                          ],
                        ),
                        Divider(color: Color(0xFF1565C0).withOpacity(0.3)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Color(0xFF1565C0))),
                            Text('$currency $price',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Color(0xFF1565C0))),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16),

                  // Baggage policy
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: hasLuggage ? Color(0xFFE8F5E9) : Color(0xFFFFF3E0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          hasLuggage ? Icons.check_circle : Icons.info_outline,
                          color: hasLuggage ? Colors.green : Colors.orange,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            hasLuggage
                                ? 'This flight includes checked baggage at no extra cost.'
                                : 'This flight does not include checked baggage. Additional fees may apply.',
                            style: TextStyle(
                              color: hasLuggage
                                  ? Colors.green[800]
                                  : Colors.orange[800],
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 80),
                ],
              ),
            ),
          ),

          // Bottom bar
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black12, blurRadius: 8, offset: Offset(0, -2))
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total price',
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                    Text(
                      '$currency $price',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FlightBooking(
                          fromCity: fromCity,
                          toCity: toCity,
                          departureDate:
                              DateTime.tryParse(flight['departDate'] ?? '') ??
                                  DateTime.now(),
                          returnDate: flight['returnDate'] != null
                              ? DateTime.tryParse(flight['returnDate'])
                              : null,
                          tripType: flight['tripType'] == 'oneway'
                              ? 'One-way'
                              : 'Round trip',
                          passengers: passengers,
                          price: flight['price'] ?? 0,
                          currency: flight['currency'] ?? '',
                          airline: flight['airline'] ?? '',
                          duration: flight['duration'] ?? '',
                          stops: flight['stops'] ?? '',
                          flightClass: flight['flightClass'] ?? '',
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE84560),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 36, vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    elevation: 0,
                  ),
                  child: Text('Continue',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline(
      String fromCity,
      String toCity,
      String fromCode,
      String toCode,
      String departTime,
      String arrivalTime,
      String airline,
      String stops) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Times column
          SizedBox(
            width: 72,
            child: Column(
              children: [
                _timeLabel(departTime),
                SizedBox(height: 60),
                _timeLabel(arrivalTime),
              ],
            ),
          ),

          SizedBox(width: 8),

          // Dots and line
          SizedBox(
            width: 20,
            child: Column(
              children: [
                _dot(),
                _line(height: 80),
                _dot(),
              ],
            ),
          ),

          SizedBox(width: 10),

          // Info column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Departure
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(fromCity,
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w600)),
                    Text(fromCode,
                        style: TextStyle(fontSize: 12, color: Colors.black54)),
                  ],
                ),

                SizedBox(height: 12),

                // Flight card
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                          color: Color(0xFF1B2A4A),
                          borderRadius: BorderRadius.circular(6)),
                      child: Icon(Icons.flight_takeoff,
                          color: Colors.white, size: 20),
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(airline,
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600)),
                        Text(stops,
                            style:
                                TextStyle(fontSize: 12, color: Colors.black54)),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 12),

                // Arrival
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(toCity,
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w600)),
                    Text(toCode,
                        style: TextStyle(fontSize: 12, color: Colors.black54)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _timeLabel(String time) {
    return Text(time,
        style: TextStyle(
            fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87));
  }

  Widget _dot() {
    return Container(
      width: 10,
      height: 10,
      decoration:
          BoxDecoration(color: Color(0xFF2979FF), shape: BoxShape.circle),
    );
  }

  Widget _line({required double height}) {
    return Container(width: 2, height: height, color: Color(0xFF2979FF));
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        SizedBox(width: 10),
        Text('$label: ',
            style: TextStyle(color: Colors.grey[600], fontSize: 13)),
        Text(value,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
      ],
    );
  }
}
