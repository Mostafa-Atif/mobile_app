// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app/l10n/app_localizations.dart';
import 'package:mobile_app/screens/flights/flight_details.dart';
import 'package:mobile_app/services/flight_translation_service.dart';
import 'package:mobile_app/theme.dart';
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
  Map<String, String> englishToArabic = {};
  bool isLoading = true;
  bool hasError = false;

  bool get isRoundTrip => widget.tripType == 'Round trip';

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _loadMapping() async {
    final jsonString =
        await rootBundle.loadString('assets/data/flight_translations.json');
    final json = jsonDecode(jsonString);

    json['cities'].forEach((arabicCity, englishCity) {
      englishToArabic[englishCity] = arabicCity;
    });
  }

  String getArabicCity(String city) {
    return englishToArabic[city] ?? city;
  }

  Future<void> fetchFlights() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });
    try {
      final uri = Uri.parse('${Config.baseUrl}/api/flights').replace(
        queryParameters: {
          'from': getArabicCity(widget.fromCity),
          'to': getArabicCity(widget.toCity),
          'tripType': isRoundTrip ? 'roundtrip' : 'oneway',
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
          isLoading = false;
          hasError = true;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
      });
    }
  }

  Future<void> _initData() async {
    await _loadMapping();
    fetchFlights();
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
    } catch (_) {
      return '--:--';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final t = Theme.of(context).extension<AppThemeExtension>()!;
    String lang = Localizations.localeOf(context).languageCode;

    if (isLoading)
      return Scaffold(
        backgroundColor: t.bg,
        body: Center(child: CircularProgressIndicator(color: t.accent)),
      );

    if (hasError)
      return Scaffold(
        backgroundColor: t.bg,
        body: _buildError(l, t),
      );

    return Scaffold(
      backgroundColor: t.bg,
      appBar: AppBar(
        backgroundColor: t.header,
        elevation: 0.5,
        shadowColor: t.divider,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: t.backIcon),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${lang == 'en' ? FlightTranslationService.translateCity(widget.fromCity) : widget.fromCity} ${lang == 'en' ? '→' : '←'} ${lang == 'en' ? FlightTranslationService.translateCity(widget.toCity) : widget.toCity}',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: t.title),
                ),
                if (isRoundTrip) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: t.accentLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text('RT',
                        style: TextStyle(
                            fontSize: 10,
                            color: t.accent,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ],
            ),
            Text(
              isRoundTrip
                  ? '${_formatDate(widget.departureDate)} · ${widget.returnDate != null ? _formatDate(widget.returnDate!) : ''} · ${widget.passengers} pax'
                  : '${widget.passengers} ${widget.passengers > 1 ? l.passengers : l.passenger} · ${widget.cabinClass} · ${_formatDate(widget.departureDate)}',
              style: TextStyle(fontSize: 10, color: t.label),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(Icons.refresh, color: t.accent),
              onPressed: fetchFlights),
        ],
      ),
      body: flights.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.airplanemode_off, size: 60, color: t.label),
                  const SizedBox(height: 16),
                  Text(l.noFlightsFound,
                      style: TextStyle(fontSize: 18, color: t.title)),
                  const SizedBox(height: 8),
                  Text(l.tryDifferentDates, style: TextStyle(color: t.label)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: flights.length,
              itemBuilder: (context, index) =>
                  _buildFlightCard(flights[index], l, t),
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
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: t.title)),
          const SizedBox(height: 8),
          Text(l.checkConnectionRetry,
              style: TextStyle(color: t.label, fontSize: 13),
              textAlign: TextAlign.center),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: fetchFlights,
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
                  Text(l.retry,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlightCard(
      Map<String, dynamic> flight, AppLocalizations l, AppThemeExtension t) {
    String lang = Localizations.localeOf(context).languageCode;
    final bool hasLuggage = flight['hasLuggage'] ?? false;
    final String currency = lang == 'en'
        ? FlightTranslationService.translateCurrency(
            flight['currency'])
        : (flight['currency']);
    final String stops = lang == 'en'
        ? FlightTranslationService.translateStops(flight['stops'] ?? 'مباشر')
        : (flight['stops'] ?? 'مباشر');
    final String returnTime = flight['returnTime'] ?? '';

    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FlightDetails(
                  flight: flight,
                  passengers: widget.passengers,
                  departureDate: widget.departureDate,
                  returnDate: widget.returnDate,
                  cabinClass: widget.cabinClass))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: t.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: t.cardBorder.withOpacity(0.5)),
          boxShadow: [
            BoxShadow(color: t.cardBorder.withOpacity(0.15), blurRadius: 10)
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Airline + price
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: t.accentLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.flight, color: t.accent, size: 20),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                          child: Text(flight['airline'] ?? '',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: t.title))),
                      Text('$currency ${flight['price']}',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: t.price)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Outbound times
                  _timesRow(
                    flight['departTime'] ?? '--:--',
                    flight['fromCode'] ?? flight['fromCity'] ?? '',
                    flight['duration'] ?? '',
                    stops,
                    flight['arrivalTime'] ?? '--:--',
                    flight['toCode'] ?? flight['toCity'] ?? '',
                    t,
                  ),

                  // Return row
                  if (isRoundTrip && returnTime.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Divider(height: 1, color: t.divider),
                    const SizedBox(height: 12),
                    Row(children: [
                      Icon(Icons.event_repeat, size: 14, color: t.accent),
                      const SizedBox(width: 4),
                      Text(l.returnFlight,
                          style: TextStyle(
                              fontSize: 12,
                              color: t.accent,
                              fontWeight: FontWeight.w600)),
                    ]),
                    const SizedBox(height: 8),
                    _timesRow(
                      returnTime,
                      flight['toCode'] ?? flight['toCity'] ?? '',
                      flight['duration'] ?? '',
                      stops,
                      _calcArrival(returnTime, flight['duration'] ?? ''),
                      flight['fromCode'] ?? flight['fromCity'] ?? '',
                      t,
                    ),
                  ],
                ],
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: t.accentLight.withOpacity(0.4),
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(16)),
                border: Border(top: BorderSide(color: t.divider)),
              ),
              child: Row(
                children: [
                  Icon(hasLuggage ? Icons.luggage : Icons.no_luggage,
                      size: 16, color: hasLuggage ? t.accent : t.label),
                  const SizedBox(width: 6),
                  Text(hasLuggage ? l.checkedBaggage : 'No checked baggage',
                      style: TextStyle(
                          fontSize: 12,
                          color: hasLuggage ? t.accent : t.label)),
                  const Spacer(),
                  Text(widget.cabinClass,
                      style: TextStyle(fontSize: 12, color: t.label)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _timesRow(String dep, String fromCode, String dur, String stops,
      String arr, String toCode, AppThemeExtension t) {
    return Row(
      children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(dep,
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: t.title)),
          Text(fromCode, style: TextStyle(fontSize: 12, color: t.label)),
        ]),
        Expanded(
          child: Column(children: [
            Text(dur, style: TextStyle(fontSize: 11, color: t.label)),
            const SizedBox(height: 4),
            Stack(alignment: Alignment.center, children: [
              Divider(color: t.divider, thickness: 1),
              Icon(Icons.flight, color: t.label, size: 16),
            ]),
            const SizedBox(height: 4),
            Text(stops, style: TextStyle(fontSize: 11, color: t.label)),
          ]),
        ),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(arr,
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: t.title)),
          Text(toCode, style: TextStyle(fontSize: 12, color: t.label)),
        ]),
      ],
    );
  }
}
