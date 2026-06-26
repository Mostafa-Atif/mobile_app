import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrencyProvider extends ChangeNotifier {
  String _currency;
  String get currency => _currency;

  CurrencyProvider(String currency) : _currency = currency;

  void setCurrency(String currency) async {
    _currency = currency;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currency', currency);
  }

  static const List<String> supportedCurrencies = [
    'SAR', 'USD', 'EUR', 'EGP', 'AED', 'KWD',
    'GBP', 'JPY', 'CAD', 'AUD', 'SGD', 'TRY', 'INR',
  ];

  static const Map<String, String> englishNames = {
    'SAR': 'Saudi Riyal',
    'USD': 'US Dollar',
    'EUR': 'Euro',
    'EGP': 'Egyptian Pound',
    'AED': 'UAE Dirham',
    'KWD': 'Kuwaiti Dinar',
    'GBP': 'British Pound',
    'JPY': 'Japanese Yen',
    'CAD': 'Canadian Dollar',
    'AUD': 'Australian Dollar',
    'SGD': 'Singapore Dollar',
    'TRY': 'Turkish Lira',
    'INR': 'Indian Rupee',
  };

  static const Map<String, String> arabicNames = {
    'SAR': 'ريال سعودي',
    'USD': 'دولار أمريكي',
    'EUR': 'يورو',
    'EGP': 'جنيه مصري',
    'AED': 'درهم إماراتي',
    'KWD': 'دينار كويتي',
    'GBP': 'جنيه إسترليني',
    'JPY': 'ين ياباني',
    'CAD': 'دولار كندي',
    'AUD': 'دولار أسترالي',
    'SGD': 'دولار سنغافوري',
    'TRY': 'ليرة تركية',
    'INR': 'روبية هندية',
  };

  static const Map<String, double> ratesFromSAR = {
    'SAR': 1.0,
    'USD': 0.27,
    'EUR': 0.25,
    'EGP': 13.2,
    'AED': 0.98,
    'KWD': 0.082,
    'GBP': 0.21,
    'JPY': 40.5,
    'CAD': 0.37,
    'AUD': 0.41,
    'SGD': 0.36,
    'TRY': 9.2,
    'INR': 22.4,
  };

  double convert(double priceInSAR) {
    return priceInSAR * (ratesFromSAR[_currency] ?? 1.0);
  }

  String format(double priceInSAR, {bool isAr = false}) {
    final converted = convert(priceInSAR);
    final label = isAr ? arabicNames[_currency]! : _currency;
    return '${converted.toStringAsFixed(0)} $label';
  }
}