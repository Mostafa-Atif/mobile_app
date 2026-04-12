import 'dart:convert';

import 'package:flutter/services.dart';

class DestinationsRepository {
  static const String _assetPath = 'data/destinations.json';

  Future<List<Map<String, dynamic>>> loadDestinations() async {
    final jsonString = await rootBundle.loadString(_assetPath);
    final decoded = json.decode(jsonString) as List<dynamic>;
    return decoded.map((item) => Map<String, dynamic>.from(item as Map)).toList();
  }

  Future<List<Map<String, dynamic>>> loadFeaturedDestinations() async {
    final destinations = await loadDestinations();
    return destinations
        .where((destination) => destination['isHomeFeatured'] == true)
        .toList();
  }

  Future<List<Map<String, dynamic>>> loadHeroDestinations({
    int limit = 4,
  }) async {
    final featuredDestinations = await loadFeaturedDestinations();
    final heroDestinations = featuredDestinations.isNotEmpty
        ? featuredDestinations
        : await loadDestinations();

    return heroDestinations.take(limit).toList();
  }

  Future<Map<String, dynamic>> loadDestinationByName(String destinationName) async {
    final destinations = await loadDestinations();
    return destinations.firstWhere(
      (item) =>
          (item['nameEn'] as String).toLowerCase() ==
          destinationName.toLowerCase(),
      orElse: () => destinations.first,
    );
  }
}
