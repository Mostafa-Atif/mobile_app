// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import 'package:mobile_app/screens/flights/flight_booking.dart';
import 'package:mobile_app/services/flight_translation_service.dart';
import 'package:mobile_app/theme.dart';

class FlightDetails extends StatelessWidget {
  final Map<String, dynamic> flight;
  final int passengers;
  final DateTime departureDate;
  final DateTime? returnDate;
  final dynamic cabinClass;

  const FlightDetails(
      {super.key,
      required this.flight,
      required this.passengers,
      required this.departureDate,
      required this.returnDate,
      required this.cabinClass});

  double getClassMultiplier(String cabinClass, AppLocalizations l) {
    final Map<String, double> multipliers = {
      l.economy: 1.0,
      l.premiumEconomy: 1.65,
      l.business: 2.5,
      l.firstClass: 5.0,
    };
    return multipliers[cabinClass] ?? 1.0;
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

  String _formatDuration(String arabicDuration, String lang) {
    // Parse "7س 30د" format
    final regex = RegExp(r'(\d+)س\s*(\d+)د');
    final match = regex.firstMatch(arabicDuration);

    if (match == null) return arabicDuration; // fallback if format changes

    final hours = int.parse(match.group(1)!);
    final minutes = int.parse(match.group(2)!);

    if (lang == 'ar') {
      return '${hours}س ${minutes}د';
    }

    // English format
    if (minutes == 0) {
      return hours == 1 ? '$hours hour' : '$hours hours';
    }
    if (hours == 0) {
      return minutes == 1 ? '$minutes minute' : '$minutes minutes';
    }
    return '$hours h $minutes m';
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final t = Theme.of(context).extension<AppThemeExtension>()!;
    String lang = Localizations.localeOf(context).languageCode;

    final String airline = flight['airline'] ?? '';
    final String fromCity = flight['fromCity'] ?? '';
    final String toCity = flight['toCity'] ?? '';
    final String fromCode = flight['fromCode'] ?? '';
    final String toCode = flight['toCode'] ?? '';
    final String departTime = flight['departTime'] ?? '--:--';
    final String arrivalTime = flight['arrivalTime'] ?? '--:--';
    final String returnTime = flight['returnTime'] ?? '';
    final String duration = flight['duration'] ?? '';
    final String stops = lang == 'en'
        ? FlightTranslationService.translateStops(flight['stops'] ?? 'مباشر')
        : (flight['stops'] ?? 'مباشر');
    final String flightClass = cabinClass;
    final String currency = lang == 'en'
        ? FlightTranslationService.translateCurrency(flight['currency'])
        : (flight['currency']);
    final num price = flight['price'] ?? 0;
    final double classMultiplier = getClassMultiplier(cabinClass, l);
    final num classPrice = (flight['price'] as num) * classMultiplier;
    final num totalPrice = classPrice * passengers;
    final bool hasLuggage = flight['hasLuggage'] ?? false;
    final String tripType = flight['tripType'] ?? '';
    final bool isRoundTrip = tripType == 'roundtrip';

    List<String> months;
    List<String> days;

    if (lang == 'ar') {
      months = [
        'يناير',
        'فبراير',
        'مارس',
        'أبريل',
        'مايو',
        'يونيو',
        'يوليو',
        'أغسطس',
        'سبتمبر',
        'أكتوبر',
        'نوفمبر',
        'ديسمبر'
      ];
      days = [
        'الاثنين',
        'الثلاثاء',
        'الأربعاء',
        'الخميس',
        'الجمعة',
        'السبت',
        'الأحد'
      ];
    } else {
      months = [
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
      days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    }

    String formattedDepartDate = '';
    String formattedReturnDate = '';

    if (flight['departDate'] != null) {
      final date = DateTime.tryParse(departureDate.toString());
      if (date != null)
        formattedDepartDate =
            '${days[date.weekday - 1]}, ${date.day} ${months[date.month - 1]} ${date.year}';
    }
    if (flight['returnDate'] != null) {
      final date = DateTime.tryParse(returnDate.toString());
      if (date != null)
        formattedReturnDate =
            '${days[date.weekday - 1]}, ${date.day} ${months[date.month - 1]} ${date.year}';
    }

    return Scaffold(
      backgroundColor: t.bg,
      appBar: AppBar(
        backgroundColor: t.header,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: t.backIcon),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(l.reviewTrip,
            style: TextStyle(
                fontSize: 17, fontWeight: FontWeight.w500, color: t.title)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Route header
                  Row(
                    children: [
                      Text(
                          '${lang == 'en' ? FlightTranslationService.translateCity(fromCity) : fromCity} ${lang == 'en' ? '→' : '←'} ${lang == 'en' ? FlightTranslationService.translateCity(toCity) : toCity}',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: t.title)),
                      const SizedBox(width: 10),
                      if (isRoundTrip)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                              color: t.accentLight,
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(l.roundTrip,
                              style: TextStyle(
                                  fontSize: 11,
                                  color: t.accent,
                                  fontWeight: FontWeight.w600)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_formatDuration(duration, lang),
                          style: TextStyle(fontSize: 13, color: t.label)),
                      Text(formattedDepartDate,
                          style: TextStyle(fontSize: 13, color: t.label)),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Outbound label
                  if (isRoundTrip)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(children: [
                        Icon(Icons.flight_takeoff, size: 16, color: t.accent),
                        const SizedBox(width: 6),
                        Text(l.outboundFlight,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: t.accent)),
                        const SizedBox(width: 8),
                        Text(formattedDepartDate,
                            style: TextStyle(fontSize: 12, color: t.label)),
                      ]),
                    ),

                  _buildTimeline(
                      context,
                      t,
                      lang == 'en'
                          ? FlightTranslationService.translateCity(fromCity)
                          : fromCity,
                      lang == 'en'
                          ? FlightTranslationService.translateCity(toCity)
                          : toCity,
                      fromCode,
                      toCode,
                      departTime,
                      arrivalTime,
                      airline,
                      lang == 'en'
                          ? FlightTranslationService.translateStops(
                              flight['stops'] ?? 'مباشر')
                          : (flight['stops'] ?? 'مباشر')),

                  // Return flight
                  if (isRoundTrip && returnTime.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Divider(color: t.divider),
                    const SizedBox(height: 16),
                    Row(children: [
                      Icon(Icons.flight_land, size: 16, color: t.accent),
                      const SizedBox(width: 6),
                      Text(l.returnFlight,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: t.accent)),
                      const SizedBox(width: 8),
                      Text(formattedReturnDate,
                          style: TextStyle(fontSize: 12, color: t.label)),
                    ]),
                    const SizedBox(height: 12),
                    _buildTimeline(
                        context,
                        t,
                        lang == 'en'
                            ? FlightTranslationService.translateCity(toCity)
                            : toCity,
                        lang == 'en'
                            ? FlightTranslationService.translateCity(fromCity)
                            : fromCity,
                        toCode,
                        fromCode,
                        returnTime,
                        _calcArrival(returnTime, duration),
                        airline,
                        stops),
                  ],

                  const SizedBox(height: 24),

                  // Flight details card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: t.card,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: t.cardBorder.withOpacity(0.5)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l.flightDetails,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: t.title)),
                        const SizedBox(height: 12),
                        _infoRow(t, Icons.airline_seat_recline_normal, l.class_,
                            flightClass),
                        const SizedBox(height: 10),
                        _infoRow(t, Icons.swap_calls, l.tripType,
                            isRoundTrip ? l.roundTrip : l.oneWay),
                        const SizedBox(height: 10),
                        _infoRow(t, Icons.luggage, l.checkedBaggage,
                            hasLuggage ? l.included : 'Not included'),
                        if (isRoundTrip && formattedReturnDate.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          _infoRow(t, Icons.event_repeat, l.returnDate,
                              formattedReturnDate),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Price summary card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: t.accentLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l.priceSummary,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: t.accent)),
                        const SizedBox(height: 12),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(l.baseFare,
                                  style: TextStyle(color: t.accent)),
                              Text('$price $currency',
                                  style: TextStyle(
                                      color: t.accent,
                                      fontWeight: FontWeight.w600)),
                            ]),
                        const SizedBox(height: 8),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(cabinClass,
                                  style: TextStyle(color: t.accent)),
                              Text('× ${classMultiplier}',
                                  style: TextStyle(
                                      color: t.accent,
                                      fontWeight: FontWeight.w600)),
                            ]),
                        const SizedBox(height: 8),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(l.taxesAndFees,
                                  style: TextStyle(color: t.accent)),
                              Text(l.included,
                                  style: TextStyle(color: t.accent)),
                            ]),
                        const SizedBox(height: 8),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  '$passengers ${passengers == 1 ? l.passenger : l.passengers}',
                                  style: TextStyle(color: t.accent)),
                              Text('× $classPrice $currency',
                                  style: TextStyle(
                                      color: t.accent,
                                      fontWeight: FontWeight.w600)),
                            ]),
                        Divider(color: t.accent.withOpacity(0.2)),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(l.total,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: t.accent)),
                              Text('$totalPrice $currency',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: t.accent)),
                            ]),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Baggage notice
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: hasLuggage
                          ? Colors.green.withOpacity(0.08)
                          : Colors.orange.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: hasLuggage
                            ? Colors.green.withOpacity(0.2)
                            : Colors.orange.withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                            hasLuggage
                                ? Icons.check_circle
                                : Icons.info_outline,
                            color: hasLuggage ? Colors.green : Colors.orange),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            hasLuggage
                                ? l.checkedBaggageIncluded
                                : l.noBaggageIncluded,
                            style: TextStyle(
                                color: hasLuggage
                                    ? Colors.green[800]
                                    : Colors.orange[800],
                                fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),

          // Bottom bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: t.header,
              border: Border(top: BorderSide(color: t.divider)),
              boxShadow: [
                BoxShadow(
                    color: t.divider.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, -2))
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.totalPrice,
                        style: TextStyle(fontSize: 12, color: t.label)),
                    Text('$totalPrice $currency',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: t.title)),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FlightBooking(
                            fromCity: fromCity,
                            toCity: toCity,
                            departureDate: departureDate,
                            returnDate: returnDate != null
                                ? DateTime.tryParse(returnDate.toString())
                                : null,
                            tripType: isRoundTrip ? 'Round trip' : 'One-way',
                            passengers: passengers,
                            price: flight['price'] ?? 0,
                            currency: lang == 'en'
                                ? FlightTranslationService.translateCurrency(
                                    flight['currency'])
                                : (flight['currency']),
                            airline: flight['airline'] ?? '',
                            duration: flight['duration'] ?? '',
                            stops: lang == 'en'
                                ? FlightTranslationService.translateStops(
                                    flight['stops'] ?? 'مباشر')
                                : (flight['stops'] ?? 'مباشر'),
                            flightClass: cabinClass,
                          ),
                        ));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: t.btnGradient),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                            color: t.accent.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4))
                      ],
                    ),
                    child: Text(l.continue_,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline(
      BuildContext context,
      AppThemeExtension t,
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
          SizedBox(
              width: 72,
              child: Column(children: [
                _timeLabel(t, departTime),
                const SizedBox(height: 60),
                _timeLabel(t, arrivalTime),
              ])),
          const SizedBox(width: 8),
          SizedBox(
              width: 20,
              child: Column(children: [
                _dot(t.accent),
                _line(height: 80, color: t.accent),
                _dot(t.accent),
              ])),
          const SizedBox(width: 10),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(fromCity,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: t.title)),
                Text(fromCode, style: TextStyle(fontSize: 12, color: t.label)),
              ]),
              const SizedBox(height: 12),
              Row(children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                      color: t.accentLight,
                      borderRadius: BorderRadius.circular(6)),
                  child: Icon(Icons.flight_takeoff, color: t.accent, size: 20),
                ),
                const SizedBox(width: 10),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(airline,
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: t.title)),
                  Text(stops, style: TextStyle(fontSize: 12, color: t.label)),
                ]),
              ]),
              const SizedBox(height: 12),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(toCity,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: t.title)),
                Text(toCode, style: TextStyle(fontSize: 12, color: t.label)),
              ]),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _timeLabel(AppThemeExtension t, String time) => Text(time,
      style:
          TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: t.title));

  Widget _dot(Color color) => Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle));

  Widget _line({required double height, required Color color}) =>
      Container(width: 2, height: height, color: color);

  Widget _infoRow(
          AppThemeExtension t, IconData icon, String label, String value) =>
      Row(children: [
        Icon(icon, size: 18, color: t.label),
        const SizedBox(width: 10),
        Text('$label: ', style: TextStyle(color: t.label, fontSize: 13)),
        Text(value,
            style: TextStyle(
                fontWeight: FontWeight.w600, fontSize: 13, color: t.title)),
      ]);
}
