import 'package:flutter/material.dart';
import 'package:mobile_app/screens/home/home_screen.dart';
import 'package:mobile_app/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<AppThemeExtension>()!;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    final features = [
      {
        'icon': Icons.flight_rounded,
        'title': isAr ? 'حجز رحلات' : 'Flight Booking',
        'desc': isAr
            ? 'ابحث عن أفضل الرحلات وأرخصها من مئات شركات الطيران حول العالم.'
            : 'Search and book the best flights from hundreds of airlines worldwide.',
      },
      {
        'icon': Icons.hotel_rounded,
        'title': isAr ? 'حجز فنادق' : 'Hotel Stays',
        'desc': isAr
            ? 'اختر من بين أكثر من مليون فندق وشقة فندقية في جميع أنحاء العالم.'
            : 'Choose from over 1M+ hotels and apartments across the globe.',
      },
      {
        'icon': Icons.directions_car_rounded,
        'title': isAr ? 'تأجير سيارات' : 'Car Rentals',
        'desc': isAr
            ? 'استأجر سيارتك المفضلة بأفضل الأسعار مع خيار السائق الخاص.'
            : 'Rent your preferred car at the best rates with an optional private driver.',
      },
      {
        'icon': Icons.support_agent_rounded,
        'title': isAr ? 'دعم على مدار الساعة' : '24/7 Support',
        'desc': isAr
            ? 'فريق دعم متاح دائماً لمساعدتك في أي وقت خلال رحلتك.'
            : 'Our support team is always available to assist you throughout your journey.',
      },
    ];

    final stats = [
      {'value': '1M+', 'label': isAr ? 'فندق' : 'Hotels'},
      {'value': '500+', 'label': isAr ? 'وجهة' : 'Destinations'},
      {'value': '50K+', 'label': isAr ? 'عميل سعيد' : 'Happy Travelers'},
    ];

    return Scaffold(
      backgroundColor: t.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Hero banner ──
              Stack(
                children: [
                  Image.network(
                    'https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?w=800&q=80',
                    height: 240,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    color: Colors.black.withOpacity(0.45),
                    colorBlendMode: BlendMode.darken,
                    errorBuilder: (_, __, ___) => Container(
                      height: 240,
                      color: t.card,
                    ),
                  ),
                  Container(
                    height: 240,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, t.bg.withOpacity(0.95)],
                        stops: const [0.45, 1.0],
                      ),
                    ),
                  ),
                  // Back button
                  Positioned(
                    top: 16,
                    left: isAr ? null : 20,
                    right: isAr ? 20 : null,
                    child: GestureDetector(
                      onTap: () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                        (route) => false,
                      ),
                      child: Container(
                        width: 36, height: 36,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white.withOpacity(0.2)),
                        ),
                        child: Icon(
                          isAr ? Icons.arrow_forward : Icons.arrow_back,
                          color: Colors.white, size: 18,
                        ),
                      ),
                    ),
                  ),
                  // Hero text
                  Positioned(
                    bottom: 24,
                    left: 24, right: 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isAr ? 'رحّال' : 'RAHAL',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 12,
                            letterSpacing: 4,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isAr ? 'من نحن' : 'About Us',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                            fontFamily: 'DM Serif Display',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // ── Mission ──
                    _sectionLabel(isAr ? 'مهمّتنا' : 'Our Mission', t),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: _cardDecoration(t),
                      child: Text(
                        isAr
                            ? 'رحّال هو رفيقك في كل رحلة. نؤمن بأن السفر يجب أن يكون سهلاً وممتعاً ومتاحاً للجميع. لذلك وفّرنا في مكان واحد كل ما تحتاجه — من حجز رحلات الطيران إلى الفنادق وتأجير السيارات — بأسعار منافسة وتجربة استخدام لا مثيل لها.'
                            : 'Rahal is your companion on every journey. We believe travel should be simple, enjoyable, and accessible to everyone. That\'s why we\'ve brought everything you need into one place — from flights and hotels to car rentals — at competitive prices with an unmatched experience.',
                        style: TextStyle(
                          fontSize: 15,
                          color: t.title,
                          height: 1.7,
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ── Stats ──
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        color: t.accent,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: t.accent.withOpacity(0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        children: stats.map((s) {
                          final isLast = s == stats.last;
                          return Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  right: isLast
                                      ? BorderSide.none
                                      : BorderSide(
                                          color: Colors.white.withOpacity(0.2),
                                          width: 1),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    s['value']!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    s['label']!,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.75),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ── What we offer ──
                    _sectionLabel(isAr ? 'ما نقدّمه' : 'What We Offer', t),
                    const SizedBox(height: 10),
                    ...features.map((f) => Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(18),
                      decoration: _cardDecoration(t),
                      child: Row(
                        children: [
                          Container(
                            width: 48, height: 48,
                            decoration: BoxDecoration(
                              color: t.accentLight,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(f['icon'] as IconData,
                                color: t.accent, size: 24),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  f['title'] as String,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: t.title,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  f['desc'] as String,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: t.label,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),

                    const SizedBox(height: 28),

                    // ── Get In Touch ──
                    _sectionLabel(isAr ? 'تواصل معنا' : 'Get In Touch', t),
                    const SizedBox(height: 10),
                    Container(
                      decoration: _cardDecoration(t),
                      child: Column(
                        children: [
                          _contactRow(
                            icon: Icons.email_outlined,
                            label: isAr ? 'البريد الإلكتروني' : 'Email',
                            value: 'support@rahal.app',
                            t: t,
                            showDivider: true,
                            onTap: () => _launchUrl('mailto:support@rahal.app'),
                          ),
                          _contactRow(
                            icon: Icons.phone_outlined,
                            label: isAr ? 'الهاتف' : 'Phone',
                            value: '+966 50 000 0000',
                            t: t,
                            showDivider: true,
                            onTap: () => _launchUrl('tel:+966500000000'),
                          ),
                          
                          _contactRow(
                            icon: Icons.facebook_rounded,
                            label: 'Facebook',
                            value: 'Rahal',
                            t: t,
                            showDivider: true,
                            onTap: () => _launchUrl(
                                'https://www.facebook.com/profile.php?id=61583307142506'),
                          ),
                          _contactRow(
                            icon: Icons.camera_alt_outlined,
                            label: 'Instagram',
                            value: '@toursrahal',
                            t: t,
                            showDivider: true,
                            onTap: () => _launchUrl(
                                'https://www.instagram.com/toursrahal/'),
                          ),
                          _contactRow(
                            icon: Icons.music_note_rounded,
                            label: 'TikTok',
                            value: '@portsaid42',
                            t: t,
                            showDivider: true,
                            onTap: () => _launchUrl(
                                'https://www.tiktok.com/@portsaid42?lang=en'),
                          ),
                          _contactRow(
                            icon: Icons.business_rounded,
                            label: 'LinkedIn',
                            value: 'Rahal Tour',
                            t: t,
                            showDivider: false,
                            onTap: () => _launchUrl(
                                'https://www.linkedin.com/in/rahal-tour-2224673b1/?isSelfProfile=true'),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // ── Footer ──
                    Center(
                      child: Column(
                        children: [
                          Text(
                            isAr ? 'رحّال' : 'RAHAL',
                            style: TextStyle(
                              color: t.label,
                              fontSize: 12,
                              letterSpacing: 4,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isAr ? 'الإصدار ١.٠.٠' : 'Version 1.0.0',
                            style: TextStyle(color: t.label, fontSize: 12),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  Widget _sectionLabel(String text, AppThemeExtension t) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: t.label,
        letterSpacing: 1.2,
      ),
    );
  }

  BoxDecoration _cardDecoration(AppThemeExtension t) {
    return BoxDecoration(
      color: t.card,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: t.cardBorder.withOpacity(0.4)),
      boxShadow: [
        BoxShadow(
          color: t.cardBorder.withOpacity(0.1),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  Widget _contactRow({
    required IconData icon,
    required String label,
    required String value,
    required AppThemeExtension t,
    required bool showDivider,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Row(
              children: [
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: t.accentLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: t.accent, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 11,
                          color: t.label,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        value,
                        style: TextStyle(
                          fontSize: 14,
                          color: t.title,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded, size: 14, color: t.label),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(height: 1, color: t.divider, indent: 18, endIndent: 18),
      ],
    );
  }
}