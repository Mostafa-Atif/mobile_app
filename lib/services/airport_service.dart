import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/airport_data.dart';

Future<List<AirportData>> loadAirports(BuildContext context) async {
  final locale = Localizations.localeOf(context).languageCode;
  final String data = await rootBundle.loadString('assets/data/airports_$locale.json');
  final List json = jsonDecode(data);
  return json.map((e) => AirportData.fromJson(e)).toList();
}