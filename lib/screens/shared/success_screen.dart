import 'package:flutter/material.dart';
import 'package:mobile_app/theme.dart';

class SuccessScreen extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onContinue;

  const SuccessScreen({
    super.key,
    this.title = 'Success!',
    this.message = 'Your request has been completed.\nEverything is set!',
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<AppThemeExtension>()!;

    return Scaffold(
      backgroundColor: t.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                width: 88, height: 88,
                decoration: BoxDecoration(color: t.successBg, shape: BoxShape.circle),
                child: Icon(Icons.check_rounded, color: t.success, size: 48),
              ),
              const SizedBox(height: 28),
              Text(title, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: t.title)),
              const SizedBox(height: 12),
              Text(message, textAlign: TextAlign.center, style: TextStyle(fontSize: 15, color: t.label, height: 1.6)),
              const Spacer(),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: t.btnGradient),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: t.accent.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))],
                ),
                child: ElevatedButton(
                  onPressed: onContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: const Text('Continue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}