// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app/screens/flights/review.dart';

class FlightResults extends StatefulWidget {
  final String fromCity;
  final String toCity;
  final String tripType;
  final DateTime departureDate;
  final int passengers;
  final String cabinClass;

  const FlightResults({
    super.key,
    required this.fromCity,
    required this.toCity,
    required this.tripType,
    required this.departureDate,
    required this.passengers,
    required this.cabinClass,
  });

  @override
  State<FlightResults> createState() => _FlightResultsState();
}

class _FlightResultsState extends State<FlightResults> {
  List<dynamic> flights = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchFlights();
  }

  Future<void> fetchFlights() async {
    try {
      final uri = Uri.parse('http://localhost:5000/api/flights').replace(
        queryParameters: {
          'from': widget.fromCity,
          'to': widget.toCity,
          'tripType': widget.tripType == 'One-way' ? 'oneway' : 'roundtrip',
        },
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        setState(() {
          flights = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load flights';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Connection error: $e';
        isLoading = false;
      });
    }
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
    List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return '${days[date.weekday - 1]}, ${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            Text(
              '${widget.fromCity} → ${widget.toCity}',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            Text(
              '${widget.passengers} passenger${widget.passengers > 1 ? 's' : ''} · ${widget.cabinClass} · ${_formatDate(widget.departureDate)}',
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(Icons.refresh, color: Colors.blue),
              onPressed: () {
                setState(() => isLoading = true);
                fetchFlights();
              }),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child:
                      Text(errorMessage!, style: TextStyle(color: Colors.red)))
              : flights.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.airplanemode_off,
                              size: 60, color: Colors.grey[400]),
                          SizedBox(height: 16),
                          Text('No flights found',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey)),
                          SizedBox(height: 8),
                          Text('Try different dates or cities',
                              style: TextStyle(color: Colors.grey[400])),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemCount: flights.length,
                      itemBuilder: (context, index) {
                        final flight = flights[index];
                        return _buildFlightCard(flight);
                      },
                    ),
    );
  }

  Widget _buildFlightCard(Map<String, dynamic> flight) {
    final bool hasLuggage = flight['hasLuggage'] ?? false;
    final String currency = flight['currency'] ?? 'QAR';
    final String stops = flight['stops'] ?? 'Direct';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Review(flight: flight),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Airline row
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Color(0xFF1B2A4A),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child:
                            Icon(Icons.flight, color: Colors.white, size: 20),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          flight['airline'] ?? '',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Text(
                        '$currency ${flight['price']}',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ],
                  ),

                  SizedBox(height: 16),

                  // Times row
                  Row(
                    children: [
                      // Depart time
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            flight['departTime'] ?? '--:--',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            flight['fromCode'] ?? flight['fromCity'] ?? '',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),

                      Expanded(
                        child: Column(
                          children: [
                            Text(flight['duration'] ?? '',
                                style: TextStyle(
                                    fontSize: 11, color: Colors.grey)),
                            SizedBox(height: 4),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Divider(color: Colors.grey[300], thickness: 1),
                                Icon(Icons.flight,
                                    color: Colors.grey[400], size: 16),
                              ],
                            ),
                            SizedBox(height: 4),
                            Text(stops,
                                style: TextStyle(
                                    fontSize: 11, color: Colors.grey)),
                          ],
                        ),
                      ),

                      // Arrival time
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            flight['arrivalTime'] ?? '--:--',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            flight['toCode'] ?? flight['toCity'] ?? '',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Bottom bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(12)),
                border: Border(top: BorderSide(color: Colors.grey[200]!)),
              ),
              child: Row(
                children: [
                  Icon(
                    hasLuggage ? Icons.luggage : Icons.no_luggage,
                    size: 16,
                    color: hasLuggage ? Colors.blue : Colors.grey,
                  ),
                  SizedBox(width: 6),
                  Text(
                    hasLuggage ? 'Checked baggage' : 'No checked baggage',
                    style: TextStyle(
                        fontSize: 12,
                        color: hasLuggage ? Colors.blue : Colors.grey),
                  ),
                  Spacer(),
                  Text(
                    flight['flightClass'] ?? '',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
