// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app/l10n/app_localizations.dart';
import 'package:mobile_app/providers/currency_provider.dart';
import 'package:mobile_app/screens/shared/success_screen.dart';
import 'package:mobile_app/screens/home/home_screen.dart';
import 'package:mobile_app/theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config.dart';

class HotelBooking extends StatefulWidget {
  final String hotelName;
  final DateTime checkIn;
  final DateTime checkOut;
  final int numRooms;
  final int numAdults;
  final int numChildren;
  final double pricePerNight;
  final int nights;

  const HotelBooking({
    super.key,
    required this.hotelName,
    required this.checkIn,
    required this.checkOut,
    required this.numRooms,
    required this.numAdults,
    required this.numChildren,
    required this.pricePerNight,
    required this.nights,
  });

  @override
  State<HotelBooking> createState() => _HotelBookingState();
}

class _HotelBookingState extends State<HotelBooking> {
  AppThemeExtension get _t => Theme.of(context).extension<AppThemeExtension>()!;

  bool isSubmitting = false;
  bool summaryExpanded = false;
  String token = '';
  List<Map<String, dynamic>> guestList = [];
  String? _appliedPromo;
  double _discountAmount = 0;
  String? _promoError;
  bool _promoLoading = false;
  final TextEditingController _promoCtrl = TextEditingController();
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _initGuests();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
  }

  int get numPeople => widget.numAdults + widget.numChildren;
  double get totalPrice =>
      widget.pricePerNight * widget.nights * widget.numRooms;
  double get discountedTotal => totalPrice - _discountAmount;

  // ── Promo code logic ───────────────────────────────────────────────────────

  static const Map<String, double> _promoCodes = {
    'RAHAL20': 0.20,
    'TEST10': 0.10,
    'TEST0': 0.10,
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
      _discountAmount = totalPrice * discount;
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

  Widget _promoSection(AppLocalizations l, AppThemeExtension t, bool isAr) {
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
                          Text('−${context.watch<CurrencyProvider>().format(_discountAmount, isAr: isAr)}',
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

  Widget _priceBreakdown(AppLocalizations l, AppThemeExtension t, bool isAr) {
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
          Text(context.watch<CurrencyProvider>().format(totalPrice, isAr: isAr),
              style: TextStyle(color: t.title, fontSize: 13)),
        ]),
        const SizedBox(height: 6),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(l.discountWithCode(_appliedPromo!),
              style: const TextStyle(color: Colors.green, fontSize: 13)),
          Text('−${context.watch<CurrencyProvider>().format(_discountAmount, isAr: isAr)}',
              style: const TextStyle(color: Colors.green, fontSize: 13)),
        ]),
        Divider(color: t.divider, height: 16),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Total',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 15, color: t.title)),
          Text(
              context
                  .watch<CurrencyProvider>()
                  .format(discountedTotal, isAr: isAr),
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 15, color: t.price)),
        ]),
      ]),
    );
  }

  Future<void> _initGuests() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';

    final List<Map<String, dynamic>> list = [
      {
        'filled': false,
        'name':
            '${prefs.getString('firstName') ?? ''} ${prefs.getString('lastName') ?? ''}'
                .trim(),
        'email': prefs.getString('email') ?? '',
        'phone': prefs.getString('phone') ?? '',
        'address': '',
      }
    ];

    for (int i = 1; i < numPeople; i++) {
      list.add({
        'filled': false,
        'name': '',
        'email': '',
        'phone': '',
        'address': '',
      });
    }

    setState(() => guestList = list);
  }

  String _formatDate(DateTime date) {
    final locale = Localizations.localeOf(context).languageCode;
    return DateFormat('d MMM y', locale).format(date);
  }

  String? _validateName(String val) {
    if (val.trim().isEmpty) return 'required';
    if (!RegExp(r'^[a-zA-Z\u0600-\u06FF\s]+$').hasMatch(val.trim()))
      return 'lettersOnly';
    return null;
  }

  String? _validateEmail(String val) {
    if (val.trim().isEmpty) return 'required';
    if (!RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$').hasMatch(val.trim())) {
      return 'validEmail';
    }
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
      case 'required':
        return l.errorRequired;
      case 'lettersOnly':
        return l.errorLettersOnly;
      case 'validEmail':
        return l.errorValidEmail;
      case 'validPhone':
        return l.errorValidPhone;
      default:
        return '';
    }
  }

  String _bookingErrorMessage(http.Response response, AppLocalizations l) {
    try {
      final body = json.decode(response.body);
      if (body is Map && body['message'] != null) {
        return body['message'].toString();
      }
    } catch (_) {}
    return l.bookingFailed;
  }

  void _openGuestSheet(int index, AppLocalizations l) {
    final g = Map<String, dynamic>.from(guestList[index]);
    final nameCtrl = TextEditingController(text: g['name']);
    final emailCtrl = TextEditingController(text: g['email']);
    final phoneCtrl = TextEditingController(text: g['phone']);
    final addressCtrl = TextEditingController(text: g['address']);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        String? nameError;
        String? emailError;
        String? phoneError;

        return StatefulBuilder(
          builder: (sheetContext, setSheet) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
                left: 12,
                right: 12,
                top: 12,
              ),
              child: Container(
                height: MediaQuery.of(sheetContext).size.height * 0.78,
                padding: EdgeInsets.fromLTRB(20, 16, 20, 20),
                decoration: BoxDecoration(
                  color: _t.bg,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 42,
                        height: 5,
                        decoration: BoxDecoration(
                          color: _t.label.withOpacity(0.35),
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                    SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '${l.guest} ${index + 1}${index == 0 ? ' (${l.you})' : ''}',
                            style: TextStyle(
                              color: _t.title,
                              fontSize: 26,
                              height: 1.05,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'DM Serif Display',
                            ),
                          ),
                        ),
                        _iconShell(
                          icon: Icons.close_rounded,
                          onTap: () => Navigator.pop(sheetContext),
                        ),
                      ],
                    ),
                    SizedBox(height: 18),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            _validatedField(nameCtrl, '${l.fullName} *',
                                nameError, setSheet),
                            SizedBox(height: 12),
                            _validatedField(
                              emailCtrl,
                              '${l.email} *',
                              emailError,
                              setSheet,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            SizedBox(height: 12),
                            _validatedField(
                              phoneCtrl,
                              '${l.phone} *',
                              phoneError,
                              setSheet,
                              keyboardType: TextInputType.phone,
                            ),
                            SizedBox(height: 12),
                            _field(addressCtrl, l.address),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: _t.btnGradient),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            final nErr = _validateName(nameCtrl.text);
                            final eErr = _validateEmail(emailCtrl.text);
                            final pErr = _validatePhone(phoneCtrl.text);

                            if (nErr != null || eErr != null || pErr != null) {
                              setSheet(() {
                                nameError = nErr != null
                                    ? _resolveError(nErr, l)
                                    : null;
                                emailError = eErr != null
                                    ? _resolveError(eErr, l)
                                    : null;
                                phoneError = pErr != null
                                    ? _resolveError(pErr, l)
                                    : null;
                              });
                              return;
                            }

                            setState(() {
                              guestList[index] = {
                                'filled': true,
                                'name': nameCtrl.text.trim(),
                                'email': emailCtrl.text.trim(),
                                'phone': phoneCtrl.text.trim(),
                                'address': addressCtrl.text.trim(),
                              };
                            });
                            Navigator.pop(sheetContext);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            shadowColor: Colors.transparent,
                            elevation: 0,
                            padding: EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: Text(
                            l.saveGuest(index + 1),
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w800),
                          ),
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

  Future<void> _submitBooking(AppLocalizations l) async {
    final unfilled = guestList.where((g) => !g['filled']).length;
    if (unfilled > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.fillGuestDetails)),
      );
      return;
    }

    setState(() => isSubmitting = true);

    try {
      final response = await http.post(
        Uri.parse('${Config.baseUrl}/api/hotels'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'hotelName': widget.hotelName,
          'checkInDate': widget.checkIn.toIso8601String(),
          'checkOutDate': widget.checkOut.toIso8601String(),
          'checkInTime': '15:00',
          'checkOutTime': '12:00',
          'numRooms': widget.numRooms,
          'numPeople': numPeople,
          'promoCode': _appliedPromo,
          'totalPrice': discountedTotal,
          'guests': guestList
              .map((g) => {
                    'name': g['name'],
                    'email': g['email'],
                    'phone': g['phone'],
                    'address': g['address'],
                  })
              .toList(),
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
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
              title: 'Booking Confirmed!',
              message:
                  'Your hotel has been booked successfully.\nEnjoy your stay!',
              onContinue: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => HomeScreen()),
                (route) => false,
              ),
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_bookingErrorMessage(response, l))),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.errorWithMessage('$e'))),
      );
    }

    setState(() => isSubmitting = false);
  }

  Widget _validatedField(
    TextEditingController ctrl,
    String label,
    String? errorText,
    StateSetter setSheet, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: ctrl,
          keyboardType: keyboardType,
          onChanged: (_) => setSheet(() {}),
          style: TextStyle(color: _t.title),
          decoration: _inputDecoration(label, errorText: errorText),
        ),
        if (errorText != null)
          Padding(
            padding: EdgeInsets.only(left: 4, top: 6),
            child: Text(
              errorText,
              style: TextStyle(
                color: AppColors.error,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Widget _field(
    TextEditingController ctrl,
    String label, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: ctrl,
      keyboardType: keyboardType,
      style: TextStyle(color: _t.title),
      decoration: _inputDecoration(label),
    );
  }

  InputDecoration _inputDecoration(String label, {String? errorText}) {
    final borderColor =
        errorText != null ? AppColors.error.withOpacity(0.5) : _t.fieldBorder;
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: _t.label,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
      filled: true,
      fillColor: _t.field,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: _t.accent, width: 1.4),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final t = Theme.of(context).extension<AppThemeExtension>()!;
    final bool isAr = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      backgroundColor: _t.bg,
      body: guestList.isEmpty
          ? Center(child: CircularProgressIndicator(color: _t.accent))
          : Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      expandedHeight: 170,
                      pinned: true,
                      elevation: 0,
                      backgroundColor: _t.bg,
                      surfaceTintColor: Colors.transparent,
                      leadingWidth: 72,
                      leading: Padding(
                        padding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
                        child: _iconShell(
                          icon: Icons.chevron_left_rounded,
                          onTap: () => Navigator.pop(context),
                        ),
                      ),
                      flexibleSpace: FlexibleSpaceBar(
                        background: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [_t.accentLight, _t.bg],
                            ),
                          ),
                          child: SafeArea(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(20, 28, 20, 24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    l.bookingDetails.toUpperCase(),
                                    style: TextStyle(
                                      color: _t.accent,
                                      fontSize: 10,
                                      letterSpacing: 2.4,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    l.guestDetails,
                                    style: TextStyle(
                                      color: _t.title,
                                      fontSize: 30,
                                      height: 1,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'DM Serif Display',
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    widget.hotelName,
                                    style: TextStyle(
                                      color: _t.label,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(16, 16, 16, 130),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSummaryCard(l, isAr),
                            SizedBox(height: 18),

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
                                border: Border.all(
                                    color: t.accent.withOpacity(0.2)),
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                          Text(l.hotelsCashPaymentTitle,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: t.accent)),
                                          const SizedBox(height: 4),
                                          Text(l.hotelsCashPaymentBody,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: t.sub,
                                                  height: 1.5)),
                                        ])),
                                  ]),
                            ),

                            _sectionHeader(
                              l.guestDetails,
                              '${guestList.length} ${l.guests.toLowerCase()}',
                            ),
                            SizedBox(height: 10),
                            ...List.generate(
                              guestList.length,
                              (i) => Padding(
                                padding: EdgeInsets.only(bottom: 12),
                                child: _buildGuestCard(i, l),
                              ),
                            ),
                            SizedBox(height: 18),
                            _promoSection(l, _t, isAr),
                            SizedBox(height: 12),
                            if (_appliedPromo != null) ...[
                              _priceBreakdown(l, _t, isAr),
                              SizedBox(height: 12),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                _buildBottomBar(l, isAr),
              ],
            ),
    );
  }

  Widget _buildSummaryCard(AppLocalizations l, bool isAr) {
    return Container(
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _t.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _t.cardBorder.withOpacity(0.45)),
        boxShadow: _cardShadows(),
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () => setState(() => summaryExpanded = !summaryExpanded),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.hotelName,
                        style: TextStyle(
                          color: _t.title,
                          fontSize: 24,
                          height: 1.05,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'DM Serif Display',
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        context.watch<CurrencyProvider>().format(
                            _appliedPromo != null
                                ? discountedTotal
                                : totalPrice.toDouble(),
                            isAr: isAr),
                        style: TextStyle(
                          color: _t.accent,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      summaryExpanded ? l.hideSummary : l.viewSummary,
                      style: TextStyle(
                        color: _t.accent,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 6),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: _t.accentLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        summaryExpanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        color: _t.accent,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (summaryExpanded) ...[
            SizedBox(height: 16),
            Divider(color: _t.divider.withOpacity(0.45)),
            SizedBox(height: 12),
            _summaryRow(Icons.calendar_today_outlined, l.checkInLabel,
                _formatDate(widget.checkIn)),
            _summaryRow(Icons.calendar_today_outlined, l.checkOutLabel,
                _formatDate(widget.checkOut)),
            _summaryRow(
                Icons.nights_stay_outlined, l.nightsLabel, '${widget.nights}'),
            _summaryRow(Icons.bed_outlined, l.roomsLabel, '${widget.numRooms}'),
            _summaryRow(Icons.people_outline, l.guestsLabel, '$numPeople'),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _t.accentLight,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _priceLine(
                      l.pricePerNight,
                      context
                          .watch<CurrencyProvider>()
                          .format(widget.pricePerNight.toDouble(), isAr: isAr)),
                  SizedBox(height: 8),
                  if (_appliedPromo != null) ...[
                    _priceLine(l.discountWithCode(_appliedPromo!),
                        '−${context.watch<CurrencyProvider>().format(_discountAmount, isAr: isAr)}',
                        color: Colors.green),
                    SizedBox(height: 8),
                  ],
                  _priceLine(
                      l.total,
                      context.watch<CurrencyProvider>().format(
                          _appliedPromo != null
                              ? discountedTotal
                              : totalPrice.toDouble(),
                          isAr: isAr),
                      strong: true),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildGuestCard(int index, AppLocalizations l) {
    final g = guestList[index];
    final filled = g['filled'] as bool;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _t.card,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: _t.cardBorder.withOpacity(0.45)),
        boxShadow: _cardShadows(),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: filled ? _t.accentLight : _t.field,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.person_outline_rounded,
              color: filled ? _t.accent : _t.title.withOpacity(0.7),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${l.guest} ${index + 1}${index == 0 ? ' (${l.you})' : ''}',
                  style: TextStyle(
                    color: _t.title,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  filled && (g['name'] as String).isNotEmpty
                      ? g['name']
                      : l.guestDetails,
                  style: TextStyle(
                    color: _t.label,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8),
          _pillButton(
            label: filled ? l.edit : l.add,
            filled: filled,
            icon: filled ? Icons.edit_outlined : Icons.add_rounded,
            onTap: () => _openGuestSheet(index, l),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(AppLocalizations l, bool isAr) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: EdgeInsets.fromLTRB(18, 14, 18, 26),
        decoration: BoxDecoration(
          color: _t.card.withOpacity(0.97),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          border:
              Border(top: BorderSide(color: _t.cardBorder.withOpacity(0.4))),
          boxShadow: _cardShadows(stronger: true),
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.watch<CurrencyProvider>().format(
                          _appliedPromo != null
                              ? discountedTotal
                              : totalPrice.toDouble(),
                          isAr: isAr),
                      style: TextStyle(
                        color: _t.title,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      l.totalNightsRooms(
                        context
                            .watch<CurrencyProvider>()
                            .format(totalPrice, isAr: isAr),
                        widget.nights,
                        widget.numRooms,
                      ),
                      style: TextStyle(
                        color: _t.label,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: _t.btnGradient),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: ElevatedButton(
                  onPressed: isSubmitting ? null : () => _submitBooking(l),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    disabledBackgroundColor: Colors.transparent,
                    disabledForegroundColor: Colors.white70,
                    foregroundColor: Colors.white,
                    shadowColor: Colors.transparent,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: isSubmitting
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          l.bookNow,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w800),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _summaryRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: _t.accentLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 15, color: _t.accent),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: _t.label,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: _t.title,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _priceLine(String label, String value,
      {bool strong = false, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: color ?? (strong ? _t.title : _t.label),
            fontSize: strong ? 14 : 12,
            fontWeight: strong ? FontWeight.w800 : FontWeight.w700,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: color ?? (strong ? _t.accent : _t.title),
            fontSize: strong ? 14 : 12,
            fontWeight: strong ? FontWeight.w900 : FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _sectionHeader(String title, String subtitle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: _t.title,
            fontSize: 20,
            fontWeight: FontWeight.w400,
            fontFamily: 'DM Serif Display',
          ),
        ),
        Text(
          subtitle,
          style: TextStyle(
            color: _t.accent,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _pillButton({
    required String label,
    required bool filled,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Ink(
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: filled ? _t.field : _t.accent,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: filled ? _t.cardBorder.withOpacity(0.45) : _t.accent,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: filled ? _t.title : Colors.white),
              SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: filled ? _t.title : Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconShell({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        onTap: onTap,
        child: Ink(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: _t.card.withOpacity(0.9),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _t.cardBorder.withOpacity(0.25)),
          ),
          child: Icon(icon, color: _t.backIcon, size: 24),
        ),
      ),
    );
  }

  List<BoxShadow> _cardShadows({bool stronger = false}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return [
      BoxShadow(
        color: isDark
            ? Colors.black.withOpacity(stronger ? 0.28 : 0.22)
            : _t.cardBorder.withOpacity(stronger ? 0.2 : 0.16),
        blurRadius: isDark ? (stronger ? 22 : 18) : (stronger ? 28 : 22),
        offset: Offset(0, stronger ? 12 : 10),
      ),
    ];
  }
}
