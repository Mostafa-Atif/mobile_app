import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import 'package:mobile_app/screens/hotels/hotel_results.dart';
import 'package:mobile_app/theme.dart';
import 'package:provider/provider.dart';
import 'guests_picker.dart';

class HotelSearch extends StatefulWidget {
  @override
  _HotelSearchState createState() => _HotelSearchState();
}

class _HotelSearchState extends State<HotelSearch> {
  String selectedDestination = '';
  String searchType = 'country';
  DateTime checkInDate = DateTime.now();
  DateTime checkOutDate = DateTime.now().add(const Duration(days: 1));
  Map<String, List<String>> countryCityMap = {};
  List<RoomData> roomsList = [RoomData(adults: 2, children: 0)];

  @override
  void initState() {
    super.initState();
    loadDestinations();
  }

  Future<void> loadDestinations() async {
    final String jsonString = await rootBundle.loadString('assets/hotels.json');
    final List<dynamic> jsonData = json.decode(jsonString);
    Map<String, List<String>> map = {};
    for (var hotel in jsonData) {
      final country = hotel["country"]["en"].toString();
      final city = hotel["city"]["en"].toString();
      if (!map.containsKey(country)) map[country] = [];
      if (!map[country]!.contains(city)) map[country]!.add(city);
    }
    setState(() {
      countryCityMap = map;
      selectedDestination = map.keys.first;
      searchType = 'country';
    });
  }

  void showDestinationPicker(AppLocalizations l, AppThemeExtension t) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: BoxDecoration(
            color: t.card,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: t.cardBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    l.whereToQuestion,
                    style: TextStyle(
                      color: t.title,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'DM Serif Display',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: countryCityMap.entries.expand((entry) {
                    return [
                      ListTile(
                        title: Text(entry.key,
                            style: TextStyle(
                              color: t.title,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            )),
                        leading: Icon(Icons.public, color: t.accent),
                        onTap: () {
                          setState(() {
                            selectedDestination = entry.key;
                            searchType = 'country';
                          });
                          Navigator.pop(context);
                        },
                      ),
                      ...entry.value.map((city) => ListTile(
                        contentPadding: const EdgeInsets.only(left: 32),
                        title: Text(city,
                            style: TextStyle(color: t.sub, fontSize: 15)),
                        leading: Icon(Icons.location_city,
                            color: t.cardBorder, size: 20),
                        onTap: () {
                          setState(() {
                            selectedDestination = city;
                            searchType = 'city';
                          });
                          Navigator.pop(context);
                        },
                      )),
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

  Future<void> selectDate(BuildContext context, bool isCheckIn, AppThemeExtension t) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isCheckIn ? checkInDate : checkOutDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: ColorScheme.dark(
            primary: t.accent,
            surface: t.card,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          checkInDate = picked;
          if (checkOutDate.isBefore(checkInDate) ||
              checkOutDate.isAtSameMomentAs(checkInDate)) {
            checkOutDate = checkInDate.add(const Duration(days: 1));
          }
        } else {
          checkOutDate = picked;
        }
      });
    }
  }

  String formatDate(DateTime date) {
    const months = ['Jan','Feb','Mar','Apr','May','Jun',
                    'Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${date.day} ${months[date.month - 1]}';
  }

  String formatGuests() {
    int totalAdults = roomsList.fold(0, (sum, r) => sum + r.adults);
    return '$totalAdults ${totalAdults > 1 ? 'Adults' : 'Adult'} · ${roomsList.length} ${roomsList.length > 1 ? 'Rooms' : 'Room'}';
  }

  void showGuestsPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return GuestsPicker(
          initialRooms: roomsList,
          onDone: (newRooms) => setState(() => roomsList = newRooms),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<AppThemeExtension>()!;
    final l = AppLocalizations.of(context)!;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      backgroundColor: t.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // ── Header ──
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        color: t.backBg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        isAr ? Icons.arrow_forward : Icons.arrow_back,
                        color: t.backIcon,
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                   crossAxisAlignment: CrossAxisAlignment.center,
                   children: [
                      Text(
                         l.searchStays,
                         textAlign: TextAlign.center,
                         style: TextStyle(
                         color: t.title,
                         fontSize: 20,
                          fontWeight: FontWeight.bold,
                            ),
                         ),
                     Text(
                      l.overOneMillion,
                      textAlign: TextAlign.center,
                        style: TextStyle(color: t.label, fontSize: 13),
                         ),
                       ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // ── Unified form card ──
              Container(
                decoration: BoxDecoration(
                  color: t.card,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: t.cardBorder.withOpacity(0.4)),
                  boxShadow: [
                    BoxShadow(
                      color: t.cardBorder.withOpacity(0.15),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [

                    // ── Destination ──
                    GestureDetector(
                      onTap: () => showDestinationPicker(l, t),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'DESTINATION',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: t.label,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    selectedDestination.isEmpty ? '...' : selectedDestination,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: t.title,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Tag chip
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: t.accentLight,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                searchType == 'country'
                                    ? (isAr ? 'دولة كاملة' : 'Entire\ncountry')
                                    : (isAr ? 'مدينة فقط' : 'City\nonly'),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: t.accent,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Divider(height: 1, color: t.divider),

                    // ── Check In / Check Out ──
                    IntrinsicHeight(
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => selectDate(context, true, t),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(20, 18, 12, 18),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'CHECK IN',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: t.label,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      formatDate(checkInDate),
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: t.title,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          VerticalDivider(width: 1, color: t.divider),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => selectDate(context, false, t),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'CHECK OUT',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: t.label,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      formatDate(checkOutDate),
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: t.title,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Divider(height: 1, color: t.divider),

                    // ── Guests ──
                    GestureDetector(
                      onTap: showGuestsPicker,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'GUESTS',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: t.label,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    formatGuests(),
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: t.title,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.keyboard_arrow_down, color: t.label),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── Search button ──
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HotelResults(
                        destination: selectedDestination,
                        searchType: searchType,
                        checkIn: checkInDate,
                        checkOut: checkOutDate,
                        numRooms: roomsList.length,
                        numAdults: roomsList.fold(0, (sum, r) => sum + r.adults),
                        numChildren: roomsList.fold(0, (sum, r) => sum + r.children),
                      ),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: t.btnGradient,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: t.accent.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      l.searchProperties,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
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
}