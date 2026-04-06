// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/screens/auth/sign_in.dart';
import 'package:mobile_app/screens/auth/sign_up.dart';
import 'package:mobile_app/screens/car%20rent/carssearch.dart';
import 'package:mobile_app/screens/flights/flightsearch.dart';
import 'package:mobile_app/screens/hotels/hotel_search.dart';
import 'package:mobile_app/screens/onboarding/onboarding_screen_1.dart';
import 'package:mobile_app/screens/temp_home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/onboarding/onboarding_screen_1.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final bool onboardingDone = prefs.getBool('onboardingDone') ?? false;
  final String token = prefs.getString('token') ?? '';

  Widget startScreen;
  if (!onboardingDone) {
    startScreen = const OnboardingScreen1();
  } else if (token.isNotEmpty) {
    startScreen = const TempHome();
  } else {
    startScreen = const SignIn();
  }

  runApp(MyApp(startScreen: startScreen));
}

class MyApp extends StatefulWidget {
  final Widget startScreen;
  const MyApp({Key? key, required this.startScreen}) : super(key: key);

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
      theme: ThemeData(
        textTheme: GoogleFonts.dmSansTextTheme(),
      ),
      home: widget.startScreen,
    );
  }
}