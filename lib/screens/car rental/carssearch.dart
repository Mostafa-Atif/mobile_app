// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app/l10n/app_localizations.dart';
import 'package:mobile_app/theme.dart';
import 'package:provider/provider.dart';
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

  // ── UI Helpers ──────────────────────────────────────────────────────────────

  Widget _buildError(AppThemeExtension t) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off, size: 60, color: t.cardBorder),
          const SizedBox(height: 16),
          Text('Unable to connect',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: t.title)),
          const SizedBox(height: 8),
          Text('Please check your connection and try again',
              style: TextStyle(color: t.label, fontSize: 13), textAlign: TextAlign.center),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: fetchCars,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              shape: const StadiumBorder(),
              backgroundColor: t.accent,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text, AppThemeExtension t) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: t.label,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _formField(
    TextEditingController ctrl,
    String label,
    AppThemeExtension t, {
    TextInputType keyboardType = TextInputType.text,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: t.field,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: errorText != null
                  ? Colors.red.shade300
                  : t.fieldBorder.withOpacity(0.5),
            ),
          ),
          child: TextField(
            controller: ctrl,
            keyboardType: keyboardType,
            onChanged: (_) => setState(() {}),
            style: TextStyle(color: t.title, fontSize: 15),
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(color: t.label, fontSize: 14),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 4),
            child: Text(errorText,
                style: TextStyle(color: Colors.red.shade400, fontSize: 12)),
          ),
      ],
    );
  }

  Widget _dropdownField({
    required String? value,
    required String hint,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required AppThemeExtension t,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: t.field,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: t.fieldBorder.withOpacity(0.5)),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        dropdownColor: t.card,
        style: TextStyle(color: t.title, fontSize: 15),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          hintText: hint,
          hintStyle: TextStyle(color: t.label),
        ),
        icon: Icon(Icons.keyboard_arrow_down, color: t.label),
        items: items
            .map((loc) => DropdownMenuItem(
                  value: loc,
                  child: Text(loc, style: TextStyle(color: t.title)),
                ))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _dateTimeButton({
    required DateTime? value,
    required VoidCallback onTap,
    required AppLocalizations l,
    required AppThemeExtension t,
    required IconData icon,
  }) {
    final hasValue = value != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: t.field,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: t.fieldBorder.withOpacity(0.5)),
        ),
        child: Row(
          children: [
            Icon(icon, color: t.accent, size: 20),
            const SizedBox(width: 12),
            Text(
              _formatDateTime(value, l),
              style: TextStyle(
                color: hasValue ? t.title : t.label,
                fontSize: 15,
                fontWeight: hasValue ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<AppThemeExtension>()!;
    final l = AppLocalizations.of(context)!;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      backgroundColor: t.bg,
      body: SafeArea(
        child: hasError
            ? _buildError(t)
            : Column(
                children: [
                  // ── Header ──
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 36, height: 36,
                            decoration: BoxDecoration(
                              color: t.backBg,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              isAr ? Icons.arrow_forward : Icons.arrow_back,
                              color: t.backIcon, size: 18,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                            l.carRentTitle,
                           textAlign: TextAlign.center,
                           style: TextStyle(
                            color: t.title,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                       ),
                     ),
                         Text(
                       l.carRentSubtitle,
                        textAlign: TextAlign.center,
                       style: TextStyle(color: t.label, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
               ),

                  // ── Body ──
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          // ── Cars list ──
                          if (isLoading)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 40),
                              child: Center(
                                child: CircularProgressIndicator(color: t.accent),
                              ),
                            )
                          else if (cars.isEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 40),
                              child: Center(
                                child: Text(l.noCarAvailable,
                                    style: TextStyle(color: t.label)),
                              ),
                            )
                          else
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: visibleCount.clamp(0, cars.length),
                              itemBuilder: (context, index) {
                                final car = cars[index];
                                final isSelected = selectedCar != null &&
                                    selectedCar!['_id'] == car['_id'];
                                return GestureDetector(
                                  onTap: () => setState(() => selectedCar = car),
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    decoration: BoxDecoration(
                                      color: isSelected ? t.accentLight : t.card,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: isSelected
                                            ? t.accent
                                            : t.cardBorder.withOpacity(0.5),
                                        width: isSelected ? 2 : 1,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: t.cardBorder.withOpacity(0.15),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    padding: const EdgeInsets.all(18),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Name + selected badge
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                car['name'] ?? '',
                                                style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                  color: t.title,
                                                ),
                                              ),
                                            ),
                                            if (isSelected)
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 10, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: t.accent,
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                child: Text(
                                                  l.selected,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                          ],
                                        ),

                                        const SizedBox(height: 14),

                                        // Specs + image
                                        Row(
                                          children: [
                                            Icon(Icons.person_outline,
                                                size: 20, color: t.label),
                                            const SizedBox(width: 4),
                                            Text('${car['seats'] ?? '-'}',
                                                style: TextStyle(
                                                    fontSize: 14, color: t.title)),
                                            const SizedBox(width: 16),
                                            Icon(Icons.work_outline,
                                                size: 20, color: t.label),
                                            const SizedBox(width: 4),
                                            Text('${car['bags'] ?? '-'}',
                                                style: TextStyle(
                                                    fontSize: 14, color: t.title)),
                                            const SizedBox(width: 16),
                                            Icon(Icons.settings,
                                                size: 20, color: t.label),
                                            const SizedBox(width: 4),
                                            Text(car['transmission'] ?? '-',
                                                style: TextStyle(
                                                    fontSize: 14, color: t.title)),
                                            const Spacer(),
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(10),
                                              child: car['image'] != null
                                                  ? Image.network(
                                                      car['image'],
                                                      width: 90, height: 56,
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (_, __, ___) =>
                                                          _carImageFallback(t),
                                                    )
                                                  : _carImageFallback(t),
                                            ),
                                          ],
                                        ),

                                        const SizedBox(height: 14),
                                        Divider(color: t.divider, height: 1),
                                        const SizedBox(height: 14),

                                        // Brand + pricing
                                        Row(
                                          children: [
                                            Text(
                                              car['brand'] ?? '',
                                              style: TextStyle(
                                                  fontSize: 14, color: t.label),
                                            ),
                                            const Spacer(),
                                            _priceChip(
                                                label: l.perDay,
                                                amount:
                                                    '﷼ ${car['pricePerDay']}',
                                                t: t),
                                            const SizedBox(width: 16),
                                            _priceChip(
                                                label: l.perWeek,
                                                amount:
                                                    '﷼ ${(car['pricePerDay'] * 7).toStringAsFixed(0)}',
                                                t: t),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Text(l.vatIncluded,
                                            style: TextStyle(
                                                fontSize: 11, color: t.label)),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),

                          // ── Show more ──
                          if (!isLoading && !hasError && visibleCount < cars.length)
                            GestureDetector(
                              onTap: () => setState(() => visibleCount += 7),
                              child: Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                decoration: BoxDecoration(
                                  color: t.card,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                      color: t.cardBorder.withOpacity(0.5)),
                                ),
                                child: Center(
                                  child: Text(
                                    l.showMore,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: t.accent,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                          const SizedBox(height: 8),

                          // ── Booking Details ──
                          Text(
                            l.bookingDetails,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: t.title,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Personal info card
                          Container(
                            decoration: BoxDecoration(
                              color: t.card,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: t.cardBorder.withOpacity(0.4)),
                              boxShadow: [
                                BoxShadow(
                                  color: t.cardBorder.withOpacity(0.1),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(18),
                            child: Column(
                              children: [
                                _formField(firstNameCtrl, l.firstName, t,
                                    errorText: _firstNameErrorKey != null
                                        ? _resolveError(_firstNameErrorKey, l)
                                        : null),
                                const SizedBox(height: 12),
                                _formField(lastNameCtrl, l.lastName, t,
                                    errorText: _lastNameErrorKey != null
                                        ? _resolveError(_lastNameErrorKey, l)
                                        : null),
                                const SizedBox(height: 12),
                                _formField(emailCtrl, l.email, t,
                                    keyboardType: TextInputType.emailAddress,
                                    errorText: _emailErrorKey != null
                                        ? _resolveError(_emailErrorKey, l)
                                        : null),
                                const SizedBox(height: 12),
                                _formField(phoneCtrl, l.phone, t,
                                    keyboardType: TextInputType.phone,
                                    errorText: _phoneErrorKey != null
                                        ? _resolveError(_phoneErrorKey, l)
                                        : null),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Selected car banner
                          if (selectedCar != null)
                            Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: t.accentLight,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: t.accent.withOpacity(0.4)),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.directions_car, color: t.accent),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      '${selectedCar!['name']} — ﷼${selectedCar!['pricePerDay']}/${l.perDay}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: t.accent),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => setState(() => selectedCar = null),
                                    child: Icon(Icons.close, color: t.accent, size: 18),
                                  ),
                                ],
                              ),
                            )
                          else
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Text(l.selectCarFirst,
                                  style: TextStyle(color: t.label, fontSize: 13)),
                            ),

                          // Locations card
                          Container(
                            decoration: BoxDecoration(
                              color: t.card,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: t.cardBorder.withOpacity(0.4)),
                              boxShadow: [
                                BoxShadow(
                                  color: t.cardBorder.withOpacity(0.1),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _sectionLabel(l.pickupLocation, t),
                                const SizedBox(height: 8),
                                _dropdownField(
                                  value: pickupLocation,
                                  hint: l.selectLocation,
                                  items: locations,
                                  onChanged: (val) =>
                                      setState(() => pickupLocation = val),
                                  t: t,
                                ),
                                const SizedBox(height: 16),
                                Divider(color: t.divider, height: 1),
                                const SizedBox(height: 16),
                                _sectionLabel(l.dropoffLocation, t),
                                const SizedBox(height: 8),
                                _dropdownField(
                                  value: dropoffLocation,
                                  hint: l.selectLocation,
                                  items: locations,
                                  onChanged: (val) =>
                                      setState(() => dropoffLocation = val),
                                  t: t,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Date/time card
                          Container(
                            decoration: BoxDecoration(
                              color: t.card,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: t.cardBorder.withOpacity(0.4)),
                              boxShadow: [
                                BoxShadow(
                                  color: t.cardBorder.withOpacity(0.1),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _sectionLabel(l.pickupDateTime, t),
                                const SizedBox(height: 8),
                                _dateTimeButton(
                                  value: pickupDateTime,
                                  onTap: () => _pickDateTime(true),
                                  l: l, t: t,
                                  icon: Icons.flight_takeoff_rounded,
                                ),
                                const SizedBox(height: 16),
                                Divider(color: t.divider, height: 1),
                                const SizedBox(height: 16),
                                _sectionLabel(l.dropoffDateTime, t),
                                const SizedBox(height: 8),
                                _dateTimeButton(
                                  value: dropoffDateTime,
                                  onTap: () => _pickDateTime(false),
                                  l: l, t: t,
                                  icon: Icons.flight_land_rounded,
                                ),
                                if (totalDays > 0) ...[
                                  const SizedBox(height: 12),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: t.accentLight,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      l.totalDays(totalDays),
                                      style: TextStyle(
                                          color: t.accent,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Private driver card
                          Container(
                            decoration: BoxDecoration(
                              color: t.card,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: t.cardBorder.withOpacity(0.4)),
                            ),
                            child: SwitchListTile(
                              title: Text(l.privateDriver,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: t.title)),
                              subtitle: Text(l.privateDriverExtra,
                                  style: TextStyle(
                                      fontSize: 12, color: t.label)),
                              value: privateDriver,
                              onChanged: (val) =>
                                  setState(() => privateDriver = val),
                              activeColor: t.accent,
                            ),
                          ),

                          // Price summary
                          if (selectedCar != null && totalDays > 0) ...[
                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: t.card,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: t.cardBorder.withOpacity(0.4)),
                              ),
                              child: Column(
                                children: [
                                  _summaryRow(
                                    l.carRentalDays(totalDays),
                                    '﷼ ${(selectedCar!['pricePerDay'] * totalDays).toStringAsFixed(0)}',
                                    t,
                                  ),
                                  if (privateDriver) ...[
                                    const SizedBox(height: 8),
                                    _summaryRow(
                                      l.privateDriver,
                                      '﷼ ${(totalDays * 100).toStringAsFixed(0)}',
                                      t,
                                    ),
                                  ],
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    child: Divider(color: t.divider, height: 1),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(l.total,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: t.title)),
                                      Text(
                                        '﷼ ${((selectedCar!['pricePerDay'] * totalDays) + (privateDriver ? totalDays * 100 : 0)).toStringAsFixed(0)}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: t.price,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],

                          const SizedBox(height: 24),

                          // ── Confirm button ──
                          GestureDetector(
                            onTap: isSubmitting ? null : () => _submitBooking(l),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: t.btnGradient),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: t.accent.withOpacity(0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: isSubmitting
                                    ? const CircularProgressIndicator(
                                        color: Colors.white)
                                    : Text(
                                        l.confirmBooking,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _carImageFallback(AppThemeExtension t) {
    return Container(
      width: 90, height: 56,
      decoration: BoxDecoration(
        color: t.accentLight,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(Icons.directions_car, size: 36, color: t.accent),
    );
  }

  Widget _priceChip({
    required String label,
    required String amount,
    required AppThemeExtension t,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(label, style: TextStyle(fontSize: 11, color: t.label)),
        Text(amount,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: t.price)),
      ],
    );
  }

  Widget _summaryRow(String label, String value, AppThemeExtension t) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: t.label, fontSize: 14)),
        Text(value,
            style: TextStyle(
                color: t.title, fontSize: 14, fontWeight: FontWeight.w600)),
      ],
    );
  }
}