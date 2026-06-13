import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app/config.dart';
// import 'package:mobile_app/l10n/app_localizations.dart';
// import 'package:mobile_app/theme.dart';



Future<void> pay(int amount) async {
  Stripe.publishableKey = 'pk_test_51ThYmaEJd6SsMZnj5VoFLlSyCoB3jTjgC6oOblHzdEqW2GsGRj3fKZvnv005jwUh8ILcL4lYAuCkCOdqn37FQK5K0095ehkKgq';
  await Stripe.instance.applySettings();
  // 1. Get client secret from your backend
  final response = await http.post(
    Uri.parse('${Config.baseUrl}/api/payments/create-payment-intent'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'amount': amount}),
  );

  final clientSecret = jsonDecode(response.body)['clientSecret'];

  // 2. Show Stripe payment sheet
  await Stripe.instance.initPaymentSheet(
    paymentSheetParameters: SetupPaymentSheetParameters(
      paymentIntentClientSecret: clientSecret,
      merchantDisplayName: 'Your App Name',
    ),
  );

  await Stripe.instance.presentPaymentSheet();
}



// class PaymentSection extends StatefulWidget {
//   const PaymentSection({super.key});

//   @override
//   State<PaymentSection> createState() => PaymentSectionState();
// }

// class PaymentSectionState extends State<PaymentSection> {
//   AppThemeExtension get _t => Theme.of(context).extension<AppThemeExtension>()!;

//   final _formKey = GlobalKey<FormState>();

//   final _cardNumberController  = TextEditingController();
//   final _cardholderController  = TextEditingController();
//   final _expiryController      = TextEditingController();
//   final _cvvController         = TextEditingController();

//   bool _isCredit   = true;
//   bool _obscureCvv = true;

//   bool validate() => _formKey.currentState?.validate() ?? false;

//   // Detected card network from first digits
//   _CardNetwork _network = _CardNetwork.unknown;



//   @override
//   void dispose() {
//     _cardNumberController.dispose();
//     _cardholderController.dispose();
//     _expiryController.dispose();
//     _cvvController.dispose();
//     super.dispose();
//   }

//   void _detectNetwork(String value) {
//     final raw = value.replaceAll(' ', '');
//     _CardNetwork detected;
//     if (raw.startsWith('4')) {
//       detected = _CardNetwork.visa;
//     } else if (raw.startsWith('5') || raw.startsWith('2')) {
//       detected = _CardNetwork.mastercard;
//     } else if (raw.startsWith('3')) {
//       detected = _CardNetwork.amex;
//     } else {
//       detected = _CardNetwork.unknown;
//     }
//     if (detected != _network) setState(() => _network = detected);
//   }

//   String? _validateCardNumber(String? value) {
//     final l = AppLocalizations.of(context)!;
//     final raw = (value ?? '').replaceAll(' ', '');
//     if (raw.isEmpty) return l.paymentErrorCardNumberRequired;
//     final expectedLength = _network == _CardNetwork.amex ? 15 : 16;
//     if (raw.length != expectedLength) return l.paymentErrorCardNumberInvalid;
//     if (!_luhn(raw)) return l.paymentErrorCardNumberInvalid;
//     return null;
//   }

//   String? _validateCardholder(String? value) {
//     final l = AppLocalizations.of(context)!;
//     final v = (value ?? '').trim();
//     if (v.isEmpty) return l.paymentErrorCardholderRequired;
//     if (v.length < 2) return l.paymentErrorCardholderInvalid;
//     // Only allow letters (A-Z after auto-uppercase) and spaces
//     if (!RegExp(r'^[A-Z\s]+$').hasMatch(v)) return l.paymentErrorCardholderInvalid;
//     return null;
//   }

//   String? _validateExpiry(String? value) {
//     final l = AppLocalizations.of(context)!;
//     final raw = (value ?? '').replaceAll(' ', '').replaceAll('/', '');
//     if (raw.length != 4) return l.paymentErrorExpiryRequired;
//     final month = int.tryParse(raw.substring(0, 2));
//     final year  = int.tryParse('20${raw.substring(2)}');
//     if (month == null || year == null || month < 1 || month > 12) {
//       return l.paymentErrorExpiryInvalid;
//     }
//     final now = DateTime.now();
//     final expiry = DateTime(year, month + 1);
//     if (expiry.isBefore(now)) return l.paymentErrorExpiryExpired;
//     return null;
//   }

//   String? _validateCvv(String? value) {
//     final l = AppLocalizations.of(context)!;
//     final raw = (value ?? '').trim();
//     final expected = _network == _CardNetwork.amex ? 4 : 3;
//     if (raw.isEmpty) return l.paymentErrorCvvRequired;
//     if (raw.length != expected) return l.paymentErrorCvvInvalid;
//     return null;
//   }

//   bool _luhn(String number) {
//     int sum = 0;
//     bool alternate = false;
//     for (int i = number.length - 1; i >= 0; i--) {
//       int n = int.parse(number[i]);
//       if (alternate) {
//         n *= 2;
//         if (n > 9) n -= 9;
//       }
//       sum += n;
//       alternate = !alternate;
//     }
//     return sum % 10 == 0;
//   }







//   @override
//   Widget build(BuildContext context) {
//     final l      = AppLocalizations.of(context)!;
//     final t      = _t;
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16),
//       decoration: BoxDecoration(
//         color: t.card,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: t.cardBorder),
//       ),
//       padding: const EdgeInsets.all(20),
//       child: Form(
//         key: _formKey,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [

//             // ── Section title ──────────────────────────────────────
//             Text(
//               l.paymentTitle,
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w700,
//                 color: t.title,
//               ),
//             ),
//             const SizedBox(height: 16),

//             // ── Credit / Debit toggle ──────────────────────────────
//             Row(
//               children: [
//                 _CardTypeButton(
//                   label: l.paymentCreditCard,
//                   icon: Icons.credit_card_rounded,
//                   selected: _isCredit,
//                   t: t,
//                   onTap: () => setState(() => _isCredit = true),
//                 ),
//                 const SizedBox(width: 10),
//                 _CardTypeButton(
//                   label: l.paymentDebitCard,
//                   icon: Icons.credit_card_outlined,
//                   selected: !_isCredit,
//                   t: t,
//                   onTap: () => setState(() => _isCredit = false),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),

//             // ── Accepted networks ──────────────────────────────────
//             Row(
//               children: [
//                 _NetworkBadge(label: 'VISA',  highlight: _network == _CardNetwork.visa,       t: t),
//                 const SizedBox(width: 8),
//                 _NetworkBadge(label: 'MC',    highlight: _network == _CardNetwork.mastercard, t: t),
//                 const SizedBox(width: 8),
//                 _NetworkBadge(label: 'AMEX',  highlight: _network == _CardNetwork.amex,       t: t),
//               ],
//             ),
//             const SizedBox(height: 20),

//             // ── Card number — always LTR ───────────────────────────
//             _FieldLabel(label: l.paymentCardNumber, t: t),
//             const SizedBox(height: 6),
//             Directionality(
//               textDirection: TextDirection.ltr,
//               child: TextFormField(
//                 controller: _cardNumberController,
//                 keyboardType: TextInputType.number,
//                 inputFormatters: [_CardNumberFormatter()],
//                 style: TextStyle(color: t.title, fontSize: 15, letterSpacing: 1.5),
//                 decoration: _inputDecoration(
//                   hint: '0000  0000  0000  0000',
//                   t: t,
//                   isDark: isDark,
//                   suffix: _network != _CardNetwork.unknown
//                       ? Icon(Icons.check_circle_rounded, color: t.success, size: 18)
//                       : null,
//                 ),
//                 onChanged: _detectNetwork,
//                 validator: _validateCardNumber,
//               ),
//             ),
//             const SizedBox(height: 14),

//             // ── Cardholder name — always LTR, always UPPERCASE ─────
//             _FieldLabel(label: l.paymentCardholderName, t: t),
//             const SizedBox(height: 6),
//             Directionality(
//               textDirection: TextDirection.ltr,
//               child: TextFormField(
//                 controller: _cardholderController,
//                 keyboardType: TextInputType.name,
//                 // Force uppercase on the keyboard level where supported
//                 textCapitalization: TextCapitalization.characters,
//                 inputFormatters: [
//                   // Strip anything that isn't a letter or space
//                   FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
//                   // Hard cap at 26 characters (standard card name length)
//                   LengthLimitingTextInputFormatter(26),
//                   // Convert to uppercase as the user types
//                   _UpperCaseFormatter(),
//                 ],
//                 style: TextStyle(color: t.title, fontSize: 15, letterSpacing: 1.0),
//                 decoration: _inputDecoration(
//                   hint: l.paymentCardholderHint,
//                   t: t,
//                   isDark: isDark,
//                 ),
//                 validator: _validateCardholder,
//               ),
//             ),
//             const SizedBox(height: 14),

//             // ── Expiry + CVV — always LTR ──────────────────────────
//             Row(
//               children: [
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _FieldLabel(label: l.paymentExpiry, t: t),
//                       const SizedBox(height: 6),
//                       Directionality(
//                         textDirection: TextDirection.ltr,
//                         child: TextFormField(
//                           controller: _expiryController,
//                           keyboardType: TextInputType.number,
//                           inputFormatters: [_ExpiryFormatter()],
//                           style: TextStyle(color: t.title, fontSize: 15),
//                           decoration: _inputDecoration(
//                             hint: 'MM / YY',
//                             t: t,
//                             isDark: isDark,
//                           ),
//                           validator: _validateExpiry,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _FieldLabel(label: l.paymentCvv, t: t),
//                       const SizedBox(height: 6),
//                       Directionality(
//                         textDirection: TextDirection.ltr,
//                         child: TextFormField(
//                           controller: _cvvController,
//                           keyboardType: TextInputType.number,
//                           obscureText: _obscureCvv,
//                           inputFormatters: [
//                             FilteringTextInputFormatter.digitsOnly,
//                             LengthLimitingTextInputFormatter(
//                               _network == _CardNetwork.amex ? 4 : 3,
//                             ),
//                           ],
//                           style: TextStyle(color: t.title, fontSize: 15),
//                           decoration: _inputDecoration(
//                             hint: _network == _CardNetwork.amex ? '••••' : '•••',
//                             t: t,
//                             isDark: isDark,
//                             suffix: GestureDetector(
//                               onTap: () => setState(() => _obscureCvv = !_obscureCvv),
//                               child: Icon(
//                                 _obscureCvv ? Icons.visibility_off_outlined : Icons.visibility_outlined,
//                                 size: 18,
//                                 color: t.label,
//                               ),
//                             ),
//                           ),
//                           validator: _validateCvv,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),

//             // ── Secure note ────────────────────────────────────────
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//               decoration: BoxDecoration(
//                 color: t.accentLight,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Row(
//                 children: [
//                   Icon(Icons.lock_rounded, size: 14, color: t.accent),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: Text(
//                       l.paymentSecureNote,
//                       style: TextStyle(fontSize: 12, color: t.sub),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   InputDecoration _inputDecoration({
//     required String hint,
//     required AppThemeExtension t,
//     required bool isDark,
//     Widget? suffix,
//   }) {
//     return InputDecoration(
//       hintText: hint,
//       hintStyle: TextStyle(color: t.label, fontSize: 14),
//       suffixIcon: suffix != null ? Padding(padding: const EdgeInsets.only(right: 12), child: suffix) : null,
//       suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
//       filled: true,
//       fillColor: t.field,
//       contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: BorderSide(color: t.fieldBorder),
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: BorderSide(color: t.fieldBorder),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: BorderSide(color: t.accent, width: 1.5),
//       ),
//       errorBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: BorderSide(color: t.danger),
//       ),
//       focusedErrorBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: BorderSide(color: t.danger, width: 1.5),
//       ),
//       errorStyle: TextStyle(color: t.danger, fontSize: 11),
//     );
//   }
// }

// // ── Sub-widgets ───────────────────────────────────────────────────────────────

// class _CardTypeButton extends StatelessWidget {
//   final String label;
//   final IconData icon;
//   final bool selected;
//   final AppThemeExtension t;
//   final VoidCallback onTap;

//   const _CardTypeButton({
//     required this.label,
//     required this.icon,
//     required this.selected,
//     required this.t,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: GestureDetector(
//         onTap: onTap,
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 150),
//           padding: const EdgeInsets.symmetric(vertical: 10),
//           decoration: BoxDecoration(
//             color: selected ? t.accentLight : t.field,
//             borderRadius: BorderRadius.circular(14),
//             border: Border.all(
//               color: selected ? t.accent : t.fieldBorder,
//               width: selected ? 1.5 : 1,
//             ),
//           ),
//           child: Column(
//             children: [
//               Icon(icon, size: 22, color: selected ? t.accent : t.label),
//               const SizedBox(height: 4),
//               Text(
//                 label,
//                 style: TextStyle(
//                   fontSize: 12,
//                   fontWeight: FontWeight.w500,
//                   color: selected ? t.accent : t.label,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _NetworkBadge extends StatelessWidget {
//   final String label;
//   final bool highlight;
//   final AppThemeExtension t;

//   const _NetworkBadge({
//     required this.label,
//     required this.highlight,
//     required this.t,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 150),
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//       decoration: BoxDecoration(
//         color: highlight ? t.accentLight : t.field,
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(
//           color: highlight ? t.accent : t.fieldBorder,
//           width: highlight ? 1.5 : 1,
//         ),
//       ),
//       child: Text(
//         label,
//         style: TextStyle(
//           fontSize: 11,
//           fontWeight: FontWeight.w700,
//           color: highlight ? t.accent : t.label,
//         ),
//       ),
//     );
//   }
// }

// class _FieldLabel extends StatelessWidget {
//   final String label;
//   final AppThemeExtension t;

//   const _FieldLabel({required this.label, required this.t});

//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       label.toUpperCase(),
//       style: TextStyle(
//         fontSize: 11,
//         fontWeight: FontWeight.w600,
//         color: t.label,
//         letterSpacing: 0.5,
//       ),
//     );
//   }
// }

// // ── Input formatters ──────────────────────────────────────────────────────────

// class _UpperCaseFormatter extends TextInputFormatter {
//   @override
//   TextEditingValue formatEditUpdate(TextEditingValue old, TextEditingValue next) {
//     return next.copyWith(text: next.text.toUpperCase());
//   }
// }

// class _CardNumberFormatter extends TextInputFormatter {
//   @override
//   TextEditingValue formatEditUpdate(TextEditingValue old, TextEditingValue next) {
//     final digits = next.text.replaceAll(RegExp(r'\D'), '');
//     final capped  = digits.length > 16 ? digits.substring(0, 16) : digits;
//     final buffer  = StringBuffer();
//     for (int i = 0; i < capped.length; i++) {
//       if (i > 0 && i % 4 == 0) buffer.write('  ');
//       buffer.write(capped[i]);
//     }
//     final str = buffer.toString();
//     return TextEditingValue(
//       text: str,
//       selection: TextSelection.collapsed(offset: str.length),
//     );
//   }
// }

// class _ExpiryFormatter extends TextInputFormatter {
//   @override
//   TextEditingValue formatEditUpdate(TextEditingValue old, TextEditingValue next) {
//     final digits = next.text.replaceAll(RegExp(r'\D'), '');
//     final capped  = digits.length > 4 ? digits.substring(0, 4) : digits;

//     // Cap month to 01–12 as user types
//     String result = capped;
//     if (capped.length >= 2) {
//       final month = int.tryParse(capped.substring(0, 2)) ?? 0;
//       final clampedMonth = month.clamp(1, 12).toString().padLeft(2, '0');
//       result = clampedMonth + capped.substring(2);
//     } else if (capped.length == 1) {
//       final first = int.tryParse(capped) ?? 0;
//       result = first > 1 ? '0$capped' : capped;
//     }

//     final str = result.length >= 3
//         ? '${result.substring(0, 2)} / ${result.substring(2)}'
//         : result;

//     return TextEditingValue(
//       text: str,
//       selection: TextSelection.collapsed(offset: str.length),
//     );
//   }
// }

// // ── Card network enum ─────────────────────────────────────────────────────────

// enum _CardNetwork { unknown, visa, mastercard, amex }