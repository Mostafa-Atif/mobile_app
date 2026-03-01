import 'package:flutter/material.dart';
import 'guests_picker.dart';
import 'flightsearch.dart';

class HotelSearch extends StatefulWidget {
  @override
  _HotelSearchState createState() => _HotelSearchState();
}

class _HotelSearchState extends State<HotelSearch> {
  
  String selectedDestination = 'Dubai';

  DateTime checkInDate = DateTime(2026, 2, 8);
  DateTime checkOutDate = DateTime(2026, 2, 9);

  List<RoomData> roomsList = [
  RoomData(adults: 2, children: 0),
];
  
  List<String> destinations = [
    'Dubai',
    'Paris',
    'London',
    'New York',
    'Tokyo',
    'Cairo',
  ];
  
  void showDestinationPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Destination'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: destinations.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(destinations[index]),
                  onTap: () {
                    setState(() {
                      selectedDestination = destinations[index];
                    });
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> selectDate(BuildContext context, bool isCheckIn) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: isCheckIn ? checkInDate : checkOutDate,
    firstDate: DateTime(2020),
    lastDate: DateTime(2030),
  );
  
  if (picked != null) {
    setState(() {
      if (isCheckIn) {
        checkInDate = picked;
        // Make sure check-out is after check-in
        if (checkOutDate.isBefore(checkInDate) || checkOutDate.isAtSameMomentAs(checkInDate)) {
          checkOutDate = checkInDate.add(Duration(days: 1));
        }
      } else {
        checkOutDate = picked;
      }
    });
  }
}
  
  String formatDate(DateTime date) {
    List<String> months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }
  
String formatGuests() {
  int totalAdults = 0;
  int totalChildren = 0;
  
  for (var room in roomsList) {
    totalAdults += room.adults;
    totalChildren += room.children;
  }
  
  return '${roomsList.length} Room${roomsList.length > 1 ? 's' : ''}, $totalAdults Adult${totalAdults > 1 ? 's' : ''}, $totalChildren Children';
}
  void showGuestsPicker() {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return GuestsPicker(
        initialRooms: roomsList,
        onDone: (newRooms) {
          setState(() {
            roomsList = newRooms;
          });
        },
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.all(16),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'Search stays',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'Over 1M properties at your fingertips',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Search Card
            Padding(
              padding: EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Destination field - CLICKABLE
                    GestureDetector(
                      onTap: showDestinationPicker,
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: Colors.grey,
                            size: 28,
                          ),
                          SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Destination',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                selectedDestination,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    // Divider
                    SizedBox(height: 16),
                    Divider(color: Colors.grey[300], thickness: 1),
                    SizedBox(height: 16),
                    
                    // Check-in and Check-out
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          color: Colors.grey,
                          size: 28,
                        ),
                        SizedBox(width: 16),
                        
                        // Check-in 
                        Expanded(
                          child: GestureDetector(
                            onTap: () => selectDate(context, true),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Check in',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  formatDate(checkInDate),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.grey,
                          size: 20,
                        ),
                        SizedBox(width: 16),
                        
                        // Check-out 
                        Expanded(
                          child: GestureDetector(
                            onTap: () => selectDate(context, false),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Check out',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  formatDate(checkOutDate),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    // Divider
                    SizedBox(height: 16),
                    Divider(color: Colors.grey[300], thickness: 1),
                    SizedBox(height: 16),
                    
                    // Guests
                    GestureDetector(
                      onTap: showGuestsPicker,
                      child: Row(
                        children: [
                          Icon(
                            Icons.people_outline,
                            color: Colors.grey,
                            size: 28,
                          ),
                          SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Guests',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                formatGuests(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Search button
                    ElevatedButton(
                       onPressed: () {
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FlightSearch()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        minimumSize: Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search, size: 24),
                          SizedBox(width: 8),
                          Text(
                            'Search properties',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}