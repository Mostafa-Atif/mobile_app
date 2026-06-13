// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import 'package:mobile_app/screens/auth/sign_in.dart';
import 'package:mobile_app/screens/home/admin_dashboard_screen.dart';
import 'package:mobile_app/screens/home/home_screen.dart';
import 'package:mobile_app/screens/onboarding/onboarding_screen_1.dart';
import '../Archive/temp_home.dart';
import 'package:mobile_app/theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final bool onboardingDone = prefs.getBool('onboardingDone') ?? false;
  final String token = prefs.getString('token') ?? '';

  Widget startScreen;
  if (!onboardingDone) {
    startScreen = const TempHome();
  } else if (token.isNotEmpty) {
    startScreen = const TempHome();
  } else {
    startScreen = const TempHome();
  }


  // Stripe.publishableKey = 'pk_test_51ThYmaEJd6SsMZnj5VoFLlSyCoB3jTjgC6oOblHzdEqW2GsGRj3fKZvnv005jwUh8ILcL4lYAuCkCOdqn37FQK5K0095ehkKgq';
  // await Stripe.instance.applySettings();


  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: MyApp(startScreen: startScreen),
    ),
  );
}

class MyApp extends StatefulWidget {
  final Widget startScreen;
  const MyApp({super.key, required this.startScreen});

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en');

  void setLocale(Locale locale) {
    setState(() => _locale = locale);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    return MaterialApp(
      title: 'Rahal',
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'),
        const Locale('ar'),
      ],
      locale: _locale,
      debugShowCheckedModeBanner: false,
      theme: lightTheme(),
      darkTheme: darkTheme(),
      themeMode: themeProvider.mode,
      home: widget.startScreen,
    );
  }
}
