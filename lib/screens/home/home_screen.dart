import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app/config.dart';
import 'package:mobile_app/data/destinations_repository.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import 'package:mobile_app/screens/chatbot/travel_chat.dart';
import 'package:mobile_app/screens/destinations/all_destinations_screen.dart';
import 'package:mobile_app/screens/home/about_us_screen.dart';
import 'package:mobile_app/screens/dashboards/admin_dashboard_screen.dart';
import 'package:mobile_app/screens/home/settings_screen.dart';
import 'package:mobile_app/screens/dashboards/user_dashboard_screen.dart';
import 'package:mobile_app/screens/auth/sign_in.dart';
import 'package:mobile_app/theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../car rental/carssearch.dart';
import '../destinations/destination_detail_screen.dart';
import '../flights/flight_search.dart';
import '../hotels/hotel_search.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DestinationsRepository _destinationsRepository =
      DestinationsRepository();

  String firstName = '';
  String email = '';
  bool isAdmin = false;

  late final Future<List<Map<String, dynamic>>> _heroDestinationsFuture;
  late final Future<List<Map<String, dynamic>>> _featuredDestinationsFuture;
  late final Future<_UpcomingBooking?> _upcomingFuture;

  late PageController _heroPageController;
  int _currentHeroPage = 0;
  Timer? _heroTimer;
  int _heroDestinationsCount = 0;

  final LayerLink _profileMenuLink = LayerLink();
  OverlayEntry? _profileMenuEntry;

  @override
  void initState() {
    super.initState();
    _loadUser();
    _heroDestinationsFuture = _destinationsRepository.loadHeroDestinations();
    _featuredDestinationsFuture =
        _destinationsRepository.loadFeaturedDestinations();
    _upcomingFuture = _fetchUpcoming();
    _heroPageController = PageController();
    _startHeroAutoScroll();
  }

  @override
  void reassemble() {
    super.reassemble();
    _heroTimer?.cancel();
    _heroPageController.dispose();
    _heroPageController = PageController(initialPage: _currentHeroPage);
    _startHeroAutoScroll();
  }

  void _startHeroAutoScroll() {
    _heroTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;
      if (_heroDestinationsCount <= 1) return;
      if (!_heroPageController.hasClients ||
          _heroPageController.positions.length != 1) return;
      final next = (_currentHeroPage + 1) % _heroDestinationsCount;
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
    _profileMenuEntry?.remove();
    _profileMenuEntry = null;
    _heroTimer?.cancel();
    _heroPageController.dispose();
    super.dispose();
  }

  // ── Concept D — Dark gradient card ───────────────────────────────────────────
  // btnGradient (deep navy → steel blue) as surface, white text on top.
  Widget cashBanner(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final t = Theme.of(context).extension<AppThemeExtension>()!;
    const white = AppColors.white;
    final chipBg = Colors.white.withOpacity(0.15);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: t.btnGradient,
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.payments_outlined, size: 22, color: white),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.cashBannerTitle,
                  style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500, color: white),
                ),
                const SizedBox(height: 4),
                Text(
                  l.cashBannerBody,
                  style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.75),
                      height: 1.55),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    _Chip(Icons.flight, l.flights, chipBg, white),
                    _Chip(Icons.apartment_outlined, l.hotels, chipBg, white),
                    _Chip(Icons.directions_car_outlined, l.userDashboardCars,
                        chipBg, white),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _Chip(IconData icon, String label, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: fg),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      firstName = prefs.getString('firstName') ?? '';
      email = prefs.getString('email') ?? '';
      isAdmin = prefs.getBool('isAdmin') ?? false;
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('firstName');
    await prefs.remove('lastName');
    await prefs.remove('email');
    await prefs.remove('phone');
    await prefs.remove('userId');
    await prefs.remove('gender');
    await prefs.remove('role');
    await prefs.remove('userType');
    await prefs.remove('isAdmin');
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const SignIn()),
      (route) => false,
    );
  }

  // ── Fetch upcoming booking ────────────────────────────────────────────────

  Future<_UpcomingBooking?> _fetchUpcoming() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    if (token.isEmpty) return null;

    final response = await http.get(
      Uri.parse('${Config.baseUrl}/api/my-bookings'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode != 200) return null;

    final data = json.decode(response.body) as Map<String, dynamic>;
    final now = DateTime.now();
    _UpcomingBooking? pick;

    // flights
    for (final item in (data['flightBookings'] as List<dynamic>? ?? [])) {
      final m = item as Map<String, dynamic>;
      final date = _parseDate(m['departureDate']);
      if (date.isAfter(now)) {
        if (pick == null || date.isBefore(pick.date)) {
          pick = _UpcomingBooking(
            type: _BType.flight,
            date: date,
            status: (m['status'] ?? 'pending') as String,
            title: '${m['fromCity']} → ${m['toCity']}',
            line1Label: 'Date',
            line1Value: _formatDate(m['departureDate']),
            line2Label: 'Departs',
            line2Value: _formatTime(m['departureDate']),
            line3Label: 'Passenger',
            line3Value: (m['fullName'] as String? ?? '-').split(' ').first,
          );
        }
      }
    }

    // cars
    for (final item in (data['carBookings'] as List<dynamic>? ?? [])) {
      final m = item as Map<String, dynamic>;
      final date = _parseDate(m['pickupDateTime']);
      if (date.isAfter(now)) {
        if (pick == null || date.isBefore(pick.date)) {
          pick = _UpcomingBooking(
            type: _BType.car,
            date: date,
            status: (m['status'] ?? 'pending') as String,
            title: (m['carName'] ?? '-') as String,
            line1Label: 'Pick-up',
            line1Value: _formatDate(m['pickupDateTime']),
            line2Label: 'Drop-off',
            line2Value: _formatDate(m['dropoffDateTime']),
            line3Label: 'From',
            line3Value: (m['pickupLocation'] ?? '-') as String,
          );
        }
      }
    }

    // hotels
    for (final item in (data['hotelBookings'] as List<dynamic>? ?? [])) {
      final m = item as Map<String, dynamic>;
      final date = _parseDate(m['checkInDate']);
      if (date.isAfter(now)) {
        if (pick == null || date.isBefore(pick.date)) {
          pick = _UpcomingBooking(
            type: _BType.hotel,
            date: date,
            status: (m['status'] ?? 'pending') as String,
            title: (m['hotelName'] ?? '-') as String,
            line1Label: 'Check-in',
            line1Value: _formatDate(m['checkInDate']),
            line2Label: 'Check-out',
            line2Value: _formatDate(m['checkOutDate']),
            line3Label: 'Rooms',
            line3Value: '${m['numRooms'] ?? '-'}',
          );
        }
      }
    }

    return pick;
  }

  // ── Profile menu ──────────────────────────────────────────────────────────

  void _openProfileMenu() {
    if (_profileMenuEntry != null) {
      _closeProfileMenu();
      return;
    }
    final isRtl = Localizations.localeOf(context).languageCode == 'ar';
    _profileMenuEntry = OverlayEntry(
      builder: (_) => _ProfileMenuOverlay(
        link: _profileMenuLink,
        onClose: _closeProfileMenu,
        isRtl: isRtl,
        onSelected: (value) async {
          _closeProfileMenu();
          switch (value) {
            case 'dashboard':
              _openDashboard();
            case 'about':
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const AboutUsScreen()));
            case 'bookings':
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const UserDashboardScreen()));
            case 'settings':
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()));
            case 'logout':
              await Future.delayed(const Duration(milliseconds: 100));
              _logout();
          }
        },
        firstName: firstName,
        email: email,
        isAdmin: isAdmin,
      ),
    );
    Overlay.of(context).insert(_profileMenuEntry!);
    setState(() {});
  }

  void _closeProfileMenu() {
    _profileMenuEntry?.remove();
    _profileMenuEntry = null;
    if (mounted) setState(() {});
  }

  Future<void> _openDashboard() async {
    final prefs = await SharedPreferences.getInstance();
    final role = (prefs.getString('role') ?? '').toLowerCase();
    final userType = (prefs.getString('userType') ?? '').toLowerCase();
    final isAdmin = prefs.getBool('isAdmin') == true ||
        role == 'admin' ||
        userType == 'admin';

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => isAdmin
            ? const AdminDashboardScreen()
            : const UserDashboardScreen(),
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<AppThemeExtension>()!;
    final l = AppLocalizations.of(context)!;
    final isDark = context.watch<ThemeProvider>().isDark;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      backgroundColor: t.bg,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 40),
        child: _ChatFAB(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TravelChatScreen()),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      body: FutureBuilder<List<List<Map<String, dynamic>>>>(
        future:
            Future.wait([_heroDestinationsFuture, _featuredDestinationsFuture]),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator(color: t.accent));
          }

          final heroDestinations = snapshot.data![0];
          final featuredDestinations = snapshot.data![1];

          if (_heroDestinationsCount != heroDestinations.length) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              final nextPage = heroDestinations.isEmpty
                  ? 0
                  : _currentHeroPage % heroDestinations.length;
              setState(() {
                _heroDestinationsCount = heroDestinations.length;
                _currentHeroPage = nextPage;
              });
              if (_heroPageController.hasClients &&
                  _heroPageController.positions.length == 1) {
                _heroPageController.jumpToPage(nextPage);
              }
            });
          }

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child:
                    _buildHero(context, t, l, isDark, isAr, heroDestinations),
              ),
              SliverToBoxAdapter(
                child: _buildBody(context, t, l, isAr, featuredDestinations),
              ),
            ],
          );
        },
      ),
    );
  }

  // ── Category buttons ───────────────────────────

  Widget _buildCategoryButtons(
    BuildContext context,
    AppThemeExtension t,
    AppLocalizations l,
  ) {
    final items = [
      (
        icon: Icons.flight_rounded,
        label: l.flights,
        page: () => FlightSearch(),
      ),
      (
        icon: Icons.hotel_rounded,
        label: l.hotels,
        page: () => HotelSearch(),
      ),
      (
        icon: Icons.directions_car_rounded,
        label: l.carRent,
        page: () => CarsSearch(),
      ),
    ];

    return Row(
      children: List.generate(items.length, (i) {
        final item = items[i];
        final cardColor = Color.lerp(t.card, t.accent, 0.07)!;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              left: i == 0 ? 0 : 5,
              right: i == items.length - 1 ? 0 : 5,
            ),
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => item.page()),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 13),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: t.accent.withOpacity(0.18)),
                  boxShadow: [
                    BoxShadow(
                      color: t.accent.withOpacity(0.08),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: t.accentLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(item.icon, color: t.accent, size: 19),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      item.label,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: t.title,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  // ── Hero ──────────────────────────────────────────────────────────────────

  Widget _buildHero(
    BuildContext context,
    AppThemeExtension t,
    AppLocalizations l,
    bool isDark,
    bool isAr,
    List<Map<String, dynamic>> destinations,
  ) {
    final displayLetter = firstName.isNotEmpty
        ? firstName.characters.first
        : (email.isNotEmpty ? email.characters.first.toUpperCase() : '?');

    return SizedBox(
      height: 340,
      child: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            controller: _heroPageController,
            onPageChanged: (i) => setState(() => _currentHeroPage = i),
            itemCount: destinations.length,
            itemBuilder: (context, i) => Image.network(
              destinations[i]['imageUrl'] as String,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: t.card),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(isDark ? 0.55 : 0.40),
                  Colors.black.withOpacity(isDark ? 0.70 : 0.54),
                  t.bg.withOpacity(0.98),
                ],
                stops: const [0.0, 0.50, 1.0],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CompositedTransformTarget(
                        link: _profileMenuLink,
                        child: GestureDetector(
                          onTap: _openProfileMenu,
                          child: Container(
                            width: 40,
                            height: 40,
                            margin: const EdgeInsets.only(top: 4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black.withOpacity(0.28),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.24),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              displayLetter,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Text(
                        isAr ? l.appTitle : l.appTitle.toUpperCase(),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.88),
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 4,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    firstName.isNotEmpty
                        ? l.homeGreetingWithName(firstName)
                        : l.homeGreeting,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.72),
                      fontSize: 13.5,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l.homeHeroTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'DM Serif Display',
                      letterSpacing: -0.5,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 28),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Body ──────────────────────────────────────────────────────────────────

  Widget _buildBody(
    BuildContext context,
    AppThemeExtension t,
    AppLocalizations l,
    bool isAr,
    List<Map<String, dynamic>> destinations,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategoryButtons(context, t, l),
          const SizedBox(height: 24),
          // _buildUpcomingTrip(context, t, l),
          // const SizedBox(height: 32),
          cashBanner(context),
          const SizedBox(height: 32),
          _buildSpecialOffers(context, t, l),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l.homeDestinationsTitle,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: t.title,
                  fontFamily: 'DM Serif Display',
                  letterSpacing: -0.2,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const AllDestinationsScreen()),
                ),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: t.accentLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    l.seeAll,
                    style: TextStyle(
                      fontSize: 12,
                      color: t.accent,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _buildDestinations(t, isAr, destinations),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // ── Upcoming trip ─────────────────────────────────────────────────────────

  Widget _buildUpcomingTrip(
    BuildContext context,
    AppThemeExtension t,
    AppLocalizations l,
  ) {
    return FutureBuilder<_UpcomingBooking?>(
      future: _upcomingFuture,
      builder: (context, snapshot) {
        // loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l.upcomingTrip,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: t.title,
                  fontFamily: 'DM Serif Display',
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 14),
              Container(
                height: 150,
                decoration: BoxDecoration(
                  color: t.card,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: t.cardBorder.withOpacity(0.45)),
                ),
                child: Center(
                  child: CircularProgressIndicator(
                      color: t.accent, strokeWidth: 2),
                ),
              ),
            ],
          );
        }

        // no upcoming booking → hide section entirely
        if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
          return const SizedBox.shrink();
        }

        final b = snapshot.data!;
        final daysUntil = b.date.difference(DateTime.now()).inDays;
        final isConfirmed = b.status == 'confirmed';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l.upcomingTrip,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: t.title,
                    fontFamily: 'DM Serif Display',
                    letterSpacing: -0.2,
                  ),
                ),
                GestureDetector(
                  onTap: _openDashboard,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: t.accentLight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      l.seeAll,
                      style: TextStyle(
                        fontSize: 12,
                        color: t.accent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: t.card,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: t.cardBorder.withOpacity(0.45)),
                boxShadow: [
                  BoxShadow(
                    color: t.cardBorder.withOpacity(0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Type + status badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        b.typeLabel,
                        style: TextStyle(
                          fontSize: 11,
                          color: t.title.withOpacity(0.45),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 9, vertical: 3),
                        decoration: BoxDecoration(
                          color: isConfirmed
                              ? const Color(0xFFDCFCE7)
                              : const Color(0xFFFEF9C3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isConfirmed
                                  ? Icons.check_circle_outline_rounded
                                  : Icons.access_time_rounded,
                              size: 11,
                              color: isConfirmed
                                  ? const Color(0xFF166534)
                                  : const Color(0xFF854D0E),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              isConfirmed ? 'Confirmed' : 'Pending',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: isConfirmed
                                    ? const Color(0xFF166534)
                                    : const Color(0xFF854D0E),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Title
                  Text(
                    b.title,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: t.title,
                      letterSpacing: -0.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 14),

                  // Meta row
                  Row(
                    children: [
                      _TripMeta(label: b.line1Label, value: b.line1Value, t: t),
                      const SizedBox(width: 18),
                      _TripMeta(label: b.line2Label, value: b.line2Value, t: t),
                      const SizedBox(width: 18),
                      _TripMeta(label: b.line3Label, value: b.line3Value, t: t),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Footer
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                    decoration: BoxDecoration(
                      color: t.bg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 11,
                              color: t.title.withOpacity(0.55),
                            ),
                            children: [
                              const TextSpan(text: 'In '),
                              TextSpan(
                                text: '$daysUntil days',
                                style: TextStyle(
                                  color: t.accent,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: _openDashboard,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 5),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: t.accent.withOpacity(0.60)),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Details',
                              style: TextStyle(
                                fontSize: 11,
                                color: t.accent,
                                fontWeight: FontWeight.w600,
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
          ],
        );
      },
    );
  }

  // ── Special Offers / 20% promo banner ────────────────────────────────────

  Widget _buildSpecialOffers(
    BuildContext context,
    AppThemeExtension t,
    AppLocalizations l,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0A1628),
              Color(0xFF0D2A5E),
              Color(0xFF1A4A8A),
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -8,
              top: -10,
              child: Text(
                '20%',
                style: TextStyle(
                  fontSize: 90,
                  fontWeight: FontWeight.w900,
                  color: Colors.white.withOpacity(0.04),
                  letterSpacing: -4,
                  height: 1.0,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l.specialOffer,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          fontFamily: 'DM Serif Display',
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5A623).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: const Color(0xFFF5A623).withOpacity(0.3),
                          width: 0.5,
                        ),
                      ),
                      child: Text(
                        l.offerBadge,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                          color: Color(0xFFF5A623),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w900,
                      height: 1.2,
                      color: Colors.white,
                      letterSpacing: -0.4,
                    ),
                    children: [
                      TextSpan(text: '${l.offerWelcomeGift}\n'),
                      TextSpan(
                        text: l.offerDiscount,
                        style: const TextStyle(color: Color(0xFFF5A623)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Text(
                      l.offerCodeLabel,
                      style: TextStyle(
                        fontSize: 9,
                        color: Colors.white.withOpacity(0.45),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: const Text(
                        'RAHAL20',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 2,
                          color: Colors.white,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(const ClipboardData(text: 'RAHAL20'));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l.offerCodeCopied),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5A623),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFF5A623).withOpacity(0.5),
                              blurRadius: 14,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          l.offerCopyCode,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1A1000),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Destinations ──────────────────────────────────────────────────────────

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
        childAspectRatio: 0.92,
      ),
      itemCount: destinations.length,
      itemBuilder: (context, i) {
        final dest = destinations[i];
        return _DestinationCard(
          destination: dest,
          isAr: isAr,
          t: t,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DestinationDetailScreen(destinationData: dest),
            ),
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Upcoming booking model
// ═══════════════════════════════════════════════════════════════════════════

enum _BType { flight, car, hotel }

class _UpcomingBooking {
  final _BType type;
  final DateTime date;
  final String status;
  final String title;
  final String line1Label;
  final String line1Value;
  final String line2Label;
  final String line2Value;
  final String line3Label;
  final String line3Value;

  const _UpcomingBooking({
    required this.type,
    required this.date,
    required this.status,
    required this.title,
    required this.line1Label,
    required this.line1Value,
    required this.line2Label,
    required this.line2Value,
    required this.line3Label,
    required this.line3Value,
  });

  String get typeLabel {
    switch (type) {
      case _BType.flight:
        return 'Flight';
      case _BType.car:
        return 'Car Rental';
      case _BType.hotel:
        return 'Hotel';
    }
  }
}

DateTime _parseDate(dynamic value) {
  if (value == null) return DateTime.fromMillisecondsSinceEpoch(0);
  return DateTime.tryParse(value.toString()) ??
      DateTime.fromMillisecondsSinceEpoch(0);
}

String _formatDate(dynamic value) {
  final d = _parseDate(value);
  if (d.year == 1970) return '-';
  return '${d.day}/${d.month}/${d.year}';
}

String _formatTime(dynamic value) {
  final d = _parseDate(value);
  if (d.year == 1970) return '-';
  final h = d.hour.toString().padLeft(2, '0');
  final m = d.minute.toString().padLeft(2, '0');
  return '$h:$m';
}

// ═══════════════════════════════════════════════════════════════════════════
// Trip meta
// ═══════════════════════════════════════════════════════════════════════════

class _TripMeta extends StatelessWidget {
  final String label;
  final String value;
  final AppThemeExtension t;

  const _TripMeta({
    required this.label,
    required this.value,
    required this.t,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: t.title.withOpacity(0.45),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: t.title,
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Destination card
// ═══════════════════════════════════════════════════════════════════════════

class _DestinationCard extends StatefulWidget {
  final Map<String, dynamic> destination;
  final bool isAr;
  final AppThemeExtension t;
  final VoidCallback onTap;

  const _DestinationCard({
    required this.destination,
    required this.isAr,
    required this.t,
    required this.onTap,
  });

  @override
  State<_DestinationCard> createState() => _DestinationCardState();
}

class _DestinationCardState extends State<_DestinationCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final name = widget.isAr
        ? widget.destination['nameAr'] as String
        : widget.destination['nameEn'] as String;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 110),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                widget.destination['imageUrl'] as String,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: widget.t.card),
              ),
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black87],
                    stops: [0.45, 1.0],
                  ),
                ),
              ),
              Positioned(
                bottom: 12,
                left: 12,
                right: 12,
                child: Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.2,
                    shadows: [
                      Shadow(color: Colors.black54, blurRadius: 8),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Profile Menu Overlay
// ═══════════════════════════════════════════════════════════════════════════

class _ProfileMenuOverlay extends StatefulWidget {
  final LayerLink link;
  final VoidCallback onClose;
  final ValueChanged<String> onSelected;
  final String firstName;
  final String email;
  final bool isAdmin;
  final bool isRtl;

  const _ProfileMenuOverlay({
    required this.link,
    required this.onClose,
    required this.onSelected,
    required this.firstName,
    required this.email,
    required this.isAdmin,
    required this.isRtl,
  });

  @override
  State<_ProfileMenuOverlay> createState() => _ProfileMenuOverlayState();
}

class _ProfileMenuOverlayState extends State<_ProfileMenuOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 260));
    _scale = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack);
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _dismiss() async {
    await _ctrl.reverse();
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<AppThemeExtension>()!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l = AppLocalizations.of(context)!;
    bool isAdmin = widget.isAdmin;

    final displayLetter = widget.firstName.isNotEmpty
        ? widget.firstName.characters.first
        : (widget.email.isNotEmpty
            ? widget.email.characters.first.toUpperCase()
            : '?');

    final menuBg = isDark
        ? const Color(0xFF0F192D).withOpacity(0.93)
        : Colors.white.withOpacity(0.84);
    final borderCol = isDark
        ? Colors.white.withOpacity(0.10)
        : Colors.white.withOpacity(0.90);
    final headerBorderCol = isDark
        ? Colors.white.withOpacity(0.07)
        : const Color(0xFF6496BE).withOpacity(0.12);
    final nameCol = isDark ? t.title : const Color(0xFF1A3A52);
    final emailCol = isDark
        ? Colors.white.withOpacity(0.72)
        : const Color(0xFF234B72).withOpacity(0.65);
    final iconBg = isDark ? Colors.white.withOpacity(0.06) : t.accentLight;
    final iconCol =
        isDark ? Colors.white.withOpacity(0.50) : t.accent.withOpacity(0.70);
    final labelCol = isDark
        ? Colors.white.withOpacity(0.65)
        : const Color(0xFF194164).withOpacity(0.70);
    final chevronCol = isDark
        ? Colors.white.withOpacity(0.18)
        : const Color(0xFF5082AA).withOpacity(0.28);
    final dividerCol = isDark
        ? Colors.white.withOpacity(0.07)
        : const Color(0xFF6496BE).withOpacity(0.13);

    const menuWidth = 232.0;
    const avatarWidth = 40.0;
    final offsetX = widget.isRtl ? -(menuWidth - avatarWidth) : 0.0;
    final scaleOrigin = widget.isRtl ? Alignment.topLeft : Alignment.topRight;

    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: _dismiss,
            behavior: HitTestBehavior.translucent,
            child: const SizedBox.expand(),
          ),
        ),
        CompositedTransformFollower(
          link: widget.link,
          showWhenUnlinked: false,
          offset: Offset(offsetX, 50),
          child: FadeTransition(
            opacity: _fade,
            child: ScaleTransition(
              scale: _scale,
              alignment: scaleOrigin,
              child: Material(
                color: Colors.transparent,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
                    child: Container(
                      width: menuWidth,
                      decoration: BoxDecoration(
                        color: menuBg,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: borderCol),
                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.black.withOpacity(isDark ? 0.48 : 0.12),
                            blurRadius: 32,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                            decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: headerBorderCol)),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: 52,
                                  height: 52,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        t.accent,
                                        t.accent.withOpacity(0.70),
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: t.accent.withOpacity(0.28),
                                        blurRadius: 0,
                                        spreadRadius: 3,
                                      ),
                                    ],
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    displayLetter,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  widget.firstName.isNotEmpty
                                      ? widget.firstName
                                      : l.menuProfileFallback,
                                  style: TextStyle(
                                    color: nameCol,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    fontFamily: 'DM Serif Display',
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  widget.email.isNotEmpty
                                      ? widget.email
                                      : l.menuNoEmail,
                                  style: TextStyle(
                                    color: emailCol,
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.1,
                                  ),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Column(
                              children: [
                                _MenuRow(
                                  icon: Icons.dashboard_outlined,
                                  label: isAdmin
                                      ? l.menuAdminDashboard
                                      : l.menuDashboard,
                                  iconBg: iconBg,
                                  iconColor: iconCol,
                                  labelColor: labelCol,
                                  chevronColor: chevronCol,
                                  isDark: isDark,
                                  onTap: () => widget.onSelected('dashboard'),
                                ),
                                _MenuRow(
                                  icon: Icons.settings_outlined,
                                  label: l.menuSettings,
                                  iconBg: iconBg,
                                  iconColor: iconCol,
                                  labelColor: labelCol,
                                  chevronColor: chevronCol,
                                  isDark: isDark,
                                  onTap: () => widget.onSelected('settings'),
                                ),
                                _MenuRow(
                                  icon: Icons.info_outline_rounded,
                                  label: l.menuAboutUs,
                                  iconBg: iconBg,
                                  iconColor: iconCol,
                                  labelColor: labelCol,
                                  chevronColor: chevronCol,
                                  isDark: isDark,
                                  onTap: () => widget.onSelected('about'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 3),
                                  child: Divider(height: 1, color: dividerCol),
                                ),
                                _MenuRow(
                                  icon: Icons.logout_rounded,
                                  label: l.menuLogout,
                                  iconBg:
                                      const Color(0xFFFB7185).withOpacity(0.08),
                                  iconColor:
                                      const Color(0xFFFB7185).withOpacity(0.70),
                                  labelColor:
                                      const Color(0xFFDC4545).withOpacity(0.78),
                                  chevronColor: Colors.transparent,
                                  isDark: isDark,
                                  showChevron: false,
                                  onTap: () => widget.onSelected('logout'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Menu row
// ═══════════════════════════════════════════════════════════════════════════

class _MenuRow extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color iconBg;
  final Color iconColor;
  final Color labelColor;
  final Color chevronColor;
  final bool isDark;
  final bool showChevron;
  final VoidCallback onTap;

  const _MenuRow({
    required this.icon,
    required this.label,
    required this.iconBg,
    required this.iconColor,
    required this.labelColor,
    required this.chevronColor,
    required this.isDark,
    required this.onTap,
    this.showChevron = true,
  });

  @override
  State<_MenuRow> createState() => _MenuRowState();
}

class _MenuRowState extends State<_MenuRow> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final hoverBg = widget.isDark
        ? Colors.white.withOpacity(0.05)
        : Colors.black.withOpacity(0.04);

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        decoration: BoxDecoration(
          color: _pressed ? hoverBg : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: widget.iconBg,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(widget.icon, color: widget.iconColor, size: 15),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Text(
                widget.label,
                style: TextStyle(
                  color: widget.labelColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (widget.showChevron)
              Icon(Icons.chevron_right_rounded,
                  color: widget.chevronColor, size: 16),
          ],
        ),
      ),
    );
  }
}

class _ChatFAB extends StatelessWidget {
  final VoidCallback onTap;
  const _ChatFAB({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final t = Theme.of(context).extension<AppThemeExtension>()!;
    final l = AppLocalizations.of(context)!;
    final bg = isDark ? const Color(0xFF0D1B2A) : const Color(0xFFF0F8FC);
    final iconColor = const Color(0xFF1f93a0);
    final textColor =
        isDark ? const Color(0xFFE8F4FA) : const Color(0xFF1f93a0);
    final borderColor = isDark
        ? const Color(0xFF4DB8E8).withOpacity(0.3)
        : const Color(0xFF1f93a0).withOpacity(0.2);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.4 : 0.12),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.auto_awesome_rounded, color: iconColor, size: 18),
            const SizedBox(width: 8),
            Text(
              l.askRahal,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
