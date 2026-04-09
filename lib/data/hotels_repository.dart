import 'dart:convert';

import 'package:flutter/services.dart';

class HotelsRepository {
  static const String _assetPath = 'data/hotels.json';

  Future<List<Map<String, dynamic>>> loadHotels() async {
    final jsonString = await rootBundle.loadString(_assetPath);
    final decoded = json.decode(jsonString) as List<dynamic>;
    return decoded.map((item) => Map<String, dynamic>.from(item as Map)).toList();
  }

  String localizedValue(dynamic mapOrString, String lang) {
    if (mapOrString is Map) {
      return mapOrString[lang]?.toString() ??
          mapOrString['en']?.toString() ??
          mapOrString['ar']?.toString() ??
          '';
    }
    return mapOrString?.toString() ?? '';
  }

  Future<Map<String, List<String>>> loadCountryCityMap(String lang) async {
    final hotels = await loadHotels();
    final map = <String, List<String>>{};

    for (final hotel in hotels) {
      final country = localizedValue(hotel['country'], lang);
      final city = localizedValue(hotel['city'], lang);
      map.putIfAbsent(country, () => []);
      if (!map[country]!.contains(city)) {
        map[country]!.add(city);
      }
    }

    return map;
  }

  Future<List<Map<String, dynamic>>> loadSearchResults({
    required String lang,
    required String destination,
    required String searchType,
    required String reviewsLabel,
  }) async {
    final hotels = await loadHotels();

    return hotels.where((hotel) {
      final country = localizedValue(hotel['country'], lang);
      final city = localizedValue(hotel['city'], lang);
      if (searchType == 'country') {
        return country.toLowerCase() == destination.toLowerCase();
      }
      return city.toLowerCase() == destination.toLowerCase();
    }).map((hotel) {
      final city = localizedValue(hotel['city'], lang);
      final country = localizedValue(hotel['country'], lang);

      return {
        ...hotel,
        'title': localizedValue(hotel['name'], lang),
        'subTitle': '$city, $country',
        'reviews': reviewsLabel,
        'imgUrl': hotel['image'],
        'isFavorite': false,
      };
    }).toList();
  }
}
