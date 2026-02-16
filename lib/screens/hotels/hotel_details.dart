// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HotelDetails extends StatefulWidget {
  HotelDetails({super.key});


  @override
  State<HotelDetails> createState() => _HotelDetailsState();
}

class _HotelDetailsState extends State<HotelDetails> {

  final images = [
    'images/hotels/hotel1.webp',
    'images/hotels/hotel2.webp',
    'images/hotels/hotel3.webp',
    'images/hotels/hotel4.webp',
  ];

  DateTime checkInDate = DateTime.now();
  DateTime checkOutDate = DateTime.now().add(Duration(days: 1));


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: Text(
          'Hotel',
          style: TextStyle(color: Colors.black),
          // TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.lightBlueAccent,
        // elevation: 0,  // remove shadow
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_outlined),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.favorite_outline),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        children: [
          Container(
            height: 200,
            child: Stack(
              children: [
                PageView.builder(
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return Image.asset(images[index], fit: BoxFit.cover,);
                  },
                ),
                // Photo count (top right corner)
                Positioned(
                  top: 20,
                  right: 20,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text('4 📷', style: TextStyle(color: Colors.white)),
                  ),
                ),
                
                // Hotel info (bottom left)
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Some Hotel Somewhere',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 51, 161, 212),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text('Hotel', style: TextStyle(color: Colors.white)),
                          ),
                          SizedBox(width: 8),
                          for (int i = 1; i <= 3; i++)
                            Icon(Icons.star, color: Colors.amber, size: 16),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )
          ),
          SizedBox(height: 12),
          Row(
            children: [
              // Rating box (left)
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '7.0',
                        style: TextStyle(
                          // backgroundColor: Colors.orange,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Good',
                      style: TextStyle(color: Colors.black),
                    ),
                    Text(
                      '103 Reviews',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16),
              
              // Reviews box (right)
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 227, 246, 255),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text('103 Reviews', style: TextStyle(color: Colors.grey, fontSize: 16,)),
                      SizedBox(height: 8),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'View Reviews',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(width: 16),
            ],
          ),
          SizedBox(height: 16,),
          Row(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 30,),
              Image.asset(
                'images/Gmaps.jpg',
                // height: 150,
              ),
              Expanded(
                child: Column(
                  children: [
                    Text('Location', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    // SizedBox(height: 8),
                    Text('Somewhere in the world that starts with an N.\nProbably a third world country.'),
                    // SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        // Open Google Maps app or link
                      },
                      child: Text('Open in Maps', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 30,),
            ],
          ),
          SizedBox(height: 16,),

          Row(
            children: [
              SizedBox(width: 16),
              Expanded(
                flex: 1,
                child: OutlinedButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      setState(() {
                        checkInDate = picked;
                      });
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey[300]!, width: 2),  // border
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),  // rounded corners
                    padding: EdgeInsets.symmetric(vertical: 15),  // padding
                    foregroundColor: Color(0xFF1f93a0),  // text color
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Check in',
                        style: TextStyle(
                          color: Colors.black,
                          ),
                        ),
                        Text(
                          DateFormat('dd MMM').format(checkInDate),
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                flex: 1,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey[300]!, width: 2),  // border
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),  // rounded corners
                    padding: EdgeInsets.symmetric(vertical: 15),  // padding
                    foregroundColor: Color(0xFF1f93a0),  // text color
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Check out',
                        style: TextStyle(
                          color: Colors.black,
                          ),
                        ),
                        Text(
                          DateFormat('dd MMM').format(checkOutDate),
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey[300]!, width: 2),  // border
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),  // rounded corners
                    padding: EdgeInsets.symmetric(vertical: 25),  // padding
                    foregroundColor: Color(0xFF1f93a0),  // text color
                  ),
                  child: Text('1 Room, 1 Adult, 0 Children', style: TextStyle(fontWeight: FontWeight.bold),),
                ),
              ),
              SizedBox(width: 16),
            ],
          )



        ],
      ),
    );
  }
}