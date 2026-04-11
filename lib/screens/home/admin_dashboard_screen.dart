import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app/config.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import 'package:mobile_app/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AdminSection { cars, hotels, flights }

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  AdminSection _activeSection = AdminSection.cars;
  bool _isLoading = true;
  String? _error;
  String? _busyBookingId;
  List<_AdminBooking> _carBookings = const [];
  List<_AdminBooking> _hotelBookings = const [];
  List<_AdminBooking> _flightBookings = const [];

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      final headers = <String, String>{
        'Content-Type': 'application/json',
        if (token.isNotEmpty) 'Authorization': 'Bearer $token',
      };

      final responses = await Future.wait([
        http.get(
          Uri.parse('${Config.baseUrl}/api/car-bookings'),
          headers: headers,
        ),
        http.get(
          Uri.parse('${Config.baseUrl}/api/hotels'),
          headers: headers,
        ),
        http.get(
          Uri.parse('${Config.baseUrl}/api/flight-bookings'),
          headers: headers,
        ),
      ]);

      for (final response in responses) {
        if (response.statusCode != 200) {
          throw Exception('Failed to load admin dashboard');
        }
      }

      final cars = (json.decode(responses[0].body) as List<dynamic>)
          .map(
            (item) => _AdminBooking.fromCar(
              item as Map<String, dynamic>,
            ),
          )
          .toList();
      final hotels = (json.decode(responses[1].body) as List<dynamic>)
          .map(
            (item) => _AdminBooking.fromHotel(
              item as Map<String, dynamic>,
            ),
          )
          .toList();
      final flights = (json.decode(responses[2].body) as List<dynamic>)
          .map(
            (item) => _AdminBooking.fromFlight(
              item as Map<String, dynamic>,
            ),
          )
          .toList();

      if (!mounted) return;
      setState(() {
        _carBookings = cars;
        _hotelBookings = hotels;
        _flightBookings = flights;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Could not load admin dashboard';
        _isLoading = false;
      });
    }
  }

  Future<void> _confirmBooking(_AdminBooking booking) async {
    await _runBookingAction(
      booking: booking,
      request: (headers) => http.put(
        Uri.parse('${Config.baseUrl}${booking.basePath}/${booking.id}/confirm'),
        headers: headers,
      ),
      onSuccess: (items) => items
          .map(
            (item) => item.id == booking.id
                ? item.copyWith(status: 'confirmed')
                : item,
          )
          .toList(),
      successMessage: 'Booking confirmed',
    );
  }

  Future<void> _deleteBooking(_AdminBooking booking) async {
    await _runBookingAction(
      booking: booking,
      request: (headers) => http.delete(
        Uri.parse('${Config.baseUrl}${booking.basePath}/${booking.id}'),
        headers: headers,
      ),
      onSuccess: (items) => items.where((item) => item.id != booking.id).toList(),
      successMessage: 'Booking deleted',
    );
  }

  Future<void> _runBookingAction({
    required _AdminBooking booking,
    required Future<http.Response> Function(Map<String, String>) request,
    required List<_AdminBooking> Function(List<_AdminBooking>) onSuccess,
    required String successMessage,
  }) async {
    setState(() => _busyBookingId = booking.id);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      final headers = <String, String>{
        'Content-Type': 'application/json',
        if (token.isNotEmpty) 'Authorization': 'Bearer $token',
      };

      final response = await request(headers);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception();
      }

      if (!mounted) return;
      setState(() {
        switch (booking.section) {
          case AdminSection.cars:
            _carBookings = onSuccess(_carBookings);
            break;
          case AdminSection.hotels:
            _hotelBookings = onSuccess(_hotelBookings);
            break;
          case AdminSection.flights:
            _flightBookings = onSuccess(_flightBookings);
            break;
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(successMessage)),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Action failed')),
      );
    } finally {
      if (mounted) {
        setState(() => _busyBookingId = null);
      }
    }
  }

  List<_AdminBooking> get _activeBookings {
    switch (_activeSection) {
      case AdminSection.cars:
        return _carBookings;
      case AdminSection.hotels:
        return _hotelBookings;
      case AdminSection.flights:
        return _flightBookings;
    }
  }

  String _sectionTitle(AdminSection section) {
    switch (section) {
      case AdminSection.cars:
        return 'Car Bookings';
      case AdminSection.hotels:
        return 'Hotel Bookings';
      case AdminSection.flights:
        return 'Flight Bookings';
    }
  }

  String _sectionSubtitle(AdminSection section) {
    switch (section) {
      case AdminSection.cars:
        return 'Manage and review all car rental bookings';
      case AdminSection.hotels:
        return 'Manage and review all hotel bookings';
      case AdminSection.flights:
        return 'Manage and review all flight bookings';
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<AppThemeExtension>()!;
    final l = AppLocalizations.of(context)!;
    final activeBookings = _activeBookings;
    final pendingCount =
        activeBookings.where((item) => item.status == 'pending').length;
    final confirmedCount =
        activeBookings.where((item) => item.status == 'confirmed').length;

    return Scaffold(
      backgroundColor: t.bg,
      body: RefreshIndicator(
        onRefresh: _loadDashboard,
        color: t.accent,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: _AdminHero(
                title: _sectionTitle(_activeSection),
                subtitle: _sectionSubtitle(_activeSection),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: _AdminSectionRow(
                  activeSection: _activeSection,
                  onChanged: (section) => setState(() => _activeSection = section),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: _QuickStatCard(
                        label: l.total,
                        value: activeBookings.length.toString(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _QuickStatCard(
                        label: l.statusPending,
                        value: pendingCount.toString(),
                        highlight: true,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _QuickStatCard(
                        label: l.statusConfirmed,
                        value: confirmedCount.toString(),
                      ),
                    ),
                  ],
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
                child: _AdminErrorState(
                  message: _error!,
                  onRetry: _loadDashboard,
                ),
              )
            else if (activeBookings.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: _AdminEmptyState(
                  title: 'No bookings here yet',
                  subtitle: 'New bookings for this section will appear here.',
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                sliver: SliverList.separated(
                  itemCount: activeBookings.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final booking = activeBookings[index];
                    return _AdminBookingCard(
                      booking: booking,
                      busy: _busyBookingId == booking.id,
                      onConfirm: () => _confirmBooking(booking),
                      onDelete: () => _deleteBooking(booking),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _AdminHero extends StatelessWidget {
  const _AdminHero({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<AppThemeExtension>()!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            isDark ? t.header : t.title,
            t.accent,
          ],
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

class _AdminSectionRow extends StatelessWidget {
  const _AdminSectionRow({
    required this.activeSection,
    required this.onChanged,
  });

  final AdminSection activeSection;
  final ValueChanged<AdminSection> onChanged;

  @override
  Widget build(BuildContext context) {
    final sections = [
      (AdminSection.cars, 'Cars'),
      (AdminSection.hotels, 'Hotels'),
      (AdminSection.flights, 'Flights'),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: sections.map((item) {
          return Padding(
            padding: const EdgeInsetsDirectional.only(end: 10),
            child: _AdminChip(
              label: item.$2,
              selected: item.$1 == activeSection,
              onTap: () => onChanged(item.$1),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _AdminChip extends StatelessWidget {
  const _AdminChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
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
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : t.title,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _QuickStatCard extends StatelessWidget {
  const _QuickStatCard({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<AppThemeExtension>()!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: t.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: t.cardBorder.withOpacity(0.45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              color: highlight ? t.warning : t.accent,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: t.sub,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminBookingCard extends StatelessWidget {
  const _AdminBookingCard({
    required this.booking,
    required this.busy,
    required this.onConfirm,
    required this.onDelete,
  });

  final _AdminBooking booking;
  final bool busy;
  final VoidCallback onConfirm;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final t = Theme.of(context).extension<AppThemeExtension>()!;
    final isConfirmed = booking.status == 'confirmed';

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
                      booking.title,
                      style: TextStyle(
                        color: t.title,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      booking.subtitle,
                      style: TextStyle(
                        color: t.sub,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              _AdminStatusBadge(status: booking.status),
            ],
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: booking.details.map((detail) {
              return _AdminInfoPill(
                label: detail.label,
                value: detail.value,
              );
            }).toList(),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: busy || isConfirmed ? null : onConfirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: t.success,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: t.success.withOpacity(0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: busy
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(isConfirmed ? l.statusConfirmed : 'Confirm'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: busy ? null : onDelete,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: t.danger,
                    side: BorderSide(color: t.danger.withOpacity(0.45)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text('Delete'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AdminInfoPill extends StatelessWidget {
  const _AdminInfoPill({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<AppThemeExtension>()!;

    return Container(
      constraints: const BoxConstraints(minWidth: 130),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: t.accentLight,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
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
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminStatusBadge extends StatelessWidget {
  const _AdminStatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final t = Theme.of(context).extension<AppThemeExtension>()!;
    late final Color fg;
    late final Color bg;
    late final String text;

    switch (status) {
      case 'confirmed':
        fg = t.success;
        bg = t.successBg;
        text = l.statusConfirmed;
        break;
      case 'completed':
        fg = t.info;
        bg = t.infoBg;
        text = l.statusCompleted;
        break;
      case 'cancelled':
        fg = t.danger;
        bg = t.dangerBg;
        text = l.statusCancelled;
        break;
      default:
        fg = t.warning;
        bg = t.warningBg;
        text = l.statusPending;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: fg,
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _AdminEmptyState extends StatelessWidget {
  const _AdminEmptyState({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<AppThemeExtension>()!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inventory_2_outlined, size: 52, color: t.sub),
            const SizedBox(height: 14),
            Text(
              title,
              style: TextStyle(
                color: t.title,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
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

class _AdminErrorState extends StatelessWidget {
  const _AdminErrorState({
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
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: t.title,
                fontSize: 18,
                fontWeight: FontWeight.w800,
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

class _AdminBooking {
  const _AdminBooking({
    required this.id,
    required this.section,
    required this.basePath,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.icon,
    required this.details,
  });

  final String id;
  final AdminSection section;
  final String basePath;
  final String title;
  final String subtitle;
  final String status;
  final IconData icon;
  final List<_AdminBookingDetail> details;

  factory _AdminBooking.fromCar(Map<String, dynamic> item) {
    final customerName =
        '${item['firstName'] ?? ''} ${item['lastName'] ?? ''}'.trim();

    return _AdminBooking(
      id: '${item['_id']}',
      section: AdminSection.cars,
      basePath: '/api/car-bookings',
      title: '${item['carName'] ?? '-'}',
      subtitle: [
        if (customerName.isNotEmpty) customerName,
        if ((item['email'] ?? '').toString().isNotEmpty) item['email'],
      ].join(' • '),
      status: '${item['status'] ?? 'pending'}'.toLowerCase(),
      icon: Icons.directions_car_filled_rounded,
      details: [
        _AdminBookingDetail('Phone', '${item['phone'] ?? '-'}'),
        _AdminBookingDetail('Pick up', _formatDate(item['pickupDateTime'])),
        _AdminBookingDetail('Drop off', _formatDate(item['dropoffDateTime'])),
        _AdminBookingDetail('Total', '\$${item['totalPrice'] ?? '-'}'),
      ],
    );
  }

  factory _AdminBooking.fromHotel(Map<String, dynamic> item) {
    final guests = item['guests'] as List<dynamic>? ?? const [];
    final guest = guests.isNotEmpty
        ? guests.first as Map<String, dynamic>
        : const <String, dynamic>{};

    return _AdminBooking(
      id: '${item['_id']}',
      section: AdminSection.hotels,
      basePath: '/api/hotels',
      title: '${item['hotelName'] ?? '-'}',
      subtitle: [
        if ((guest['name'] ?? '').toString().isNotEmpty) guest['name'],
        if ((guest['email'] ?? '').toString().isNotEmpty) guest['email'],
      ].join(' • '),
      status: '${item['status'] ?? 'pending'}'.toLowerCase(),
      icon: Icons.hotel_rounded,
      details: [
        _AdminBookingDetail('Phone', '${guest['phone'] ?? '-'}'),
        _AdminBookingDetail('Check in', _formatDate(item['checkInDate'])),
        _AdminBookingDetail('Check out', _formatDate(item['checkOutDate'])),
        _AdminBookingDetail('Rooms', '${item['numRooms'] ?? '-'}'),
      ],
    );
  }

  factory _AdminBooking.fromFlight(Map<String, dynamic> item) {
    return _AdminBooking(
      id: '${item['_id']}',
      section: AdminSection.flights,
      basePath: '/api/flight-bookings',
      title: '${item['fromCity'] ?? '-'} -> ${item['toCity'] ?? '-'}',
      subtitle: [
        if ((item['fullName'] ?? '').toString().isNotEmpty) item['fullName'],
        if ((item['email'] ?? '').toString().isNotEmpty) item['email'],
      ].join(' • '),
      status: '${item['status'] ?? 'pending'}'.toLowerCase(),
      icon: Icons.flight_takeoff_rounded,
      details: [
        _AdminBookingDetail('Departure', _formatDate(item['departureDate'])),
        _AdminBookingDetail(
          'Return',
          item['returnDate'] == null ? '-' : _formatDate(item['returnDate']),
        ),
        _AdminBookingDetail('Trip type', '${item['tripType'] ?? '-'}'),
      ],
    );
  }

  _AdminBooking copyWith({
    String? status,
  }) {
    return _AdminBooking(
      id: id,
      section: section,
      basePath: basePath,
      title: title,
      subtitle: subtitle,
      status: status ?? this.status,
      icon: icon,
      details: details,
    );
  }

  Color iconBackground(AppThemeExtension t) {
    switch (section) {
      case AdminSection.cars:
        return t.warningBg;
      case AdminSection.hotels:
        return t.successBg;
      case AdminSection.flights:
        return t.infoBg;
    }
  }

  Color iconForeground(AppThemeExtension t) {
    switch (section) {
      case AdminSection.cars:
        return t.warning;
      case AdminSection.hotels:
        return t.success;
      case AdminSection.flights:
        return t.info;
    }
  }

  static String _formatDate(dynamic value) {
    if (value == null) return '-';
    final date = DateTime.tryParse(value.toString());
    if (date == null) return '-';
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _AdminBookingDetail {
  const _AdminBookingDetail(this.label, this.value);

  final String label;
  final String value;
}
