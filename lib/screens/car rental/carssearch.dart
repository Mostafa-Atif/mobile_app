// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import 'package:mobile_app/models/airport_data.dart';
import 'package:mobile_app/services/airport_service.dart';
import 'package:mobile_app/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_app/screens/home/home_screen.dart';
import '../../config.dart';

enum BookingStep { tripDetails, chooseCar, personalInfo, review }
enum CarSortOption { priceLow, priceHigh, nameAZ, seatsLow, seatsHigh }

List<AirportData> _airports = [];

class CarsSearch extends StatefulWidget {
  const CarsSearch({super.key});
  @override
  _CarsSearchState createState() => _CarsSearchState();
}

class _CarsSearchState extends State<CarsSearch> with TickerProviderStateMixin {

  // ── Data ───────────────────────────────────────────────────────────────────
  List<dynamic> cars = [];
  bool isLoading = true;
  bool hasError = false;
  bool isSubmitting = false;
  bool _submitted = false;
  final MapController _mapController = MapController();

  // ── Stepper ────────────────────────────────────────────────────────────────
  BookingStep _currentStep = BookingStep.tripDetails;
  late final PageController _pageCtrl;

  // ── Filters & Sort ─────────────────────────────────────────────────────────
  String _filterSeats = 'Any';
  String _filterPrice = 'Any';
  CarSortOption _sortOption = CarSortOption.priceLow;

  List<dynamic> get filteredAndSortedCars {
    var list = cars.where((car) {
      if (_filterSeats != 'Any') {
        final seats = car['seats'] as int? ?? 0;
        if (_filterSeats == '4' && seats != 4) return false;
        if (_filterSeats == '5' && seats != 5) return false;
        if (_filterSeats == '7+' && seats < 7) return false;
      }
      if (_filterPrice != 'Any') {
        final price = (car['pricePerDay'] as num?)?.toDouble() ?? 0;
        if (_filterPrice == '<200' && price >= 200) return false;
        if (_filterPrice == '200-400' && (price < 200 || price > 400)) return false;
        if (_filterPrice == '400+' && price <= 400) return false;
      }
      return true;
    }).toList();

    list.sort((a, b) {
      switch (_sortOption) {
        case CarSortOption.priceLow:
          return ((a['pricePerDay'] as num?) ?? 0).compareTo((b['pricePerDay'] as num?) ?? 0);
        case CarSortOption.priceHigh:
          return ((b['pricePerDay'] as num?) ?? 0).compareTo((a['pricePerDay'] as num?) ?? 0);
        case CarSortOption.nameAZ:
          return (a['name'] as String? ?? '').compareTo(b['name'] as String? ?? '');
        case CarSortOption.seatsLow:
          return ((a['seats'] as int?) ?? 0).compareTo((b['seats'] as int?) ?? 0);
        case CarSortOption.seatsHigh:
          return ((b['seats'] as int?) ?? 0).compareTo((a['seats'] as int?) ?? 0);
      }
    });
    return list;
  }

  // ── Promo ──────────────────────────────────────────────────────────────────
  String? _appliedPromo;
  double _discountAmount = 0;
  String? _promoError;
  bool _promoLoading = false;
  final TextEditingController _promoCtrl = TextEditingController();
  double _discountPercent = 0;

  // ── Booking state ──────────────────────────────────────────────────────────
  Map<String, dynamic>? selectedCar;
  DateTime? pickupDateTime;
  DateTime? dropoffDateTime;
  bool privateDriver = false;
  AirportData? selectedAirport;

  // ── User ───────────────────────────────────────────────────────────────────
  String userId = '';
  String token = '';
  final TextEditingController firstNameCtrl = TextEditingController();
  final TextEditingController lastNameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();

  // ── Lifecycle ──────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    _pageCtrl = PageController();
    loadUserInfo();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchCars();
    loadAirports(context).then((data) => setState(() => _airports = data));
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    firstNameCtrl.dispose();
    lastNameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    _promoCtrl.dispose();
    super.dispose();
  }

  // ── Navigation ─────────────────────────────────────────────────────────────
  void _goToStep(BookingStep step) {
    setState(() => _currentStep = step);
    _pageCtrl.animateToPage(step.index,
        duration: const Duration(milliseconds: 350), curve: Curves.easeInOut);
  }

  bool _canAdvance(AppLocalizations l) {
    switch (_currentStep) {
      case BookingStep.tripDetails:
        if (selectedAirport == null) { _showSnack(l.selectLocationsError); return false; }
        if (pickupDateTime == null || dropoffDateTime == null) { _showSnack(l.selectDatesError); return false; }
        if (dropoffDateTime!.isBefore(pickupDateTime!)) { _showSnack(l.dropoffBeforePickup); return false; }
        return true;
      case BookingStep.chooseCar:
        if (selectedCar == null) { _showSnack(l.selectCarError); return false; }
        return true;
      case BookingStep.personalInfo:
        setState(() => _submitted = true);
        return _validateName(firstNameCtrl.text) == null &&
            _validateName(lastNameCtrl.text) == null &&
            _validateEmail(emailCtrl.text) == null &&
            _validatePhone(phoneCtrl.text) == null;
      case BookingStep.review:
        return true;
    }
  }

  void _showSnack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  // ── Fetch cars ─────────────────────────────────────────────────────────────
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

  Future<void> fetchCars() async {
    setState(() { isLoading = true; hasError = false; });
    try {
      final lang = Localizations.localeOf(context).languageCode;
      final response = await http.get(Uri.parse('${Config.baseUrl}/api/cars?lang=$lang'));
      if (response.statusCode == 200) {
        setState(() { cars = json.decode(response.body); isLoading = false; });
      } else {
        setState(() { isLoading = false; hasError = true; });
      }
    } catch (e) {
      setState(() { isLoading = false; hasError = true; });
    }
  }

  // ── Date/time ──────────────────────────────────────────────────────────────
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
    setState(() { if (isPickup) pickupDateTime = combined; else dropoffDateTime = combined; });
    _recalculateDiscount();
  }

  String _formatDateTime(DateTime? dt, AppLocalizations l) {
    if (dt == null) return l.selectDateTime;
    return '${dt.day}/${dt.month}/${dt.year}  ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  int get totalDays {
    if (pickupDateTime == null || dropoffDateTime == null) return 0;
    return (dropoffDateTime!.difference(pickupDateTime!).inHours / 24).ceil();
  }

  // ── Validation ─────────────────────────────────────────────────────────────
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
    switch (key) {
      case 'required': return l.errorRequired;
      case 'lettersOnly': return l.errorLettersOnly;
      case 'validEmail': return l.errorValidEmail;
      case 'validPhone': return l.errorValidPhone;
      default: return '';
    }
  }

  String? get _firstNameError => _submitted ? _validateName(firstNameCtrl.text) : null;
  String? get _lastNameError => _submitted ? _validateName(lastNameCtrl.text) : null;
  String? get _emailError => _submitted ? _validateEmail(emailCtrl.text) : null;
  String? get _phoneError => _submitted ? _validatePhone(phoneCtrl.text) : null;

  // ── Promo ──────────────────────────────────────────────────────────────────
  double get _totalBeforeDiscount {
    if (selectedCar == null || totalDays == 0) return 0;
    return ((selectedCar!['pricePerDay'] ?? 0) * totalDays +
        (privateDriver ? totalDays * 100 : 0)).toDouble();
  }

  double get _totalAfterDiscount => _totalBeforeDiscount - _discountAmount;

  void _recalculateDiscount() {
    if (_appliedPromo == null) return;
    setState(() => _discountAmount = _totalBeforeDiscount * _discountPercent);
  }

  Future<void> _applyPromo(AppLocalizations l, AppThemeExtension t) async {
    final code = _promoCtrl.text.trim().toUpperCase();
    if (code.isEmpty) return;
    setState(() { _promoLoading = true; _promoError = null; });
    try {
      final res = await http.post(
        Uri.parse('${Config.baseUrl}/api/promo/validate'),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
        body: json.encode({'code': code, 'userId': userId}),
      );
      final data = json.decode(res.body);
      if (res.statusCode == 200) {
        setState(() {
          _appliedPromo = code;
          _discountPercent = data['discountPercent'] / 100;
          _discountAmount = _totalBeforeDiscount * _discountPercent;
          _promoLoading = false;
        });
      } else {
        setState(() { _promoError = data['message'] ?? l.invalidPromoCode; _promoLoading = false; });
      }
    } catch (e) {
      setState(() { _promoError = l.promoValidateFailed; _promoLoading = false; });
    }
  }

  void _removePromo() => setState(() {
    _appliedPromo = null; _discountAmount = 0; _promoError = null; _promoCtrl.clear();
  });

  // ── Submit ─────────────────────────────────────────────────────────────────
  Future<void> _submitBooking(AppLocalizations l) async {
    if (token.isEmpty) { _showSnack(l.signInFirst); return; }
    setState(() => isSubmitting = true);
    try {
      final lang = Localizations.localeOf(context).languageCode;
      final location = '${selectedAirport!.name} (${selectedAirport!.code})';
      final response = await http.post(
        Uri.parse('${Config.baseUrl}/api/car-bookings'),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
        body: json.encode({
          'carId': selectedCar!['_id'],
          'pickupLocation': location,
          'dropoffLocation': location,
          'pickupDateTime': pickupDateTime!.toIso8601String(),
          'dropoffDateTime': dropoffDateTime!.toIso8601String(),
          'privateDriver': privateDriver,
          'lang': lang,
          'promoCode': _appliedPromo,
        }),
      );
      final data = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        _resetState();
        if (!mounted) return;
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => SuccessScreen(onContinue: () => Navigator.pushAndRemoveUntil(
            context, MaterialPageRoute(builder: (_) => HomeScreen()), (route) => false,
          )),
        ));
      } else {
        _showSnack(data['message'] ?? l.bookingFailed);
      }
    } catch (e) {
      _showSnack('Error: $e');
    }
    setState(() => isSubmitting = false);
  }

  void _resetState() {
    setState(() {
      selectedCar = null; selectedAirport = null;
      pickupDateTime = null; dropoffDateTime = null;
      privateDriver = false; _submitted = false;
      _appliedPromo = null; _discountAmount = 0;
      _currentStep = BookingStep.tripDetails;
      _filterSeats = 'Any'; _filterPrice = 'Any';
      _sortOption = CarSortOption.priceLow;
    });
    _promoCtrl.clear();
    _pageCtrl.jumpToPage(0);
  }

  // ══════════════════════════════════════════════════════════════════════════
  // BUILD
  // ══════════════════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<AppThemeExtension>()!;
    final l = AppLocalizations.of(context)!;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      backgroundColor: t.bg,
      body: SafeArea(
        child: hasError
            ? _buildError(t, l)
            : Column(children: [
                _buildHeader(t, l, isAr),
                _buildStepIndicator(t, l),
                Expanded(
                  child: PageView(
                    controller: _pageCtrl,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildStep1TripDetails(t, l),
                      _buildStep2CarSelect(t, l),
                      _buildStep3PersonalInfo(t, l),
                      _buildStep4Review(t, l),
                    ],
                  ),
                ),
                _buildBottomBar(t, l),
              ]),
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────
  Widget _buildHeader(AppThemeExtension t, AppLocalizations l, bool isAr) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
          color: t.card, border: Border(bottom: BorderSide(color: t.divider))),
      child: Row(children: [
        GestureDetector(
          onTap: () {
            if (_currentStep.index > 0) _goToStep(BookingStep.values[_currentStep.index - 1]);
            else Navigator.pop(context);
          },
          child: Container(
            width: 38, height: 38,
            decoration: BoxDecoration(color: t.backBg, borderRadius: BorderRadius.circular(10)),
            child: Icon(isAr ? Icons.arrow_forward : Icons.arrow_back, color: t.backIcon, size: 18),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(_stepTitle(l),
              style: TextStyle(color: t.title, fontSize: 17, fontWeight: FontWeight.bold)),
          Text(l.stepOf(_currentStep.index + 1),
              style: TextStyle(color: t.label, fontSize: 12)),
        ])),
        if (selectedCar != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: t.accentLight,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: t.accent.withOpacity(0.3)),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.directions_car, size: 14, color: t.accent),
              const SizedBox(width: 4),
              Text(selectedCar!['name'] ?? '',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: t.accent)),
            ]),
          ),
      ]),
    );
  }

  String _stepTitle(AppLocalizations l) {
    switch (_currentStep) {
      case BookingStep.tripDetails: return l.tripDetails;
      case BookingStep.chooseCar: return l.carRentTitle;
      case BookingStep.personalInfo: return l.yourInformation;
      case BookingStep.review: return l.reviewAndConfirm;
    }
  }

  // ── Step Indicator ─────────────────────────────────────────────────────────
  Widget _buildStepIndicator(AppThemeExtension t, AppLocalizations l) {
    final steps = [l.trip, l.vehicle, l.yourInformation, l.reviewAndConfirm];
    return Container(
      color: t.card,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      child: Row(
        children: List.generate(steps.length, (i) {
          final isActive = i == _currentStep.index;
          final isDone = i < _currentStep.index;
          return Expanded(
            child: Row(children: [
              Expanded(
                child: GestureDetector(
                  onTap: isDone ? () => _goToStep(BookingStep.values[i]) : null,
                  child: Column(children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      height: 3,
                      decoration: BoxDecoration(
                        color: isActive || isDone ? t.accent : t.cardBorder.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      if (isDone)
                        Icon(Icons.check_circle, size: 12, color: t.accent)
                      else
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          width: 6, height: 6,
                          decoration: BoxDecoration(
                            color: isActive ? t.accent : t.cardBorder.withOpacity(0.4),
                            shape: BoxShape.circle,
                          ),
                        ),
                      const SizedBox(width: 4),
                      Flexible(child: Text(steps[i], overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: isActive ? FontWeight.w700 : FontWeight.normal,
                            color: isActive ? t.accent : isDone ? t.sub : t.label,
                          ))),
                    ]),
                  ]),
                ),
              ),
              if (i < steps.length - 1) const SizedBox(width: 4),
            ]),
          );
        }),
      ),
    );
  }

  // ── Bottom Bar ─────────────────────────────────────────────────────────────
  Widget _buildBottomBar(AppThemeExtension t, AppLocalizations l) {
    final isLastStep = _currentStep == BookingStep.review;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      decoration: BoxDecoration(
        color: t.card,
        border: Border(top: BorderSide(color: t.divider)),
        boxShadow: [BoxShadow(
            color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, -4))],
      ),
      child: Row(children: [
        if (selectedCar != null && totalDays > 0) ...[
          Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            Text('﷼ ${_totalAfterDiscount.toStringAsFixed(0)}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: t.price)),
            Text('$totalDays ${totalDays == 1 ? l.day : l.days} ${l.total2}',
                style: TextStyle(fontSize: 11, color: t.label)),
          ]),
          const SizedBox(width: 16),
        ],
        Expanded(
          child: GestureDetector(
            onTap: isSubmitting ? null : () {
              if (isLastStep) _submitBooking(l);
              else if (_canAdvance(l)) _goToStep(BookingStep.values[_currentStep.index + 1]);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: t.btnGradient),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(
                    color: t.accent.withOpacity(0.25), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Center(
                child: isSubmitting
                    ? const SizedBox(width: 22, height: 22,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                    : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text(isLastStep ? l.bookNow : l.continuee,
                            style: const TextStyle(color: Colors.white, fontSize: 15,
                                fontWeight: FontWeight.bold, letterSpacing: 0.3)),
                        if (!isLastStep) ...[
                          const SizedBox(width: 6),
                          const Icon(Icons.arrow_forward, color: Colors.white, size: 16),
                        ],
                      ]),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // STEP 1 — Trip Details
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildStep1TripDetails(AppThemeExtension t, AppLocalizations l) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        // ── Airport picker card ──
        _sectionCard(t, children: [
          _inlineLabel(l.pickupAndDropoff, t),
          const SizedBox(height: 10),

          // Airport picker field
          _searchablePickerField(
            value: selectedAirport != null
                ? '${selectedAirport!.name} (${selectedAirport!.code})'
                : null,
            hint: l.selectLocation,
            icon: Icons.flight,
            t: t,
            onTap: () => _showAirportSheet(context, t, l),
          ),

          // Confirmed location + map
          if (selectedAirport != null) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: t.successBg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: t.success.withOpacity(0.3)),
              ),
              child: Row(children: [
                Icon(Icons.check_circle_outline, size: 16, color: t.success),
                const SizedBox(width: 8),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(selectedAirport!.name,
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: t.success)),
                  Text('${selectedAirport!.city} · ${selectedAirport!.country}',
                      style: TextStyle(fontSize: 11, color: t.success.withOpacity(0.8))),
                ])),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: t.success.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(selectedAirport!.code,
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: t.success)),
                ),
              ]),
            ),
            const SizedBox(height: 14),

            // Map — hardcoded lat/lng, no geocoding needed
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: SizedBox(
                height: 200,
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: LatLng(selectedAirport!.lat, selectedAirport!.lng),
                    initialZoom: 14,
                    interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                    ),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.app',
                    ),
                    MarkerLayer(markers: [
                      Marker(
                        point: LatLng(selectedAirport!.lat, selectedAirport!.lng),
                        width: 56, height: 56,
                        child: Column(mainAxisSize: MainAxisSize.min, children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                            decoration: BoxDecoration(
                              color: t.accent,
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: [BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 4, offset: const Offset(0, 2))],
                            ),
                            child: Text(selectedAirport!.code,
                                style: const TextStyle(color: Colors.white,
                                    fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                          Icon(Icons.flight, color: t.accent, size: 24),
                        ]),
                      ),
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ]),

        const SizedBox(height: 16),

        // ── Dates card ──
        _sectionCard(t, children: [
          _inlineLabel(l.pickupDateTime, t),
          const SizedBox(height: 8),
          _dateTimeButton(value: pickupDateTime, onTap: () => _pickDateTime(true),
              l: l, t: t, icon: Icons.flight_takeoff_rounded),
          const SizedBox(height: 16),
          Divider(color: t.divider, height: 1),
          const SizedBox(height: 16),
          _inlineLabel(l.dropoffDateTime, t),
          const SizedBox(height: 8),
          _dateTimeButton(value: dropoffDateTime, onTap: () => _pickDateTime(false),
              l: l, t: t, icon: Icons.flight_land_rounded),
          if (totalDays > 0) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(color: t.accentLight, borderRadius: BorderRadius.circular(10)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.calendar_today_outlined, size: 14, color: t.accent),
                const SizedBox(width: 6),
                Text(l.totalDays(totalDays),
                    style: TextStyle(color: t.accent, fontSize: 13, fontWeight: FontWeight.w600)),
              ]),
            ),
          ],
        ]),

        const SizedBox(height: 16),

        // ── Private driver ──
        _sectionCard(t, padding: EdgeInsets.zero, children: [
          SwitchListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            title: Text(l.privateDriver,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: t.title)),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(l.privateDriverExtra, style: TextStyle(fontSize: 12, color: t.label)),
            ),
            secondary: Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: privateDriver ? t.accentLight : t.field,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.person_pin,
                  color: privateDriver ? t.accent : t.label, size: 20),
            ),
            value: privateDriver,
            onChanged: (val) { setState(() => privateDriver = val); _recalculateDiscount(); },
            activeThumbColor: t.accent,
            activeTrackColor: t.accent.withOpacity(0.3),
          ),
        ]),

        const SizedBox(height: 8),
      ]),
    );
  }

  // ── Airport searchable bottom sheet ───────────────────────────────────────
  Future<void> _showAirportSheet(
      BuildContext context, AppThemeExtension t, AppLocalizations l) async {
    final ctrl = TextEditingController();
    List<AirportData> filtered = List.from(_airports);

    // Group by country for display
    Map<String, List<AirportData>> grouped(List<AirportData> list) {
      final map = <String, List<AirportData>>{};
      for (final a in list) {
        map.putIfAbsent(a.country, () => []).add(a);
      }
      return Map.fromEntries(map.entries.toList()..sort((a, b) => a.key.compareTo(b.key)));
    }

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setSheet) {
          final groups = grouped(filtered);
          return Container(
            height: MediaQuery.of(context).size.height * 0.82,
            decoration: BoxDecoration(
              color: t.card,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40, height: 4,
                decoration: BoxDecoration(
                    color: t.cardBorder.withOpacity(0.5), borderRadius: BorderRadius.circular(2)),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
                child: Text(l.selectLocation,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: t.title)),
              ),
              // Search
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: TextField(
                  controller: ctrl,
                  autofocus: true,
                  style: TextStyle(color: t.title, fontSize: 15),
                  decoration: InputDecoration(
                    hintText: l.searchCountry,
                    hintStyle: TextStyle(color: t.label),
                    filled: true, fillColor: t.field,
                    prefixIcon: Icon(Icons.search, color: t.label, size: 20),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  ),
                  onChanged: (q) {
                    setSheet(() {
                      filtered = _airports.where((a) =>
                        a.name.toLowerCase().contains(q.toLowerCase()) ||
                        a.code.toLowerCase().contains(q.toLowerCase()) ||
                        a.city.toLowerCase().contains(q.toLowerCase()) ||
                        a.country.toLowerCase().contains(q.toLowerCase()),
                      ).toList();
                    });
                  },
                ),
              ),
              Divider(color: t.divider, height: 1),
              // Grouped list
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(bottom: 24),
                  children: groups.entries.map((entry) {
                    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      // Country header
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 6),
                        child: Text(entry.key.toUpperCase(),
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700,
                                color: t.label, letterSpacing: 1.1)),
                      ),
                      ...entry.value.map((airport) => InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          setState(() => selectedAirport = airport);
                          _mapController.move(LatLng(airport.lat, airport.lng), 14);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          child: Row(children: [
                            Container(
                              width: 44, height: 36,
                              decoration: BoxDecoration(
                                color: t.accentLight,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(airport.code,
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,
                                        color: t.accent)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(airport.name,
                                  style: TextStyle(fontSize: 14, color: t.title,
                                      fontWeight: FontWeight.w500)),
                              Text(airport.city,
                                  style: TextStyle(fontSize: 12, color: t.label)),
                            ])),
                            if (selectedAirport?.code == airport.code)
                              Icon(Icons.check_circle, color: t.accent, size: 18),
                          ]),
                        ),
                      )),
                      Divider(color: t.divider.withOpacity(0.5), height: 1,
                          indent: 20, endIndent: 20),
                    ]);
                  }).toList(),
                ),
              ),
            ]),
          );
        },
      ),
    );
    ctrl.dispose();
  }

  // ══════════════════════════════════════════════════════════════════════════
  // STEP 2 — Choose a Car
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildStep2CarSelect(AppThemeExtension t, AppLocalizations l) {
    final results = filteredAndSortedCars;
    return Column(children: [
      // ── Collapsed filter bar — single row ──
      Container(
        color: t.card,
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        child: Row(children: [
          // Seats chips
          Icon(Icons.person_outline, size: 14, color: t.label),
          const SizedBox(width: 4),
          ..._filterChips([l.all, '4', '5', '7+'], _filterSeats,
              (v) => setState(() => _filterSeats = v), t),
          Container(width: 1, height: 20,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              color: t.divider),
          // Price chips
          ..._filterChips(['<200', '200-400', '400+'], _filterPrice,
              (v) => setState(() => _filterPrice = v), t),
          const Spacer(),
          // Sort button — icon only
          GestureDetector(
            onTap: () => _showSortSheet(t, l),
            child: Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: _sortOption != CarSortOption.priceLow ? t.accentLight : t.field,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _sortOption != CarSortOption.priceLow
                      ? t.accent.withOpacity(0.4)
                      : t.fieldBorder.withOpacity(0.4),
                ),
              ),
              child: Icon(Icons.sort,
                  size: 18,
                  color: _sortOption != CarSortOption.priceLow ? t.accent : t.label),
            ),
          ),
        ]),
      ),
      Divider(height: 1, color: t.divider),

      // ── Car list ──
      Expanded(
        child: isLoading
            ? Center(child: CircularProgressIndicator(color: t.accent))
            : results.isEmpty
                ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(Icons.directions_car_outlined, size: 48, color: t.cardBorder),
                    const SizedBox(height: 12),
                    Text(l.noCarsMatch, style: TextStyle(color: t.label, fontSize: 14)),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => setState(() { _filterSeats = 'Any'; _filterPrice = 'Any'; }),
                      child: Text(l.clearFilters,
                          style: TextStyle(color: t.accent, fontSize: 13, fontWeight: FontWeight.w600)),
                    ),
                  ]))
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                    itemCount: results.length,
                    itemBuilder: (_, i) => _buildCarCard(results[i], t, l),
                  ),
      ),
    ]);
  }

  List<Widget> _filterChips(List<String> options, String selected,
      ValueChanged<String> onTap, AppThemeExtension t) {
    return options.map((opt) {
      final isSelected = opt == selected;
      return GestureDetector(
        onTap: () => onTap(isSelected ? 'Any' : opt),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.only(right: 5),
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
          decoration: BoxDecoration(
            color: isSelected ? t.accent : t.field,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: isSelected ? t.accent : t.fieldBorder.withOpacity(0.5)),
          ),
          child: Text(opt, style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
            color: isSelected ? Colors.white : t.sub,
          )),
        ),
      );
    }).toList();
  }

  String _sortLabel(AppLocalizations l) {
    switch (_sortOption) {
      case CarSortOption.priceLow: return l.sortPriceLow;
      case CarSortOption.priceHigh: return l.sortPriceHigh;
      case CarSortOption.nameAZ: return l.sortNameAZ;
      case CarSortOption.seatsLow: return l.sortSeatsLow;
      case CarSortOption.seatsHigh: return l.sortSeatsHigh;
    }
  }

  void _showSortSheet(AppThemeExtension t, AppLocalizations l) {
    final options = [
      (CarSortOption.priceLow, l.sortPriceLow, Icons.arrow_upward),
      (CarSortOption.priceHigh, l.sortPriceHigh, Icons.arrow_downward),
      (CarSortOption.nameAZ, l.sortNameAZ, Icons.sort_by_alpha),
      (CarSortOption.seatsLow, l.sortSeatsLow, Icons.person_outline),
      (CarSortOption.seatsHigh, l.sortSeatsHigh, Icons.people_outline),
    ];
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: BoxDecoration(
            color: t.card, borderRadius: const BorderRadius.vertical(top: Radius.circular(24))),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 40, height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
                color: t.cardBorder.withOpacity(0.5), borderRadius: BorderRadius.circular(2)),
          ),
          Text(l.sortBy,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: t.title)),
          const SizedBox(height: 16),
          ...options.map((opt) {
            final isSelected = _sortOption == opt.$1;
            return InkWell(
              onTap: () { setState(() => _sortOption = opt.$1); Navigator.pop(context); },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                margin: const EdgeInsets.only(bottom: 6),
                decoration: BoxDecoration(
                  color: isSelected ? t.accentLight : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: isSelected ? t.accent.withOpacity(0.3) : Colors.transparent),
                ),
                child: Row(children: [
                  Icon(opt.$3, size: 18, color: isSelected ? t.accent : t.label),
                  const SizedBox(width: 12),
                  Expanded(child: Text(opt.$2, style: TextStyle(
                    fontSize: 14,
                    color: isSelected ? t.accent : t.title,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ))),
                  if (isSelected) Icon(Icons.check, size: 18, color: t.accent),
                ]),
              ),
            );
          }),
        ]),
      ),
    );
  }

  // ── Car card — compact horizontal layout ───────────────────────────────────
  Widget _buildCarCard(Map<String, dynamic> car, AppThemeExtension t, AppLocalizations l) {
    final isSelected = selectedCar != null && selectedCar!['_id'] == car['_id'];
    final fuel = car['fuel'] as String? ?? '';
    final fuelColor = fuel == 'Electric'
        ? Colors.green
        : fuel == 'Diesel' ? Colors.orange : t.label;

    return GestureDetector(
      onTap: () { setState(() => selectedCar = car); _recalculateDiscount(); },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? t.accentLight : t.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? t.accent : t.cardBorder.withOpacity(0.45),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: t.accent.withOpacity(0.12), blurRadius: 12, offset: const Offset(0, 4))]
              : [BoxShadow(color: t.cardBorder.withOpacity(0.08), blurRadius: 6, offset: const Offset(0, 2))],
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          // ── Thumbnail ──
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 90, height: 68,
              color: t.accentLight,
              child: car['image'] != null
                  ? Image.network(car['image'], width: 90, height: 68, fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Icon(Icons.directions_car,
                          size: 32, color: t.accent.withOpacity(0.4)))
                  : Icon(Icons.directions_car, size: 32, color: t.accent.withOpacity(0.4)),
            ),
          ),
          const SizedBox(width: 12),

          // ── Info ──
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Text(car['name'] ?? '',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: t.title),
                    maxLines: 1, overflow: TextOverflow.ellipsis)),
                if (isSelected)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: t.accent, borderRadius: BorderRadius.circular(20)),
                    child: Text(l.selected,
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
              ]),
              const SizedBox(height: 3),
              Row(children: [
                Text(car['brand'] ?? '',
                    style: TextStyle(fontSize: 12, color: t.label)),
                const SizedBox(width: 6),
                Container(width: 3, height: 3,
                    decoration: BoxDecoration(color: t.cardBorder, shape: BoxShape.circle)),
                const SizedBox(width: 6),
                Text(fuel, style: TextStyle(fontSize: 12, color: fuelColor, fontWeight: FontWeight.w500)),
              ]),
              const SizedBox(height: 8),
              Row(children: [
                _miniSpec(Icons.person_outline, '${car['seats'] ?? '-'}', t),
                const SizedBox(width: 8),
                _miniSpec(Icons.work_outline, '${car['bags'] ?? '-'}', t),
                const SizedBox(width: 8),
                _miniSpec(Icons.settings_outlined, car['transmission'] ?? '-', t),
              ]),
            ]),
          ),

          const SizedBox(width: 10),

          // ── Price ──
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('﷼${car['pricePerDay']}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: t.price)),
            Text(l.perDay, style: TextStyle(fontSize: 10, color: t.label)),
          ]),
        ]),
      ),
    );
  }

  Widget _miniSpec(IconData icon, String label, AppThemeExtension t) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 12, color: t.label),
      const SizedBox(width: 3),
      Text(label, style: TextStyle(fontSize: 11, color: t.sub)),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════════════
  // STEP 3 — Personal Info
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildStep3PersonalInfo(AppThemeExtension t, AppLocalizations l) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: _sectionCard(t, children: [
        _formField(firstNameCtrl, l.firstName, t, icon: Icons.person_outline,
            errorText: _firstNameError != null ? _resolveError(_firstNameError, l) : null),
        const SizedBox(height: 14),
        _formField(lastNameCtrl, l.lastName, t, icon: Icons.person_outline,
            errorText: _lastNameError != null ? _resolveError(_lastNameError, l) : null),
        const SizedBox(height: 14),
        _formField(emailCtrl, l.email, t, icon: Icons.mail_outline,
            keyboardType: TextInputType.emailAddress,
            errorText: _emailError != null ? _resolveError(_emailError, l) : null),
        const SizedBox(height: 14),
        _formField(phoneCtrl, l.phone, t, icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            errorText: _phoneError != null ? _resolveError(_phoneError, l) : null),
      ]),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // STEP 4 — Review
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildStep4Review(AppThemeExtension t, AppLocalizations l) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        // ── Pay at pickup — framed as an advantage ──
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [t.accent.withOpacity(0.08), t.accent.withOpacity(0.03)],
              begin: Alignment.topLeft, end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: t.accent.withOpacity(0.2)),
          ),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: t.accent.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.payments_outlined, color: t.accent, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(l.carsCashPaymentTitle,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: t.accent)),
              const SizedBox(height: 4),
              Text(l.carsCashPaymentBody,
                  style: TextStyle(fontSize: 12, color: t.sub, height: 1.5)),
            ])),
          ]),
        ),

        // ── Car ──
        if (selectedCar != null)
          _reviewSection(t, icon: Icons.directions_car_outlined, label: l.vehicle,
            child: Row(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 80, height: 52, color: t.accentLight,
                  child: selectedCar!['image'] != null
                      ? Image.network(selectedCar!['image'], width: 80, height: 52,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => Icon(Icons.directions_car,
                              size: 28, color: t.accent))
                      : Icon(Icons.directions_car, size: 28, color: t.accent),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(selectedCar!['name'] ?? '',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: t.title)),
                const SizedBox(height: 2),
                Text(selectedCar!['brand'] ?? '',
                    style: TextStyle(fontSize: 12, color: t.label)),
              ])),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text('﷼ ${selectedCar!['pricePerDay']}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: t.price)),
                Text(l.perDay, style: TextStyle(fontSize: 11, color: t.label)),
              ]),
            ]),
          ),

        const SizedBox(height: 12),

        // ── Trip ──
        _reviewSection(t, icon: Icons.map_outlined, label: l.trip,
          child: Column(children: [
            if (selectedAirport != null)
              _reviewRow(l.location,
                  '${selectedAirport!.name} (${selectedAirport!.code})', t,
                  icon: Icons.flight),
            const SizedBox(height: 10),
            _reviewRow(l.from, _formatDateTime(pickupDateTime, l), t,
                icon: Icons.flight_takeoff_rounded),
            const SizedBox(height: 10),
            _reviewRow(l.until, _formatDateTime(dropoffDateTime, l), t,
                icon: Icons.flight_land_rounded),
            if (privateDriver) ...[
              const SizedBox(height: 10),
              _reviewRow(l.privateDriver, l.included, t,
                  icon: Icons.person_pin, valueColor: t.success),
            ],
          ]),
        ),

        const SizedBox(height: 12),
        _promoSection(l, t),
        const SizedBox(height: 12),

        // ── Price breakdown ──
        if (selectedCar != null && totalDays > 0)
          _reviewSection(t, icon: Icons.receipt_long_outlined, label: l.priceBreakdown,
            child: Column(children: [
              _summaryRow(l.carRentalDays(totalDays),
                  '﷼ ${(selectedCar!['pricePerDay'] * totalDays).toStringAsFixed(0)}', t),
              if (privateDriver) ...[
                const SizedBox(height: 8),
                _summaryRow(l.privateDriver,
                    '﷼ ${(totalDays * 100).toStringAsFixed(0)}', t),
              ],
              if (_appliedPromo != null) ...[
                const SizedBox(height: 8),
                _summaryRow('$_appliedPromo (${l.promoCode})',
                    '−﷼ ${_discountAmount.toStringAsFixed(0)}', t, color: t.success),
              ],
              Padding(padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Divider(color: t.divider, height: 1)),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(l.total,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: t.title)),
                Text('﷼ ${_totalAfterDiscount.toStringAsFixed(0)}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: t.price)),
              ]),
            ]),
          ),

        const SizedBox(height: 8),
      ]),
    );
  }

  Widget _reviewSection(AppThemeExtension t,
      {required IconData icon, required String label, required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: t.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: t.cardBorder.withOpacity(0.4)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
          child: Row(children: [
            Icon(icon, size: 16, color: t.accent),
            const SizedBox(width: 6),
            Text(label.toUpperCase(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700,
                color: t.label, letterSpacing: 1.0)),
          ]),
        ),
        Padding(padding: const EdgeInsets.all(14), child: child),
      ]),
    );
  }

  Widget _reviewRow(String label, String value, AppThemeExtension t,
      {IconData? icon, Color? valueColor}) {
    return Row(children: [
      if (icon != null) ...[Icon(icon, size: 14, color: t.label), const SizedBox(width: 6)],
      Text(label, style: TextStyle(fontSize: 13, color: t.label)),
      const Spacer(),
      Flexible(child: Text(value, textAlign: TextAlign.end,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
              color: valueColor ?? t.title))),
    ]);
  }

  // ══════════════════════════════════════════════════════════════════════════
  // SHARED WIDGETS
  // ══════════════════════════════════════════════════════════════════════════

  Widget _sectionCard(AppThemeExtension t,
      {required List<Widget> children, EdgeInsets? padding}) {
    return Container(
      decoration: BoxDecoration(
        color: t.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: t.cardBorder.withOpacity(0.4)),
        boxShadow: [BoxShadow(
            color: t.cardBorder.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 3))],
      ),
      padding: padding ?? const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }

  Widget _inlineLabel(String text, AppThemeExtension t) => Text(
    text.toUpperCase(),
    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700,
        color: t.label, letterSpacing: 1.1),
  );

  Widget _searchablePickerField({
    required String? value,
    required String hint,
    required IconData icon,
    required AppThemeExtension t,
    required VoidCallback onTap,
  }) {
    final hasValue = value != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: hasValue ? t.accentLight : t.field,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: hasValue ? t.accent.withOpacity(0.4) : t.fieldBorder.withOpacity(0.5)),
        ),
        child: Row(children: [
          Icon(icon, size: 18, color: hasValue ? t.accent : t.label),
          const SizedBox(width: 10),
          Expanded(child: Text(value ?? hint,
              style: TextStyle(fontSize: 15,
                  color: hasValue ? t.title : t.label,
                  fontWeight: hasValue ? FontWeight.w600 : FontWeight.normal),
              maxLines: 1, overflow: TextOverflow.ellipsis)),
          Icon(Icons.keyboard_arrow_down,
              color: hasValue ? t.accent : t.label, size: 20),
        ]),
      ),
    );
  }

  Widget _formField(TextEditingController ctrl, String label, AppThemeExtension t, {
    TextInputType keyboardType = TextInputType.text,
    String? errorText,
    IconData? icon,
  }) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        decoration: BoxDecoration(
          color: t.field,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: errorText != null ? Colors.red.shade300 : t.fieldBorder.withOpacity(0.5)),
        ),
        child: Row(children: [
          if (icon != null)
            Padding(padding: const EdgeInsets.only(left: 12),
                child: Icon(icon, size: 18, color: t.label)),
          Expanded(child: TextField(
            controller: ctrl,
            keyboardType: keyboardType,
            onChanged: (_) => setState(() {}),
            style: TextStyle(color: t.title, fontSize: 15),
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(color: t.label, fontSize: 14),
              border: InputBorder.none,
              contentPadding: EdgeInsets.fromLTRB(icon != null ? 8 : 16, 14, 16, 14),
            ),
          )),
        ]),
      ),
      if (errorText != null)
        Padding(padding: const EdgeInsets.only(left: 4, top: 4),
            child: Text(errorText, style: TextStyle(color: Colors.red.shade400, fontSize: 12))),
    ]);
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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: hasValue ? t.accentLight : t.field,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: hasValue ? t.accent.withOpacity(0.4) : t.fieldBorder.withOpacity(0.5)),
        ),
        child: Row(children: [
          Container(
            width: 34, height: 34,
            decoration: BoxDecoration(
              color: hasValue ? t.accent : t.fieldBorder.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: hasValue ? Colors.white : t.label, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(_formatDateTime(value, l),
              style: TextStyle(color: hasValue ? t.title : t.label, fontSize: 14,
                  fontWeight: hasValue ? FontWeight.w600 : FontWeight.normal))),
          Icon(Icons.chevron_right, color: t.label, size: 18),
        ]),
      ),
    );
  }

  Widget _promoSection(AppLocalizations l, AppThemeExtension t) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: t.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: t.cardBorder.withOpacity(0.5)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(Icons.local_offer_outlined, size: 16, color: t.accent),
          const SizedBox(width: 6),
          Text(l.promoCode,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: t.title)),
        ]),
        const SizedBox(height: 10),
        if (_appliedPromo == null) ...[
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: TextField(
              controller: _promoCtrl,
              textCapitalization: TextCapitalization.characters,
              style: TextStyle(color: t.title, letterSpacing: 1.2, fontSize: 14),
              onChanged: (_) { if (_promoError != null) setState(() => _promoError = null); },
              decoration: InputDecoration(
                hintText: l.enterCode,
                hintStyle: TextStyle(color: t.label, fontSize: 13),
                filled: true, fillColor: t.field, errorText: _promoError, isDense: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: t.fieldBorder)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: _promoError != null ? Colors.red.shade300 : t.fieldBorder)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: t.accent, width: 1.5)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
            )),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _promoLoading ? null : () => _applyPromo(l, t),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: t.btnGradient),
                    borderRadius: BorderRadius.circular(10)),
                child: _promoLoading
                    ? const SizedBox(width: 16, height: 16,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text(l.apply,
                        style: const TextStyle(color: Colors.white,
                            fontWeight: FontWeight.w600, fontSize: 14)),
              ),
            ),
          ]),
        ] else ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: t.successBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: t.success.withOpacity(0.3)),
            ),
            child: Row(children: [
              Icon(Icons.check_circle_outline, color: t.success, size: 18),
              const SizedBox(width: 8),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(_appliedPromo!, style: TextStyle(fontWeight: FontWeight.w700,
                    letterSpacing: 1.1, color: t.success, fontSize: 13)),
                Text('−﷼ ${_discountAmount.toStringAsFixed(2)} ${l.saved}',
                    style: TextStyle(fontSize: 11, color: t.success.withOpacity(0.8))),
              ])),
              GestureDetector(onTap: _removePromo,
                  child: Icon(Icons.close, size: 18, color: t.label)),
            ]),
          ),
        ],
      ]),
    );
  }

  Widget _buildError(AppThemeExtension t, AppLocalizations l) => Center(
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
        label: Text(l.retry),
        style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            backgroundColor: t.accent, foregroundColor: Colors.white),
      ),
    ]),
  );

  Widget _summaryRow(String label, String value, AppThemeExtension t, {Color? color}) =>
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: TextStyle(color: color ?? t.label, fontSize: 14)),
        Text(value, style: TextStyle(color: color ?? t.title, fontSize: 14,
            fontWeight: FontWeight.w600)),
      ]);
}

// ══════════════════════════════════════════════════════════════════════════════
// SUCCESS SCREEN
// ══════════════════════════════════════════════════════════════════════════════
class SuccessScreen extends StatelessWidget {
  final VoidCallback onContinue;
  const SuccessScreen({super.key, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<AppThemeExtension>()!;
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: t.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(children: [
            const Spacer(),

            // Icon
            Container(
              width: 96, height: 96,
              decoration: BoxDecoration(color: t.successBg, shape: BoxShape.circle),
              child: Icon(Icons.check_rounded, color: t.success, size: 52),
            ),
            const SizedBox(height: 28),

            // Title
            Text(l.bookingConfirmedTitle,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: t.title)),
            const SizedBox(height: 12),

            // Message
            Text(l.bookingConfirmedMessage,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: t.label, height: 1.6)),

            const SizedBox(height: 32),

            // Pay at pickup reminder on success screen too
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: t.accentLight,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: t.accent.withOpacity(0.2)),
              ),
              child: Row(children: [
                Icon(Icons.payments_outlined, color: t.accent, size: 20),
                const SizedBox(width: 10),
                Expanded(child: Text("l.carsCashPaymentTitle",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: t.accent))),
              ]),
            ),

            const Spacer(),

            // Continue button
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: t.btnGradient),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(
                    color: t.accent.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))],
              ),
              child: ElevatedButton(
                onPressed: onContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent, shadowColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: Text(l.continuee,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600,
                        letterSpacing: 0.5)),
              ),
            ),
            const SizedBox(height: 16),
          ]),
        ),
      ),
    );
  }
}