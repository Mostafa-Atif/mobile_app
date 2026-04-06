// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config.dart';

class CarsSearch extends StatefulWidget {
  @override
  _CarsSearchState createState() => _CarsSearchState();
}

class _CarsSearchState extends State<CarsSearch> {
  List<dynamic> cars = [];
  bool isLoading = true;
  bool hasError = false;
  bool isSubmitting = false;
  bool _submitted = false;
  int visibleCount = 3;

  Map<String, dynamic>? selectedCar;
  String? pickupLocation;
  String? dropoffLocation;
  DateTime? pickupDateTime;
  DateTime? dropoffDateTime;
  bool privateDriver = false;

  String userId = '';
  String token = '';

  final TextEditingController firstNameCtrl = TextEditingController();
  final TextEditingController lastNameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();

  final List<String> locations = ['Dubai', 'Abu Dhabi', 'Riyadh', 'Jeddah', 'Cairo'];

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

  String _resolveError(String? key, AppLocalizations l) {
    if (key == null) return '';
    switch (key) {
      case 'required': return l.errorRequired;
      case 'lettersOnly': return l.errorLettersOnly;
      case 'validEmail': return l.errorValidEmail;
      case 'validPhone': return l.errorValidPhone;
      default: return '';
    }
  }

  String? get _firstNameErrorKey => _submitted ? _validateName(firstNameCtrl.text) : null;
  String? get _lastNameErrorKey => _submitted ? _validateName(lastNameCtrl.text) : null;
  String? get _emailErrorKey => _submitted ? _validateEmail(emailCtrl.text) : null;
  String? get _phoneErrorKey => _submitted ? _validatePhone(phoneCtrl.text) : null;

  @override
  void initState() {
    super.initState();
    fetchCars();
    loadUserInfo();
  }

  Future<void> loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId') ?? '';
      token = prefs.getString('token') ?? '';
    });
    firstNameCtrl.text = prefs.getString('firstName') ?? '';
    lastNameCtrl.text = prefs.getString('lastName') ?? '';
    emailCtrl.text = prefs.getString('email') ?? '';
    phoneCtrl.text = prefs.getString('phone') ?? '';
  }

  @override
  void dispose() {
    firstNameCtrl.dispose();
    lastNameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> fetchCars() async {
    setState(() { isLoading = true; hasError = false; });
    try {
      final response = await http.get(Uri.parse('${Config.baseUrl}/api/cars'));
      if (response.statusCode == 200) {
        setState(() {
          cars = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() { isLoading = false; hasError = true; });
      }
    } catch (e) {
      setState(() { isLoading = false; hasError = true; });
    }
  }

  Future<void> _pickDateTime(bool isPickup) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (date == null) return;
    final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (time == null) return;
    final combined = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    setState(() {
      if (isPickup) pickupDateTime = combined;
      else dropoffDateTime = combined;
    });
  }

  String _formatDateTime(DateTime? dt, AppLocalizations l) {
    if (dt == null) return l.selectDateTime;
    return '${dt.day}/${dt.month}/${dt.year} at ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  int get totalDays {
    if (pickupDateTime == null || dropoffDateTime == null) return 0;
    return dropoffDateTime!.difference(pickupDateTime!).inDays;
  }

  Future<void> _submitBooking(AppLocalizations l) async {
    setState(() => _submitted = true);

    final hasErrors = _validateName(firstNameCtrl.text) != null ||
        _validateName(lastNameCtrl.text) != null ||
        _validateEmail(emailCtrl.text) != null ||
        _validatePhone(phoneCtrl.text) != null;

    if (selectedCar == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.selectCarError)));
      return;
    }
    if (hasErrors) return;
    if (pickupLocation == null || dropoffLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.selectLocationsError)));
      return;
    }
    if (pickupDateTime == null || dropoffDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.selectDatesError)));
      return;
    }
    if (dropoffDateTime!.isBefore(pickupDateTime!)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.dropoffBeforePickup)));
      return;
    }
    if (token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.signInFirst)));
      return;
    }

    setState(() => isSubmitting = true);

    try {
      final response = await http.post(
        Uri.parse('${Config.baseUrl}/api/car-bookings'),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
        body: json.encode({
          'carId': selectedCar!['_id'],
          'pickupLocation': pickupLocation,
          'dropoffLocation': dropoffLocation,
          'pickupDateTime': pickupDateTime!.toIso8601String(),
          'dropoffDateTime': dropoffDateTime!.toIso8601String(),
          'privateDriver': privateDriver,
          'lang': 'en',
        }),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.bookingConfirmed), backgroundColor: Colors.green),
        );
        setState(() {
          selectedCar = null;
          pickupLocation = null;
          dropoffLocation = null;
          pickupDateTime = null;
          dropoffDateTime = null;
          privateDriver = false;
          _submitted = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? l.bookingFailed)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }

    setState(() => isSubmitting = false);
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off, size: 60, color: Colors.grey[300]),
          SizedBox(height: 16),
          Text('Unable to connect',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[700])),
          SizedBox(height: 8),
          Text('Please check your connection and try again',
              style: TextStyle(color: Colors.grey[500], fontSize: 13),
              textAlign: TextAlign.center),
          SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: fetchCars,
            icon: Icon(Icons.refresh),
            label: Text('Retry'),
            style: ElevatedButton.styleFrom(
                shape: StadiumBorder(), backgroundColor: Colors.red, foregroundColor: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _formField(TextEditingController ctrl, String label, {
    TextInputType keyboardType = TextInputType.text,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12),
            border: errorText != null ? Border.all(color: Colors.red.shade300) : null,
          ),
          child: TextField(
            controller: ctrl,
            keyboardType: keyboardType,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: EdgeInsets.only(left: 4, top: 4),
            child: Text(errorText, style: TextStyle(color: Colors.red.shade400, fontSize: 12)),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(l.carRentTitle,
            style: TextStyle(color: Colors.black, fontSize: 26, fontWeight: FontWeight.w700,
                letterSpacing: 1.2, fontFamily: 'serif')),
        centerTitle: true,
      ),
      body: hasError
          ? _buildError()
          : SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l.carRentSubtitle,
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Text(l.carRentHint,
                            style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                      ],
                    ),
                  ),

                  isLoading
                      ? Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: Center(child: CircularProgressIndicator()))
                      : cars.isEmpty
                          ? Padding(
                              padding: EdgeInsets.symmetric(vertical: 40),
                              child: Center(child: Text(l.noCarAvailable,
                                  style: TextStyle(color: Colors.grey))))
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: visibleCount.clamp(0, cars.length),
                              itemBuilder: (context, index) {
                                final car = cars[index];
                                final isSelected = selectedCar != null &&
                                    selectedCar!['_id'] == car['_id'];
                                return GestureDetector(
                                  onTap: () => setState(() => selectedCar = car),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: isSelected ? Color(0xFFE8F5E9) : Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                            color: isSelected ? Colors.green : Colors.grey[300]!,
                                            width: isSelected ? 2 : 1),
                                      ),
                                      padding: EdgeInsets.all(20),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(car['name'] ?? '',
                                                    style: TextStyle(fontSize: 18,
                                                        fontWeight: FontWeight.bold)),
                                              ),
                                              if (isSelected)
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10, vertical: 4),
                                                  decoration: BoxDecoration(
                                                      color: Colors.green,
                                                      borderRadius: BorderRadius.circular(20)),
                                                  child: Text(l.selected,
                                                      style: TextStyle(color: Colors.white,
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.bold)),
                                                ),
                                            ],
                                          ),
                                          SizedBox(height: 16),
                                          Row(
                                            children: [
                                              Icon(Icons.person_outline, size: 24,
                                                  color: Colors.grey[700]),
                                              SizedBox(width: 8),
                                              Text('${car['seats'] ?? '-'}',
                                                  style: TextStyle(fontSize: 16)),
                                              SizedBox(width: 24),
                                              Icon(Icons.work_outline, size: 24,
                                                  color: Colors.grey[700]),
                                              SizedBox(width: 8),
                                              Text('${car['bags'] ?? '-'}',
                                                  style: TextStyle(fontSize: 16)),
                                              SizedBox(width: 24),
                                              Icon(Icons.settings, size: 24,
                                                  color: Colors.grey[700]),
                                              SizedBox(width: 8),
                                              Text(car['transmission'] ?? '-',
                                                  style: TextStyle(fontSize: 16)),
                                              Spacer(),
                                              car['image'] != null
                                                  ? ClipRRect(
                                                      borderRadius: BorderRadius.circular(8),
                                                      child: Image.network(car['image'],
                                                          width: 100, height: 60,
                                                          fit: BoxFit.cover,
                                                          errorBuilder: (_, __, ___) =>
                                                              Container(
                                                                width: 100, height: 60,
                                                                decoration: BoxDecoration(
                                                                    color: Colors.blue[50],
                                                                    borderRadius:
                                                                        BorderRadius.circular(8)),
                                                                child: Icon(Icons.directions_car,
                                                                    size: 45,
                                                                    color: Colors.blue[400]),
                                                              )))
                                                  : Container(
                                                      width: 100, height: 60,
                                                      decoration: BoxDecoration(
                                                          color: Colors.blue[50],
                                                          borderRadius: BorderRadius.circular(8)),
                                                      child: Icon(Icons.directions_car,
                                                          size: 45, color: Colors.blue[400]),
                                                    ),
                                            ],
                                          ),
                                          SizedBox(height: 16),
                                          Row(
                                            children: [
                                              Text(car['brand'] ?? '',
                                                  style: TextStyle(fontSize: 16,
                                                      color: Colors.grey[700])),
                                              Spacer(),
                                              Column(children: [
                                                Text(l.perDay,
                                                    style: TextStyle(fontSize: 12,
                                                        color: Colors.grey)),
                                                Text('﷼ ${car['pricePerDay']}',
                                                    style: TextStyle(fontSize: 18,
                                                        fontWeight: FontWeight.bold)),
                                              ]),
                                              SizedBox(width: 32),
                                              Column(children: [
                                                Text(l.perWeek,
                                                    style: TextStyle(fontSize: 12,
                                                        color: Colors.grey)),
                                                Text('﷼ ${(car['pricePerDay'] * 7).toStringAsFixed(0)}',
                                                    style: TextStyle(fontSize: 18,
                                                        fontWeight: FontWeight.bold)),
                                              ]),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          Text(l.vatIncluded,
                                              style: TextStyle(fontSize: 11, color: Colors.grey)),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),

                  if (!isLoading && !hasError && visibleCount < cars.length)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: OutlinedButton(
                        onPressed: () => setState(() => visibleCount += 7),
                        style: OutlinedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28)),
                          side: BorderSide(color: Colors.red),
                          foregroundColor: Colors.red,
                        ),
                        child: Text(l.showMore,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),

                  SizedBox(height: 24),

                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l.bookingDetails,
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        SizedBox(height: 16),

                        _formField(firstNameCtrl, l.firstName,
                            errorText: _firstNameErrorKey != null
                                ? _resolveError(_firstNameErrorKey, l) : null),
                        SizedBox(height: 12),
                        _formField(lastNameCtrl, l.lastName,
                            errorText: _lastNameErrorKey != null
                                ? _resolveError(_lastNameErrorKey, l) : null),
                        SizedBox(height: 12),
                        _formField(emailCtrl, l.email,
                            keyboardType: TextInputType.emailAddress,
                            errorText: _emailErrorKey != null
                                ? _resolveError(_emailErrorKey, l) : null),
                        SizedBox(height: 12),
                        _formField(phoneCtrl, l.phone,
                            keyboardType: TextInputType.phone,
                            errorText: _phoneErrorKey != null
                                ? _resolveError(_phoneErrorKey, l) : null),
                        SizedBox(height: 20),

                        if (selectedCar != null)
                          Container(
                            margin: EdgeInsets.only(bottom: 16),
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Color(0xFFE8F5E9),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.green),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.directions_car, color: Colors.green),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                      '${selectedCar!['name']} — ﷼${selectedCar!['pricePerDay']}/${l.perDay}',
                                      style: TextStyle(fontWeight: FontWeight.bold,
                                          color: Colors.green[800])),
                                ),
                                GestureDetector(
                                  onTap: () => setState(() => selectedCar = null),
                                  child: Icon(Icons.close, color: Colors.green, size: 18),
                                ),
                              ],
                            ),
                          )
                        else
                          Padding(
                            padding: EdgeInsets.only(bottom: 16),
                            child: Text(l.selectCarFirst,
                                style: TextStyle(color: Colors.grey, fontSize: 13)),
                          ),

                        Text(l.pickupLocation,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(8)),
                          child: DropdownButtonFormField<String>(
                            value: pickupLocation,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12)),
                            hint: Text(l.selectLocation),
                            items: locations.map((loc) =>
                                DropdownMenuItem(value: loc, child: Text(loc))).toList(),
                            onChanged: (val) => setState(() => pickupLocation = val),
                          ),
                        ),

                        SizedBox(height: 20),

                        Text(l.dropoffLocation,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(8)),
                          child: DropdownButtonFormField<String>(
                            value: dropoffLocation,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12)),
                            hint: Text(l.selectLocation),
                            items: locations.map((loc) =>
                                DropdownMenuItem(value: loc, child: Text(loc))).toList(),
                            onChanged: (val) => setState(() => dropoffLocation = val),
                          ),
                        ),

                        SizedBox(height: 20),

                        Text(l.pickupDateTime,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        SizedBox(height: 8),
                        OutlinedButton(
                          onPressed: () => _pickDateTime(true),
                          style: OutlinedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            side: BorderSide(color: Colors.grey[300]!),
                            foregroundColor:
                                pickupDateTime != null ? Colors.black : Colors.grey,
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(_formatDateTime(pickupDateTime, l)),
                          ),
                        ),

                        SizedBox(height: 20),

                        Text(l.dropoffDateTime,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        SizedBox(height: 8),
                        OutlinedButton(
                          onPressed: () => _pickDateTime(false),
                          style: OutlinedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            side: BorderSide(color: Colors.grey[300]!),
                            foregroundColor:
                                dropoffDateTime != null ? Colors.black : Colors.grey,
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(_formatDateTime(dropoffDateTime, l)),
                          ),
                        ),

                        SizedBox(height: 20),

                        if (totalDays > 0)
                          Text(l.totalDays(totalDays),
                              style: TextStyle(color: Colors.grey[600], fontSize: 13)),

                        SizedBox(height: 20),

                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(8)),
                          child: SwitchListTile(
                            title: Text(l.privateDriver,
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                            subtitle: Text(l.privateDriverExtra,
                                style: TextStyle(fontSize: 12, color: Colors.grey)),
                            value: privateDriver,
                            onChanged: (val) => setState(() => privateDriver = val),
                            activeColor: Colors.red,
                          ),
                        ),

                        SizedBox(height: 20),

                        if (selectedCar != null && totalDays > 0)
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey[200]!)),
                            child: Column(
                              children: [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(l.carRentalDays(totalDays)),
                                      Text('﷼ ${(selectedCar!['pricePerDay'] * totalDays).toStringAsFixed(0)}'),
                                    ]),
                                if (privateDriver) ...[
                                  SizedBox(height: 8),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(l.privateDriver),
                                        Text('﷼ ${(totalDays * 100).toStringAsFixed(0)}'),
                                      ]),
                                ],
                                Divider(),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(l.total,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold, fontSize: 16)),
                                      Text(
                                          '﷼ ${((selectedCar!['pricePerDay'] * totalDays) + (privateDriver ? totalDays * 100 : 0)).toStringAsFixed(0)}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.red)),
                                    ]),
                              ],
                            ),
                          ),

                        SizedBox(height: 24),

                        ElevatedButton(
                          onPressed: isSubmitting ? null : () => _submitBooking(l),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            minimumSize: Size(double.infinity, 56),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28)),
                            elevation: 2,
                          ),
                          child: isSubmitting
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text(l.confirmBooking,
                                  style: TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.bold)),
                        ),

                        SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}