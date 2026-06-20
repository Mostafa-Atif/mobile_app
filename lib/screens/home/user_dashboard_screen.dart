import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app/config.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import 'package:mobile_app/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum BookingFilter { all, flight, hotel, car }

class UserDashboardScreen extends StatefulWidget {
  const UserDashboardScreen({super.key});

  @override
  State<UserDashboardScreen> createState() => _UserDashboardScreenState();
}

class _UserDashboardScreenState extends State<UserDashboardScreen> {
  BookingFilter _activeFilter = BookingFilter.all;
  bool _isLoading = true;
  String? _error;
  List<_BookingCardData> _bookings = const [];

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      if (token.isEmpty) {
        throw Exception('Missing token');
      }

      final response = await http.get(
        Uri.parse('${Config.baseUrl}/api/my-bookings'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode != 200) {
        final body = json.decode(response.body) as Map<String, dynamic>;
        throw Exception(body['message'] ?? 'Failed to load bookings');
      }

      final data = json.decode(response.body) as Map<String, dynamic>;
      final hotels = (data['hotelBookings'] as List<dynamic>? ?? const [])
          .map((item) =>
              _BookingCardData.fromHotel(item as Map<String, dynamic>))
          .toList();
      final cars = (data['carBookings'] as List<dynamic>? ?? const [])
          .map((item) => _BookingCardData.fromCar(item as Map<String, dynamic>))
          .toList();
      final flights = (data['flightBookings'] as List<dynamic>? ?? const [])
          .map((item) =>
              _BookingCardData.fromFlight(item as Map<String, dynamic>))
          .toList();

      final merged = [...flights, ...hotels, ...cars]
        ..sort((a, b) => b.primaryDate.compareTo(a.primaryDate));

      if (!mounted) return;
      setState(() {
        _bookings = merged;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final t = Theme.of(context).extension<AppThemeExtension>()!;
    final filtered = _filteredBookings();

    return Scaffold(
      backgroundColor: t.bg,
      body: RefreshIndicator(
        onRefresh: _loadBookings,
        color: t.accent,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: _DashboardHero(
                title: l.userDashboardTitle,
                subtitle: l.userDashboardSubtitle,
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: _StatsRow(bookings: _bookings),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: _FilterRow(
                  activeFilter: _activeFilter,
                  counts: _FilterCounts.fromBookings(_bookings),
                  onChanged: (filter) => setState(() => _activeFilter = filter),
                ),
              ),
            ),
            if (_isLoading)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_error != null)
              SliverFillRemaining(
                hasScrollBody: false,
                child: _ErrorState(
                  message: _error!,
                  onRetry: _loadBookings,
                ),
              )
            else if (filtered.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: _EmptyState(),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                sliver: SliverList.separated(
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    return _BookingCard(booking: filtered[index]);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<_BookingCardData> _filteredBookings() {
    switch (_activeFilter) {
      case BookingFilter.flight:
        return _bookings
            .where((item) => item.type == BookingFilter.flight)
            .toList();
      case BookingFilter.hotel:
        return _bookings
            .where((item) => item.type == BookingFilter.hotel)
            .toList();
      case BookingFilter.car:
        return _bookings
            .where((item) => item.type == BookingFilter.car)
            .toList();
      case BookingFilter.all:
        return _bookings;
    }
  }
}

class _DashboardHero extends StatelessWidget {
  const _DashboardHero({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<AppThemeExtension>()!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final startColor = isDark ? t.header : t.title;
    final endColor = isDark ? t.card : t.accent;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [startColor, endColor],
        ),
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(isDark ? 0.08 : 0.14),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.white.withOpacity(isDark ? 0.10 : 0.18),
                ),
              ),
              child: IconButton(
                onPressed: () => Navigator.maybePop(context),
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.white.withOpacity(0.78),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.bookings});

  final List<_BookingCardData> bookings;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final t = Theme.of(context).extension<AppThemeExtension>()!;
    final confirmed =
        bookings.where((item) => item.status == 'confirmed').length;
    final completed =
        bookings.where((item) => item.status == 'completed').length;
    final pending = bookings.where((item) => item.status == 'pending').length;

    final stats = [
      (l.userDashboardTotal, bookings.length),
      (l.userDashboardConfirmed, confirmed),
      (l.userDashboardCompleted, completed),
      (l.userDashboardPending, pending),
    ];

    return SizedBox(
      height: 96,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: stats.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final stat = stats[index];
          return Container(
            width: 140,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: t.card,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: t.cardBorder.withOpacity(0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stat.$2.toString(),
                  style: TextStyle(
                    color: t.accent,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Spacer(),
                Text(
                  stat.$1,
                  style: TextStyle(
                    color: t.sub,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow({
    required this.activeFilter,
    required this.counts,
    required this.onChanged,
  });

  final BookingFilter activeFilter;
  final _FilterCounts counts;
  final ValueChanged<BookingFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final items = [
      (BookingFilter.all, l.userDashboardAll, counts.all),
      (BookingFilter.flight, l.userDashboardFlights, counts.flights),
      (BookingFilter.hotel, l.userDashboardHotels, counts.hotels),
      (BookingFilter.car, l.userDashboardCars, counts.cars),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: items.map((item) {
          final selected = item.$1 == activeFilter;
          return Padding(
            padding: const EdgeInsetsDirectional.only(end: 10),
            child: _FilterChip(
              label: item.$2,
              count: item.$3,
              selected: selected,
              onTap: () => onChanged(item.$1),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<AppThemeExtension>()!;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? t.accent : t.card,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: selected ? t.accent : t.cardBorder.withOpacity(0.6),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : t.title,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: selected ? Colors.white.withOpacity(0.2) : t.accentLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  color: selected ? Colors.white : t.accent,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  const _BookingCard({required this.booking});

  final _BookingCardData booking;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final t = Theme.of(context).extension<AppThemeExtension>()!;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: t.card,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: t.cardBorder.withOpacity(0.45)),
        boxShadow: [
          BoxShadow(
            color: t.cardBorder.withOpacity(0.12),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: booking.iconBackground(t),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(booking.icon, color: booking.iconForeground(t)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.typeLabel(l),
                      style: TextStyle(
                        color: t.sub,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      booking.title,
                      style: TextStyle(
                        color: t.title,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              _StatusBadge(status: booking.status),
            ],
          ),
          const SizedBox(height: 18),
          ...booking.rows.map(
            (row) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Expanded(
                    child: _InfoBlock(
                      label: row.leftLabel(l),
                      value: row.leftValue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _InfoBlock(
                      label: row.rightLabel(l),
                      value: row.rightValue,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoBlock extends StatelessWidget {
  const _InfoBlock({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<AppThemeExtension>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: t.sub,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: t.title,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final t = Theme.of(context).extension<AppThemeExtension>()!;
    late final Color fg;
    late final Color bg;

    switch (status) {
      case 'confirmed':
        fg = t.success;
        bg = t.successBg;
        break;
      case 'completed':
        fg = t.info;
        bg = t.infoBg;
        break;
      case 'cancelled':
        fg = t.danger;
        bg = t.dangerBg;
        break;
      default:
        fg = t.warning;
        bg = t.warningBg;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _statusLabel(l),
        style: TextStyle(
          color: fg,
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  String _statusLabel(AppLocalizations l) {
    switch (status) {
      case 'confirmed':
        return l.statusConfirmed;
      case 'completed':
        return l.statusCompleted;
      case 'cancelled':
        return l.statusCancelled;
      default:
        return l.statusPending;
    }
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final t = Theme.of(context).extension<AppThemeExtension>()!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.event_note_rounded, size: 52, color: t.sub),
            const SizedBox(height: 14),
            Text(
              l.userDashboardNoBookings,
              style: TextStyle(
                color: t.title,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l.userDashboardNoBookingsSubtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: t.sub,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final t = Theme.of(context).extension<AppThemeExtension>()!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_rounded, size: 52, color: t.sub),
            const SizedBox(height: 14),
            Text(
              l.userDashboardLoadError,
              style: TextStyle(
                color: t.title,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: t.sub,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: t.accent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(l.retry),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterCounts {
  const _FilterCounts({
    required this.all,
    required this.flights,
    required this.hotels,
    required this.cars,
  });

  final int all;
  final int flights;
  final int hotels;
  final int cars;

  factory _FilterCounts.fromBookings(List<_BookingCardData> bookings) {
    return _FilterCounts(
      all: bookings.length,
      flights:
          bookings.where((item) => item.type == BookingFilter.flight).length,
      hotels: bookings.where((item) => item.type == BookingFilter.hotel).length,
      cars: bookings.where((item) => item.type == BookingFilter.car).length,
    );
  }
}

class _BookingCardData {
  const _BookingCardData({
    required this.type,
    required this.title,
    required this.status,
    required this.primaryDate,
    required this.icon,
    required this.rows,
  });

  final BookingFilter type;
  final String title;
  final String status;
  final DateTime primaryDate;
  final IconData icon;
  final List<_BookingInfoRow> rows;

  factory _BookingCardData.fromHotel(Map<String, dynamic> item) {
    final guests = (item['guests'] as List<dynamic>? ?? const []);
    final firstGuest = guests.isNotEmpty
        ? guests.first as Map<String, dynamic>
        : <String, dynamic>{};

    return _BookingCardData(
      type: BookingFilter.hotel,
      title: (item['hotelName'] ?? '-') as String,
      status: ((item['status'] ?? 'pending') as String).toLowerCase(),
      primaryDate: _parseDate(item['checkInDate']),
      icon: Icons.hotel_rounded,
      rows: [
        _BookingInfoRow(
          leftLabel: (l) => l.userDashboardCheckIn,
          leftValue: _formatDate(item['checkInDate']),
          rightLabel: (l) => l.userDashboardCheckOut,
          rightValue: _formatDate(item['checkOutDate']),
        ),
        _BookingInfoRow(
          leftLabel: (l) => l.userDashboardRooms,
          leftValue: '${item['numRooms'] ?? '-'}',
          rightLabel: (l) => l.userDashboardGuest,
          rightValue: (firstGuest['name'] ?? '-') as String,
        ),
      ],
    );
  }

  factory _BookingCardData.fromCar(Map<String, dynamic> item) {
    return _BookingCardData(
      type: BookingFilter.car,
      title: (item['carName'] ?? '-') as String,
      status: ((item['status'] ?? 'pending') as String).toLowerCase(),
      primaryDate: _parseDate(item['pickupDateTime']),
      icon: Icons.directions_car_filled_rounded,
      rows: [
        _BookingInfoRow(
          leftLabel: (l) => l.userDashboardPickUp,
          leftValue: _formatDate(item['pickupDateTime']),
          rightLabel: (l) => l.userDashboardDropOff,
          rightValue: _formatDate(item['dropoffDateTime']),
        ),
        _BookingInfoRow(
          leftLabel: (l) => l.userDashboardRoute,
          leftValue: '${item['pickupLocation'] ?? '-'}',
          rightLabel: (l) => l.total,
          rightValue: '\$${item['totalPrice'] ?? '-'}',
        ),
      ],
    );
  }

  factory _BookingCardData.fromFlight(Map<String, dynamic> item) {
    return _BookingCardData(
      type: BookingFilter.flight,
      title: '${item['fromCity'] ?? '-'} -> ${item['toCity'] ?? '-'}',
      status: ((item['status'] ?? 'pending') as String).toLowerCase(),
      primaryDate: _parseDate(item['departureDate']),
      icon: Icons.flight_takeoff_rounded,
      rows: [
        _BookingInfoRow(
          leftLabel: (l) => l.userDashboardDepartureDate,
          leftValue: _formatDate(item['departureDate']),
          rightLabel: (l) => l.userDashboardReturnDate,
          rightValue: item['returnDate'] == null
              ? '-'
              : _formatDate(item['returnDate']),
        ),
        _BookingInfoRow(
          leftLabel: (l) => l.userDashboardPassenger,
          leftValue: (item['fullName'] ?? '-') as String,
          rightLabel: (l) => l.userDashboardTripType,
          rightValue: (item['tripType'] ?? '-') as String,
        ),
      ],
    );
  }

  Color iconBackground(AppThemeExtension t) {
    switch (type) {
      case BookingFilter.flight:
        return t.infoBg;
      case BookingFilter.hotel:
        return t.successBg;
      case BookingFilter.car:
        return t.warningBg;
      case BookingFilter.all:
        return t.accentLight;
    }
  }

  Color iconForeground(AppThemeExtension t) {
    switch (type) {
      case BookingFilter.flight:
        return t.info;
      case BookingFilter.hotel:
        return t.success;
      case BookingFilter.car:
        return t.warning;
      case BookingFilter.all:
        return t.accent;
    }
  }

  String typeLabel(AppLocalizations l) {
    switch (type) {
      case BookingFilter.flight:
        return l.userDashboardFlight;
      case BookingFilter.hotel:
        return l.userDashboardHotel;
      case BookingFilter.car:
        return l.userDashboardCar;
      case BookingFilter.all:
        return '';
    }
  }

  static DateTime _parseDate(dynamic value) {
    if (value == null) return DateTime.fromMillisecondsSinceEpoch(0);
    return DateTime.tryParse(value.toString()) ??
        DateTime.fromMillisecondsSinceEpoch(0);
  }

  static String _formatDate(dynamic value) {
    final date = _parseDate(value);
    if (date.year == 1970) return '-';
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _BookingInfoRow {
  const _BookingInfoRow({
    required this.leftLabel,
    required this.leftValue,
    required this.rightLabel,
    required this.rightValue,
  });

  final String Function(AppLocalizations) leftLabel;
  final String leftValue;
  final String Function(AppLocalizations) rightLabel;
  final String rightValue;
}
