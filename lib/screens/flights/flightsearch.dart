import 'package:flutter/material.dart';

class FlightSearch extends StatefulWidget {
  @override
  _FlightSearchState createState() => _FlightSearchState();
}

class _FlightSearchState extends State<FlightSearch> {
  // Trip type
  String selectedTripType = 'Round trip';

  // Regular flight data
  String fromCity = 'Cairo';
  String toCity = 'Dubai';
  DateTime departureDate = DateTime.now().add(Duration(days: 1));
  DateTime? returnDate = DateTime.now().add(Duration(days: 3));

  // Regular flight passengers
  int adults = 1;
  int children = 0;
  int infants = 0;
  String cabinClass = 'Economy';

  // Multi-city flights - EACH flight has its own passengers!
  List<Map<String, dynamic>> multiCityFlights = [
    {
      'from': 'Cairo',
      'to': 'Dubai',
      'date': DateTime.now().add(Duration(days: 1)),
      'adults': 1,
      'children': 0,
      'infants': 0,
      'cabinClass': 'Economy',
    },
    {
      'from': 'Dubai',
      'to': 'London',
      'date': DateTime.now().add(Duration(days: 3)),
      'adults': 1,
      'children': 0,
      'infants': 0,
      'cabinClass': 'Economy',
    },
  ];

  // Data lists
  List<String> cities = [
    'Cairo',
    'Dubai',
    'Paris',
    'London',
    'New York',
    'Tokyo',
  ];

  List<String> cabinClasses = [
    'Economy',
    'Premium Economy',
    'Business',
    'First Class',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
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
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    Center(
                      child: Text(
                        'Search Flights',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Trip type selector
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _buildTripTypeButton('One-way'),
                    SizedBox(width: 12),
                    _buildTripTypeButton('Round trip'),
                    SizedBox(width: 12),
                    _buildTripTypeButton('Multi-city'),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // Flight card
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
                    children: selectedTripType == 'Multi-city'
                        ? _buildMultiCitySegments()
                        : _buildRegularFlightFields(),
                  ),
                ),
              ),

              // Search button
              Padding(
                padding: EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: _handleSearch,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Search Flights',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTripTypeButton(String tripType) {
    bool isSelected = selectedTripType == tripType;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTripType = tripType;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.redAccent : Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            tripType,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildRegularFlightFields() {
    return [
      // From field
      GestureDetector(
        onTap: () => showCityPicker(true),
        child: Row(
          children: [
            Icon(Icons.flight_takeoff, color: Colors.grey, size: 28),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('From', style: TextStyle(fontSize: 14, color: Colors.grey)),
                SizedBox(height: 4),
                Text(
                  fromCity,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ],
            ),
          ],
        ),
      ),

      SizedBox(height: 16),
      Divider(color: Colors.grey[300], thickness: 1),
      SizedBox(height: 16),

      // To field
      GestureDetector(
        onTap: () => showCityPicker(false),
        child: Row(
          children: [
            Icon(Icons.flight_land, color: Colors.grey, size: 28),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('To', style: TextStyle(fontSize: 14, color: Colors.grey)),
                SizedBox(height: 4),
                Text(
                  toCity,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ],
            ),
          ],
        ),
      ),

      SizedBox(height: 16),
      Divider(color: Colors.grey[300], thickness: 1),
      SizedBox(height: 16),

      // Date fields - EXACTLY like hotel search
      Row(
        children: [
          Icon(Icons.calendar_today_outlined, color: Colors.grey, size: 28),
          SizedBox(width: 16),
          
          // Departure
          Expanded(
            child: GestureDetector(
              onTap: () => selectFlightDate(true),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Departure',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  SizedBox(height: 4),
                  Text(
                    formatDate(departureDate),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ],
              ),
            ),
          ),

          if (selectedTripType == 'Round trip') ...[
            Icon(Icons.arrow_forward, color: Colors.grey, size: 20),
            SizedBox(width: 16),
            Expanded(
              child: GestureDetector(
                onTap: () => selectFlightDate(false),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Return',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    SizedBox(height: 4),
                    Text(
                      returnDate != null ? formatDate(returnDate!) : 'Select date',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),

      SizedBox(height: 16),
      Divider(color: Colors.grey[300], thickness: 1),
      SizedBox(height: 16),

      // Passengers
      GestureDetector(
        onTap: () => showPassengersPicker(),
        child: Row(
          children: [
            Icon(Icons.person_outline, color: Colors.grey, size: 28),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Passengers & Class',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${adults + children + infants} Passenger${(adults + children + infants) > 1 ? 's' : ''}, $cabinClass',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> _buildMultiCitySegments() {
    List<Widget> segments = [];

    for (int i = 0; i < multiCityFlights.length; i++) {
      segments.add(_buildMultiCitySegment(i));

      if (i < multiCityFlights.length - 1) {
        segments.add(SizedBox(height: 16));
        segments.add(Divider(color: Colors.grey[300], thickness: 2));
        segments.add(SizedBox(height: 16));
      }
    }

    if (multiCityFlights.length < 6) {
      segments.add(SizedBox(height: 16));
      segments.add(
        TextButton.icon(
          onPressed: () {
            setState(() {
              multiCityFlights.add({
                'from': 'Cairo',
                'to': 'Dubai',
                'date': DateTime.now().add(Duration(days: multiCityFlights.length)),
                'adults': 1,
                'children': 0,
                'infants': 0,
                'cabinClass': 'Economy',
              });
            });
          },
          icon: Icon(Icons.add_circle_outline, color: Colors.green),
          label: Text(
            'Add flight (Max ${6 - multiCityFlights.length} more)',
            style: TextStyle(color: Colors.blueGrey, fontSize: 16),
          ),
        ),
      );
    }

    return segments;
  }

  Widget _buildMultiCitySegment(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Flight header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Flight ${index + 1}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            if (multiCityFlights.length > 2)
              IconButton(
                icon: Icon(Icons.close, color: Colors.red),
                onPressed: () {
                  setState(() {
                    multiCityFlights.removeAt(index);
                  });
                },
              ),
          ],
        ),
        
        SizedBox(height: 12),

        // From
        GestureDetector(
          onTap: () => showMultiCityPicker(index, true),
          child: Row(
            children: [
              Icon(Icons.flight_takeoff, color: Colors.grey, size: 24),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('From', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  Text(
                    multiCityFlights[index]['from'],
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        SizedBox(height: 12),

        // To
        GestureDetector(
          onTap: () => showMultiCityPicker(index, false),
          child: Row(
            children: [
              Icon(Icons.flight_land, color: Colors.grey, size: 24),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('To', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  Text(
                    multiCityFlights[index]['to'],
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        SizedBox(height: 12),

        // Date - EXACTLY like hotel search format
        GestureDetector(
          onTap: () => selectMultiCityDate(index),
          child: Row(
            children: [
              Icon(Icons.calendar_today, color: Colors.grey, size: 20),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Date', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  Text(
                    formatDate(multiCityFlights[index]['date']),
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        SizedBox(height: 12),

        // Passengers for THIS specific flight
        GestureDetector(
          onTap: () => showMultiCityPassengersPicker(index),
          child: Row(
            children: [
              Icon(Icons.person_outline, color: Colors.grey, size: 24),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Passengers & Class',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      '${multiCityFlights[index]['adults'] + multiCityFlights[index]['children'] + multiCityFlights[index]['infants']} Passenger${(multiCityFlights[index]['adults'] + multiCityFlights[index]['children'] + multiCityFlights[index]['infants']) > 1 ? 's' : ''}, ${multiCityFlights[index]['cabinClass']}',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void showCityPicker(bool isFrom) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isFrom ? 'Select Departure City' : 'Select Arrival City'),
        content: Container(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: cities.length,
            itemBuilder: (context, i) => ListTile(
              title: Text(cities[i]),
              onTap: () {
                setState(() {
                  if (isFrom) {
                    fromCity = cities[i];
                  } else {
                    toCity = cities[i];
                  }
                });
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
    );
  }

  void showMultiCityPicker(int index, bool isFrom) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isFrom ? 'Select Departure City' : 'Select Arrival City'),
        content: Container(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: cities.length,
            itemBuilder: (context, i) => ListTile(
              title: Text(cities[i]),
              onTap: () {
                setState(() {
                  if (isFrom) {
                    multiCityFlights[index]['from'] = cities[i];
                  } else {
                    multiCityFlights[index]['to'] = cities[i];
                  }
                });
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> selectFlightDate(bool isDeparture) async {
    DateTime initialDate = isDeparture ? departureDate : (returnDate ?? departureDate);
    DateTime firstDate = DateTime.now();
    
    // Make sure initialDate is not before firstDate
    if (initialDate.isBefore(firstDate)) {
      initialDate = firstDate;
    }
    
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        if (isDeparture) {
          departureDate = picked;
          if (returnDate != null && returnDate!.isBefore(departureDate)) {
            returnDate = departureDate.add(Duration(days: 1));
          }
        } else {
          returnDate = picked;
        }
      });
    }
  }

  Future<void> selectMultiCityDate(int index) async {
    DateTime initialDate = multiCityFlights[index]['date'];
    DateTime firstDate = DateTime.now();
    
    // Make sure initialDate is not before firstDate
    if (initialDate.isBefore(firstDate)) {
      initialDate = firstDate;
    }
    
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        multiCityFlights[index]['date'] = picked;
      });
    }
  }

  void showPassengersPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: EdgeInsets.all(20),
          height: 500,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Passengers',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              SizedBox(height: 20),
              _buildPassengerCounter(
                'Adults',
                'Age 12+',
                adults,
                () => setModalState(() => adults > 1 ? adults-- : null),
                () => setModalState(() => adults++),
              ),
              Divider(height: 30),
              _buildPassengerCounter(
                'Children',
                'Age 2-11',
                children,
                () => setModalState(() => children > 0 ? children-- : null),
                () => setModalState(() => children++),
              ),
              Divider(height: 30),
              _buildPassengerCounter(
                'Infants',
                'Under 2',
                infants,
                () => setModalState(() => infants > 0 ? infants-- : null),
                () => setModalState(() => infants < adults ? infants++ : null),
              ),
              SizedBox(height: 20),
              Text(
                'Cabin Class',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Wrap(
                spacing: 10,
                children: cabinClasses.map((classType) {
                  bool isSelected = cabinClass == classType;
                  return ChoiceChip(
                    label: Text(classType),
                    selected: isSelected,
                    onSelected: (selected) {
                      setModalState(() => cabinClass = classType);
                    },
                    selectedColor: Colors.redAccent,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  );
                }).toList(),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  setState(() {});
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Done',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // SEPARATE passengers picker for EACH multi-city flight
  void showMultiCityPassengersPicker(int index) {
    // Use temporary variables to hold the values
    int tempAdults = multiCityFlights[index]['adults'];
    int tempChildren = multiCityFlights[index]['children'];
    int tempInfants = multiCityFlights[index]['infants'];
    String tempCabinClass = multiCityFlights[index]['cabinClass'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: EdgeInsets.all(20),
          height: 500,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Flight ${index + 1} Passengers',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              SizedBox(height: 20),
              _buildPassengerCounter(
                'Adults',
                'Age 12+',
                tempAdults,
                () => setModalState(() => tempAdults > 1 ? tempAdults-- : null),
                () => setModalState(() => tempAdults++),
              ),
              Divider(height: 30),
              _buildPassengerCounter(
                'Children',
                'Age 2-11',
                tempChildren,
                () => setModalState(() => tempChildren > 0 ? tempChildren-- : null),
                () => setModalState(() => tempChildren++),
              ),
              Divider(height: 30),
              _buildPassengerCounter(
                'Infants',
                'Under 2',
                tempInfants,
                () => setModalState(() => tempInfants > 0 ? tempInfants-- : null),
                () => setModalState(() => tempInfants < tempAdults ? tempInfants++ : null),
              ),
              SizedBox(height: 20),
              Text(
                'Cabin Class',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Wrap(
                spacing: 10,
                children: cabinClasses.map((classType) {
                  bool isSelected = tempCabinClass == classType;
                  return ChoiceChip(
                    label: Text(classType),
                    selected: isSelected,
                    onSelected: (selected) {
                      setModalState(() => tempCabinClass = classType);
                    },
                    selectedColor: Colors.redAccent,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  );
                }).toList(),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  // Save the values back to the main state
                  setState(() {
                    multiCityFlights[index]['adults'] = tempAdults;
                    multiCityFlights[index]['children'] = tempChildren;
                    multiCityFlights[index]['infants'] = tempInfants;
                    multiCityFlights[index]['cabinClass'] = tempCabinClass;
                  });
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Done',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPassengerCounter(
    String label,
    String subtitle,
    int value,
    VoidCallback onDecrease,
    VoidCallback onIncrease,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            Text(
              subtitle,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.remove_circle_outline),
              color: Colors.green,
              iconSize: 32,
              onPressed: onDecrease,
            ),
            SizedBox(
              width: 40,
              child: Text(
                '$value',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            IconButton(
              icon: Icon(Icons.add_circle_outline),
              color: Colors.green,
              iconSize: 32,
              onPressed: onIncrease,
            ),
          ],
        ),
      ],
    );
  }

  // Date format EXACTLY like hotel search: "8 Feb, 2026"
  String formatDate(DateTime date) {
    List<String> months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }

  void _handleSearch() {
    print('=== FLIGHT SEARCH ===');
    print('Trip Type: $selectedTripType');
    if (selectedTripType == 'Multi-city') {
      for (int i = 0; i < multiCityFlights.length; i++) {
        print('Flight ${i + 1}: ${multiCityFlights[i]['from']} → ${multiCityFlights[i]['to']}');
        print('  Date: ${formatDate(multiCityFlights[i]['date'])}');
        print('  Passengers: ${multiCityFlights[i]['adults']} adults, ${multiCityFlights[i]['children']} children, ${multiCityFlights[i]['infants']} infants');
        print('  Class: ${multiCityFlights[i]['cabinClass']}');
      }
    } else {
      print('From: $fromCity → To: $toCity');
      print('Departure: ${formatDate(departureDate)}');
      if (selectedTripType == 'Round trip' && returnDate != null) {
        print('Return: ${formatDate(returnDate!)}');
      }
      print('Passengers: $adults adults, $children children, $infants infants');
      print('Class: $cabinClass');
    }
    print('=====================');
  }
}