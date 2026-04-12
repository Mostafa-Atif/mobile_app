// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import 'package:mobile_app/screens/auth/sign_in.dart';
import 'package:mobile_app/screens/auth/sign_up.dart';
import 'package:mobile_app/screens/onboarding/onboarding_screen_1.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen3 extends StatelessWidget {
  const OnboardingScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return OnboardingPage(
      imagePath: 'images/onboarding/onboarding3.png',
      title: l.onboarding3Title,
      body: l.onboarding3Body,
      dotIndex: 2,
      onNext: () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('onboardingDone', true);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const SignUp()),
        );
      },
      nextLabel: l.signUp,
      onSecondary: () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('onboardingDone', true);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const SignIn()),
        );
      },
      secondaryLabel: l.signIn,
    );
  }
}
