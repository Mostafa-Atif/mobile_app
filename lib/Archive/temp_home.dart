import 'package:flutter/material.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../main.dart';
import '../theme.dart';
import '../screens/auth/sign_in.dart';
import '../screens/auth/sign_up.dart';
import '../screens/car rental/carssearch.dart';
import '../screens/flights/flightsearch.dart';
import '../screens/hotels/hotel_search.dart';
import '../screens/home/admin_dashboard_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/home/user_dashboard_screen.dart';
import '../screens/onboarding/onboarding_screen_1.dart';
import 'package:provider/provider.dart';

class TempHome extends StatelessWidget {
  const TempHome({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final t = Theme.of(context).extension<AppThemeExtension>()!;
    final isDark = context.watch<ThemeProvider>().isDark;

    return Scaffold(
      backgroundColor: t.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Text(
                        l.appTitle,
                        style: TextStyle(
                          color: t.accent,
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                        ),
                      ),
                      Text(
                        l.devMenu,
                        style: TextStyle(color: t.label, fontSize: 13),
                      ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Row(
                    children: [
                      // Dark mode toggle
                      GestureDetector(
                        onTap: () => context.read<ThemeProvider>().toggle(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: t.accentLight,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: t.cardBorder),
                          ),
                          child: Icon(
                            isDark ? Icons.light_mode : Icons.dark_mode,
                            color: t.accent,
                            size: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Language toggle
                      GestureDetector(
                        onTap: () {
                          final next = isAr ? const Locale('en') : const Locale('ar');
                          MyApp.setLocale(context, next);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: t.accentLight,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: t.cardBorder),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.language, color: t.accent, size: 16),
                              const SizedBox(width: 6),
                              Text(
                                isAr ? 'EN' : 'AR',
                                style: TextStyle(
                                  color: t.title,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 48),

              Text(
                l.mainScreens,
                style: TextStyle(
                  color: t.label,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _card(context, t,
                      label: l.homeDestinationsTitle,
                      icon: Icons.home_rounded,
                      page: () => const HomeScreen(),
                      small: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _card(context, t,
                      label: l.getStarted,
                      icon: Icons.rocket_launch_rounded,
                      page: () => const OnboardingScreen1(),
                      small: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              _card(context, t,
                label: l.menuDashboard,
                icon: Icons.dashboard_customize_rounded,
                page: () => const UserDashboardScreen(),
                small: true,
              ),
              const SizedBox(height: 12),

              _card(context, t,
                label: 'Admin Dashboard',
                icon: Icons.admin_panel_settings_rounded,
                page: () => const AdminDashboardScreen(),
                small: true,
              ),
              const SizedBox(height: 12),

              _card(context, t,
                label: l.hotels,
                icon: Icons.hotel_rounded,
                page: () => HotelSearch(),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _card(context, t,
                      label: l.flights,
                      icon: Icons.flight_rounded,
                      page: () => FlightSearch(),
                      small: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _card(context, t,
                      label: l.carRent,
                      icon: Icons.directions_car_rounded,
                      page: () => CarsSearch(),
                      small: true,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 36),

              Text(
                l.auth,
                style: TextStyle(
                  color: t.label,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _card(context, t,
                      label: l.signIn,
                      icon: Icons.login_rounded,
                      page: () => const SignIn(),
                      small: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _card(context, t,
                      label: l.signUp,
                      icon: Icons.person_add_rounded,
                      page: () => const SignUp(),
                      small: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _card(
    BuildContext context,
    AppThemeExtension t, {
    required String label,
    required IconData icon,
    required Widget Function() page,
    bool small = false,
  }) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page())),
      child: Container(
        height: small ? 90 : 110,
        decoration: BoxDecoration(
          color: t.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: t.cardBorder),
          boxShadow: [
            BoxShadow(
              color: t.cardBorder.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: t.accentLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: t.accent, size: small ? 20 : 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: t.title,
                  fontSize: small ? 14 : 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: t.label, size: 14),
          ],
        ),
      ),
    );
  }
}
