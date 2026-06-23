class AirportData {
  final String code, name, city, country;
  final double lat, lng;

  const AirportData({
    required this.code, required this.name,
    required this.city, required this.country,
    required this.lat,  required this.lng,
  });

  factory AirportData.fromJson(Map<String, dynamic> json) => AirportData(
    code:    json['code'],
    name:    json['name'],
    city:    json['city'],
    country: json['country'],
    lat:     (json['lat'] as num).toDouble(),
    lng:     (json['lng'] as num).toDouble(),
  );
}