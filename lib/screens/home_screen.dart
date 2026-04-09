import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_app/data/destinations_repository.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import 'package:mobile_app/screens/all_destinations_screen.dart';
import 'package:mobile_app/theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'car rental/carssearch.dart';
import 'destination_detail_screen.dart';
import 'flights/flightsearch.dart';
import 'hotels/hotel_search.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DestinationsRepository _destinationsRepository = DestinationsRepository();
  String firstName = '';
  late final Future<List<Map<String, dynamic>>> _featuredDestinationsFuture;

  late final PageController _heroPageController;
  int _currentHeroPage = 0;
  Timer? _heroTimer;

  @override
  void initState() {
    super.initState();
    _loadUser();
    _featuredDestinationsFuture =
        _destinationsRepository.loadFeaturedDestinations();
    _heroPageController = PageController();
    _startHeroAutoScroll();
  }

  void _startHeroAutoScroll() {
    _heroTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;

      _featuredDestinationsFuture.then((destinations) {
        if (!mounted || destinations.isEmpty) return;

        final next = (_currentHeroPage + 1) % destinations.length;
        _heroPageController.animateToPage(
          next,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
        setState(() => _currentHeroPage = next);
      });
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
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _featuredDestinationsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final destinations = snapshot.data!;

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _buildHero(context, t, l, isDark, isAr, destinations),
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
                            l.homeDestinationsTitle,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: t.title,
                              fontFamily: 'DM Serif Display',
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AllDestinationsScreen(),
                              ),
                            ),
                            child: Text(
                              l.seeAll,
                              style: TextStyle(
                                fontSize: 13,
                                color: t.accent,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildDestinations(t, isAr, destinations),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHero(
    BuildContext context,
    AppThemeExtension t,
    AppLocalizations l,
    bool isDark,
    bool isAr,
    List<Map<String, dynamic>> destinations,
  ) {
    final heroFilter = isDark ? 0.45 : 0.30;

    return SizedBox(
      height: 320,
      child: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            controller: _heroPageController,
            onPageChanged: (i) => setState(() => _currentHeroPage = i),
            itemCount: destinations.length,
            itemBuilder: (context, i) {
              return Image.network(
                destinations[i]['imageUrl'] as String,
                fit: BoxFit.cover,
                color: Colors.black.withOpacity(heroFilter),
                colorBlendMode: BlendMode.darken,
                errorBuilder: (_, __, ___) => Container(color: t.card),
              );
            },
          ),
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
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isAr ? l.appTitle : l.appTitle.toUpperCase(),
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
                            isDark
                                ? Icons.light_mode_outlined
                                : Icons.dark_mode_outlined,
                            () => context.read<ThemeProvider>().toggle(),
                          ),
                          const SizedBox(width: 8),
                          _heroIconBtn(
                            Icons.language,
                            () {
                              final next =
                                  isAr ? const Locale('en') : const Locale('ar');
                              MyApp.setLocale(context, next);
                            },
                            label: isAr ? 'EN' : 'AR',
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    firstName.isNotEmpty
                        ? l.homeGreetingWithName(firstName)
                        : l.homeGreeting,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.75),
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l.homeHeroTitle,
                    style: TextStyle(
                      color: t.title,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 30),
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
            ? Row(
                children: [
                  Icon(icon, color: Colors.white, size: 14),
                  const SizedBox(width: 5),
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
            : Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }

  Widget _buildCategories(
    BuildContext context,
    AppThemeExtension t,
    AppLocalizations l,
  ) {
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
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
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
                      child: Icon(
                        cat['icon'] as IconData,
                        color: t.accent,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      cat['label'] as String,
                      style: TextStyle(
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

  Widget _buildDestinations(
    AppThemeExtension t,
    bool isAr,
    List<Map<String, dynamic>> destinations,
  ) {
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
        final destination = destinations[i];

        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DestinationDetailScreen(
                destinationData: destination,
              ),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  destination['imageUrl'] as String,
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
                    isAr
                        ? destination['nameAr'] as String
                        : destination['nameEn'] as String,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
