// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mobile_app/Archive/test.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import 'package:mobile_app/providers/currency_provider.dart';
import 'package:mobile_app/screens/auth/sign_in.dart';
import 'package:mobile_app/screens/dashboards/admin_dashboard_screen.dart';
import 'package:mobile_app/screens/home/home_screen.dart';
import 'package:mobile_app/screens/onboarding/onboarding_screen_1.dart';
import 'package:mobile_app/services/flight_translation_service.dart';
import '../Archive/temp_home.dart';
import 'package:mobile_app/theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final bool onboardingDone = prefs.getBool('onboardingDone') ?? false;
  final String token = prefs.getString('token') ?? '';
  await FlightTranslationService.init();
  final bool isDark = prefs.getBool('isDark') ?? false;
  final String currency = prefs.getString('currency') ?? 'KWD';
  final String lang = prefs.getString('lang') ?? 'en';

  Widget startScreen;
  if (!onboardingDone) {
    startScreen = const TempHome();
  } else if (token.isNotEmpty) {
    startScreen = const TempHome();
  } else {
    startScreen = const TempHome();
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider(isDark)),
        ChangeNotifierProvider(create: (_) => CurrencyProvider(currency)),
      ],
      child: MyApp(startScreen: startScreen, initialLang: lang),
    ),
  );
}

class MyApp extends StatefulWidget {
  final Widget startScreen;
  final String initialLang;
  const MyApp({super.key, required this.startScreen, required this.initialLang});

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    _locale = Locale(widget.initialLang);
  }

  void setLocale(Locale locale) async {
    setState(() => _locale = locale);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lang', locale.languageCode);
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
