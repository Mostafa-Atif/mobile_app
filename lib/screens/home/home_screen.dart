import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mobile_app/data/destinations_repository.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import 'package:mobile_app/screens/home/all_destinations_screen.dart';
import 'package:mobile_app/screens/home/about_us_screen.dart';
import 'package:mobile_app/screens/home/settings_screen.dart';
import 'package:mobile_app/screens/home/user_dashboard_screen.dart';
import 'package:mobile_app/screens/auth/sign_in.dart';
import 'package:mobile_app/theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../car rental/carssearch.dart';
import 'destination_detail_screen.dart';
import '../flights/flightsearch.dart';
import '../hotels/hotel_search.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DestinationsRepository _destinationsRepository = DestinationsRepository();

  String firstName = '';
  String email = '';

  late final Future<List<Map<String, dynamic>>> _heroDestinationsFuture;
  late final Future<List<Map<String, dynamic>>> _featuredDestinationsFuture;

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
    _featuredDestinationsFuture = _destinationsRepository.loadFeaturedDestinations();
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
    _closeProfileMenu();
    _heroTimer?.cancel();
    _heroPageController.dispose();
    super.dispose();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      firstName = prefs.getString('firstName') ?? '';
      email = prefs.getString('email') ?? '';
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
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const SignIn()),
      (route) => false,
    );
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
        onSelected: (value) {
          _closeProfileMenu();
          switch (value) {
            case 'dashboard':
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const UserDashboardScreen()));
            case 'about':
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const AboutUsScreen()));
            case 'settings':
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()));
            case 'logout':
              _logout();
          }
        },
        firstName: firstName,
        email: email,
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

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<AppThemeExtension>()!;
    final l = AppLocalizations.of(context)!;
    final isDark = context.watch<ThemeProvider>().isDark;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      backgroundColor: t.bg,
      body: FutureBuilder<List<List<Map<String, dynamic>>>>(
        future: Future.wait([_heroDestinationsFuture, _featuredDestinationsFuture]),
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
                child: _buildHero(
                    context, t, l, isDark, isAr, heroDestinations),
              ),
              SliverToBoxAdapter(
                child: _buildBody(
                    context, t, l, isAr, featuredDestinations),
              ),
            ],
          );
        },
      ),
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
      height: 360,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background carousel
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

          // Three-stop gradient: transparent top → mid dark → bg color
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(isDark ? 0.50 : 0.35),
                  Colors.black.withOpacity(isDark ? 0.68 : 0.52),
                  t.bg.withOpacity(0.97),
                ],
                stops: const [0.0, 0.52, 1.0],
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isAr ? l.appTitle : l.appTitle.toUpperCase(),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.88),
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 4,
                        ),
                      ),
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
                    ],
                  ),

                  const Spacer(),

                  // Greeting
                  Text(
                    firstName.isNotEmpty
                        ? l.homeGreetingWithName(firstName)
                        : l.homeGreeting,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.68),
                      fontSize: 13.5,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 5),

                  // Hero title
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
                  const SizedBox(height: 20),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Body (below hero) ─────────────────────────────────────────────────────

  Widget _buildBody(
    BuildContext context,
    AppThemeExtension t,
    AppLocalizations l,
    bool isAr,
    List<Map<String, dynamic>> destinations,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 28, 22, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategories(context, t, l),
          const SizedBox(height: 36),

          // Section header
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
          const SizedBox(height: 16),

          _buildDestinations(t, isAr, destinations),
          const SizedBox(height: 36),
        ],
      ),
    );
  }

  // ── Categories ────────────────────────────────────────────────────────────

  Widget _buildCategories(
      BuildContext context, AppThemeExtension t, AppLocalizations l) {
    final categories = [
      {
        'label': l.menuDashboard,
        'icon': Icons.dashboard_customize_rounded,
        'page': () => const UserDashboardScreen()
      },
      {
        'label': l.flights,
        'icon': Icons.flight_rounded,
        'page': () => FlightSearch()
      },
      {
        'label': l.hotels,
        'icon': Icons.hotel_rounded,
        'page': () => HotelSearch()
      },
      {
        'label': l.carRent,
        'icon': Icons.directions_car_rounded,
        'page': () => CarsSearch()
      },
    ];

    final itemWidth = (MediaQuery.sizeOf(context).width - 22 - 22 - 12) / 2;

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: categories.map((cat) {
        return SizedBox(
          width: itemWidth,
          child: _CategoryCard(
            icon: cat['icon'] as IconData,
            label: cat['label'] as String,
            t: t,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => (cat['page'] as Function)()),
            ),
          ),
        );
      }).toList(),
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
        childAspectRatio: 0.92, // taller = better for photos
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
// Category card
// ═══════════════════════════════════════════════════════════════════════════

class _CategoryCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final AppThemeExtension t;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.icon,
    required this.label,
    required this.t,
    required this.onTap,
  });

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final t = widget.t;
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
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
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: t.accentLight,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(widget.icon, color: t.accent, size: 24),
              ),
              const SizedBox(height: 10),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: t.title,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
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
                    shadows: [Shadow(color: Colors.black54, blurRadius: 8)],
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
  final bool isRtl;

  const _ProfileMenuOverlay({
    required this.link,
    required this.onClose,
    required this.onSelected,
    required this.firstName,
    required this.email,
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

    final displayLetter = widget.firstName.isNotEmpty
        ? widget.firstName.characters.first
        : (widget.email.isNotEmpty
            ? widget.email.characters.first.toUpperCase()
            : '?');

    final menuBg = isDark
        ? const Color(0xFF0F192D).withOpacity(0.93)
        : Colors.white.withOpacity(0.84);
    final borderCol =
        isDark ? Colors.white.withOpacity(0.10) : Colors.white.withOpacity(0.90);
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
    final onlineDotBorder = isDark ? const Color(0xFF0F1A2D) : Colors.white;

    // RTL fix:
    // LTR — avatar is on the right. Shift menu LEFT by (menuWidth - avatarWidth)
    //        so the right edges line up. Spring opens from top-right.
    // RTL — avatar is on the LEFT (after the layout flip). No X shift needed;
    //        left edges already align. Spring opens from top-left.
    const menuWidth = 232.0;
    const avatarWidth = 40.0;
    final offsetX = widget.isRtl ? 0.0 : -(menuWidth - avatarWidth);
    final scaleOrigin =
        widget.isRtl ? Alignment.topLeft : Alignment.topRight;

    return Stack(
      children: [
        // Dismiss barrier
        Positioned.fill(
          child: GestureDetector(
            onTap: _dismiss,
            behavior: HitTestBehavior.translucent,
            child: const SizedBox.expand(),
          ),
        ),

        // Menu
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
                            color: Colors.black
                                .withOpacity(isDark ? 0.48 : 0.12),
                            blurRadius: 32,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Profile header
                          Container(
                            padding:
                                const EdgeInsets.fromLTRB(16, 20, 16, 16),
                            decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: headerBorderCol)),
                            ),
                            child: Column(
                              children: [
                                Stack(
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
                                    // Positioned(
                                    //   bottom: 2,
                                    //   right: 2,
                                    //   child: Container(
                                    //     width: 12,
                                    //     height: 12,
                                    //     decoration: BoxDecoration(
                                    //       shape: BoxShape.circle,
                                    //       color: const Color(0xFF34D399),
                                    //       border: Border.all(
                                    //           color: onlineDotBorder,
                                    //           width: 2),
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
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

                          // Rows
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Column(
                              children: [
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
                                  iconBg: const Color(0xFFFB7185)
                                      .withOpacity(0.08),
                                  iconColor: const Color(0xFFFB7185)
                                      .withOpacity(0.70),
                                  labelColor: const Color(0xFFDC4545)
                                      .withOpacity(0.78),
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
