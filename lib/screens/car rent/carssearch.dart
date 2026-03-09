import 'package:flutter/material.dart';

class CarsSearch extends StatefulWidget {
  @override
  _CarsSearchState createState() => _CarsSearchState();
}

class _CarsSearchState extends State<CarsSearch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
            title: Text(
              'Almosafer',
        style: TextStyle(
          color: Colors.black,
          fontSize: 26,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
          fontFamily: 'serif',
          ),
        ),
          centerTitle: true,
        ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header section
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rent a car at the best rates',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Explore a wide variety of options for your domestic journey',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            // We'll add car cards here next
            
            // Car Card 1 - SEDAN Standard
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Car category title
                    Text(
                      'SEDAN - Standard',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    
                    SizedBox(height: 16),
                    
                    // Icons row (passengers, luggage, transmission)
                    Row(
                      children: [
                        Icon(Icons.person_outline, size: 24, color: Colors.grey[700]),
                        SizedBox(width: 8),
                        Text('4', style: TextStyle(fontSize: 16)),
                        
                        SizedBox(width: 24),
                        
                        Icon(Icons.work_outline, size: 24, color: Colors.grey[700]),
                        SizedBox(width: 8),
                        Text('1', style: TextStyle(fontSize: 16)),
                        
                        SizedBox(width: 24),
                        
                        Icon(Icons.settings, size: 24, color: Colors.grey[700]),
                        SizedBox(width: 8),
                        Text('Automatic', style: TextStyle(fontSize: 16)),
                        
                        Spacer(),
                        
                        // Car image placeholder
                      Container(
                        width: 100,
                        height: 60,
                        decoration: BoxDecoration(
                        color: Colors.blue[50],
                       borderRadius: BorderRadius.circular(8),
                              ),
                        child: Center(
                        child: Icon(
                          Icons.directions_car,
                          size: 45,
                         color: Colors.blue[400],
                              ),
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 16),
                    
                    // Pricing row
                    Row(
                      children: [
                        Text(
                          'Kia Pegas',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                        
                        Spacer(),
                        
                        Column(
                          children: [
                            Text('Per day', style: TextStyle(fontSize: 12, color: Colors.grey)),
                            Text('﷼ 125', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        
                        SizedBox(width: 32),
                        
                        Column(
                          children: [
                            Text('Per week', style: TextStyle(fontSize: 12, color: Colors.grey)),
                            Text('﷼ 770', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 8),
                    
                    Text(
                      '*The prices are inclusive of VAT',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                    
                    SizedBox(height: 16),
                    Divider(color: Colors.grey[300]),
                    
                    
                   
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SEDAN - Luxury',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    
                    SizedBox(height: 16),
                    
                    Row(
                      children: [
                        Icon(Icons.person_outline, size: 24, color: Colors.grey[700]),
                        SizedBox(width: 8),
                        Text('4', style: TextStyle(fontSize: 16)),
                        
                        SizedBox(width: 24),
                        
                        Icon(Icons.work_outline, size: 24, color: Colors.grey[700]),
                        SizedBox(width: 8),
                        Text('1', style: TextStyle(fontSize: 16)),
                        
                        SizedBox(width: 24),
                        
                        Icon(Icons.settings, size: 24, color: Colors.grey[700]),
                        SizedBox(width: 8),
                        Text('Automatic', style: TextStyle(fontSize: 16)),
                        
                        Spacer(),
                        
                       Container(
                         width: 100,
                          height: 60,
                         decoration: BoxDecoration(
                         color: Colors.purple[50],
                         borderRadius: BorderRadius.circular(8),
                                  ),
                        child: Center(
                        child: Icon(
                          Icons.car_rental,
                          size: 45,
                          color: Colors.purple[400],
                           ),
                         ),
                      ),
                    ],
                  ),
                    
                    SizedBox(height: 16),
                    
                    Row(
                      children: [
                        Text(
                          'BMW 3 Series',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                        
                        Spacer(),
                        
                        Column(
                          children: [
                            Text('Per day', style: TextStyle(fontSize: 12, color: Colors.grey)),
                            Text('﷼ 485', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        
                        SizedBox(width: 32),
                        
                        Column(
                          children: [
                            Text('Per week', style: TextStyle(fontSize: 12, color: Colors.grey)),
                            Text('﷼ 2920', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 8),
                    
                    Text(
                      '*The prices are inclusive of VAT',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                    
                    SizedBox(height: 16),
                    Divider(color: Colors.grey[300]),
                    
                  ],
                ),
              ),
            ),
            // Car Card 3 - SUV
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SUV',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    
                    SizedBox(height: 16),
                    
                    Row(
                      children: [
                        Icon(Icons.person_outline, size: 24, color: Colors.grey[700]),
                        SizedBox(width: 8),
                        Text('7', style: TextStyle(fontSize: 16)),
                        
                        SizedBox(width: 24),
                        
                        Icon(Icons.work_outline, size: 24, color: Colors.grey[700]),
                        SizedBox(width: 8),
                        Text('2', style: TextStyle(fontSize: 16)),
                        
                        SizedBox(width: 24),
                        
                        Icon(Icons.settings, size: 24, color: Colors.grey[700]),
                        SizedBox(width: 8),
                        Text('Automatic', style: TextStyle(fontSize: 16)),
                        
                        Spacer(),
                        
                        Container(
                           width: 100,
                           height: 60,
                          decoration: BoxDecoration(
                          color: Colors.orange[50],
                         borderRadius: BorderRadius.circular(8),
                                   ),
                        child: Center(
                         child: Icon(
                          Icons.airport_shuttle,
                               size: 45,
                        color: Colors.orange[700],
                             ),
                          ),
                         ),
                      ],
                    ),
                    
                    SizedBox(height: 16),
                    
                    Row(
                      children: [
                        Text(
                          'Toyota Fortuner',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                        
                        Spacer(),
                        
                        Column(
                          children: [
                            Text('Per day', style: TextStyle(fontSize: 12, color: Colors.grey)),
                            Text('﷼ 350', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        
                        SizedBox(width: 32),
                        
                        Column(
                          children: [
                            Text('Per week', style: TextStyle(fontSize: 12, color: Colors.grey)),
                            Text('﷼ 2100', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 8),
                    
                    Text(
                      '*The prices are inclusive of VAT',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                    
                    SizedBox(height: 16),
                    Divider(color: Colors.grey[300]),
                  ],
                ),
              ),
            ),
            // Car Card 4 - Compact
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'COMPACT',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    
                    SizedBox(height: 16),
                    
                    Row(
                      children: [
                        Icon(Icons.person_outline, size: 24, color: Colors.grey[700]),
                        SizedBox(width: 8),
                        Text('5', style: TextStyle(fontSize: 16)),
                        
                        SizedBox(width: 24),
                        
                        Icon(Icons.work_outline, size: 24, color: Colors.grey[700]),
                        SizedBox(width: 8),
                        Text('1', style: TextStyle(fontSize: 16)),
                        
                        SizedBox(width: 24),
                        
                        Icon(Icons.settings, size: 24, color: Colors.grey[700]),
                        SizedBox(width: 8),
                        Text('Automatic', style: TextStyle(fontSize: 16)),
                        
                        Spacer(),
                        
                        Container(
                        width: 100,
                        height: 60,
                        decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(8),
                                ),
                        child: Center(
                         child: Icon(
                              Icons.local_taxi,
                              size: 45,
                         color: Colors.green[600],
                                 ),
                              ),
                            ),
                         ],
                       ),
                    
                    SizedBox(height: 16),
                    
                    Row(
                      children: [
                        Text(
                          'Hyundai Accent',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                        
                        Spacer(),
                        
                        Column(
                          children: [
                            Text('Per day', style: TextStyle(fontSize: 12, color: Colors.grey)),
                            Text('﷼ 95', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        
                        SizedBox(width: 32),
                        
                        Column(
                          children: [
                            Text('Per week', style: TextStyle(fontSize: 12, color: Colors.grey)),
                            Text('﷼ 570', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 8),
                    
                    Text(
                      '*The prices are inclusive of VAT',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                    
                    SizedBox(height: 16),
                    Divider(color: Colors.grey[300]),

                    SizedBox(height: 24),
            
            // Contact via WhatsApp button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton.icon(
                onPressed: () {
                  // Open WhatsApp
                  print('Contact via WhatsApp');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF25D366), // WhatsApp green
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: 2,
                ),
                icon: Icon(Icons.chat, size: 24),
                label: Text(
                  'Contact us via WhatsApp',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            
            SizedBox(height: 24),
            
            // OR divider
            Center(
              child: Text(
                'OR',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
            ),
            
            SizedBox(height: 24),

            // Form section
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pick-up location
                  Text(
                    'Pick-up location',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      hint: Text('Select location'),
                      items: ['Dubai', 'Abu Dhabi', 'Riyadh', 'Jeddah', 'Cairo']
                          .map((location) => DropdownMenuItem(
                                value: location,
                                child: Text(location),
                              ))
                          .toList(),
                      onChanged: (value) {
                        // Handle location change
                      },
                    ),
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Car type
                  Text(
                    'Car type',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      hint: Text('Select car type'),
                      items: ['SEDAN - Standard', 'SEDAN - Luxury', 'SUV', 'COMPACT']
                          .map((type) => DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              ))
                          .toList(),
                      onChanged: (value) {
                        // Handle car type change
                      },
                    ),
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Rental duration
                  Text(
                    'How long do you want to rent the car for?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'For example: 2 days, 3 weeks, etc.',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Name
                  Text(
                    'Name',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      // Title dropdown
                      Container(
                        width: 100,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          ),
                          hint: Text('Title'),
                          items: ['Mr', 'Mrs', 'Ms', 'Dr']
                              .map((title) => DropdownMenuItem(
                                    value: title,
                                    child: Text(title),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            // Handle title change
                          },
                        ),
                      ),
                      
                      SizedBox(width: 12),
                      
                      // Name field
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Enter your name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Email
                  Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Enter your email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Mobile number
                  Text(
                    'Mobile number',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      // Country code dropdown
                      Container(
                        width: 120,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          ),
                          value: '+966',
                          items: ['+966', '+971', '+20', '+1', '+44']
                              .map((code) => DropdownMenuItem(
                                    value: code,
                                    child: Text(code),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            // Handle country code change
                          },
                        ),
                      ),
                      
                      SizedBox(width: 12),
                      
                      // Phone number field
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: 'Phone number',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 24),
                  
                  // Request a call back button
                  ElevatedButton(
                    onPressed: () {
                      print('Request a call back');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      elevation: 2,
                    ),
                    child: Text(
                      'Request a call back',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 40),
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
  