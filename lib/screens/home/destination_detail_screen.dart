// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_app/data/destinations_repository.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import 'package:mobile_app/theme.dart';

class DestinationDetailScreen extends StatelessWidget {
  const DestinationDetailScreen({
    super.key,
    this.destinationName,
    this.destinationData,
  }) : assert(destinationName != null || destinationData != null);

  final String? destinationName;
  final Map<String, dynamic>? destinationData;
  static final DestinationsRepository _destinationsRepository =
  DestinationsRepository();

  Future<Map<String, dynamic>> _loadDestination() async {
    if (destinationData != null) return destinationData!;
    return _destinationsRepository.loadDestinationByName(destinationName!);
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<AppThemeExtension>()!;
    final l = AppLocalizations.of(context)!;

    return FutureBuilder<Map<String, dynamic>>(
      future: _loadDestination(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: t.bg,
            body: Center(child: CircularProgressIndicator(color: t.accent)),
          );
        }
        return _DestinationDetailView(data: snapshot.data!, t: t, l: l);
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _DestinationDetailView extends StatefulWidget {
  const _DestinationDetailView({
    required this.data,
    required this.t,
    required this.l,
  });

  final Map<String, dynamic> data;
  final AppThemeExtension t;
  final AppLocalizations l;

  @override
  State<_DestinationDetailView> createState() => _DestinationDetailViewState();
}

class _DestinationDetailViewState extends State<_DestinationDetailView> {
  final ScrollController _scrollController = ScrollController();
  bool _appBarSolid = false;

  AppThemeExtension get t => widget.t;
  AppLocalizations get l => widget.l;
  bool get isAr => Localizations.localeOf(context).languageCode == 'ar';

  // Scroll distance before the app bar goes fully solid
  static const double _solidThreshold = 260.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final shouldBeSolid = _scrollController.offset > _solidThreshold;
      if (shouldBeSolid != _appBarSolid) {
        setState(() => _appBarSolid = shouldBeSolid);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    final nameEn = data['nameEn'] as String;
    final nameAr = data['nameAr'] as String;
    final countryEn = data['countryEn'] as String;
    final countryAr = data['countryAr'] as String;
    final descriptionEn = data['descriptionEn'] as String;
    final descriptionAr = data['descriptionAr'] as String;
    final imageUrl = data['imageUrl'] as String;
    final websiteUrl = data['websiteUrl'] as String;

    final name = isAr ? nameAr : nameEn;
    final country = isAr ? countryAr : countryEn;
    final description = isAr ? descriptionAr : descriptionEn;

    final heroHeight = MediaQuery.of(context).size.height * 0.48;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final infoSections = [
      {
        'icon': Icons.wb_sunny_outlined,
        'title': l.destinationBestTimeTitle,
        'body': isAr
            ? l.destinationBestTimeBody(nameAr)
            : l.destinationBestTimeBody(nameEn),
      },
      {
        'icon': Icons.restaurant_outlined,
        'title': l.destinationCuisineTitle,
        'body': isAr
            ? l.destinationCuisineBody(nameAr)
            : l.destinationCuisineBody(nameEn),
      },
      {
        'icon': Icons.hotel_outlined,
        'title': l.destinationStayTitle,
        'body': l.destinationStayBody,
      },
      {
        'icon': Icons.attractions_outlined,
        'title': l.destinationAttractionsTitle,
        'body': isAr
            ? l.destinationAttractionsBody(nameAr)
            : l.destinationAttractionsBody(nameEn),
      },
    ];

    return Scaffold(
      backgroundColor: t.bg,
      extendBodyBehindAppBar: true,

      // ── App bar: fully transparent OR fully solid — never in-between ──────
      appBar: AppBar(
        backgroundColor: _appBarSolid ? t.bg : Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        bottom: _appBarSolid
            ? PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(
            height: 1,
            thickness: 1,
            color: t.cardBorder.withOpacity(0.35),
          ),
        )
            : null,
        systemOverlayStyle: _appBarSolid
            ? (isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark)
            : SystemUiOverlayStyle.light,
        leadingWidth: 64,
        leading: Padding(
          padding: EdgeInsets.only(left: 16),
          child: _BackButton(t: t, overImage: !_appBarSolid),
        ),
        // Title only appears once the bar is solid — no fade artifact
        title: _appBarSolid
            ? Text(
          name,
          style: TextStyle(
            color: t.title,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        )
            : null,
      ),

      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Hero ─────────────────────────────────────────────────────────
            SizedBox(
              height: heroHeight,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: t.card),
                  ),

                  // Three-stop gradient: clear → dark → bg color
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.38, 0.80, 1.0],
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.52),
                          t.bg,
                        ],
                      ),
                    ),
                  ),

                  // Name + country pill, anchored to bottom of hero
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: t.accent.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.location_on_rounded,
                                  color: Colors.white, size: 12),
                              SizedBox(width: 4),
                              Text(
                                country,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        // Bold system font — renders crisply over images
                        // on all screen densities, unlike serif display fonts
                        Text(
                          name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.w800,
                            height: 1.15,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Body ─────────────────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.75,
                      color: t.sub,
                    ),
                  ),

                  SizedBox(height: 24),
                  _WebsiteCard(url: websiteUrl, t: t, l: l),
                  SizedBox(height: 28),

                  // Section label
                  Text(
                    l.destinationAttractionsTitle
                        .toUpperCase(),
                    style: TextStyle(
                      color: t.accent,
                      fontSize: 10,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    l.destinationBestTimeTitle,
                    style: TextStyle(
                      color: t.title,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                    ),
                  ),

                  SizedBox(height: 14),

                  ...infoSections.map(
                        (s) => Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: _InfoCard(
                        icon: s['icon'] as IconData,
                        title: s['title'] as String,
                        body: s['body'] as String,
                        t: t,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Back button ───────────────────────────────────────────────────────────────

class _BackButton extends StatelessWidget {
  const _BackButton({required this.t, required this.overImage});
  final AppThemeExtension t;
  final bool overImage;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        customBorder:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onTap: () => Navigator.pop(context),
        child: Ink(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: overImage
                ? Colors.black.withOpacity(0.32)
                : t.card.withOpacity(0.9),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: overImage
                  ? Colors.white.withOpacity(0.2)
                  : t.cardBorder.withOpacity(0.25),
            ),
          ),
          child: Icon(
            Icons.chevron_left_rounded,
            color: overImage ? Colors.white : t.backIcon,
            size: 24,
          ),
        ),
      ),
    );
  }
}

// ── Website card ──────────────────────────────────────────────────────────────

class _WebsiteCard extends StatelessWidget {
  const _WebsiteCard({required this.url, required this.t, required this.l});
  final String url;
  final AppThemeExtension t;
  final AppLocalizations l;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: t.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: t.cardBorder.withOpacity(0.45)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: t.accentLight,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.language_rounded, color: t.accent, size: 22),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.homeOfficialWebsite,
                  style: TextStyle(
                    color: t.label,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
                SizedBox(height: 3),
                SelectableText(
                  url,
                  style: TextStyle(
                    color: t.accent,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Expandable info card ──────────────────────────────────────────────────────

class _InfoCard extends StatefulWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.body,
    required this.t,
  });
  final IconData icon;
  final String title;
  final String body;
  final AppThemeExtension t;

  @override
  State<_InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<_InfoCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final t = widget.t;

    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 240),
        curve: Curves.easeInOut,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _expanded ? t.accentLight : t.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _expanded
                ? t.accent.withOpacity(0.28)
                : t.cardBorder.withOpacity(0.45),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: _expanded ? t.accent : t.accentLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    widget.icon,
                    color: _expanded ? Colors.white : t.accent,
                    size: 19,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      color: t.title,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                AnimatedRotation(
                  turns: _expanded ? 0.5 : 0,
                  duration: Duration(milliseconds: 240),
                  curve: Curves.easeInOut,
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: t.label,
                    size: 22,
                  ),
                ),
              ],
            ),
            AnimatedCrossFade(
              firstChild: SizedBox.shrink(),
              secondChild: Padding(
                padding: EdgeInsets.only(top: 12),
                child: Text(
                  widget.body,
                  style: TextStyle(
                    color: t.sub,
                    fontSize: 14,
                    height: 1.65,
                  ),
                ),
              ),
              crossFadeState: _expanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: Duration(milliseconds: 220),
              sizeCurve: Curves.easeInOut,
            ),
          ],
        ),
      ),
    );
  }
}