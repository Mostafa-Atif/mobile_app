import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import 'package:mobile_app/theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'hotels/hotel_search.dart';
import 'flights/flightsearch.dart';
import 'car rental/carssearch.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String firstName = '';

  final List<Map<String, String>> destinations = [
    {
      'name': 'Dubai',
      'nameAr': 'دبي',
      'img': 'https://images.unsplash.com/photo-1512453979798-5ea266f8880c?w=800&q=80',
    },
    {
      'name': 'Paris',
      'nameAr': 'باريس',
      'img': 'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?w=800&q=80',
    },
    {
      'name': 'London',
      'nameAr': 'لندن',
      'img': 'https://images.unsplash.com/photo-1513635269975-59663e0ac1ad?w=800&q=80',
    },
    {
      'name': 'Tokyo',
      'nameAr': 'طوكيو',
      'img': 'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=800&q=80',
    },
  ];

  late final PageController _heroPageController;
  int _currentHeroPage = 0;
  Timer? _heroTimer;

  @override
  void initState() {
    super.initState();
    _loadUser();
    _heroPageController = PageController();
    _startHeroAutoScroll();
  }

  void _startHeroAutoScroll() {
    _heroTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;
      final next = (_currentHeroPage + 1) % destinations.length;
      _heroPageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
      setState(() => _currentHeroPage = next);
    });
  }

  @override
  void dispose() {
    _heroTimer?.cancel();
    _heroPageController.dispose();
    super.dispose();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => firstName = prefs.getString('firstName') ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<AppThemeExtension>()!;
    final l = AppLocalizations.of(context)!;
    final isDark = context.watch<ThemeProvider>().isDark;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      backgroundColor: t.bg,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _buildHero(context, t, l, isDark, isAr),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCategories(context, t, l),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isAr ? 'الوجهات' : 'Destinations',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: t.title,
                          fontFamily: 'DM Serif Display',
                        ),
                      ),
                      Text(
                        isAr ? 'عرض الكل' : 'See all',
                        style: TextStyle(fontSize: 13, color: t.accent, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildDestinations(t, isAr),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHero(BuildContext context, AppThemeExtension t, AppLocalizations l, bool isDark, bool isAr) {
    final heroFilter = isDark ? 0.45 : 0.30;

    return SizedBox(
      height: 320,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // ── Auto-scrolling background images ──
          PageView.builder(
            controller: _heroPageController,
            onPageChanged: (i) => setState(() => _currentHeroPage = i),
            itemCount: destinations.length,
            itemBuilder: (context, i) {
              return Image.network(
                destinations[i]['img']!,
                fit: BoxFit.cover,
                color: Colors.black.withOpacity(heroFilter),
                colorBlendMode: BlendMode.darken,
                errorBuilder: (_, __, ___) => Container(color: t.card),
              );
            },
          ),

          // ── Gradient overlay ──
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  t.bg.withOpacity(0.95),
                ],
                stops: const [0.4, 1.0],
              ),
            ),
          ),

          // ── Content ──
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isAr ? 'رحّال' : 'RAHAL',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 4,
                        ),
                      ),
                      Row(
                        children: [
                          _heroIconBtn(
                            isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                            () => context.read<ThemeProvider>().toggle(),
                          ),
                          const SizedBox(width: 8),
                          _heroIconBtn(
                            Icons.language,
                            () {
                              final next = isAr ? const Locale('en') : const Locale('ar');
                              MyApp.setLocale(context, next);
                            },
                            label: isAr ? 'EN' : 'AR',
                          ),
                        ],
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Greeting
                  Text(
                    isAr
                        ? '${firstName.isNotEmpty ? '$firstName، ' : ''}جاهز للإقلاع؟'
                        : 'Ready for takeoff${firstName.isNotEmpty ? ', $firstName' : ''}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.75),
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Main heading
                  Text(
                    isAr ? 'خطّط لمغامرتك القادمة' : 'Plan your next\nadventure',
                    style: TextStyle(
                      color: t.title,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 14),


                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _heroIconBtn(IconData icon, VoidCallback onTap, {String? label}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: label != null
            ? const EdgeInsets.symmetric(horizontal: 12, vertical: 7)
            : const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: label != null
            ? Row(children: [
                Icon(icon, color: Colors.white, size: 14),
                const SizedBox(width: 5),
                Text(label,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
              ])
            : Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }

  Widget _buildCategories(BuildContext context, AppThemeExtension t, AppLocalizations l) {
    final categories = [
      {
        'label': l.flights,
        'icon': Icons.flight_rounded,
        'page': () => FlightSearch(),
      },
      {
        'label': l.hotels,
        'icon': Icons.hotel_rounded,
        'page': () => HotelSearch(),
      },
      {
        'label': l.carRent,
        'icon': Icons.directions_car_rounded,
        'page': () => CarsSearch(),
      },
    ];

    return Row(
      children: categories.map((cat) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => (cat['page'] as Function)()),
              ),
              child: Container(
                // ── Taller card + more padding ──
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
                decoration: BoxDecoration(
                  color: t.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: t.cardBorder.withOpacity(0.5)),
                  boxShadow: [
                    BoxShadow(
                      color: t.cardBorder.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        color: t.accentLight,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      // ── Bigger icon ──
                      child: Icon(cat['icon'] as IconData, color: t.accent, size: 32),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      cat['label'] as String,
                      style: TextStyle(
                        // ── Bigger label ──
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: t.title,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDestinations(AppThemeExtension t, bool isAr) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.3,
      ),
      itemCount: destinations.length,
      itemBuilder: (context, i) {
        final d = destinations[i];
        return ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                d['img']!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: t.card),
              ),
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black54],
                    stops: [0.4, 1.0],
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                left: 12,
                child: Text(
                  isAr ? d['nameAr']! : d['name']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}