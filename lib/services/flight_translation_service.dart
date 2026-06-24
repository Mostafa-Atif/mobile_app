import 'package:flutter/services.dart';
import 'dart:convert';

class FlightTranslationService {
  static late Map<String, dynamic> _translations;

  static Future<void> init() async {
    final jsonString = await rootBundle.loadString('assets/data/flight_translations.json');
    _translations = json.decode(jsonString);
  }

  static String translateCity(String arabicCity) {
    return _translations['cities'][arabicCity] ?? arabicCity;
  }

  static String translateStops(String arabicStops) {
    return _translations['stops'][arabicStops] ?? arabicStops;
  }

  static String translateCurrency(String arabicCurrency) {
    return _translations['currency'][arabicCurrency] ?? arabicCurrency;
  }
}