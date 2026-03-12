import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../config.dart';

class FlightBooking extends StatefulWidget {
  final String fromCity;
  final String toCity;
  final DateTime departureDate;
  final DateTime? returnDate;
  final String tripType;
  final int passengers;
  final num price;
  final String currency;
  final String airline;
  final String duration;
  final String stops;
  final String flightClass;

  const FlightBooking({
    super.key,
    required this.fromCity,
    required this.toCity,
    required this.departureDate,
    this.returnDate,
    required this.tripType,
    required this.passengers,
    required this.price,
    required this.currency,
    required this.airline,
    required this.duration,
    required this.stops,
    required this.flightClass,
  });

  @override
  State<FlightBooking> createState() => _FlightBookingState();
}

class _FlightBookingState extends State<FlightBooking> {
  static const Color teal = Color(0xFF00BFA5);
  static const Color red = Color(0xFFE53935);
  static const Color blue = Color(0xFF1565C0);

  bool isSubmitting = false;
  bool summaryExpanded = false;
  String token = '';

  // Each passenger: Map with their data, plus 'filled' bool
  List<Map<String, dynamic>> passengerList = [];

  @override
  void initState() {
    super.initState();
    _initPassengers();
  }

  Future<void> _initPassengers() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';

    List<Map<String, dynamic>> list = [
      {
        'filled': false,
        'firstName': prefs.getString('firstName') ?? '',
        'lastName': prefs.getString('lastName') ?? '',
        'email': prefs.getString('email') ?? '',
        'phone': prefs.getString('phone') ?? '',
        'nationality': '',
        'passportNumber': '',
        'gender': prefs.getString('gender') ?? '',
        'dateOfBirth': null,
        'passportExpiry': null,
        'countryCode': '+20',
      }
    ];

    for (int i = 1; i < widget.passengers; i++) {
      list.add(_emptyPassenger());
    }

    setState(() => passengerList = list);
  }

  Map<String, dynamic> _emptyPassenger() {
    return {
      'filled': false,
      'title': null,
      'firstName': '',
      'lastName': '',
      'email': '',
      'phone': '',
      'nationality': '',
      'passportNumber': '',
      'gender': null,
      'dateOfBirth': null,
      'passportExpiry': null,
      'countryCode': '+20',
    };
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Select date';
    List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  num get totalPrice => widget.price * widget.passengers;

  void _openPassengerSheet(int index) {
    final p = Map<String, dynamic>.from(passengerList[index]);

    final firstNameCtrl = TextEditingController(text: p['firstName']);
    final lastNameCtrl = TextEditingController(text: p['lastName']);
    final emailCtrl = TextEditingController(text: p['email']);
    final phoneCtrl = TextEditingController(text: p['phone']);
    final nationalityCtrl = TextEditingController(text: p['nationality']);
    final passportCtrl = TextEditingController(text: p['passportNumber']);
    String? gender = p['gender']?.isEmpty == true ? null : p['gender'];
    DateTime? dob = p['dateOfBirth'];
    DateTime? expiry = p['passportExpiry'];
    String countryCode = p['countryCode'] ?? '+20';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        bool showError = false;
        return StatefulBuilder(
        builder: (sheetContext, setSheet) {
          return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(sheetContext).viewInsets.bottom),
          child: Container(
            height: MediaQuery.of(sheetContext).size.height * 0.9,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Passenger ${index + 1}${index == 0 ? ' (You)' : ''}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(sheetContext),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        _sheetTextField(firstNameCtrl, 'First name *'),
                        const SizedBox(height: 12),
                        _sheetTextField(lastNameCtrl, 'Last name *'),
                        const SizedBox(height: 12),

                        // Gender
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: gender,
                              isExpanded: true,
                              hint: Text('Gender *', style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
                              items: ['Male', 'Female']
                                  .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                                  .toList(),
                              onChanged: (val) => setSheet(() => gender = val),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        _sheetDateField(sheetContext, 'Date of birth *', dob, (picked) => setSheet(() => dob = picked), isDOB: true),
                        const SizedBox(height: 12),
                        _sheetTextField(nationalityCtrl, 'Nationality *'),
                        const SizedBox(height: 16),

                        const Text('Travel document', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 12),

                        _sheetTextField(passportCtrl, 'Passport number *'),
                        const SizedBox(height: 12),
                        _sheetDateField(sheetContext, 'Passport expiry date *', expiry, (picked) => setSheet(() => expiry = picked), isDOB: false),
                        const SizedBox(height: 16),

                        const Text('Contact details', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 12),

                        _sheetTextField(emailCtrl, 'Email *', keyboardType: TextInputType.emailAddress),
                        const SizedBox(height: 12),

                        Row(
                          children: [
                            Container(
                              height: 56,
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade400),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: countryCode,
                                  items: ['+20', '+966', '+971', '+1', '+44']
                                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                                      .toList(),
                                  onChanged: (val) => setSheet(() => countryCode = val!),
                                  icon: const Icon(Icons.keyboard_arrow_down, size: 20),
                                  style: const TextStyle(fontSize: 14, color: Colors.black),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(child: _sheetTextField(phoneCtrl, 'Mobile number *', keyboardType: TextInputType.phone)),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),

                // Error text
                if (showError)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      'Please fill in all required fields',
                      style: TextStyle(color: Colors.red, fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                  ),

                // Save button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (firstNameCtrl.text.isEmpty || lastNameCtrl.text.isEmpty ||
                          emailCtrl.text.isEmpty || phoneCtrl.text.isEmpty ||
                          nationalityCtrl.text.isEmpty || passportCtrl.text.isEmpty ||
                          gender == null || dob == null || expiry == null) {
                        setSheet(() => showError = true);
                        return;
                      }
                      setState(() {
                        passengerList[index] = {
                          'filled': true,
                          'firstName': firstNameCtrl.text.trim(),
                          'lastName': lastNameCtrl.text.trim(),
                          'email': emailCtrl.text.trim(),
                          'phone': phoneCtrl.text.trim(),
                          'nationality': nationalityCtrl.text.trim(),
                          'passportNumber': passportCtrl.text.trim(),
                          'gender': gender,
                          'dateOfBirth': dob,
                          'passportExpiry': expiry,
                          'countryCode': countryCode,
                        };
                      });
                      Navigator.pop(sheetContext);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: teal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      elevation: 0,
                    ),
                    child: Text(
                      'Save Passenger ${index + 1}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
        },
      );
      },
    );
  }

  Future<void> _submitBookings() async {
    final unfilled = passengerList.where((p) => !p['filled']).length;
    if (unfilled > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in details for all $unfilled remaining passenger${unfilled > 1 ? 's' : ''}')),
      );
      return;
    }

    setState(() => isSubmitting = true);

    try {
      final requests = passengerList.map((p) {
        return http.post(
          Uri.parse('${Config.baseUrl}/api/flight-bookings'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: json.encode({
            'fromCity': widget.fromCity,
            'toCity': widget.toCity,
            'departureDate': widget.departureDate.toIso8601String(),
            'returnDate': widget.returnDate?.toIso8601String(),
            'tripType': widget.tripType == 'One-way' ? 'oneway' : 'roundtrip',
            'fullName': '${p['firstName']} ${p['lastName']}',
            'dateOfBirth': (p['dateOfBirth'] as DateTime).toIso8601String(),
            'gender': p['gender'],
            'nationality': p['nationality'],
            'passportNumber': p['passportNumber'],
            'passportExpiry': (p['passportExpiry'] as DateTime).toIso8601String(),
            'email': p['email'],
            'phone': '${p['countryCode']}${p['phone']}',
          }),
        );
      }).toList();

      final results = await Future.wait(requests);
      final allSuccess = results.every((r) => r.statusCode == 200 || r.statusCode == 201);

      if (allSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Flight booked successfully! ✈️'), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Some bookings failed. Please try again.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }

    setState(() => isSubmitting = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Traveller details', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: passengerList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Collapsible flight summary
                  GestureDetector(
                    onTap: () => setState(() => summaryExpanded = !summaryExpanded),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${widget.fromCity} → ${widget.toCity}',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${widget.currency} $totalPrice',
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: blue),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    summaryExpanded ? 'Hide summary' : 'View summary',
                                    style: const TextStyle(fontSize: 13, color: teal),
                                  ),
                                  Icon(
                                    summaryExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                    color: teal,
                                  ),
                                ],
                              ),
                            ],
                          ),

                          // Expanded summary
                          if (summaryExpanded) ...[
                            const SizedBox(height: 14),
                            const Divider(),
                            const SizedBox(height: 10),
                            _summaryRow(Icons.calendar_today_outlined, 'Departure', _formatDate(widget.departureDate)),
                            if (widget.returnDate != null)
                              _summaryRow(Icons.calendar_today_outlined, 'Return', _formatDate(widget.returnDate)),
                            _summaryRow(Icons.airline_seat_recline_normal, 'Class', widget.flightClass),
                            _summaryRow(Icons.swap_calls, 'Trip type', widget.tripType),
                            _summaryRow(Icons.people_outline, 'Passengers', '${widget.passengers}'),
                            _summaryRow(Icons.flight, 'Airline', widget.airline),
                            _summaryRow(Icons.timer_outlined, 'Duration', widget.duration),
                            _summaryRow(Icons.location_on_outlined, 'Stops', widget.stops),
                            const Divider(),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Price per person', style: TextStyle(color: Colors.grey, fontSize: 13)),
                                Text('${widget.currency} ${widget.price}', style: const TextStyle(fontSize: 13)),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                Text('${widget.currency} $totalPrice',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: blue)),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Passenger cards
                  const Text('Traveller details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),

                  ...List.generate(passengerList.length, (i) {
                    final p = passengerList[i];
                    final filled = p['filled'] as bool;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.person_outline, color: filled ? teal : Colors.black87, size: 22),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Passenger ${i + 1}${i == 0 ? ' (You)' : ''}',
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                  if (filled && p['firstName'].isNotEmpty)
                                    Text(
                                      '${p['firstName']} ${p['lastName']}',
                                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                    ),
                                ],
                              ),
                            ],
                          ),
                          ElevatedButton.icon(
                            onPressed: () => _openPassengerSheet(i),
                            icon: Icon(filled ? Icons.edit : Icons.add, size: 18),
                            label: Text(filled ? 'Edit' : 'Add', style: const TextStyle(fontSize: 14)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: filled ? Colors.grey.shade100 : teal,
                              foregroundColor: filled ? Colors.black87 : Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              elevation: 0,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),

                  const SizedBox(height: 24),

                  // Confirm button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isSubmitting ? null : _submitBookings,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        elevation: 0,
                      ),
                      child: isSubmitting
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              passengerList.length > 1
                                  ? 'Confirm ${passengerList.length} Bookings'
                                  : 'Confirm Booking',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  Widget _summaryRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Text('$label: ', style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _sheetTextField(TextEditingController controller, String label,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade400)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade400)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: teal, width: 1.5)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
    );
  }

  Widget _sheetDateField(BuildContext ctx, String label, DateTime? value, Function(DateTime) onPicked, {required bool isDOB}) {
    return GestureDetector(
      onTap: () async {
        final now = DateTime.now();
        final picked = await showDatePicker(
          context: ctx,
          initialDate: isDOB ? DateTime(2000) : now,
          firstDate: isDOB ? DateTime(1900) : now,
          lastDate: isDOB ? now : DateTime(2100),
        );
        if (picked != null) onPicked(picked);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value != null ? _formatDate(value) : label,
              style: TextStyle(fontSize: 14, color: value != null ? Colors.black87 : Colors.grey.shade600),
            ),
            Icon(Icons.calendar_today_outlined, size: 18, color: Colors.grey.shade500),
          ],
        ),
      ),
    );
  }
}