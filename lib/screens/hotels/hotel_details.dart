// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';

class HotelDetails extends StatefulWidget {
  final Map<String, dynamic> hotel;

  const HotelDetails({super.key, required this.hotel});

  @override
  State<HotelDetails> createState() => _HotelDetailsState();
}

class _HotelDetailsState extends State<HotelDetails> {
  static const Color _teal = Color(0xFF1f93a0);
  static const Color _red = Color(0xFFE84545);

  bool isFavorite = false;

  DateTime checkInDate = DateTime.now();
  DateTime checkOutDate = DateTime.now().add(Duration(days: 1));

  int get nightCount => checkOutDate.difference(checkInDate).inDays;

  String formatDate(DateTime date) {
    List<String> months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]}';
  }

  IconData _viewIcon(String view) {
    switch (view) {
      case 'sea': return Icons.waves;
      case 'pool': return Icons.pool;
      case 'garden': return Icons.park;
      case 'city': return Icons.location_city;
      case 'mountain': return Icons.landscape;
      case 'river': return Icons.water;
      case 'lake': return Icons.water;
      case 'harbor': return Icons.anchor;
      default: return Icons.visibility;
    }
  }

  String _viewLabel(String view) {
    return view[0].toUpperCase() + view.substring(1) + ' View';
  }

  String _ratingLabel(int rating) {
    switch (rating) {
      case 5: return 'Exceptional';
      case 4: return 'Excellent';
      case 3: return 'Very Good';
      case 2: return 'Good';
      default: return 'Standard';
    }
  }

  @override
  Widget build(BuildContext context) {
    final hotel = widget.hotel;
    final String name = hotel['title'] ?? '';
    final String subTitle = hotel['subTitle'] ?? '';
    final int rating = int.tryParse(hotel['rating'].toString()) ?? 0;
    final int price = int.tryParse(hotel['price'].toString()) ?? 0;
    final String imgUrl = hotel['imgUrl'] ?? '';
    final List<dynamic> views = hotel['views'] ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // ── Hero image app bar ──
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: Colors.white,
            foregroundColor: _teal,
            leading: Container(
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.of(context).maybePop(),
              ),
            ),
            actions: [
              Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.black,
                  ),
                  onPressed: () => setState(() => isFavorite = !isFavorite),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                imgUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey[200],
                  child: Icon(Icons.image_not_supported, size: 60, color: Colors.grey),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ── Name + Rating badge ──
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(width: 12),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: _teal,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Text(
                              rating.toString(),
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            Text(
                              _ratingLabel(rating),
                              style: TextStyle(color: Colors.white70, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 8),

                  // ── Stars ──
                  Row(
                    children: List.generate(
                      rating,
                      (i) => Icon(Icons.star, color: Colors.amber, size: 18),
                    ),
                  ),

                  SizedBox(height: 12),

                  // ── Location ──
                  Container(
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.location_on, color: _teal, size: 22),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(subTitle,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16),

                  // ── Views ──
                  if (views.isNotEmpty) ...[
                    Text('Views', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: views.map((view) {
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: Color(0xFFE0F5F7),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(_viewIcon(view.toString()), size: 16, color: _teal),
                              SizedBox(width: 6),
                              Text(
                                _viewLabel(view.toString()),
                                style: TextStyle(color: _teal, fontSize: 13, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 16),
                  ],

                  // ── Check-in / Check-out ──
                  Text('Your Stay', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: checkInDate,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) setState(() {
                              checkInDate = picked;
                              if (checkOutDate.isBefore(checkInDate) || checkOutDate.isAtSameMomentAs(checkInDate)) {
                                checkOutDate = checkInDate.add(Duration(days: 1));
                              }
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.grey[300]!, width: 2),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: EdgeInsets.symmetric(vertical: 14),
                            foregroundColor: _teal,
                          ),
                          child: Column(
                            children: [
                              Text('Check in', style: TextStyle(color: Colors.grey, fontSize: 12)),
                              SizedBox(height: 4),
                              Text(formatDate(checkInDate),
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black)),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Icon(Icons.arrow_forward, color: Colors.grey),
                      ),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: checkOutDate,
                              firstDate: checkInDate.add(Duration(days: 1)),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) setState(() => checkOutDate = picked);
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.grey[300]!, width: 2),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: EdgeInsets.symmetric(vertical: 14),
                            foregroundColor: _teal,
                          ),
                          child: Column(
                            children: [
                              Text('Check out', style: TextStyle(color: Colors.grey, fontSize: 12)),
                              SizedBox(height: 4),
                              Text(formatDate(checkOutDate),
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10),

                  // Night count info
                  Center(
                    child: Text(
                      '$nightCount night${nightCount != 1 ? 's' : ''}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                  ),

                  SizedBox(height: 100), // space for bottom bar
                ],
              ),
            ),
          ),
        ],
      ),

      // ── Bottom Book Now bar ──
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SAR $price / night',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                Text(
                  'SAR ${price * nightCount} total ($nightCount nights)',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: _red,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: StadiumBorder(),
              ),
              child: Text('Book Now', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}