// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app/l10n/app_localizations.dart';
import 'package:mobile_app/screens/flights/review.dart';
import '../../config.dart';

class FlightResults extends StatefulWidget {
  final String fromCity;
  final String toCity;
  final String tripType;
  final DateTime departureDate;
  final DateTime? returnDate;
  final int passengers;
  final String cabinClass;

  const FlightResults({
    super.key,
    required this.fromCity,
    required this.toCity,
    required this.tripType,
    required this.departureDate,
    this.returnDate,
    required this.passengers,
    required this.cabinClass,
  });

  @override
  State<FlightResults> createState() => _FlightResultsState();
}

class _FlightResultsState extends State<FlightResults> {
  List<dynamic> flights = [];
  bool isLoading = true;
  bool hasError = false;

  bool get isRoundTrip => widget.tripType == 'Round trip';

  @override
  void initState() {
    super.initState();
    fetchFlights();
  }

  Future<void> fetchFlights() async {
    setState(() { isLoading = true; hasError = false; });
    try {
      final uri = Uri.parse('${Config.baseUrl}/api/flights').replace(
        queryParameters: {
          'from': widget.fromCity,
          'to': widget.toCity,
          'tripType': isRoundTrip ? 'roundtrip' : 'oneway',
        },
      );
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        setState(() { flights = json.decode(response.body); isLoading = false; });
      } else {
        setState(() { isLoading = false; hasError = true; });
      }
    } catch (e) {
      setState(() { isLoading = false; hasError = true; });
    }
  }

  String _formatDate(DateTime date) {
    List<String> months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    List<String> days = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'];
    return '${days[date.weekday - 1]}, ${date.day} ${months[date.month - 1]} ${date.year}';
  }

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

    if (isLoading) return Scaffold(body: Center(child: CircularProgressIndicator()));
    if (hasError) return Scaffold(body: _buildError(l));

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
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${widget.fromCity} → ${widget.toCity}',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black)),
                if (isRoundTrip) ...[
                  SizedBox(width: 6),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: Color(0xFFE3F0FF),
                        borderRadius: BorderRadius.circular(10)),
                    child: Text('RT', style: TextStyle(fontSize: 10,
                        color: Color(0xFF1565C0), fontWeight: FontWeight.bold)),
                  ),
                ],
              ],
            ),
            Text(
              isRoundTrip
                  ? '${_formatDate(widget.departureDate)} · ${widget.returnDate != null ? _formatDate(widget.returnDate!) : ''} · ${widget.passengers} pax'
                  : '${widget.passengers} passenger${widget.passengers > 1 ? 's' : ''} · ${widget.cabinClass} · ${_formatDate(widget.departureDate)}',
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(Icons.refresh, color: Colors.blue),
              onPressed: fetchFlights),
        ],
      ),
      body: flights.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.airplanemode_off, size: 60, color: Colors.grey[400]),
                  SizedBox(height: 16),
                  Text(l.noFlightsFound, style: TextStyle(fontSize: 18, color: Colors.grey)),
                  SizedBox(height: 8),
                  Text(l.tryDifferentDates, style: TextStyle(color: Colors.grey[400])),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: flights.length,
              itemBuilder: (context, index) => _buildFlightCard(flights[index], l),
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
            onPressed: fetchFlights,
            icon: Icon(Icons.refresh),
            label: Text(l.retry),
            style: ElevatedButton.styleFrom(
                shape: StadiumBorder(), backgroundColor: Colors.blue, foregroundColor: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildFlightCard(Map<String, dynamic> flight, AppLocalizations l) {
    final bool hasLuggage = flight['hasLuggage'] ?? false;
    final String currency = flight['currency'] ?? 'QAR';
    final String stops = flight['stops'] ?? 'Direct';
    final String returnTime = flight['returnTime'] ?? '';

    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(
          builder: (context) => Review(flight: flight, passengers: widget.passengers))),
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)],
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 36, height: 36,
                        decoration: BoxDecoration(color: Color(0xFF1B2A4A),
                            borderRadius: BorderRadius.circular(8)),
                        child: Icon(Icons.flight, color: Colors.white, size: 20),
                      ),
                      SizedBox(width: 10),
                      Expanded(child: Text(flight['airline'] ?? '',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600))),
                      Text('$currency ${flight['price']}',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 16),
                  _timesRow(
                    flight['departTime'] ?? '--:--',
                    flight['fromCode'] ?? flight['fromCity'] ?? '',
                    flight['duration'] ?? '',
                    stops,
                    flight['arrivalTime'] ?? '--:--',
                    flight['toCode'] ?? flight['toCity'] ?? '',
                  ),
                  if (isRoundTrip && returnTime.isNotEmpty) ...[
                    SizedBox(height: 12),
                    Divider(height: 1, color: Colors.grey[200]),
                    SizedBox(height: 12),
                    Row(children: [
                      Icon(Icons.event_repeat, size: 14, color: Color(0xFF00BFA5)),
                      SizedBox(width: 4),
                      Text(l.returnFlight, style: TextStyle(fontSize: 12,
                          color: Color(0xFF00BFA5), fontWeight: FontWeight.w600)),
                    ]),
                    SizedBox(height: 8),
                    _timesRow(
                      returnTime,
                      flight['toCode'] ?? flight['toCity'] ?? '',
                      flight['duration'] ?? '',
                      stops,
                      _calcArrival(returnTime, flight['duration'] ?? ''),
                      flight['fromCode'] ?? flight['fromCity'] ?? '',
                    ),
                  ],
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
                border: Border(top: BorderSide(color: Colors.grey[200]!)),
              ),
              child: Row(
                children: [
                  Icon(hasLuggage ? Icons.luggage : Icons.no_luggage,
                      size: 16, color: hasLuggage ? Colors.blue : Colors.grey),
                  SizedBox(width: 6),
                  Text(hasLuggage ? l.checkedBaggage : 'No checked baggage',
                      style: TextStyle(fontSize: 12, color: hasLuggage ? Colors.blue : Colors.grey)),
                  Spacer(),
                  Text(flight['flightClass'] ?? '', style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _timesRow(String dep, String fromCode, String dur, String stops,
      String arr, String toCode) {
    return Row(
      children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(dep, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(fromCode, style: TextStyle(fontSize: 12, color: Colors.grey)),
        ]),
        Expanded(
          child: Column(children: [
            Text(dur, style: TextStyle(fontSize: 11, color: Colors.grey)),
            SizedBox(height: 4),
            Stack(alignment: Alignment.center, children: [
              Divider(color: Colors.grey[300], thickness: 1),
              Icon(Icons.flight, color: Colors.grey[400], size: 16),
            ]),
            SizedBox(height: 4),
            Text(stops, style: TextStyle(fontSize: 11, color: Colors.grey)),
          ]),
        ),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(arr, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(toCode, style: TextStyle(fontSize: 12, color: Colors.grey)),
        ]),
      ],
    );
  }
}