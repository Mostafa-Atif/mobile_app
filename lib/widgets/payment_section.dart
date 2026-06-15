import 'dart:convert';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app/config.dart';


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
