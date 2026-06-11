import 'package:flutter/material.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import 'package:mobile_app/theme.dart';
import 'onboarding_screen_2.dart';

class OnboardingScreen1 extends StatelessWidget {
  const OnboardingScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return OnboardingPage(
      imagePath: 'assets/images/onboarding/onboarding1.png',
      title:     l.onboarding1Title,
      body:      l.onboarding1Body,
      dotIndex:  0,
      onNext: () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingScreen2()),
      ),
      nextLabel:      l.next,
      // secondaryLabel: l.skip,
      onSecondary: () {
        // navigate to sign-in / home as needed
      },
    );
  }
}

// ── Reusable OnboardingPage ───────────────────────────────────────────────────

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({
    super.key,
    required this.imagePath,
    required this.title,
    required this.body,
    required this.dotIndex,
    required this.onNext,
    required this.nextLabel,
    this.onSecondary,
    this.secondaryLabel,
    this.totalDots = 3,
  });

  final String        imagePath;
  final String        title;
  final String        body;
  final int           dotIndex;
  final int           totalDots;
  final VoidCallback  onNext;
  final String        nextLabel;
  final VoidCallback? onSecondary;
  final String?       secondaryLabel;

  @override
  Widget build(BuildContext context) {
    final t          = Theme.of(context).extension<AppThemeExtension>()!;
    final isAr       = Localizations.localeOf(context).languageCode == 'ar';
    final h          = MediaQuery.sizeOf(context).height;
    final compact    = h < 760;
    final hasSkip    = onSecondary != null && secondaryLabel != null;

    return Scaffold(
      backgroundColor: t.bg,
      body: Directionality(
        textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
        child: Column(
          children: [
            // ── Image zone ─────────────────────────────────────────────────
            Expanded(
              flex: 5,
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    20, compact ? 16 : 22, 20, compact ? 12 : 16,
                  ),
                  child: _ImageCard(imagePath: imagePath, t: t),
                ),
              ),
            ),

            // ── Content zone ───────────────────────────────────────────────
            Expanded(
              flex: 4,
              child: _BottomSheet(
                title:          title,
                body:           body,
                dotIndex:       dotIndex,
                totalDots:      totalDots,
                nextLabel:      nextLabel,
                onNext:         onNext,
                hasSkip:        hasSkip,
                secondaryLabel: secondaryLabel,
                onSecondary:    onSecondary,
                isAr:           isAr,
                compact:        compact,
                t:              t,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Image Card ────────────────────────────────────────────────────────────────

class _ImageCard extends StatelessWidget {
  const _ImageCard({required this.imagePath, required this.t});

  final String            imagePath;
  final AppThemeExtension t;

  @override
  Widget build(BuildContext context) {
    return Container(
      width:  double.infinity,
      decoration: BoxDecoration(
        color:        t.card,
        borderRadius: BorderRadius.circular(28),
        border:       Border.all(color: t.cardBorder.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color:      t.cardBorder.withOpacity(0.14),
            blurRadius: 20,
            offset:     const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Image.asset(imagePath, fit: BoxFit.contain),
    );
  }
}

// ── Bottom Sheet panel ────────────────────────────────────────────────────────

class _BottomSheet extends StatelessWidget {
  const _BottomSheet({
    required this.title,
    required this.body,
    required this.dotIndex,
    required this.totalDots,
    required this.nextLabel,
    required this.onNext,
    required this.hasSkip,
    required this.isAr,
    required this.compact,
    required this.t,
    this.secondaryLabel,
    this.onSecondary,
  });

  final String            title;
  final String            body;
  final int               dotIndex;
  final int               totalDots;
  final String            nextLabel;
  final VoidCallback      onNext;
  final bool              hasSkip;
  final String?           secondaryLabel;
  final VoidCallback?     onSecondary;
  final bool              isAr;
  final bool              compact;
  final AppThemeExtension t;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        22, compact ? 20 : 26, 22, compact ? 18 : 28,
      ),
      decoration: BoxDecoration(
        color: t.card,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(
          top: BorderSide(color: t.cardBorder.withOpacity(0.5)),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Dots
          _DotIndicator(
            dotIndex:  dotIndex,
            totalDots: totalDots,
            isAr:      isAr,
            t:         t,
          ),
          SizedBox(height: compact ? 14 : 20),

          // Title
          Text(
            title,
            textAlign: isAr ? TextAlign.right : TextAlign.left,
            style: TextStyle(
              fontSize:   compact ? 24.0 : 28.0,
              fontWeight: FontWeight.w900,
              color:      t.title,
              height:     1.1,
            ),
          ),
          SizedBox(height: compact ? 8 : 10),

          // Body
          Text(
            body,
            textAlign: isAr ? TextAlign.right : TextAlign.left,
            style: TextStyle(
              fontSize:   compact ? 13.5 : 14.5,
              color:      t.sub,
              fontWeight: FontWeight.w600,
              height:     1.55,
            ),
          ),

          const Spacer(),

          // Primary button
          SizedBox(
            width:  double.infinity,
            height: compact ? 50.0 : 54.0,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin:  Alignment.topLeft,
                  end:    Alignment.bottomRight,
                  colors: t.btnGradient,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: ElevatedButton(
                onPressed: onNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor:     Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  nextLabel,
                  style: TextStyle(
                    color:         Colors.white,
                    fontSize:      compact ? 14.5 : 15.5,
                    fontWeight:    FontWeight.w800,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ),
          ),

          // Secondary / skip button
          if (hasSkip) ...[
            SizedBox(height: compact ? 2 : 4),
            Center(
              child: TextButton(
                onPressed: onSecondary,
                style: TextButton.styleFrom(
                  foregroundColor: t.accent,
                  padding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical:   compact ? 4 : 8,
                  ),
                ),
                child: Text(
                  secondaryLabel!,
                  style: TextStyle(
                    fontSize:   compact ? 12.5 : 13.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Dot Indicator ─────────────────────────────────────────────────────────────

class _DotIndicator extends StatelessWidget {
  const _DotIndicator({
    required this.dotIndex,
    required this.totalDots,
    required this.isAr,
    required this.t,
  });

  final int               dotIndex;
  final int               totalDots;
  final bool              isAr;
  final AppThemeExtension t;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isAr ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: List.generate(totalDots, (i) {
        final active = i == dotIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          curve:    Curves.easeInOut,
          margin:   const EdgeInsetsDirectional.only(end: 6),
          width:    active ? 22 : 7,
          height:   7,
          decoration: BoxDecoration(
            color:        active
                ? t.accent
                : t.fieldBorder.withOpacity(0.45),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}