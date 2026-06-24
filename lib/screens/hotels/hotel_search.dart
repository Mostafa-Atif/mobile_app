// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/data/hotels_repository.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import 'package:mobile_app/screens/hotels/hotel_results.dart';
import 'package:mobile_app/theme.dart';

class RoomData {
  int adults;
  int children;

  RoomData({this.adults = 2, this.children = 0});
}

class HotelSearch extends StatefulWidget {
  const HotelSearch({super.key});

  @override
  _HotelSearchState createState() => _HotelSearchState();
}

class _HotelSearchState extends State<HotelSearch> {
  AppThemeExtension get _t => Theme.of(context).extension<AppThemeExtension>()!;
  final HotelsRepository _hotelsRepository = HotelsRepository();
  String? _activeLang;

  String selectedDestination = '';
  String searchType = 'country';
  DateTime checkInDate = DateTime.now();
  DateTime checkOutDate = DateTime.now().add(Duration(days: 1));
  Map<String, List<String>> countryCityMap = {};
  List<RoomData> roomsList = [RoomData(adults: 2, children: 0)];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final lang = Localizations.localeOf(context).languageCode;
    if (_activeLang != lang) {
      _activeLang = lang;
      loadDestinations();
    }
  }

  Future<void> loadDestinations() async {
    final lang = _activeLang ?? 'en';
    final map = await _hotelsRepository.loadCountryCityMap(lang);
    setState(() {
      countryCityMap = map;
      selectedDestination = map.keys.isNotEmpty ? map.keys.first : '';
      searchType = 'country';
    });
  }

  Future<void> selectDate(BuildContext context, bool isCheckIn) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isCheckIn ? checkInDate : checkOutDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
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
        if (isCheckIn) {
          checkInDate = picked;
          if (!checkOutDate.isAfter(checkInDate)) {
            checkOutDate = checkInDate.add(Duration(days: 1));
          }
        } else {
          checkOutDate = picked;
        }
      });
    }
  }

  String formatDate(DateTime date) {
    final locale = Localizations.localeOf(context).languageCode;
    final pattern = locale == 'ar' ? 'd MMM y' : 'd MMM, y';
    return DateFormat(pattern, locale).format(date);
  }

  int get totalAdults => roomsList.fold(0, (sum, r) => sum + r.adults);
  int get totalChildren => roomsList.fold(0, (sum, r) => sum + r.children);

  String formatGuests(AppLocalizations l) {
    return '${roomsList.length} ${roomsList.length > 1 ? l.rooms : l.room}, $totalAdults ${l.adults}, $totalChildren ${l.children}';
  }

  void addRoom() {
    setState(() {
      roomsList.add(RoomData(adults: 1, children: 0));
    });
  }

  void removeRoom(int index) {
    if (roomsList.length > 1) {
      setState(() {
        roomsList.removeAt(index);
      });
    }
  }

  void _openResults() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HotelResults(
          destination: selectedDestination,
          searchType: searchType,
          checkIn: checkInDate,
          checkOut: checkOutDate,
          numRooms: roomsList.length,
          numAdults: totalAdults,
          numChildren: totalChildren,
        ),
      ),
    );
  }

  void showDestinationPicker(AppLocalizations l) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: BoxDecoration(
            color: _t.bg,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              SizedBox(height: 12),
              Container(
                width: 42,
                height: 5,
                decoration: BoxDecoration(
                  color: _t.label.withOpacity(0.35),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              SizedBox(height: 18),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      l.destination.toUpperCase(),
                      style: TextStyle(
                        color: _t.accent,
                        fontSize: 10,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 6),
                    Text(
                      l.whereToQuestion,
                      style: TextStyle(
                        color: _t.title,
                        fontSize: 28,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'DM Serif Display',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  children: countryCityMap.entries.expand((entry) {
                    return [
                      _destinationTile(
                        icon: Icons.public_rounded,
                        title: entry.key,
                        subtitle: l.entireCountry,
                        selected: searchType == 'country' &&
                            selectedDestination == entry.key,
                        onTap: () {
                          setState(() {
                            selectedDestination = entry.key;
                            searchType = 'country';
                          });
                          Navigator.pop(context);
                        },
                      ),
                      ...entry.value.map(
                        (city) => Padding(
                          padding: EdgeInsetsDirectional.only(start: 18),
                          child: _destinationTile(
                            icon: Icons.location_city_rounded,
                            title: city,
                            subtitle: l.cityOnly,
                            selected: searchType == 'city' &&
                                selectedDestination == city,
                            onTap: () {
                              setState(() {
                                selectedDestination = city;
                                searchType = 'city';
                              });
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                    ];
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: _t.bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  _iconShell(
                    icon: Icons.chevron_left_rounded,
                    onTap: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          l.searchStays,
                          style: TextStyle(
                            color: _t.title,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          l.overOneMillion,
                          style: TextStyle(
                            color: _t.label,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 42),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(16, 18, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // "Where to?" and "Search Stays" removed here
                    Container(
                      padding: EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: _t.card,
                        borderRadius: BorderRadius.circular(28),
                        border:
                            Border.all(color: _t.cardBorder.withOpacity(0.45)),
                        boxShadow: _cardShadows(),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionHeader(l.destination, l.searchProperties),
                          SizedBox(height: 16),
                          _searchTile(
                            icon: Icons.location_on_rounded,
                            title: selectedDestination.isEmpty
                                ? '...'
                                : selectedDestination,
                            subtitle: searchType == 'country'
                                ? l.entireCountry
                                : l.cityOnly,
                            onTap: () => showDestinationPicker(l),
                            trailing: Icons.keyboard_arrow_down_rounded,
                          ),
                          SizedBox(height: 14),
                          _fieldLabel(l.dates),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: _dateTile(
                                  label: l.checkIn,
                                  value: formatDate(checkInDate),
                                  icon: Icons.login_rounded,
                                  onTap: () => selectDate(context, true),
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
                                  child: Icon(Icons.arrow_forward_rounded,
                                      color: _t.accent, size: 18),
                                ),
                              ),
                              Expanded(
                                child: _dateTile(
                                  label: l.checkOut,
                                  value: formatDate(checkOutDate),
                                  icon: Icons.logout_rounded,
                                  onTap: () => selectDate(context, false),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 14),
                          _fieldLabel(l.guests),
                          SizedBox(height: 8),
                          _summaryTile(
                            icon: Icons.people_alt_outlined,
                            title: formatGuests(l),
                            subtitle: l.maxGuestsPerRoom,
                          ),
                          SizedBox(height: 12),
                          ...List.generate(
                            roomsList.length,
                            (index) => Padding(
                              padding: EdgeInsets.only(bottom: 12),
                              child: _roomCard(index, l),
                            ),
                          ),
                          SizedBox(height: 4),
                          OutlinedButton.icon(
                            onPressed: addRoom,
                            icon: Icon(Icons.add_circle_outline,
                                color: _t.accent),
                            label: Text(
                              l.addAnotherRoom,
                              style: TextStyle(
                                color: _t.accent,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: _t.accent,
                              side: BorderSide(
                                  color: _t.cardBorder.withOpacity(0.55)),
                              minimumSize: Size(double.infinity, 52),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                          ),
                          SizedBox(height: 18),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: _t.btnGradient),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: _t.accent.withOpacity(0.28),
                                  blurRadius: 18,
                                  offset: Offset(0, 8),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: _openResults,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                minimumSize: Size(double.infinity, 58),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.search_rounded,
                                      color: Colors.white, size: 22),
                                  SizedBox(width: 10),
                                  Text(
                                    l.searchProperties,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _roomCard(int index, AppLocalizations l) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _t.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _t.cardBorder.withOpacity(0.45)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: _t.accentLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.bed_rounded, color: _t.accent, size: 18),
                  ),
                  SizedBox(width: 10),
                  Text(
                    '${l.room} ${index + 1}',
                    style: TextStyle(
                      color: _t.title,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              if (roomsList.length > 1)
                TextButton(
                  onPressed: () => removeRoom(index),
                  child: Text(
                    l.remove,
                    style: TextStyle(
                      color: AppColors.error,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 14),
          _counterRow(
            '${l.adults} (12+)',
            roomsList[index].adults,
            () {
              if (roomsList[index].adults > 1) {
                setState(() => roomsList[index].adults--);
              }
            },
            () {
              if (roomsList[index].adults + roomsList[index].children < 4) {
                setState(() => roomsList[index].adults++);
              }
            },
          ),
          SizedBox(height: 12),
          _counterRow(
            '${l.children} (0-11)',
            roomsList[index].children,
            () {
              if (roomsList[index].children > 0) {
                setState(() => roomsList[index].children--);
              }
            },
            () {
              if (roomsList[index].adults + roomsList[index].children < 4) {
                setState(() => roomsList[index].children++);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _counterRow(
    String label,
    int value,
    VoidCallback onDecrease,
    VoidCallback onIncrease,
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
        _counterButton(Icons.remove_rounded, onDecrease),
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
        _counterButton(Icons.add_rounded, onIncrease),
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

  Widget _fieldLabel(String label) {
    return Text(
      label.toUpperCase(),
      style: TextStyle(
        color: _t.label,
        fontSize: 9,
        letterSpacing: 1.6,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _searchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    IconData? trailing,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Ink(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _t.card,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: _t.cardBorder.withOpacity(0.45)),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: _t.accentLight,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: _t.accent),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: _t.title,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: _t.accent,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing != null) Icon(trailing, color: _t.label),
            ],
          ),
        ),
      ),
    );
  }

  Widget _summaryTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _t.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _t.cardBorder.withOpacity(0.45)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: _t.accentLight,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: _t.accent),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: _t.title,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: _t.label,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dateTile({
    required String label,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Ink(
          padding: EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: _t.card,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: _t.cardBorder.withOpacity(0.45)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 14, color: _t.accent),
                  SizedBox(width: 4),
                  Text(
                    label,
                    style: TextStyle(
                      color: _t.label,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  color: _t.title,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _destinationTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Ink(
            padding: EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: selected ? _t.accentLight : _t.card,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: _t.cardBorder.withOpacity(0.45)),
            ),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: _t.accentLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: _t.accent, size: 20),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: _t.title,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: _t.label,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, String subtitle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: _t.title,
            fontSize: 20,
            fontWeight: FontWeight.w400,
            fontFamily: 'DM Serif Display',
          ),
        ),
        Text(
          subtitle,
          style: TextStyle(
            color: _t.accent,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _iconShell({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        onTap: onTap,
        child: Ink(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: _t.card.withOpacity(0.9),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _t.cardBorder.withOpacity(0.25)),
          ),
          child: Icon(icon, color: _t.backIcon, size: 24),
        ),
      ),
    );
  }

  List<BoxShadow> _cardShadows() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return [
      BoxShadow(
        color: isDark
            ? Colors.black.withOpacity(0.22)
            : _t.cardBorder.withOpacity(0.16),
        blurRadius: isDark ? 18 : 22,
        offset: Offset(0, 10),
      ),
    ];
  }
}
