// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import 'package:mobile_app/theme.dart';

import 'hotel_booking.dart';

class HotelDetails extends StatefulWidget {
  final Map<String, dynamic> hotel;
  final DateTime checkIn;
  final DateTime checkOut;
  final int numRooms;
  final int numAdults;
  final int numChildren;

  const HotelDetails({
    super.key,
    required this.hotel,
    required this.checkIn,
    required this.checkOut,
    required this.numRooms,
    required this.numAdults,
    required this.numChildren,
  });

  @override
  State<HotelDetails> createState() => _HotelDetailsState();
}

class _HotelDetailsState extends State<HotelDetails> {
  AppThemeExtension get _t => Theme.of(context).extension<AppThemeExtension>()!;

  bool isFavorite = false;
  late DateTime checkInDate;
  late DateTime checkOutDate;
  late int numRooms;
  late int numAdults;
  late int numChildren;

  @override
  void initState() {
    super.initState();
    checkInDate = DateTime(widget.checkIn.year, widget.checkIn.month, widget.checkIn.day);
    checkOutDate = DateTime(widget.checkOut.year, widget.checkOut.month, widget.checkOut.day);
    numRooms = widget.numRooms;
    numAdults = widget.numAdults;
    numChildren = widget.numChildren;
  }

  int get nightCount => checkOutDate.difference(checkInDate).inDays;
  int get numPeople => numAdults + numChildren;

  String formatDate(DateTime date) {
    final locale = Localizations.localeOf(context).languageCode;
    return DateFormat('d MMM', locale).format(date);
  }

  IconData _viewIcon(String view) {
    switch (view) {
      case 'sea':
        return Icons.waves_rounded;
      case 'pool':
        return Icons.pool_rounded;
      case 'garden':
        return Icons.park_rounded;
      case 'city':
        return Icons.location_city_rounded;
      case 'mountain':
        return Icons.landscape_rounded;
      case 'river':
      case 'lake':
        return Icons.water_rounded;
      case 'harbor':
        return Icons.anchor_rounded;
      default:
        return Icons.visibility_rounded;
    }
  }

  String _viewLabel(String view) =>
      '${view[0].toUpperCase()}${view.substring(1)} ${AppLocalizations.of(context)!.view}';

  String _ratingLabel(int rating) {
    switch (rating) {
      case 5:
        return 'Exceptional';
      case 4:
        return 'Excellent';
      case 3:
        return 'Very Good';
      case 2:
        return 'Good';
      default:
        return 'Standard';
    }
  }

  Future<void> _pickCheckIn() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: checkInDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: _t.accent,
                surface: _t.card,
                onSurface: _t.title,
              ),
          dialogTheme: DialogThemeData(backgroundColor: _t.card),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        checkInDate = picked;
        if (!checkOutDate.isAfter(checkInDate)) {
          checkOutDate = checkInDate.add(Duration(days: 1));
        }
      });
    }
  }

  Future<void> _pickCheckOut() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: checkOutDate,
      firstDate: checkInDate.add(Duration(days: 1)),
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: _t.accent,
                surface: _t.card,
                onSurface: _t.title,
              ),
          dialogTheme: DialogThemeData(backgroundColor: _t.card),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() => checkOutDate = picked);
    }
  }

  void _openBooking() {
    final hotel = widget.hotel;
    final String name = hotel['title'] ?? '';
    final int price = int.tryParse(hotel['price'].toString()) ?? 0;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HotelBooking(
          hotelName: name,
          checkIn: checkInDate,
          checkOut: checkOutDate,
          numRooms: numRooms,
          numAdults: numAdults,
          numChildren: numChildren,
          pricePerNight: price,
          nights: nightCount,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final hotel = widget.hotel;
    final String name = hotel['title'] ?? '';
    final String subTitle = hotel['subTitle'] ?? '';
    final int rating = int.tryParse(hotel['rating'].toString()) ?? 0;
    final int price = int.tryParse(hotel['price'].toString()) ?? 0;
    final String imgUrl = hotel['imgUrl'] ?? '';
    final List<dynamic> views = hotel['views'] ?? [];
    final int totalPrice = price * nightCount * numRooms;

    return Scaffold(
      backgroundColor: _t.bg,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                elevation: 0,
                backgroundColor: _t.bg,
                surfaceTintColor: Colors.transparent,
                leadingWidth: 72,
                leading: Padding(
                  padding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
                  child: _iconShell(
                    icon: Icons.chevron_left_rounded,
                    onTap: () => Navigator.of(context).maybePop(),
                  ),
                ),
                actions: [
                  Padding(
                    padding: EdgeInsets.only(right: 16, top: 8, bottom: 8),
                    child: _iconShell(
                      icon: isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      iconColor: isFavorite ? AppColors.error : _t.title,
                      circular: true,
                      onTap: () => setState(() => isFavorite = !isFavorite),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        imgUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: _t.accentLight,
                          child: Center(
                            child: Icon(Icons.hotel_rounded, size: 56, color: _t.accent),
                          ),
                        ),
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.08),
                              Colors.transparent,
                              _t.bg.withOpacity(0.96),
                            ],
                            stops: [0, 0.45, 1],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 130),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _heroSummaryCard(name, subTitle, rating, price),
                      SizedBox(height: 14),
                      _sectionTitle(l.yourStay),
                      SizedBox(height: 10),
                      _stayCard(l),
                      SizedBox(height: 14),
                      _sectionTitle(l.roomsAndGuests),
                      SizedBox(height: 10),
                      _guestsCard(l),
                      if (views.isNotEmpty) ...[
                        SizedBox(height: 14),
                        _sectionTitle(l.views),
                        SizedBox(height: 10),
                        _viewsCard(views),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
          _bottomBar(l, price, totalPrice),
        ],
      ),
    );
  }

  Widget _heroSummaryCard(String name, String subTitle, int rating, int price) {
    return Container(
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _t.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _t.cardBorder.withOpacity(0.45)),
        boxShadow: _cardShadows(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        color: _t.title,
                        fontSize: 28,
                        height: 1,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'DM Serif Display',
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      subTitle,
                      style: TextStyle(
                        color: _t.label,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: _t.accentLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      '$rating',
                      style: TextStyle(
                        color: _t.accent,
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      _ratingLabel(rating),
                      style: TextStyle(
                        color: _t.accent,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: _t.accentLight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'SAR $price',
                  style: TextStyle(
                    color: _t.price,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.perNight,
                  style: TextStyle(
                    color: _t.label,
                    fontSize: 12,
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

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: _t.title,
        fontSize: 18,
        fontWeight: FontWeight.w400,
        fontFamily: 'DM Serif Display',
      ),
    );
  }

  Widget _stayCard(AppLocalizations l) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _t.card,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: _t.cardBorder.withOpacity(0.45)),
        boxShadow: _cardShadows(),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _dateTile(
                  label: l.checkIn,
                  value: formatDate(checkInDate),
                  onTap: _pickCheckIn,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: _t.accentLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.arrow_forward_rounded, color: _t.accent, size: 18),
                ),
              ),
              Expanded(
                child: _dateTile(
                  label: l.checkOut,
                  value: formatDate(checkOutDate),
                  onTap: _pickCheckOut,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              l.nights(nightCount),
              style: TextStyle(
                color: _t.label,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dateTile({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Ink(
          padding: EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: _t.field,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _t.fieldBorder.withOpacity(0.5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  color: _t.label,
                  fontSize: 9,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 6),
              Text(
                value,
                style: TextStyle(
                  color: _t.title,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _guestsCard(AppLocalizations l) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _t.card,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: _t.cardBorder.withOpacity(0.45)),
        boxShadow: _cardShadows(),
      ),
      child: Column(
        children: [
          _counterRow(
            l.rooms,
            numRooms,
            () {
              if (numRooms > 1) setState(() => numRooms--);
            },
            () => setState(() => numRooms++),
          ),
          Divider(color: _t.divider.withOpacity(0.45), height: 20),
          _counterRow(
            '${l.adults} (12+)',
            numAdults,
            () {
              if (numAdults > 1) setState(() => numAdults--);
            },
            () => setState(() => numAdults++),
          ),
          Divider(color: _t.divider.withOpacity(0.45), height: 20),
          _counterRow(
            '${l.children} (0-11)',
            numChildren,
            () {
              if (numChildren > 0) setState(() => numChildren--);
            },
            () => setState(() => numChildren++),
          ),
        ],
      ),
    );
  }

  Widget _counterRow(
    String label,
    int value,
    VoidCallback onDec,
    VoidCallback onInc,
  ) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: _t.title,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        _counterButton(Icons.remove_rounded, onDec),
        SizedBox(
          width: 36,
          child: Text(
            '$value',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _t.title,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        _counterButton(Icons.add_rounded, onInc),
      ],
    );
  }

  Widget _counterButton(IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Ink(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: _t.accentLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 18, color: _t.accent),
        ),
      ),
    );
  }

  Widget _viewsCard(List<dynamic> views) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: views
          .map(
            (view) => Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              decoration: BoxDecoration(
                color: _t.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _t.cardBorder.withOpacity(0.45)),
                boxShadow: _cardShadows(),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(_viewIcon(view.toString()), size: 16, color: _t.accent),
                  SizedBox(width: 6),
                  Text(
                    _viewLabel(view.toString()),
                    style: TextStyle(
                      color: _t.title,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _bottomBar(AppLocalizations l, int price, int totalPrice) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: EdgeInsets.fromLTRB(18, 14, 18, 26),
        decoration: BoxDecoration(
          color: _t.card.withOpacity(0.97),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          border: Border(top: BorderSide(color: _t.cardBorder.withOpacity(0.4))),
          boxShadow: _cardShadows(stronger: true),
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SAR $price${l.perNight}',
                      style: TextStyle(
                        color: _t.title,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      l.totalNightsRooms(totalPrice, nightCount, numRooms),
                      style: TextStyle(
                        color: _t.label,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: _t.btnGradient),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: _t.accent.withOpacity(0.28),
                      blurRadius: 18,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _openBooking,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets.symmetric(horizontal: 28, vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: Text(
                    l.bookNow,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconShell({
    required IconData icon,
    required VoidCallback onTap,
    Color? iconColor,
    bool circular = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(circular ? 21 : 12),
        ),
        onTap: onTap,
        child: Ink(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: _t.card.withOpacity(0.9),
            borderRadius: BorderRadius.circular(circular ? 21 : 12),
            border: Border.all(color: _t.cardBorder.withOpacity(0.25)),
          ),
          child: Icon(icon, color: iconColor ?? _t.backIcon, size: 24),
        ),
      ),
    );
  }

  List<BoxShadow> _cardShadows({bool stronger = false}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return [
      BoxShadow(
        color: isDark
            ? Colors.black.withOpacity(stronger ? 0.28 : 0.22)
            : _t.cardBorder.withOpacity(stronger ? 0.2 : 0.16),
        blurRadius: isDark ? (stronger ? 22 : 18) : (stronger ? 28 : 22),
        offset: Offset(0, stronger ? 12 : 10),
      ),
    ];
  }
}
