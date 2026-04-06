// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import 'package:mobile_app/screens/flights/flight_booking.dart';

class Review extends StatelessWidget {
  final Map<String, dynamic> flight;
  final int passengers;

  const Review({super.key, required this.flight, required this.passengers});

  String _calcArrival(String departTime, String duration) {
    try {
      final parts = departTime.split(':');
      int hours = int.parse(parts[0]);
      int minutes = int.parse(parts[1]);
      final hMatch = RegExp(r'(\d+)س').firstMatch(duration);
      final mMatch = RegExp(r'(\d+)د').firstMatch(duration);
      int dHours = hMatch != null ? int.parse(hMatch.group(1)!) : 0;
      int dMins = mMatch != null ? int.parse(mMatch.group(1)!) : 0;
      int totalMins = hours * 60 + minutes + dHours * 60 + dMins;
      int finalHour = (totalMins ~/ 60) % 24;
      int finalMin = totalMins % 60;
      return '${finalHour.toString().padLeft(2, '0')}:${finalMin.toString().padLeft(2, '0')}';
    } catch (_) { return '--:--'; }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    final String airline = flight['airline'] ?? '';
    final String fromCity = flight['fromCity'] ?? '';
    final String toCity = flight['toCity'] ?? '';
    final String fromCode = flight['fromCode'] ?? '';
    final String toCode = flight['toCode'] ?? '';
    final String departTime = flight['departTime'] ?? '--:--';
    final String arrivalTime = flight['arrivalTime'] ?? '--:--';
    final String returnTime = flight['returnTime'] ?? '';
    final String duration = flight['duration'] ?? '';
    final String stops = flight['stops'] ?? '';
    final String flightClass = flight['flightClass'] ?? '';
    final String currency = flight['currency'] ?? '';
    final num price = flight['price'] ?? 0;
    final bool hasLuggage = flight['hasLuggage'] ?? false;
    final String tripType = flight['tripType'] ?? '';
    final bool isRoundTrip = tripType == 'roundtrip';

    List<String> months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    List<String> days = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'];

    String formattedDepartDate = '';
    String formattedReturnDate = '';

    if (flight['departDate'] != null) {
      final date = DateTime.tryParse(flight['departDate'].toString());
      if (date != null)
        formattedDepartDate = '${days[date.weekday - 1]}, ${date.day} ${months[date.month - 1]} ${date.year}';
    }
    if (flight['returnDate'] != null) {
      final date = DateTime.tryParse(flight['returnDate'].toString());
      if (date != null)
        formattedReturnDate = '${days[date.weekday - 1]}, ${date.day} ${months[date.month - 1]} ${date.year}';
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
        title: Text(l.reviewTrip,
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.black87)),
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

                  Row(
                    children: [
                      Text('$fromCity → $toCity',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(width: 10),
                      if (isRoundTrip)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: Color(0xFFE3F0FF),
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(l.roundTrip, style: TextStyle(fontSize: 11,
                              color: Color(0xFF1565C0), fontWeight: FontWeight.w600)),
                        ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(duration, style: TextStyle(fontSize: 13, color: Colors.black54)),
                      Text(formattedDepartDate, style: TextStyle(fontSize: 13, color: Colors.black54)),
                    ],
                  ),

                  SizedBox(height: 24),

                  if (isRoundTrip)
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Row(children: [
                        Icon(Icons.flight_takeoff, size: 16, color: Color(0xFF2979FF)),
                        SizedBox(width: 6),
                        Text(l.outboundFlight, style: TextStyle(fontSize: 14,
                            fontWeight: FontWeight.bold, color: Color(0xFF2979FF))),
                        SizedBox(width: 8),
                        Text(formattedDepartDate, style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ]),
                    ),

                  _buildTimeline(fromCity, toCity, fromCode, toCode,
                      departTime, arrivalTime, airline, stops),

                  if (isRoundTrip && returnTime.isNotEmpty) ...[
                    SizedBox(height: 24),
                    Divider(color: Colors.grey[200]),
                    SizedBox(height: 16),
                    Row(children: [
                      Icon(Icons.flight_land, size: 16, color: Color(0xFF00BFA5)),
                      SizedBox(width: 6),
                      Text(l.returnFlight, style: TextStyle(fontSize: 14,
                          fontWeight: FontWeight.bold, color: Color(0xFF00BFA5))),
                      SizedBox(width: 8),
                      Text(formattedReturnDate, style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ]),
                    SizedBox(height: 12),
                    _buildTimeline(toCity, fromCity, toCode, fromCode,
                        returnTime, _calcArrival(returnTime, duration), airline, stops,
                        color: Color(0xFF00BFA5)),
                  ],

                  SizedBox(height: 24),

                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l.flightDetails,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        SizedBox(height: 12),
                        _infoRow(Icons.airline_seat_recline_normal, l.class_, flightClass),
                        SizedBox(height: 10),
                        _infoRow(Icons.swap_calls, l.tripType,
                            isRoundTrip ? l.roundTrip : l.oneWay),
                        SizedBox(height: 10),
                        _infoRow(Icons.luggage, l.checkedBaggage,
                            hasLuggage ? l.included : 'Not included'),
                        if (isRoundTrip && formattedReturnDate.isNotEmpty) ...[
                          SizedBox(height: 10),
                          _infoRow(Icons.event_repeat, l.returnDate, formattedReturnDate),
                        ],
                      ],
                    ),
                  ),

                  SizedBox(height: 16),

                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: Color(0xFFE3F0FF), borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l.priceSummary, style: TextStyle(fontSize: 16,
                            fontWeight: FontWeight.bold, color: Color(0xFF1565C0))),
                        SizedBox(height: 12),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text(l.baseFare, style: TextStyle(color: Color(0xFF1565C0))),
                          Text('$currency $price', style: TextStyle(color: Color(0xFF1565C0),
                              fontWeight: FontWeight.w600)),
                        ]),
                        SizedBox(height: 8),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text(l.taxesAndFees, style: TextStyle(color: Color(0xFF1565C0))),
                          Text(l.included, style: TextStyle(color: Color(0xFF1565C0))),
                        ]),
                        Divider(color: Color(0xFF1565C0).withValues(alpha: 0.3)),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text(l.total, style: TextStyle(fontWeight: FontWeight.bold,
                              fontSize: 15, color: Color(0xFF1565C0))),
                          Text('$currency $price', style: TextStyle(fontWeight: FontWeight.bold,
                              fontSize: 15, color: Color(0xFF1565C0))),
                        ]),
                      ],
                    ),
                  ),

                  SizedBox(height: 16),

                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: hasLuggage ? Color(0xFFE8F5E9) : Color(0xFFFFF3E0),
                        borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      children: [
                        Icon(hasLuggage ? Icons.check_circle : Icons.info_outline,
                            color: hasLuggage ? Colors.green : Colors.orange),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            hasLuggage ? l.checkedBaggageIncluded : l.noBaggageIncluded,
                            style: TextStyle(
                                color: hasLuggage ? Colors.green[800] : Colors.orange[800],
                                fontSize: 13),
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

          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, -2))]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.totalPrice, style: TextStyle(fontSize: 12, color: Colors.grey)),
                    Text('$currency $price',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => FlightBooking(
                        fromCity: fromCity,
                        toCity: toCity,
                        departureDate: DateTime.tryParse(flight['departDate'] ?? '') ?? DateTime.now(),
                        returnDate: flight['returnDate'] != null
                            ? DateTime.tryParse(flight['returnDate'].toString()) : null,
                        tripType: isRoundTrip ? 'Round trip' : 'One-way',
                        passengers: passengers,
                        price: flight['price'] ?? 0,
                        currency: flight['currency'] ?? '',
                        airline: flight['airline'] ?? '',
                        duration: flight['duration'] ?? '',
                        stops: flight['stops'] ?? '',
                        flightClass: flight['flightClass'] ?? '',
                      ),
                    ));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE84560), foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 36, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    elevation: 0,
                  ),
                  child: Text(l.continue_,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline(String fromCity, String toCity, String fromCode, String toCode,
      String departTime, String arrivalTime, String airline, String stops,
      {Color color = const Color(0xFF2979FF)}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 72, child: Column(children: [
            _timeLabel(departTime), SizedBox(height: 60), _timeLabel(arrivalTime),
          ])),
          SizedBox(width: 8),
          SizedBox(width: 20, child: Column(children: [
            _dot(color), _line(height: 80, color: color), _dot(color),
          ])),
          SizedBox(width: 10),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(fromCity, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                Text(fromCode, style: TextStyle(fontSize: 12, color: Colors.black54)),
              ]),
              SizedBox(height: 12),
              Row(children: [
                Container(width: 36, height: 36,
                    decoration: BoxDecoration(color: Color(0xFF1B2A4A),
                        borderRadius: BorderRadius.circular(6)),
                    child: Icon(Icons.flight_takeoff, color: Colors.white, size: 20)),
                SizedBox(width: 10),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(airline, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  Text(stops, style: TextStyle(fontSize: 12, color: Colors.black54)),
                ]),
              ]),
              SizedBox(height: 12),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(toCity, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                Text(toCode, style: TextStyle(fontSize: 12, color: Colors.black54)),
              ]),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _timeLabel(String time) =>
      Text(time, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87));

  Widget _dot(Color color) => Container(width: 10, height: 10,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle));

  Widget _line({required double height, Color color = const Color(0xFF2979FF)}) =>
      Container(width: 2, height: height, color: color);

  Widget _infoRow(IconData icon, String label, String value) =>
      Row(children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        SizedBox(width: 10),
        Text('$label: ', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
        Text(value, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
      ]);
}