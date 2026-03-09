// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

import 'package:mobile_app/screens/hotels/hotel_details.dart';

class HotelResults extends StatefulWidget {
  final String destination;
  final DateTime checkIn;
  final DateTime checkOut;
  final String guests;

  const HotelResults({
    super.key,
    required this.destination,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
  });

  @override
  State<HotelResults> createState() => _HotelResultsState();
}

class _HotelResultsState extends State<HotelResults> {
  List<Map<String, dynamic>> hotels = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadHotels();
  }

  Future<void> loadHotels() async {
    final String jsonString = await rootBundle.loadString('assets/hotels.json');
    final List<dynamic> jsonData = json.decode(jsonString);

    setState(() {
      hotels = jsonData
          .where((hotel) =>
              hotel["city"]["en"].toString().toLowerCase() ==
              widget.destination.toLowerCase())
          .map((hotel) => {
                "title": hotel["name"]["en"],
                "subTitle": "${hotel["city"]["en"]}, ${hotel["country"]["en"]}",
                "rating": hotel["rating"].toString(),
                "reviews": "See reviews",
                "price": hotel["price"].toString(),
                "imgUrl": hotel["image"],
                "isFavorite": false,
              })
          .toList();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // if still loading, show a spinner
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      // ... rest of your build method stays EXACTLY the same
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.cyan),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            Text(widget.destination,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            Text(
                "${widget.checkIn.day}/${widget.checkIn.month} - ${widget.checkOut.day}/${widget.checkOut.month}, ${widget.guests}",
                style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          /* ================= SEARCH ================= */
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "Search for accommodations",
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                ),
              ),
            ),
          ),

          /* ================= ACTION ROW ================= */
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ActionItem(icon: Icons.swap_vert, label: "Sort by"),
                _ActionItem(icon: Icons.tune, label: "Filter"),
                _ActionItem(icon: Icons.map_outlined, label: "Map"),
              ],
            ),
          ),
          const Divider(height: 1),

          /* ================= FILTER DROPDOWNS ================= */
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: Row(
              children: [
                _filterDropdown(
                    "Popular Locations", ["Deira", "Marina", "Downtown"]),
                _filterDropdown("Top Categories in Dubai",
                    ["Luxury", "Family", "Business"]),
                _filterDropdown(
                    "Property Rating", ["5 Stars", "4 Stars", "All"]),
              ],
            ),
          ),

          /* ================= RESULT COUNT (المرتجع) ================= */
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Center(
              child: Text(
                "${hotels.length} properties found in Dubai",
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          ),

          /* ================= HOTEL LIST ================= */
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: hotels.length,
              itemBuilder: (context, index) {
                final hotel = hotels[index];
                return _buildHotelCard(
                  index,
                  hotel["title"],
                  hotel["subTitle"],
                  hotel["rating"],
                  hotel["reviews"],
                  hotel["price"],
                  hotel["imgUrl"],
                  hotel["isFavorite"],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /* ================= DROP DOWN FILTER ================= */
  Widget _filterDropdown(String label, List<String> options) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: PopupMenuButton<String>(
        onSelected: (value) {},
        itemBuilder: (context) => options
            .map((opt) => PopupMenuItem(value: opt, child: Text(opt)))
            .toList(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Text(label, style: const TextStyle(fontSize: 12)),
              const SizedBox(width: 4),
              const Icon(Icons.keyboard_arrow_down,
                  size: 18, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  /* ================= HOTEL CARD ================= */
  Widget _buildHotelCard(
      int index,
      String title,
      String subTitle,
      String rating,
      String reviews,
      String price,
      String imgUrl,
      bool isFavorite) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HotelDetails(
                hotel: hotels[index],
                checkIn: widget.checkIn,
                checkOut: widget.checkOut,
              ),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey[200]!),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(15)),
                    child: Image.network(imgUrl,
                        height: 200, width: double.infinity, fit: BoxFit.cover),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: IconButton(
                      icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.white,
                          size: 28),
                      onPressed: () => setState(
                          () => hotels[index]["isFavorite"] = !isFavorite),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(title,
                            style: const TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold)),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                              color: Colors.cyan[50],
                              borderRadius: BorderRadius.circular(5)),
                          child: Row(
                            children: [
                              Text(rating,
                                  style: const TextStyle(
                                      color: Colors.cyan,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(width: 4),
                              const Icon(Icons.star,
                                  color: Colors.cyan, size: 14),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Text(subTitle,
                        style: const TextStyle(
                            color: Colors.black54, fontSize: 13)),
                    const SizedBox(height: 8),
                    Text(reviews,
                        style: const TextStyle(
                            color: Colors.black87, fontSize: 12)),
                    const SizedBox(height: 12),
                    Text("SAR $price",
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.cyan)),
                    const Text("Total price for 1 night (including taxes)",
                        style: TextStyle(color: Colors.grey, fontSize: 11)),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

class _ActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  const _ActionItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}
