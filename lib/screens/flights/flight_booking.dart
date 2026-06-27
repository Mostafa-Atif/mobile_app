import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app/l10n/app_localizations.dart';
import 'package:mobile_app/screens/shared/confirmation_screen.dart';
import 'package:mobile_app/screens/shared/success_screen.dart';
import 'package:mobile_app/screens/home/home_screen.dart';
import 'package:mobile_app/services/flight_translation_service.dart';
import 'package:mobile_app/widgets/Nationality_selector.dart';
import 'package:mobile_app/theme.dart';
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
  bool isSubmitting = false;
  bool summaryExpanded = false;
  String token = '';
  List<Map<String, dynamic>> passengerList = [];

  double getClassMultiplier(String cabinClass, AppLocalizations l) {
    final Map<String, double> multipliers = {
      l.economy: 1.0,
      l.premiumEconomy: 1.65,
      l.business: 2.5,
      l.firstClass: 5.0,
    };
    return multipliers[cabinClass] ?? 1.0;
  }

  // Promo code state
  final _promoCtrl = TextEditingController();
  String? _appliedPromo;
  double _discountAmount = 0;
  bool _promoLoading = false;
  String? _promoError;

  // Key to access PaymentSection's validate()
  // final _paymentKey = GlobalKey<PaymentSectionState>();

  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _initPassengers();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void dispose() {
    _promoCtrl.dispose();
    super.dispose();
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

    List<Map<String, dynamic>> list = [
      {
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
      }
    ];

    for (int i = 1; i < widget.passengers; i++) {
      list.add({
        'filled': false,
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
      });
    }

    setState(() => passengerList = list);
  }

  String _formatDate(DateTime? date, String lang) {
    if (date == null) {
      return lang == 'ar' ? 'اختر التاريخ' : 'Select date';
    }

    List<String> months;
    if (lang == 'ar') {
      months = [
        'يناير',
        'فبراير',
        'مارس',
        'أبريل',
        'مايو',
        'يونيو',
        'يوليو',
        'أغسطس',
        'سبتمبر',
        'أكتوبر',
        'نوفمبر',
        'ديسمبر'
      ];
    } else {
      months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
    }

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  num get totalPrice {
    final double classMultiplier =
        getClassMultiplier(widget.flightClass, AppLocalizations.of(context)!);
    return widget.price * classMultiplier * widget.passengers;
  }

  num get discountedTotal => totalPrice - _discountAmount;

  String? _validateName(String val) {
    if (val.trim().isEmpty) return 'required';
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(val.trim())) return 'lettersOnly';
    return null;
  }

  String? _validateEmail(String val) {
    if (val.trim().isEmpty) return 'required';
    if (!RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$').hasMatch(val.trim()))
      return 'validEmail';
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
      case 'required':
        return l.errorRequired;
      case 'lettersOnly':
        return l.errorLettersOnly;
      case 'validEmail':
        return l.errorValidEmail;
      case 'validPhone':
        return l.errorPhone;
      case 'passport':
        return l.errorPassport;
      default:
        return '';
    }
  }

  // ── Promo code logic ───────────────────────────────────────────────────────

  static const Map<String, double> _promoCodes = {
    'RAHAL20': 0.20,
    'TEST10': 0.10,
    'TEST2': 0.10,
    'TEST3': 0.10,
    '2': 0.10,
    'TEST50': 0.50,
    'خصم الدكاترة': 1.00,
  };

  Future<void> _applyPromo(AppLocalizations l, AppThemeExtension t) async {
    final code = _promoCtrl.text.trim().toUpperCase();
    if (code.isEmpty) return;

    setState(() {
      _promoLoading = true;
      _promoError = null;
    });

    final discount = _promoCodes[code];
    if (discount == null) {
      setState(() {
        _promoError = l.invalidPromoCode;
        _promoLoading = false;
      });
      return;
    }

    final usedCodes = prefs.getStringList('usedPromoCodes') ?? [];
    if (usedCodes.contains(code)) {
      setState(() {
        _promoError = l.promoAlreadyUsed;
        _promoLoading = false;
      });
      return;
    }

    setState(() {
      _appliedPromo = code;
      _discountAmount = totalPrice.toDouble() * discount;
      _promoLoading = false;
    });
  }

  void _removePromo() {
    setState(() {
      _appliedPromo = null;
      _discountAmount = 0;
      _promoError = null;
      _promoCtrl.clear();
    });
  }

  // ── Promo section widget ───────────────────────────────────────────────────

  Widget _promoSection(AppLocalizations l, AppThemeExtension t) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: t.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: t.cardBorder.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.local_offer_outlined, size: 18, color: t.accent),
            const SizedBox(width: 8),
            Text(l.promoCode,
                style: TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w600, color: t.title)),
          ]),
          const SizedBox(height: 12),
          if (_appliedPromo == null) ...[
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                child: TextField(
                  controller: _promoCtrl,
                  textCapitalization: TextCapitalization.characters,
                  style: TextStyle(color: t.title, letterSpacing: 1.2),
                  onChanged: (_) {
                    if (_promoError != null) setState(() => _promoError = null);
                  },
                  decoration: InputDecoration(
                    hintText: l.enterCode,
                    hintStyle: TextStyle(color: t.label, fontSize: 14),
                    filled: true,
                    fillColor: t.field,
                    errorText: _promoError,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: t.fieldBorder)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                            color: _promoError != null
                                ? Colors.red.shade300
                                : t.fieldBorder)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: t.accent, width: 1.5)),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 14),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: _promoLoading ? null : () => _applyPromo(l, t),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: t.btnGradient),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _promoLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2))
                      : Text(l.apply,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600)),
                ),
              ),
            ]),
          ] else ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    const Icon(Icons.check_circle_outline,
                        color: Colors.green, size: 18),
                    const SizedBox(width: 8),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_appliedPromo!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.1,
                                  color: Colors.green)),
                          Text(
                              '−${_discountAmount.toStringAsFixed(2)} ${widget.currency}',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.green.shade700)),
                        ]),
                  ]),
                  GestureDetector(
                    onTap: _removePromo,
                    child: Icon(Icons.close, size: 20, color: t.label),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ── Price breakdown widget (shown when promo is active) ────────────────────

  Widget _priceBreakdown(AppLocalizations l, AppThemeExtension t) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: t.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: t.cardBorder.withOpacity(0.5)),
      ),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(l.subtotal, style: TextStyle(color: t.label, fontSize: 13)),
          Text('$totalPrice ${widget.currency}',
              style: TextStyle(color: t.title, fontSize: 13)),
        ]),
        const SizedBox(height: 6),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(l.discountWithCode(_appliedPromo!),
              style: const TextStyle(color: Colors.green, fontSize: 13)),
          Text('−${_discountAmount.toStringAsFixed(2)} ${widget.currency}',
              style: const TextStyle(color: Colors.green, fontSize: 13)),
        ]),
        Divider(color: t.divider, height: 16),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Total',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 15, color: t.title)),
          Text('${discountedTotal.toStringAsFixed(2)} ${widget.currency}',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 15, color: t.price)),
        ]),
      ]),
    );
  }

  // ── Passenger sheet ────────────────────────────────────────────────────────

  void _openPassengerSheet(int index, AppLocalizations l, AppThemeExtension t) {
    final p = Map<String, dynamic>.from(passengerList[index]);
    final firstNameCtrl = TextEditingController(text: p['firstName']);
    final lastNameCtrl = TextEditingController(text: p['lastName']);
    final emailCtrl = TextEditingController(text: p['email']);
    final phoneCtrl = TextEditingController(text: p['phone']);
    String? selectedNationality =
        p['nationality']?.isNotEmpty == true ? p['nationality'] : null;
    final passportCtrl = TextEditingController(text: p['passportNumber']);
    String? gender = p['gender'];
    DateTime? dob = p['dateOfBirth'];
    DateTime? expiry = p['passportExpiry'];
    String countryCode = p['countryCode'] ?? '+20';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: t.card,
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
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(sheetContext).viewInsets.bottom),
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
                          '${l.passenger} ${index + 1}${index == 0 ? ' (${l.you})' : ''}',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: t.title),
                        ),
                        IconButton(
                          icon: Icon(Icons.close, color: t.label),
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
                            _validatedField(t, firstNameCtrl,
                                '${l.firstName} *', firstNameError, setSheet),
                            if (showError &&
                                (selectedNationality == null ||
                                    selectedNationality!.isEmpty))
                              Padding(
                                padding: const EdgeInsets.only(left: 4, top: 4),
                                child: Text(l.errorRequired,
                                    style: TextStyle(
                                        color: Colors.red.shade400,
                                        fontSize: 12)),
                              ),
                            const SizedBox(height: 12),
                            _validatedField(t, lastNameCtrl, '${l.lastName} *',
                                lastNameError, setSheet),
                            const SizedBox(height: 12),

                            // Gender
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 14),
                              decoration: BoxDecoration(
                                color: t.field,
                                border: Border.all(
                                    color: showError && gender == null
                                        ? Colors.red.shade300
                                        : t.fieldBorder),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: gender,
                                  isExpanded: true,
                                  dropdownColor: t.card,
                                  hint: Text('${l.gender} *',
                                      style: TextStyle(
                                          color: t.label, fontSize: 14)),
                                  items: [
                                    DropdownMenuItem(
                                        value: 'Male',
                                        child: Text(l.male,
                                            style: TextStyle(color: t.title))),
                                    DropdownMenuItem(
                                        value: 'Female',
                                        child: Text(l.female,
                                            style: TextStyle(color: t.title))),
                                  ],
                                  onChanged: (val) =>
                                      setSheet(() => gender = val),
                                ),
                              ),
                            ),
                            if (showError && gender == null)
                              Padding(
                                  padding:
                                      const EdgeInsets.only(left: 4, top: 4),
                                  child: Text(l.errorRequired,
                                      style: TextStyle(
                                          color: Colors.red.shade400,
                                          fontSize: 12))),
                            const SizedBox(height: 12),

                            _sheetDateField(
                                t,
                                sheetContext,
                                '${l.dateOfBirth} *',
                                dob,
                                (picked) => setSheet(() => dob = picked),
                                isDOB: true),
                            if (showError && dob == null)
                              Padding(
                                  padding:
                                      const EdgeInsets.only(left: 4, top: 4),
                                  child: Text(l.errorRequired,
                                      style: TextStyle(
                                          color: Colors.red.shade400,
                                          fontSize: 12))),
                            const SizedBox(height: 12),

                            NationalityField(
                              t: t,
                              l: l,
                              value: selectedNationality,
                              onSelected: (country) {
                                setSheet(() {
                                  selectedNationality = country.name;
                                  nationalityError = null;
                                });
                              },
                            ),
                            if (showError &&
                                (selectedNationality == null ||
                                    selectedNationality!.isEmpty))
                              Padding(
                                padding: const EdgeInsets.only(left: 4, top: 4),
                                child: Text(l.errorRequired,
                                    style: TextStyle(
                                        color: Colors.red.shade400,
                                        fontSize: 12)),
                              ),
                            const SizedBox(height: 16),

                            Text(l.travelDocument,
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: t.title)),
                            const SizedBox(height: 12),

                            _validatedField(
                                t,
                                passportCtrl,
                                '${l.passportNumber} *',
                                passportError,
                                setSheet),
                            const SizedBox(height: 12),

                            _sheetDateField(
                                t,
                                sheetContext,
                                '${l.passportExpiry} *',
                                expiry,
                                (picked) => setSheet(() => expiry = picked),
                                isDOB: false),
                            if (showError && expiry == null)
                              Padding(
                                  padding:
                                      const EdgeInsets.only(left: 4, top: 4),
                                  child: Text(l.errorRequired,
                                      style: TextStyle(
                                          color: Colors.red.shade400,
                                          fontSize: 12))),
                            const SizedBox(height: 16),

                            Text(l.contactDetails,
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: t.title)),
                            const SizedBox(height: 12),

                            _validatedField(t, emailCtrl, '${l.email} *',
                                emailError, setSheet,
                                keyboardType: TextInputType.emailAddress),
                            const SizedBox(height: 12),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                PhoneCodeField(
                                  t: t,
                                  l: l,
                                  dialCode: countryCode,
                                  onSelected: (item) {
                                    setSheet(() => countryCode = item.dialCode);
                                  },
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _validatedField(
                                      t,
                                      phoneCtrl,
                                      '${l.mobileNumber} *',
                                      phoneError,
                                      setSheet,
                                      keyboardType: TextInputType.phone),
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
                            style: const TextStyle(
                                color: Colors.red, fontSize: 13),
                            textAlign: TextAlign.center),
                      ),
                    GestureDetector(
                      onTap: () {
                        final fErr = _validateName(firstNameCtrl.text);
                        final lErr = _validateName(lastNameCtrl.text);
                        final eErr = _validateEmail(emailCtrl.text);
                        final pErr = _validatePhone(phoneCtrl.text);
                        final nErr = (selectedNationality == null ||
                                selectedNationality!.isEmpty)
                            ? 'required'
                            : null;
                        final ppErr = _validatePassport(passportCtrl.text);

                        if (fErr != null ||
                            lErr != null ||
                            eErr != null ||
                            pErr != null ||
                            nErr != null ||
                            ppErr != null ||
                            gender == null ||
                            dob == null ||
                            expiry == null) {
                          setSheet(() {
                            showError = true;
                            firstNameError =
                                fErr != null ? _resolveError(fErr, l) : null;
                            lastNameError =
                                lErr != null ? _resolveError(lErr, l) : null;
                            emailError =
                                eErr != null ? _resolveError(eErr, l) : null;
                            phoneError =
                                pErr != null ? _resolveError(pErr, l) : null;
                            nationalityError =
                                nErr != null ? l.errorRequired : null;
                            passportError =
                                ppErr != null ? _resolveError(ppErr, l) : null;
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
                            'nationality': selectedNationality ?? '',
                            'passportNumber':
                                passportCtrl.text.trim().toUpperCase(),
                            'gender': gender,
                            'dateOfBirth': dob,
                            'passportExpiry': expiry,
                            'countryCode': countryCode,
                          };
                        });
                        Navigator.pop(sheetContext);
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: t.btnGradient),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(l.savePassenger(index + 1),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
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
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l.fillPassengerDetails)));
      return;
    }

    setState(() => isSubmitting = true);

    try {
      final requests = passengerList.map((p) {
        return http.post(
          Uri.parse('${Config.baseUrl}/api/flight-bookings'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
          body: json.encode({
            'fromCity': widget.fromCity,
            'toCity': widget.toCity,
            'departureDate': widget.departureDate.toIso8601String(),
            'returnDate': widget.returnDate?.toIso8601String(),
            'tripType': widget.tripType == 'One-way' ? l.oneWay : l.roundTrip,
            'fullName': '${p['firstName']} ${p['lastName']}',
            'dateOfBirth': (p['dateOfBirth'] as DateTime).toIso8601String(),
            'gender': p['gender'],
            'nationality': p['nationality'],
            'passportNumber': p['passportNumber'],
            'passportExpiry':
                (p['passportExpiry'] as DateTime).toIso8601String(),
            'email': p['email'],
            'phone': '${p['countryCode']}${p['phone']}',
            'promoCode': _appliedPromo,
            'totalPrice': discountedTotal,
          }),
        );
      }).toList();

      final results = await Future.wait(requests);
      final allSuccess =
          results.every((r) => r.statusCode == 200 || r.statusCode == 201);

      if (allSuccess) {
        if (_appliedPromo != null) {
          final prefs = await SharedPreferences.getInstance();
          final usedCodes = prefs.getStringList('usedPromoCodes') ?? [];
          usedCodes.add(_appliedPromo!);
          await prefs.setStringList('usedPromoCodes', usedCodes);
        }
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SuccessScreen(
              title: 'Flight Booked!',
              message:
                  'Your flight has been booked successfully.\nHave a great trip!',
              onContinue: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => HomeScreen()),
                (route) => false,
              ),
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l.someBookingsFailed)));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l.errorWithMessage('$e'))));
    }

    setState(() => isSubmitting = false);
  }

  Widget _validatedField(AppThemeExtension t, TextEditingController ctrl,
      String label, String? errorText, StateSetter setSheet,
      {TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: ctrl,
          keyboardType: keyboardType,
          onChanged: (_) => setSheet(() {}),
          style: TextStyle(color: t.title),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: t.label, fontSize: 14),
            filled: true,
            fillColor: t.field,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                    color: errorText != null
                        ? Colors.red.shade300
                        : t.fieldBorder)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                    color: errorText != null
                        ? Colors.red.shade300
                        : t.fieldBorder)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: t.accent, width: 1.5)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          ),
        ),
        if (errorText != null)
          Padding(
              padding: const EdgeInsets.only(left: 4, top: 4),
              child: Text(errorText,
                  style: TextStyle(color: Colors.red.shade400, fontSize: 12))),
      ],
    );
  }

  Widget _sheetDateField(AppThemeExtension t, BuildContext ctx, String label,
      DateTime? value, Function(DateTime) onPicked,
      {required bool isDOB}) {
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
          color: t.field,
          border: Border.all(color: t.fieldBorder),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
                value != null
                    ? _formatDate(
                        value, Localizations.localeOf(context).languageCode)
                    : label,
                style: TextStyle(
                    fontSize: 14, color: value != null ? t.title : t.label)),
            Icon(Icons.calendar_today_outlined, size: 18, color: t.label),
          ],
        ),
      ),
    );
  }

  String _formatDuration(String arabicDuration, String lang) {
    // Parse "7س 30د" format
    final regex = RegExp(r'(\d+)س\s*(\d+)د');
    final match = regex.firstMatch(arabicDuration);

    if (match == null) return arabicDuration; // fallback if format changes

    final hours = int.parse(match.group(1)!);
    final minutes = int.parse(match.group(2)!);

    if (lang == 'ar') {
      return '${hours}س ${minutes}د';
    }

    // English format
    if (minutes == 0) {
      return hours == 1 ? '$hours hour' : '$hours hours';
    }
    if (hours == 0) {
      return minutes == 1 ? '$minutes minute' : '$minutes minutes';
    }
    return '$hours h $minutes m';
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final t = Theme.of(context).extension<AppThemeExtension>()!;
    String lang = Localizations.localeOf(context).languageCode;

    return Scaffold(
      backgroundColor: t.bg,
      appBar: AppBar(
        title: Text(l.travellerDetails,
            style: TextStyle(
                fontWeight: FontWeight.w600, fontSize: 17, color: t.title)),
        backgroundColor: t.header,
        elevation: 0.5,
        shadowColor: t.divider,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: t.backIcon),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: passengerList.isEmpty
          ? Center(child: CircularProgressIndicator(color: t.accent))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Collapsible summary ───────────────────────────
                  GestureDetector(
                    onTap: () =>
                        setState(() => summaryExpanded = !summaryExpanded),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: t.card,
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(color: t.cardBorder.withOpacity(0.5)),
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
                                        '${lang == 'en' ? FlightTranslationService.translateCity(widget.fromCity) : widget.fromCity} ${lang == 'en' ? '→' : '←'} ${lang == 'en' ? FlightTranslationService.translateCity(widget.toCity) : widget.toCity}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: t.title)),
                                    const SizedBox(height: 4),
                                    Text(
                                        '${_appliedPromo != null ? discountedTotal.toStringAsFixed(2) : totalPrice} ${widget.currency}',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: t.price)),
                                  ]),
                              Row(children: [
                                Text(
                                    summaryExpanded
                                        ? l.hideSummaryFlight
                                        : l.viewSummaryFlight,
                                    style: TextStyle(
                                        fontSize: 13, color: t.accent)),
                                Icon(
                                    summaryExpanded
                                        ? Icons.keyboard_arrow_up
                                        : Icons.keyboard_arrow_down,
                                    color: t.accent),
                              ]),
                            ],
                          ),
                          if (summaryExpanded) ...[
                            const SizedBox(height: 14),
                            Divider(color: t.divider),
                            const SizedBox(height: 10),
                            _summaryRow(
                                t,
                                Icons.calendar_today_outlined,
                                l.departure,
                                _formatDate(widget.departureDate, lang)),
                            if (widget.returnDate != null)
                              _summaryRow(
                                  t,
                                  Icons.calendar_today_outlined,
                                  l.returnDate,
                                  _formatDate(widget.returnDate, lang)),
                            _summaryRow(t, Icons.airline_seat_recline_normal,
                                l.class_, widget.flightClass),
                            _summaryRow(
                              t,
                              Icons.swap_calls,
                              l.tripType,
                              widget.tripType == 'One-way'
                                  ? l.oneWay
                                  : l.roundTrip,
                            ),
                            _summaryRow(t, Icons.people_outline, l.passengers,
                                '${widget.passengers}'),
                            _summaryRow(
                                t, Icons.flight, l.airline, widget.airline),
                            _summaryRow(t, Icons.timer_outlined, l.duration,
                                _formatDuration(widget.duration, lang)),
                            _summaryRow(t, Icons.location_on_outlined, l.stops,
                                widget.stops),
                            Divider(color: t.divider),
                            const SizedBox(height: 10),
                            const SizedBox(height: 10),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(l.baseFare,
                                      style: TextStyle(
                                          color: t.label, fontSize: 13)),
                                  Text('${widget.price} ${widget.currency}',
                                      style: TextStyle(
                                          fontSize: 13, color: t.title)),
                                ]),
                            const SizedBox(height: 6),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(widget.flightClass,
                                      style: TextStyle(
                                          color: t.label, fontSize: 13)),
                                  Text(
                                      '× ${getClassMultiplier(widget.flightClass, l)}x',
                                      style: TextStyle(
                                          fontSize: 13, color: t.title)),
                                ]),
                            const SizedBox(height: 6),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      '${widget.passengers} ${widget.passengers == 1 ? l.passenger : l.passengers}',
                                      style: TextStyle(
                                          color: t.label, fontSize: 13)),
                                  Text(
                                      '× ${(widget.price * getClassMultiplier(widget.flightClass, l)).toStringAsFixed(2)} ${widget.currency}',
                                      style: TextStyle(
                                          fontSize: 13, color: t.title)),
                                ]),
                            if (_appliedPromo != null) ...[
                              const SizedBox(height: 6),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(l.discountWithCode(_appliedPromo!),
                                        style: const TextStyle(
                                            color: Colors.green, fontSize: 13)),
                                    Text(
                                        '−${_discountAmount.toStringAsFixed(2)} ${widget.currency}',
                                        style: const TextStyle(
                                            color: Colors.green, fontSize: 13)),
                                  ]),
                            ],
                            const SizedBox(height: 10),
                            Divider(color: t.divider),
                            const SizedBox(height: 10),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(l.total,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: t.title)),
                                  Text(
                                    '${_appliedPromo != null ? discountedTotal.toStringAsFixed(2) : totalPrice} ${widget.currency}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: t.price),
                                  ),
                                ]),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // ── Pay at pickup — framed as an advantage ──
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          t.accent.withOpacity(0.08),
                          t.accent.withOpacity(0.03)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: t.accent.withOpacity(0.2)),
                    ),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: t.accent.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(Icons.payments_outlined,
                                color: t.accent, size: 22),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                Text(l.flightsCashPaymentTitle,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: t.accent)),
                                const SizedBox(height: 4),
                                Text(l.flightsCashPaymentBody,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: t.sub,
                                        height: 1.5)),
                              ])),
                        ]),
                  ),

                  Text(l.travellerDetails,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: t.title)),
                  const SizedBox(height: 12),

                  // ── Passenger cards ───────────────────────────────
                  ...List.generate(passengerList.length, (i) {
                    final p = passengerList[i];
                    final filled = p['filled'] as bool;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: t.card,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: filled
                                ? t.accent.withOpacity(0.3)
                                : t.cardBorder.withOpacity(0.5)),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: filled ? t.accentLight : t.bg,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.person_outline,
                                  color: filled ? t.accent : t.label, size: 20),
                            ),
                            const SizedBox(width: 10),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      '${l.passenger} ${i + 1}${i == 0 ? ' (${l.you})' : ''}',
                                      style: TextStyle(
                                          fontSize: 15, color: t.title)),
                                  if (filled && p['firstName'].isNotEmpty)
                                    Text('${p['firstName']} ${p['lastName']}',
                                        style: TextStyle(
                                            fontSize: 12, color: t.label)),
                                ]),
                          ]),
                          GestureDetector(
                            onTap: () => _openPassengerSheet(i, l, t),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: filled ? t.accentLight : t.accent,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(filled ? Icons.edit : Icons.add,
                                      size: 16,
                                      color: filled ? t.accent : Colors.white),
                                  const SizedBox(width: 4),
                                  Text(filled ? l.edit : l.add,
                                      style: TextStyle(
                                          fontSize: 13,
                                          color:
                                              filled ? t.accent : Colors.white,
                                          fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),

                  // ── Payment Section ───────────────────────────────
                  // const SizedBox(height: 24),
                  // PaymentSection(key: _paymentKey),

                  // ── Promo Code ────────────────────────────────────
                  const SizedBox(height: 16),
                  _promoSection(l, t),

                  // ── Price breakdown (only when promo applied) ─────
                  if (_appliedPromo != null) ...[
                    const SizedBox(height: 12),
                    _priceBreakdown(l, t),
                  ],

                  const SizedBox(height: 24),

                  // ── Confirm button ────────────────────────────────
                  GestureDetector(
                    onTap: isSubmitting ? null : () => _submitBookings(l),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: t.btnGradient),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                              color: t.accent.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4))
                        ],
                      ),
                      child: isSubmitting
                          ? const Center(
                              child: CircularProgressIndicator(
                                  color: Colors.white))
                          : Text(
                              passengerList.length > 1
                                  ? l.confirmBookings(passengerList.length)
                                  : l.bookNow,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  Widget _summaryRow(
      AppThemeExtension t, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(children: [
        Icon(icon, size: 16, color: t.label),
        const SizedBox(width: 8),
        Text('$label: ', style: TextStyle(fontSize: 13, color: t.label)),
        Text(value,
            style: TextStyle(
                fontSize: 13, fontWeight: FontWeight.w500, color: t.title)),
      ]),
    );
  }
}
