// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:mobile_app/screens/flights/flight_results.dart';
import '../../config.dart';

class FlightSearch extends StatefulWidget {
  @override
  _FlightSearchState createState() => _FlightSearchState();
}

class _FlightSearchState extends State<FlightSearch> {
  String selectedTripType = 'One-way';

  String fromCity = 'القاهرة';
  String toCity = 'دبي';
  DateTime departureDate = DateTime.now().add(Duration(days: 1));
  DateTime? returnDate = DateTime.now().add(Duration(days: 3));

  int adults = 1;
  int children = 0;
  int infants = 0;
  String cabinClass = 'Economy';

  List<String> cities = [
    'القاهرة',
    'دبي',
    'الرياض',
    'جدة',
    'بيروت',
    'عمّان',
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
                    children: _buildRegularFlightFields(),
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
        onTap: () => setState(() => selectedTripType = tripType),
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
                Text(fromCity, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
              ],
            ),
          ],
        ),
      ),

      SizedBox(height: 16),
      Divider(color: Colors.grey[300], thickness: 1),
      SizedBox(height: 16),

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
                Text(toCity, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
              ],
            ),
          ],
        ),
      ),

      SizedBox(height: 16),
      Divider(color: Colors.grey[300], thickness: 1),
      SizedBox(height: 16),

      Row(
        children: [
          Icon(Icons.calendar_today_outlined, color: Colors.grey, size: 28),
          SizedBox(width: 16),
          Expanded(
            child: GestureDetector(
              onTap: () => selectFlightDate(true),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Departure', style: TextStyle(fontSize: 14, color: Colors.grey)),
                  SizedBox(height: 4),
                  Text(formatDate(departureDate), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
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
                    Text('Return', style: TextStyle(fontSize: 14, color: Colors.grey)),
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
                  Text('Passengers & Class', style: TextStyle(fontSize: 14, color: Colors.grey)),
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
                  if (isFrom) fromCity = cities[i];
                  else toCity = cities[i];
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
    if (initialDate.isBefore(firstDate)) initialDate = firstDate;

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
                  Text('Passengers', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  IconButton(icon: Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                ],
              ),
              SizedBox(height: 20),
              _buildPassengerCounter(
                'Adults', 'Age 12+', adults,
                () => setModalState(() => adults > 1 ? adults-- : null),
                () => setModalState(() => adults++),
              ),
              Divider(height: 30),
              _buildPassengerCounter(
                'Children', 'Age 2-11', children,
                () => setModalState(() => children > 0 ? children-- : null),
                () => setModalState(() => children++),
              ),
              Divider(height: 30),
              _buildPassengerCounter(
                'Infants', 'Under 2', infants,
                () => setModalState(() => infants > 0 ? infants-- : null),
                () => setModalState(() => infants < adults ? infants++ : null),
              ),
              SizedBox(height: 20),
              Text('Cabin Class', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Wrap(
                spacing: 10,
                children: cabinClasses.map((classType) {
                  bool isSelected = cabinClass == classType;
                  return ChoiceChip(
                    label: Text(classType),
                    selected: isSelected,
                    onSelected: (selected) => setModalState(() => cabinClass = classType),
                    selectedColor: Colors.redAccent,
                    labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('Done', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPassengerCounter(String label, String subtitle, int value, VoidCallback onDecrease, VoidCallback onIncrease) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            Text(subtitle, style: TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
        Row(
          children: [
            IconButton(icon: Icon(Icons.remove_circle_outline), color: Colors.green, iconSize: 32, onPressed: onDecrease),
            SizedBox(width: 40, child: Text('$value', textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            IconButton(icon: Icon(Icons.add_circle_outline), color: Colors.green, iconSize: 32, onPressed: onIncrease),
          ],
        ),
      ],
    );
  }

  String formatDate(DateTime date) {
    List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }

  void _handleSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FlightResults(
          fromCity: fromCity,
          toCity: toCity,
          tripType: selectedTripType,
          departureDate: departureDate,
          passengers: adults + children + infants,
          cabinClass: cabinClass,
        ),
      ),
    );
  }
}