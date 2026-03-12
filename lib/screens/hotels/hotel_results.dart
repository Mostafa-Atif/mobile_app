// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:mobile_app/screens/hotels/hotel_details.dart';

class HotelResults extends StatefulWidget {
  final String destination;
  final DateTime checkIn;
  final DateTime checkOut;
  final int numRooms;
  final int numAdults;
  final int numChildren;
  final String searchType;

  const HotelResults({
    super.key,
    required this.destination,
    required this.checkIn,
    required this.checkOut,
    required this.numRooms,
    required this.numAdults,
    required this.numChildren,
    required this.searchType,
  });

  @override
  State<HotelResults> createState() => _HotelResultsState();
}

class _HotelResultsState extends State<HotelResults> {
  static const Color _teal = Color(0xFF1f93a0);

  List<Map<String, dynamic>> allHotels = [];
  List<Map<String, dynamic>> filteredHotels = [];
  bool isLoading = true;

  String searchQuery = '';
  String? selectedRating;
  String? selectedView;
  String? sortOption;

  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadHotels();
  }

  Future<void> loadHotels() async {
    final String jsonString = await rootBundle.loadString('assets/hotels.json');
    final List<dynamic> jsonData = json.decode(jsonString);

    final loaded = jsonData
        .where((hotel) {
          if (widget.searchType == 'country') {
            return hotel["country"]["en"].toString().toLowerCase() ==
                widget.destination.toLowerCase();
          } else {
            return hotel["city"]["en"].toString().toLowerCase() ==
                widget.destination.toLowerCase();
          }
        })
        .map((hotel) => {
              "title": hotel["name"]["en"],
              "subTitle": "${hotel["city"]["en"]}, ${hotel["country"]["en"]}",
              "rating": hotel["rating"].toString(),
              "reviews": "See reviews",
              "price": hotel["price"].toString(),
              "views": hotel["views"] as List<dynamic>,
              "imgUrl": hotel["image"],
              "isFavorite": false,
            })
        .toList();

    setState(() {
      allHotels = loaded;
      filteredHotels = loaded;
      isLoading = false;
    });
  }

  void applyFilters() {
    List<Map<String, dynamic>> result = List.from(allHotels);

    if (searchQuery.isNotEmpty) {
      result = result
          .where((h) => h['title']
              .toString()
              .toLowerCase()
              .contains(searchQuery.toLowerCase()))
          .toList();
    }

    if (selectedRating != null) {
      result =
          result.where((h) => h['rating'].toString() == selectedRating).toList();
    }

    if (selectedView != null) {
      result = result
          .where((h) => (h['views'] as List).contains(selectedView))
          .toList();
    }

    if (sortOption == 'Price: Low to High') {
      result.sort(
          (a, b) => int.parse(a['price']).compareTo(int.parse(b['price'])));
    } else if (sortOption == 'Price: High to Low') {
      result.sort(
          (a, b) => int.parse(b['price']).compareTo(int.parse(a['price'])));
    } else if (sortOption == 'Rating') {
      result.sort(
          (a, b) => int.parse(b['rating']).compareTo(int.parse(a['rating'])));
    }

    setState(() => filteredHotels = result);
  }

  void showSortSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Sort by',
                  style:
                      TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              SizedBox(height: 12),
              ...['Price: Low to High', 'Price: High to Low', 'Rating']
                  .map((opt) {
                final selected = sortOption == opt;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(opt),
                  trailing:
                      selected ? Icon(Icons.check, color: _teal) : null,
                  onTap: () {
                    setState(() => sortOption = selected ? null : opt);
                    applyFilters();
                    Navigator.pop(context);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void showFilterSheet() {
    final views = allHotels
        .expand((h) => h['views'] as List)
        .toSet()
        .cast<String>()
        .toList()
      ..sort();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) {
        String? tempRating = selectedRating;
        String? tempView = selectedView;

        return StatefulBuilder(
          builder: (ctx, setSheet) {
            return Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Filter',
                      style: TextStyle(
                          fontSize: 17, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),

                  Text('Property Rating',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: ['5', '4'].map((r) {
                      final selected = tempRating == r;
                      return ChoiceChip(
                        label: Text('$r ★'),
                        selected: selected,
                        selectedColor: _teal,
                        labelStyle: TextStyle(
                            color:
                                selected ? Colors.white : Colors.black),
                        onSelected: (_) => setSheet(
                            () => tempRating = selected ? null : r),
                      );
                    }).toList(),
                  ),

                  SizedBox(height: 16),
                  Text('View',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: views.map((v) {
                      final selected = tempView == v;
                      return ChoiceChip(
                        label: Text(
                            v[0].toUpperCase() + v.substring(1)),
                        selected: selected,
                        selectedColor: _teal,
                        labelStyle: TextStyle(
                            color:
                                selected ? Colors.white : Colors.black),
                        onSelected: (_) => setSheet(
                            () => tempView = selected ? null : v),
                      );
                    }).toList(),
                  ),

                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              selectedRating = null;
                              selectedView = null;
                            });
                            applyFilters();
                            Navigator.pop(context);
                          },
                          child: Text('Clear all'),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedRating = tempRating;
                              selectedView = tempView;
                            });
                            applyFilters();
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: _teal,
                              foregroundColor: Colors.white),
                          child: Text('Apply'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                ],
              ),
            );
          },
        );
      },
    );
  }

  bool get hasActiveFilters =>
      selectedRating != null || selectedView != null;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
          body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
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
                "${widget.checkIn.day}/${widget.checkIn.month} - ${widget.checkOut.day}/${widget.checkOut.month} · ${widget.numRooms} room${widget.numRooms != 1 ? 's' : ''}, ${widget.numAdults} adult${widget.numAdults != 1 ? 's' : ''}, ${widget.numChildren} children",
                style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: searchController,
                onChanged: (val) {
                  searchQuery = val;
                  applyFilters();
                },
                decoration: InputDecoration(
                  hintText: "Search by hotel name",
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 8, vertical: 14),
                  suffixIcon: searchQuery.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            searchController.clear();
                            searchQuery = '';
                            applyFilters();
                          },
                        )
                      : null,
                ),
              ),
            ),
          ),

          // Sort & Filter
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                _actionChip(Icons.swap_vert, 'Sort by',
                    sortOption != null, showSortSheet),
                SizedBox(width: 10),
                _actionChip(
                    Icons.tune, 'Filter', hasActiveFilters, showFilterSheet),
              ],
            ),
          ),

          const Divider(height: 1),

          // Result count
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Center(
              child: Text(
                "${filteredHotels.length} properties found in ${widget.destination}",
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          ),

          // Hotel list
          Expanded(
            child: filteredHotels.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search_off,
                            size: 48, color: Colors.grey[300]),
                        SizedBox(height: 12),
                        Text('No properties match your filters',
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredHotels.length,
                    itemBuilder: (context, index) {
                      return _buildHotelCard(filteredHotels[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _actionChip(
      IconData icon, String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? Color(0xFFE0F5F7) : Colors.white,
          border:
              Border.all(color: active ? _teal : Colors.grey[300]!),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon,
                size: 16, color: active ? _teal : Colors.grey[700]),
            SizedBox(width: 6),
            Text(label,
                style: TextStyle(
                    fontSize: 13,
                    color: active ? _teal : Colors.grey[700],
                    fontWeight: active
                        ? FontWeight.w600
                        : FontWeight.normal)),
          ],
        ),
      ),
    );
  }

  Widget _buildHotelCard(Map<String, dynamic> hotel) {
    final title = hotel["title"];
    final subTitle = hotel["subTitle"];
    final rating = hotel["rating"];
    final price = hotel["price"];
    final imgUrl = hotel["imgUrl"];
    final isFavorite = hotel["isFavorite"] as bool;
    final allIndex = allHotels.indexOf(hotel);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HotelDetails(
              hotel: hotel,
              checkIn: widget.checkIn,
              checkOut: widget.checkOut,
              numRooms: widget.numRooms,
              numAdults: widget.numAdults,
              numChildren: widget.numChildren,
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
            BoxShadow(
                color: Colors.black.withOpacity(0.05), blurRadius: 10)
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(15)),
                  child: Image.network(
                    imgUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 200,
                      width: double.infinity,
                      color: Color(0xFFE0F5F7),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.hotel, size: 48, color: _teal),
                          SizedBox(height: 8),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text(title,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: _teal,
                                    fontWeight: FontWeight.w500)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: IconButton(
                    icon: Icon(
                        isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.white,
                        size: 28),
                    onPressed: () {
                      setState(() {
                        if (allIndex != -1)
                          allHotels[allIndex]["isFavorite"] = !isFavorite;
                        hotel["isFavorite"] = !isFavorite;
                      });
                    },
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
                      Expanded(
                        child: Text(title,
                            style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold)),
                      ),
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
                  const SizedBox(height: 12),
                  Text("SAR $price",
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.cyan)),
                  const Text("Total price for 1 night (including taxes)",
                      style:
                          TextStyle(color: Colors.grey, fontSize: 11)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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