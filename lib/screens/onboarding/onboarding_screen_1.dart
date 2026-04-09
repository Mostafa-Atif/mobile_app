// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import 'onboarding_screen_2.dart';

class OnboardingScreen1 extends StatelessWidget {
  const OnboardingScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return OnboardingPage(
      imagePath: 'images/onboarding/onboarding1.png',
      title: l.onboarding1Title,
      body: l.onboarding1Body,
      dotIndex: 0,
      onNext: () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingScreen2()),
      ),
      nextLabel: l.next,
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String body;
  final int dotIndex;
  final VoidCallback onNext;
  final String nextLabel;

  const OnboardingPage({super.key, 
    required this.imagePath,
    required this.title,
    required this.body,
    required this.dotIndex,
    required this.onNext,
    required this.nextLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Image section
            Expanded(
              flex: 5,
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Image.asset(imagePath, fit: BoxFit.contain),
              ),
            ),

            // Content section
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(28, 32, 28, 28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 20,
                      offset: Offset(0, -4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Dots
                    Row(
                      children: List.generate(3, (i) => Container(
                        margin: EdgeInsets.only(right: 6),
                        width: i == dotIndex ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: i == dotIndex ? Color(0xFF1f93a0) : Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      )),
                    ),
                    SizedBox(height: 20),

                    Text(title,
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            height: 1.2)),
                    SizedBox(height: 12),
                    Text(body,
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[600],
                            height: 1.6)),
                    Spacer(),

                    // Next button
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: onNext,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF1f93a0),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                        ),
                        child: Text(nextLabel,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}