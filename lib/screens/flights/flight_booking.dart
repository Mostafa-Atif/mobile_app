import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app/l10n/app_localizations.dart';
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
  List<Map<String, dynamic>> passengerList = [];

  @override
  void initState() {
    super.initState();
    _initPassengers();
  }

  String _capitalizeGender(String g) {
    if (g.toLowerCase() == 'male') return 'Male';
    if (g.toLowerCase() == 'female') return 'Female';
    return '';
  }

  Future<void> _initPassengers() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
    final rawGender = prefs.getString('gender') ?? '';
    final gender = _capitalizeGender(rawGender);

    List<Map<String, dynamic>> list = [{
      'filled': false,
      'firstName': prefs.getString('firstName') ?? '',
      'lastName': prefs.getString('lastName') ?? '',
      'email': prefs.getString('email') ?? '',
      'phone': prefs.getString('phone') ?? '',
      'nationality': '',
      'passportNumber': '',
      'gender': gender.isEmpty ? null : gender,
      'dateOfBirth': null,
      'passportExpiry': null,
      'countryCode': '+20',
    }];

    for (int i = 1; i < widget.passengers; i++) {
      list.add({
        'filled': false, 'firstName': '', 'lastName': '', 'email': '',
        'phone': '', 'nationality': '', 'passportNumber': '',
        'gender': null, 'dateOfBirth': null, 'passportExpiry': null, 'countryCode': '+20',
      });
    }

    setState(() => passengerList = list);
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Select date';
    List<String> months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  num get totalPrice => widget.price * widget.passengers;

  String? _validateName(String val) {
    if (val.trim().isEmpty) return 'required';
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(val.trim())) return 'lettersOnly';
    return null;
  }

  String? _validateEmail(String val) {
    if (val.trim().isEmpty) return 'required';
    if (!RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$').hasMatch(val.trim())) return 'validEmail';
    return null;
  }

  String? _validatePhone(String val) {
    if (val.trim().isEmpty) return 'required';
    if (!RegExp(r'^\d{7,15}$').hasMatch(val.trim())) return 'validPhone';
    return null;
  }

  String? _validatePassport(String val) {
    if (val.trim().isEmpty) return 'required';
    if (!RegExp(r'^[A-Za-z0-9]{6,9}$').hasMatch(val.trim())) return 'passport';
    return null;
  }

  String _resolveError(String? key, AppLocalizations l) {
    if (key == null) return '';
    switch (key) {
      case 'required': return l.errorRequired;
      case 'lettersOnly': return l.errorLettersOnly;
      case 'validEmail': return l.errorValidEmail;
      case 'validPhone': return l.errorPhone;
      case 'passport': return l.errorPassport;
      default: return '';
    }
  }

  void _openPassengerSheet(int index, AppLocalizations l) {
    final p = Map<String, dynamic>.from(passengerList[index]);
    final firstNameCtrl = TextEditingController(text: p['firstName']);
    final lastNameCtrl = TextEditingController(text: p['lastName']);
    final emailCtrl = TextEditingController(text: p['email']);
    final phoneCtrl = TextEditingController(text: p['phone']);
    final nationalityCtrl = TextEditingController(text: p['nationality']);
    final passportCtrl = TextEditingController(text: p['passportNumber']);
    String? gender = p['gender'];
    DateTime? dob = p['dateOfBirth'];
    DateTime? expiry = p['passportExpiry'];
    String countryCode = p['countryCode'] ?? '+20';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (sheetContext) {
        String? firstNameError;
        String? lastNameError;
        String? emailError;
        String? phoneError;
        String? nationalityError;
        String? passportError;
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
                        Text('${l.passenger} ${index + 1}${index == 0 ? ' (${l.you})' : ''}',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        IconButton(icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(sheetContext)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            _validatedField(firstNameCtrl, '${l.firstName} *',
                                firstNameError, setSheet),
                            const SizedBox(height: 12),
                            _validatedField(lastNameCtrl, '${l.lastName} *',
                                lastNameError, setSheet),
                            const SizedBox(height: 12),

                            // Gender
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: showError && gender == null
                                        ? Colors.red.shade300 : Colors.grey.shade400),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: gender,
                                  isExpanded: true,
                                  hint: Text('${l.gender} *',
                                      style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
                                  items: [
                                    DropdownMenuItem(value: 'Male', child: Text(l.male)),
                                    DropdownMenuItem(value: 'Female', child: Text(l.female)),
                                  ],
                                  onChanged: (val) => setSheet(() => gender = val),
                                ),
                              ),
                            ),
                            if (showError && gender == null)
                              Padding(padding: EdgeInsets.only(left: 4, top: 4),
                                  child: Text(l.errorRequired,
                                      style: TextStyle(color: Colors.red.shade400, fontSize: 12))),
                            const SizedBox(height: 12),

                            _sheetDateField(sheetContext, '${l.dateOfBirth} *', dob,
                                (picked) => setSheet(() => dob = picked), isDOB: true),
                            if (showError && dob == null)
                              Padding(padding: EdgeInsets.only(left: 4, top: 4),
                                  child: Text(l.errorRequired,
                                      style: TextStyle(color: Colors.red.shade400, fontSize: 12))),
                            const SizedBox(height: 12),

                            _validatedField(nationalityCtrl, '${l.nationality} *',
                                nationalityError, setSheet),
                            const SizedBox(height: 16),

                            Text(l.travelDocument,
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 12),

                            _validatedField(passportCtrl, '${l.passportNumber} *',
                                passportError, setSheet),
                            const SizedBox(height: 12),

                            _sheetDateField(sheetContext, '${l.passportExpiry} *', expiry,
                                (picked) => setSheet(() => expiry = picked), isDOB: false),
                            if (showError && expiry == null)
                              Padding(padding: EdgeInsets.only(left: 4, top: 4),
                                  child: Text(l.errorRequired,
                                      style: TextStyle(color: Colors.red.shade400, fontSize: 12))),
                            const SizedBox(height: 16),

                            Text(l.contactDetails,
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 12),

                            _validatedField(emailCtrl, '${l.email} *', emailError, setSheet,
                                keyboardType: TextInputType.emailAddress),
                            const SizedBox(height: 12),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 56,
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey.shade400),
                                      borderRadius: BorderRadius.circular(8)),
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
                                Expanded(
                                  child: _validatedField(phoneCtrl, '${l.mobileNumber} *',
                                      phoneError, setSheet, keyboardType: TextInputType.phone),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),

                    if (showError)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(l.pleaseFixErrors,
                            style: TextStyle(color: Colors.red, fontSize: 13),
                            textAlign: TextAlign.center),
                      ),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          final fErr = _validateName(firstNameCtrl.text);
                          final lErr = _validateName(lastNameCtrl.text);
                          final eErr = _validateEmail(emailCtrl.text);
                          final pErr = _validatePhone(phoneCtrl.text);
                          final nErr = _validateName(nationalityCtrl.text);
                          final ppErr = _validatePassport(passportCtrl.text);

                          if (fErr != null || lErr != null || eErr != null ||
                              pErr != null || nErr != null || ppErr != null ||
                              gender == null || dob == null || expiry == null) {
                            setSheet(() {
                              showError = true;
                              firstNameError = fErr != null ? _resolveError(fErr, l) : null;
                              lastNameError = lErr != null ? _resolveError(lErr, l) : null;
                              emailError = eErr != null ? _resolveError(eErr, l) : null;
                              phoneError = pErr != null ? _resolveError(pErr, l) : null;
                              nationalityError = nErr != null ? _resolveError(nErr, l) : null;
                              passportError = ppErr != null ? _resolveError(ppErr, l) : null;
                            });
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
                              'passportNumber': passportCtrl.text.trim().toUpperCase(),
                              'gender': gender,
                              'dateOfBirth': dob,
                              'passportExpiry': expiry,
                              'countryCode': countryCode,
                            };
                          });
                          Navigator.pop(sheetContext);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: teal, foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          elevation: 0,
                        ),
                        child: Text(l.savePassenger(index + 1),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
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

  Future<void> _submitBookings(AppLocalizations l) async {
    final unfilled = passengerList.where((p) => !p['filled']).length;
    if (unfilled > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.fillPassengerDetails)));
      return;
    }

    setState(() => isSubmitting = true);

    try {
      final requests = passengerList.map((p) {
        return http.post(
          Uri.parse('${Config.baseUrl}/api/flight-bookings'),
          headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
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
            SnackBar(content: Text(l.flightBookedSuccess), backgroundColor: Colors.green));
        Navigator.pop(context);
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l.someBookingsFailed)));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }

    setState(() => isSubmitting = false);
  }

  Widget _validatedField(TextEditingController ctrl, String label,
      String? errorText, StateSetter setSheet,
      {TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: ctrl,
          keyboardType: keyboardType,
          onChanged: (_) => setSheet(() {}),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: errorText != null
                    ? Colors.red.shade300 : Colors.grey.shade400)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: errorText != null
                    ? Colors.red.shade300 : Colors.grey.shade400)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: teal, width: 1.5)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          ),
        ),
        if (errorText != null)
          Padding(padding: const EdgeInsets.only(left: 4, top: 4),
              child: Text(errorText,
                  style: TextStyle(color: Colors.red.shade400, fontSize: 12))),
      ],
    );
  }

  Widget _sheetDateField(BuildContext ctx, String label, DateTime? value,
      Function(DateTime) onPicked, {required bool isDOB}) {
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
            borderRadius: BorderRadius.circular(8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(value != null ? _formatDate(value) : label,
                style: TextStyle(fontSize: 14,
                    color: value != null ? Colors.black87 : Colors.grey.shade600)),
            Icon(Icons.calendar_today_outlined, size: 18, color: Colors.grey.shade500),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(l.travellerDetails,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 17)),
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
                  // Summary card
                  GestureDetector(
                    onTap: () => setState(() => summaryExpanded = !summaryExpanded),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200)),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text('${widget.fromCity} → ${widget.toCity}',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                const SizedBox(height: 4),
                                Text('${widget.currency} $totalPrice',
                                    style: const TextStyle(fontSize: 16,
                                        fontWeight: FontWeight.bold, color: blue)),
                              ]),
                              Row(children: [
                                Text(summaryExpanded ? l.hideSummaryFlight : l.viewSummaryFlight,
                                    style: const TextStyle(fontSize: 13, color: teal)),
                                Icon(summaryExpanded ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down, color: teal),
                              ]),
                            ],
                          ),
                          if (summaryExpanded) ...[
                            const SizedBox(height: 14),
                            const Divider(),
                            const SizedBox(height: 10),
                            _summaryRow(Icons.calendar_today_outlined, l.departure,
                                _formatDate(widget.departureDate)),
                            if (widget.returnDate != null)
                              _summaryRow(Icons.calendar_today_outlined, l.returnDate,
                                  _formatDate(widget.returnDate)),
                            _summaryRow(Icons.airline_seat_recline_normal, l.class_,
                                widget.flightClass),
                            _summaryRow(Icons.swap_calls, l.tripType, widget.tripType),
                            _summaryRow(Icons.people_outline, l.passengers,
                                '${widget.passengers}'),
                            _summaryRow(Icons.flight, l.airline, widget.airline),
                            _summaryRow(Icons.timer_outlined, l.duration, widget.duration),
                            _summaryRow(Icons.location_on_outlined, l.stops, widget.stops),
                            const Divider(),
                            const SizedBox(height: 6),
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              Text(l.pricePerPerson,
                                  style: TextStyle(color: Colors.grey, fontSize: 13)),
                              Text('${widget.currency} ${widget.price}',
                                  style: const TextStyle(fontSize: 13)),
                            ]),
                            const SizedBox(height: 6),
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              Text(l.total,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              Text('${widget.currency} $totalPrice',
                                  style: const TextStyle(fontWeight: FontWeight.bold,
                                      fontSize: 15, color: blue)),
                            ]),
                          ],
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  Text(l.travellerDetails,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),

                  ...List.generate(passengerList.length, (i) {
                    final p = passengerList[i];
                    final filled = p['filled'] as bool;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade300)),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: [
                            Icon(Icons.person_outline,
                                color: filled ? teal : Colors.black87, size: 22),
                            const SizedBox(width: 10),
                            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text('${l.passenger} ${i + 1}${i == 0 ? ' (${l.you})' : ''}',
                                  style: const TextStyle(fontSize: 15)),
                              if (filled && p['firstName'].isNotEmpty)
                                Text('${p['firstName']} ${p['lastName']}',
                                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                            ]),
                          ]),
                          ElevatedButton.icon(
                            onPressed: () => _openPassengerSheet(i, l),
                            icon: Icon(filled ? Icons.edit : Icons.add, size: 18),
                            label: Text(filled ? 'Edit' : 'Add',
                                style: const TextStyle(fontSize: 14)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: filled ? Colors.grey.shade100 : teal,
                              foregroundColor: filled ? Colors.black87 : Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              elevation: 0,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isSubmitting ? null : () => _submitBookings(l),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: red, foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        elevation: 0,
                      ),
                      child: isSubmitting
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              passengerList.length > 1
                                  ? l.confirmBookings(passengerList.length)
                                  : l.confirmBooking,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
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
      child: Row(children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Text('$label: ', style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
      ]),
    );
  }
}