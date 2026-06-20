import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HotelMapWidget extends StatefulWidget {
  final Map<String, dynamic> hotel;
  final ThemeData appTheme;

  const HotelMapWidget({
    Key? key,
    required this.hotel,
    required this.appTheme,
  }) : super(key: key);

  @override
  State<HotelMapWidget> createState() => _HotelMapWidgetState();
}

class _HotelMapWidgetState extends State<HotelMapWidget> {
  LatLng? hotelLocation;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _geocodeHotel();
  }

  Future<void> _geocodeHotel() async {
    try {
      final hotelName = widget.hotel['name'] is Map
          ? widget.hotel['name']['en']
          : widget.hotel['name'];
      final city = widget.hotel['city'] is Map
          ? widget.hotel['city']['en']
          : widget.hotel['city'];

      final query = '$hotelName, $city';
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=1',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> results = jsonDecode(response.body);
        if (results.isNotEmpty) {
          final lat = double.parse(results[0]['lat']);
          final lng = double.parse(results[0]['lon']);
          final location = LatLng(lat, lng);

          setState(() {
            hotelLocation = location;
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = 'Location not found';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'Failed to load location';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Location',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        SizedBox(height: 10),
        if (isLoading)
          Container(
            height: 250,
            margin: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: widget.appTheme.scaffoldBackgroundColor,
            ),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        else if (errorMessage != null)
          Container(
            height: 250,
            margin: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: widget.appTheme.scaffoldBackgroundColor,
            ),
            child: Center(
              child: Text(errorMessage!),
            ),
          )
        else if (hotelLocation != null)
          Container(
            height: 250,
            margin: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            clipBehavior: Clip.hardEdge,
            child: FlutterMap(
              options: MapOptions(
                initialCenter: hotelLocation!,
                initialZoom: 15,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: hotelLocation!,
                      width: 40,
                      height: 40,
                      child: Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }
}
