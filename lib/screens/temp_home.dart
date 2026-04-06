import 'package:flutter/material.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../main.dart';
import 'auth/sign_in.dart';
import 'auth/sign_up.dart';
import 'car rent/carssearch.dart';
import 'flights/flightsearch.dart';
import 'hotels/hotel_search.dart';

class TempHome extends StatelessWidget {
  const TempHome({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: Stack(
        children: [
          // Background blobs
          Positioned(
            top: -60, left: -60,
            child: Container(
              width: 250, height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Color(0xFF1f93a0).withOpacity(0.3), Colors.transparent],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 100, right: -80,
            child: Container(
              width: 300, height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Color(0xFF0D3B38).withOpacity(0.5), Colors.transparent],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l.appTitle,
                              style: TextStyle(
                                  color: Color(0xFF1f93a0),
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1)),
                          Text(l.devMenu,
                              style: TextStyle(color: Colors.white38, fontSize: 13)),
                        ],
                      ),
                      // Language toggle
                      GestureDetector(
                        onTap: () {
                          final next = isAr ? const Locale('en') : const Locale('ar');
                          MyApp.setLocale(context, next);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.language, color: Color(0xFF1f93a0), size: 16),
                              SizedBox(width: 6),
                              Text(
                                isAr ? 'EN' : 'AR',
                                style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 48),

                  Text(l.mainScreens,
                      style: TextStyle(
                          color: Colors.white38,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2)),
                  SizedBox(height: 16),

                  _card(context,
                    label: l.hotels,
                    icon: Icons.hotel_rounded,
                    gradient: [Color(0xFF0D3B38), Color(0xFF1f93a0)],
                    page: () => HotelSearch(),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _card(context,
                          label: l.flights,
                          icon: Icons.flight_rounded,
                          gradient: [Color(0xFF1a1a2e), Color(0xFF16213e)],
                          page: () => FlightSearch(),
                          small: true,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _card(context,
                          label: l.carRent,
                          icon: Icons.directions_car_rounded,
                          gradient: [Color(0xFF2D1B00), Color(0xFF8B4513)],
                          page: () => CarsSearch(),
                          small: true,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 36),

                  Text(l.auth,
                      style: TextStyle(
                          color: Colors.white38,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2)),
                  SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: _card(context,
                          label: l.signIn,
                          icon: Icons.login_rounded,
                          gradient: [Color(0xFF1B2A1B), Color(0xFF2E7D32)],
                          page: () => const SignIn(),
                          small: true,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _card(context,
                          label: l.signUp,
                          icon: Icons.person_add_rounded,
                          gradient: [Color(0xFF1A0A2E), Color(0xFF6A1B9A)],
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
        ],
      ),
    );
  }

  Widget _card(
    BuildContext context, {
    required String label,
    required IconData icon,
    required List<Color> gradient,
    required Widget Function() page,
    bool small = false,
  }) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page())),
      child: Container(
        height: small ? 90 : 110,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white10),
        ),
        padding: EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: small ? 20 : 24),
            ),
            SizedBox(width: 14),
            Text(label,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: small ? 14 : 17,
                    fontWeight: FontWeight.bold)),
            Spacer(),
            Icon(Icons.arrow_forward_ios, color: Colors.white30, size: 14),
          ],
        ),
      ),
    );
  }
}