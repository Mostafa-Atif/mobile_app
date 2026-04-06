// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import 'hotel_booking.dart';

class HotelDetails extends StatefulWidget {
  final Map<String, dynamic> hotel;
  final DateTime checkIn;
  final DateTime checkOut;
  final int numRooms;
  final int numAdults;
  final int numChildren;

  const HotelDetails({
    super.key,
    required this.hotel,
    required this.checkIn,
    required this.checkOut,
    required this.numRooms,
    required this.numAdults,
    required this.numChildren,
  });

  @override
  State<HotelDetails> createState() => _HotelDetailsState();
}

class _HotelDetailsState extends State<HotelDetails> {
  static const Color _teal = Color(0xFF1f93a0);
  static const Color _red = Color(0xFFE84545);

  bool isFavorite = false;
  late DateTime checkInDate;
  late DateTime checkOutDate;
  late int numRooms;
  late int numAdults;
  late int numChildren;

  @override
  void initState() {
    super.initState();
    checkInDate = DateTime(widget.checkIn.year, widget.checkIn.month, widget.checkIn.day);
    checkOutDate = DateTime(widget.checkOut.year, widget.checkOut.month, widget.checkOut.day);
    numRooms = widget.numRooms;
    numAdults = widget.numAdults;
    numChildren = widget.numChildren;
  }

  int get nightCount => checkOutDate.difference(checkInDate).inDays;
  int get numPeople => numAdults + numChildren;

  String formatDate(DateTime date) {
    List<String> months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
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

  String _viewLabel(String view) => view[0].toUpperCase() + view.substring(1) + ' View';

  String _ratingLabel(int rating) {
    switch (rating) {
      case 5: return 'Exceptional';
      case 4: return 'Excellent';
      case 3: return 'Very Good';
      case 2: return 'Good';
      default: return 'Standard';
    }
  }

  Widget _counter(String label, int value, VoidCallback onDec, VoidCallback onInc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 15)),
        Row(
          children: [
            IconButton(icon: Icon(Icons.remove_circle_outline, color: _teal), onPressed: onDec),
            SizedBox(width: 32,
                child: Text('$value', textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            IconButton(icon: Icon(Icons.add_circle_outline, color: _teal), onPressed: onInc),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final hotel = widget.hotel;
    final String name = hotel['title'] ?? '';
    final String subTitle = hotel['subTitle'] ?? '';
    final int rating = int.tryParse(hotel['rating'].toString()) ?? 0;
    final int price = int.tryParse(hotel['price'].toString()) ?? 0;
    final String imgUrl = hotel['imgUrl'] ?? '';
    final List<dynamic> views = hotel['views'] ?? [];
    final int totalPrice = price * nightCount * numRooms;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
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
                  icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.black),
                  onPressed: () => setState(() => isFavorite = !isFavorite),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(imgUrl, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: Color(0xFFE0F5F7),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(Icons.hotel, size: 60, color: _teal),
                      SizedBox(height: 8),
                      Text(name, style: TextStyle(color: _teal, fontWeight: FontWeight.w500)),
                    ]),
                  )),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: Text(name,
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
                      SizedBox(width: 12),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(color: _teal, borderRadius: BorderRadius.circular(8)),
                        child: Column(
                          children: [
                            Text(rating.toString(), style: TextStyle(color: Colors.white,
                                fontWeight: FontWeight.bold, fontSize: 18)),
                            Text(_ratingLabel(rating),
                                style: TextStyle(color: Colors.white70, fontSize: 11)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(children: List.generate(rating, (i) =>
                      Icon(Icons.star, color: Colors.amber, size: 18))),
                  SizedBox(height: 12),

                  Container(
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!)),
                    child: Row(
                      children: [
                        Icon(Icons.location_on, color: _teal, size: 22),
                        SizedBox(width: 10),
                        Expanded(child: Text(subTitle,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
                      ],
                    ),
                  ),

                  SizedBox(height: 16),

                  if (views.isNotEmpty) ...[
                    Text(l.views, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Wrap(
                      spacing: 10, runSpacing: 10,
                      children: views.map((view) => Container(
                        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(color: Color(0xFFE0F5F7),
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(_viewIcon(view.toString()), size: 16, color: _teal),
                            SizedBox(width: 6),
                            Text(_viewLabel(view.toString()),
                                style: TextStyle(color: _teal, fontSize: 13,
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                      )).toList(),
                    ),
                    SizedBox(height: 16),
                  ],

                  Text(l.yourStay, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () async {
                            final picked = await showDatePicker(context: context,
                                initialDate: checkInDate, firstDate: DateTime.now(),
                                lastDate: DateTime(2100));
                            if (picked != null) setState(() {
                              checkInDate = picked;
                              if (checkOutDate.isBefore(checkInDate) ||
                                  checkOutDate.isAtSameMomentAs(checkInDate))
                                checkOutDate = checkInDate.add(Duration(days: 1));
                            });
                          },
                          style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.grey[300]!, width: 2),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              padding: EdgeInsets.symmetric(vertical: 14), foregroundColor: _teal),
                          child: Column(children: [
                            Text(l.checkIn, style: TextStyle(color: Colors.grey, fontSize: 12)),
                            SizedBox(height: 4),
                            Text(formatDate(checkInDate),
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                          ]),
                        ),
                      ),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(Icons.arrow_forward, color: Colors.grey)),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () async {
                            final picked = await showDatePicker(context: context,
                                initialDate: checkOutDate,
                                firstDate: checkInDate.add(Duration(days: 1)),
                                lastDate: DateTime(2100));
                            if (picked != null) setState(() => checkOutDate = picked);
                          },
                          style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.grey[300]!, width: 2),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              padding: EdgeInsets.symmetric(vertical: 14), foregroundColor: _teal),
                          child: Column(children: [
                            Text(l.checkOut, style: TextStyle(color: Colors.grey, fontSize: 12)),
                            SizedBox(height: 4),
                            Text(formatDate(checkOutDate),
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                          ]),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Center(child: Text(l.nights(nightCount),
                      style: TextStyle(color: Colors.grey[600], fontSize: 13))),

                  SizedBox(height: 20),

                  Text(l.roomsAndGuests,
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!)),
                    child: Column(
                      children: [
                        _counter(l.rooms, numRooms,
                            () { if (numRooms > 1) setState(() => numRooms--); },
                            () => setState(() => numRooms++)),
                        Divider(height: 16),
                        _counter('${l.adults} (12+)', numAdults,
                            () { if (numAdults > 1) setState(() => numAdults--); },
                            () => setState(() => numAdults++)),
                        Divider(height: 16),
                        _counter('${l.children} (0-11)', numChildren,
                            () { if (numChildren > 0) setState(() => numChildren--); },
                            () => setState(() => numChildren++)),
                      ],
                    ),
                  ),

                  SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]),
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('SAR $price${l.perNight}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(l.totalNightsRooms(totalPrice, nightCount, numRooms),
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => HotelBooking(
                    hotelName: name,
                    checkIn: checkInDate,
                    checkOut: checkOutDate,
                    numRooms: numRooms,
                    numAdults: numAdults,
                    numChildren: numChildren,
                    pricePerNight: price,
                    nights: nightCount,
                  ),
                ));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _red, foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: StadiumBorder(),
              ),
              child: Text(l.bookNow,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}