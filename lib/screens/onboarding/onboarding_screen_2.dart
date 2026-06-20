// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import 'package:mobile_app/screens/onboarding/onboarding_screen_1.dart';
import 'onboarding_screen_3.dart';

class OnboardingScreen2 extends StatelessWidget {
  const OnboardingScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return OnboardingPage(
      imagePath: 'assets/images/onboarding/onboarding2.png',
      title: l.onboarding2Title,
      body: l.onboarding2Body,
      dotIndex: 1,
      onNext: () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingScreen3()),
      ),
      nextLabel: l.next,
    );
  }
}
