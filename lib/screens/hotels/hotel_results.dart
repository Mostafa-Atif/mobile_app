// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:mobile_app/data/hotels_repository.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import 'package:mobile_app/screens/hotels/hotel_details.dart';
import 'package:mobile_app/theme.dart';

class HotelResults extends StatefulWidget {
  final String destination;
  final DateTime checkIn;
  final DateTime checkOut;
  final int numRooms;
  final int numAdults;
  final int numChildren;
  final String searchType;

  const HotelResults({
    super.key,
    required this.destination,
    required this.checkIn,
    required this.checkOut,
    required this.numRooms,
    required this.numAdults,
    required this.numChildren,
    required this.searchType,
  });

  @override
  State<HotelResults> createState() => _HotelResultsState();
}

class _HotelResultsState extends State<HotelResults> {
  AppThemeExtension get _t => Theme.of(context).extension<AppThemeExtension>()!;
  final HotelsRepository _hotelsRepository = HotelsRepository();
  String? _activeLang;

  List<Map<String, dynamic>> allHotels = [];
  List<Map<String, dynamic>> filteredHotels = [];
  bool isLoading = true;
  bool hasError = false;

  String searchQuery = '';
  String? selectedRating;
  String? selectedView;
  String? sortOption;

  final TextEditingController searchController = TextEditingController();

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
      loadHotels();
    }
  }

  Future<void> loadHotels() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });
    try {
      final lang = _activeLang ?? 'en';
      final l = AppLocalizations.of(context)!;
      final loaded = await _hotelsRepository.loadSearchResults(
        lang: lang,
        destination: widget.destination,
        searchType: widget.searchType,
        reviewsLabel: l.hotelSeeReviews,
      );

      setState(() {
        allHotels = loaded;
        filteredHotels = loaded;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
      });
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void applyFilters() {
    List<Map<String, dynamic>> result = List.from(allHotels);

    if (searchQuery.isNotEmpty) {
      result = result
          .where((h) => h['title']
              .toString()
              .toLowerCase()
              .contains(searchQuery.toLowerCase()))
          .toList();
    }
    if (selectedRating != null) {
      result = result.where((h) => h['rating'].toString() == selectedRating).toList();
    }
    if (selectedView != null) {
      result = result.where((h) => (h['views'] as List).contains(selectedView)).toList();
    }
    if (sortOption == 'priceLow') {
      result.sort((a, b) => int.parse(a['price']).compareTo(int.parse(b['price'])));
    } else if (sortOption == 'priceHigh') {
      result.sort((a, b) => int.parse(b['price']).compareTo(int.parse(a['price'])));
    } else if (sortOption == 'rating') {
      result.sort((a, b) => int.parse(b['rating']).compareTo(int.parse(a['rating'])));
    }

    setState(() => filteredHotels = result);
  }

  void showSortSheet(AppLocalizations l) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return _sheetShell(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sheetHeader(l.sortBy),
              ...{
                'priceLow': l.priceLowToHigh,
                'priceHigh': l.priceHighToLow,
                'rating': l.rating,
              }.entries.map((e) {
                final selected = sortOption == e.key;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    e.value,
                    style: TextStyle(color: _t.title, fontWeight: FontWeight.w700),
                  ),
                  trailing: selected ? Icon(Icons.check_rounded, color: _t.accent) : null,
                  onTap: () {
                    setState(() => sortOption = selected ? null : e.key);
                    applyFilters();
                    Navigator.pop(context);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void showFilterSheet(AppLocalizations l) {
    final views = allHotels.expand((h) => h['views'] as List).toSet().cast<String>().toList()..sort();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        String? tempRating = selectedRating;
        String? tempView = selectedView;

        return StatefulBuilder(
          builder: (ctx, setSheet) {
            return _sheetShell(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sheetHeader(l.filter),
                  Text(
                    l.propertyRating,
                    style: TextStyle(color: _t.title, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ['5', '4'].map((r) {
                      final selected = tempRating == r;
                      return ChoiceChip(
                        label: Text('$r *'),
                        selected: selected,
                        selectedColor: _t.accent,
                        backgroundColor: _t.card,
                        side: BorderSide(color: _t.cardBorder.withOpacity(0.5)),
                        labelStyle: TextStyle(
                          color: selected ? Colors.white : _t.title,
                          fontWeight: FontWeight.w700,
                        ),
                        onSelected: (_) => setSheet(() => tempRating = selected ? null : r),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16),
                  Text(
                    l.view,
                    style: TextStyle(color: _t.title, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: views.map((v) {
                      final selected = tempView == v;
                      return ChoiceChip(
                        label: Text(v[0].toUpperCase() + v.substring(1)),
                        selected: selected,
                        selectedColor: _t.accent,
                        backgroundColor: _t.card,
                        side: BorderSide(color: _t.cardBorder.withOpacity(0.5)),
                        labelStyle: TextStyle(
                          color: selected ? Colors.white : _t.title,
                          fontWeight: FontWeight.w700,
                        ),
                        onSelected: (_) => setSheet(() => tempView = selected ? null : v),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              selectedRating = null;
                              selectedView = null;
                            });
                            applyFilters();
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _t.accent,
                            side: BorderSide(color: _t.cardBorder.withOpacity(0.6)),
                            minimumSize: Size.fromHeight(48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(l.clearAll),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedRating = tempRating;
                              selectedView = tempView;
                            });
                            applyFilters();
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _t.accent,
                            foregroundColor: Colors.white,
                            minimumSize: Size.fromHeight(48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(l.apply),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  bool get hasActiveFilters => selectedRating != null || selectedView != null;

  Widget _buildError(AppLocalizations l) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off_rounded, size: 60, color: _t.label.withOpacity(0.6)),
            SizedBox(height: 16),
            Text(
              l.unableToConnect,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: _t.title,
              ),
            ),
            SizedBox(height: 8),
            Text(
              l.checkConnectionRetry,
              style: TextStyle(color: _t.label, fontSize: 13),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: loadHotels,
              icon: Icon(Icons.refresh_rounded),
              label: Text(l.retry),
              style: ElevatedButton.styleFrom(
                shape: StadiumBorder(),
                backgroundColor: _t.accent,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    if (isLoading) {
      return Scaffold(
        backgroundColor: _t.bg,
        body: Center(child: CircularProgressIndicator(color: _t.accent)),
      );
    }
    if (hasError) {
      return Scaffold(
        backgroundColor: _t.bg,
        body: _buildError(l),
      );
    }

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
                          widget.destination,
                          style: TextStyle(
                            color: _t.title,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          '${widget.checkIn.day}/${widget.checkIn.month} - ${widget.checkOut.day}/${widget.checkOut.month} · ${widget.numRooms} ${l.room}, ${widget.numAdults} ${l.adults}, ${widget.numChildren} ${l.children}',
                          style: TextStyle(
                            color: _t.label,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 42),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 18, 16, 0),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: _t.card,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: _t.cardBorder.withOpacity(0.45)),
                            boxShadow: _cardShadows(),
                          ),
                          child: TextField(
                            controller: searchController,
                            onChanged: (val) {
                              searchQuery = val;
                              applyFilters();
                            },
                            style: TextStyle(color: _t.title),
                            decoration: InputDecoration(
                              hintText: l.searchByHotelName,
                              hintStyle: TextStyle(color: _t.label),
                              border: InputBorder.none,
                              prefixIcon: Icon(Icons.search_rounded, color: _t.label),
                              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                              suffixIcon: searchQuery.isNotEmpty
                                  ? IconButton(
                                      icon: Icon(Icons.clear_rounded, color: _t.label),
                                      onPressed: () {
                                        searchController.clear();
                                        searchQuery = '';
                                        applyFilters();
                                      },
                                    )
                                  : null,
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _actionChip(
                                Icons.swap_vert_rounded,
                                l.sortBy,
                                sortOption != null,
                                () => showSortSheet(l),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: _actionChip(
                                Icons.tune_rounded,
                                l.filter,
                                hasActiveFilters,
                                () => showFilterSheet(l),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          l.propertiesFound(filteredHotels.length, widget.destination),
                          style: TextStyle(color: _t.label, fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Expanded(
                    child: filteredHotels.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.search_off_rounded, size: 48, color: _t.label.withOpacity(0.5)),
                                SizedBox(height: 12),
                                Text(l.noPropertiesMatch, style: TextStyle(color: _t.label)),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.fromLTRB(16, 0, 16, 20),
                            itemCount: filteredHotels.length,
                            itemBuilder: (context, index) =>
                                _buildHotelCard(filteredHotels[index], l),
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

  Widget _actionChip(IconData icon, String label, bool active, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Ink(
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: active ? _t.accentLight : _t.card,
            border: Border.all(
              color: active ? _t.accent : _t.cardBorder.withOpacity(0.45),
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: active ? _t.accent : _t.label),
              SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: active ? _t.accent : _t.title,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHotelCard(Map<String, dynamic> hotel, AppLocalizations l) {
    final title = hotel["title"];
    final subTitle = hotel["subTitle"];
    final rating = hotel["rating"];
    final price = hotel["price"];
    final imgUrl = hotel["imgUrl"];
    final isFavorite = hotel["isFavorite"] as bool;
    final allIndex = allHotels.indexOf(hotel);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HotelDetails(
              hotel: hotel,
              checkIn: widget.checkIn,
              checkOut: widget.checkOut,
              numRooms: widget.numRooms,
              numAdults: widget.numAdults,
              numChildren: widget.numChildren,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 18),
        decoration: BoxDecoration(
          color: _t.card,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: _t.cardBorder.withOpacity(0.45)),
          boxShadow: _cardShadows(),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
                  child: Image.network(
                    imgUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 200,
                      width: double.infinity,
                      color: _t.accentLight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.hotel_rounded, size: 48, color: _t.accent),
                          SizedBox(height: 8),
                          Text(
                            title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _t.title,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withOpacity(0.18)],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        setState(() {
                          if (allIndex != -1) {
                            allHotels[allIndex]["isFavorite"] = !isFavorite;
                          }
                          hotel["isFavorite"] = !isFavorite;
                        });
                      },
                      child: Ink(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.88),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          color: isFavorite ? AppColors.error : _t.title,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'DM Serif Display',
                            color: _t.title,
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          color: _t.accentLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Text(
                              rating,
                              style: TextStyle(color: _t.accent, fontWeight: FontWeight.w800),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.star_rounded, color: _t.accent, size: 14),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    subTitle,
                    style: TextStyle(color: _t.label, fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'SAR $price',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: _t.price,
                    ),
                  ),
                  Text(
                    l.totalPriceOneNight,
                    style: TextStyle(color: _t.label, fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sheetShell({required Widget child}) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 14, 20, 20),
      decoration: BoxDecoration(
        color: _t.bg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(top: false, child: child),
    );
  }

  Widget _sheetHeader(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: _t.label.withOpacity(0.35),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        ),
        SizedBox(height: 16),
        Text(
          title,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w400,
            fontFamily: 'DM Serif Display',
            color: _t.title,
          ),
        ),
        SizedBox(height: 14),
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
        color: isDark ? Colors.black.withOpacity(0.22) : _t.cardBorder.withOpacity(0.16),
        blurRadius: isDark ? 18 : 22,
        offset: Offset(0, 10),
      ),
    ];
  }
}
