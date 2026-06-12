import 'package:flutter/material.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import 'package:mobile_app/theme.dart';

class ConfirmationScreen extends StatelessWidget {
  final String title;
  final String message;
  final String? buttonLabel;
  final VoidCallback? onDone;

  const ConfirmationScreen({
    super.key,
    required this.title,
    required this.message,
    this.buttonLabel,
    this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<AppThemeExtension>()!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: t.bg,
      body: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  t.accentLight,
                  t.bg,
                  t.bg,
                ],
              ),
            ),
          ),
          Positioned(
            top: -80,
            left: -40,
            child: _GlowOrb(
              size: 220,
              color: t.accent.withOpacity(isDark ? 0.18 : 0.12),
            ),
          ),
          Positioned(
            top: 120,
            right: -50,
            child: _GlowOrb(
              size: 180,
              color: t.success.withOpacity(isDark ? 0.18 : 0.12),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
              child: Column(
                children: [
                  const Spacer(),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(24, 28, 24, 22),
                    decoration: BoxDecoration(
                      color: t.card,
                      borderRadius: BorderRadius.circular(34),
                      border: Border.all(color: t.cardBorder.withOpacity(0.35)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.32 : 0.08),
                          blurRadius: 30,
                          offset: const Offset(0, 18),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 92,
                          height: 92,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                t.success.withOpacity(0.92),
                                t.accent.withOpacity(0.82),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: t.success.withOpacity(0.24),
                                blurRadius: 26,
                                spreadRadius: 3,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Container(
                              width: 66,
                              height: 66,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(isDark ? 0.10 : 0.24),
                              ),
                              child: const Icon(
                                Icons.check_rounded,
                                size: 38,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: t.title,
                            fontSize: 30,
                            height: 1.05,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'DM Serif Display',
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          message,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: t.sub,
                            fontSize: 14,
                            height: 1.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 28),
                        SizedBox(
                          width: double.infinity,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: t.btnGradient),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: ElevatedButton(
                              onPressed: onDone ??
                                  () => Navigator.of(context)
                                      .popUntil((route) => route.isFirst),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: Colors.white,
                                shadowColor: Colors.transparent,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              child: Text(
                                buttonLabel ?? l.done,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  final double size;
  final Color color;

  const _GlowOrb({
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          boxShadow: [
            BoxShadow(
              color: color,
              blurRadius: 60,
              spreadRadius: 18,
            ),
          ],
        ),
      ),
    );
  }
}
