// ─────────────────────────────────────────────────────────────
//  nationality_selector.dart
//  Drop-in widget: replaces the plain Nationality TextField
// ─────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

// ── 1. Data ──────────────────────────────────────────────────

class CountryItem {
  final String name;
  final String flag; // emoji flag
  final String code; // ISO-2

  const CountryItem(this.name, this.flag, this.code);
}

const List<CountryItem> kCountries = [
  CountryItem('Afghanistan', '🇦🇫', 'AF'),
  CountryItem('Albania', '🇦🇱', 'AL'),
  CountryItem('Algeria', '🇩🇿', 'DZ'),
  CountryItem('Argentina', '🇦🇷', 'AR'),
  CountryItem('Australia', '🇦🇺', 'AU'),
  CountryItem('Austria', '🇦🇹', 'AT'),
  CountryItem('Bahrain', '🇧🇭', 'BH'),
  CountryItem('Bangladesh', '🇧🇩', 'BD'),
  CountryItem('Belgium', '🇧🇪', 'BE'),
  CountryItem('Brazil', '🇧🇷', 'BR'),
  CountryItem('Canada', '🇨🇦', 'CA'),
  CountryItem('Chile', '🇨🇱', 'CL'),
  CountryItem('China', '🇨🇳', 'CN'),
  CountryItem('Colombia', '🇨🇴', 'CO'),
  CountryItem('Croatia', '🇭🇷', 'HR'),
  CountryItem('Czech Republic', '🇨🇿', 'CZ'),
  CountryItem('Denmark', '🇩🇰', 'DK'),
  CountryItem('Egypt', '🇪🇬', 'EG'),
  CountryItem('Ethiopia', '🇪🇹', 'ET'),
  CountryItem('Finland', '🇫🇮', 'FI'),
  CountryItem('France', '🇫🇷', 'FR'),
  CountryItem('Germany', '🇩🇪', 'DE'),
  CountryItem('Ghana', '🇬🇭', 'GH'),
  CountryItem('Greece', '🇬🇷', 'GR'),
  CountryItem('Hungary', '🇭🇺', 'HU'),
  CountryItem('India', '🇮🇳', 'IN'),
  CountryItem('Indonesia', '🇮🇩', 'ID'),
  CountryItem('Iran', '🇮🇷', 'IR'),
  CountryItem('Iraq', '🇮🇶', 'IQ'),
  CountryItem('Ireland', '🇮🇪', 'IE'),
  CountryItem('Israel', '🇮🇱', 'IL'),
  CountryItem('Italy', '🇮🇹', 'IT'),
  CountryItem('Japan', '🇯🇵', 'JP'),
  CountryItem('Jordan', '🇯🇴', 'JO'),
  CountryItem('Kenya', '🇰🇪', 'KE'),
  CountryItem('Kuwait', '🇰🇼', 'KW'),
  CountryItem('Lebanon', '🇱🇧', 'LB'),
  CountryItem('Libya', '🇱🇾', 'LY'),
  CountryItem('Malaysia', '🇲🇾', 'MY'),
  CountryItem('Mexico', '🇲🇽', 'MX'),
  CountryItem('Morocco', '🇲🇦', 'MA'),
  CountryItem('Netherlands', '🇳🇱', 'NL'),
  CountryItem('New Zealand', '🇳🇿', 'NZ'),
  CountryItem('Nigeria', '🇳🇬', 'NG'),
  CountryItem('Norway', '🇳🇴', 'NO'),
  CountryItem('Oman', '🇴🇲', 'OM'),
  CountryItem('Pakistan', '🇵🇰', 'PK'),
  CountryItem('Palestine', '🇵🇸', 'PS'),
  CountryItem('Philippines', '🇵🇭', 'PH'),
  CountryItem('Poland', '🇵🇱', 'PL'),
  CountryItem('Portugal', '🇵🇹', 'PT'),
  CountryItem('Qatar', '🇶🇦', 'QA'),
  CountryItem('Romania', '🇷🇴', 'RO'),
  CountryItem('Russia', '🇷🇺', 'RU'),
  CountryItem('Saudi Arabia', '🇸🇦', 'SA'),
  CountryItem('Singapore', '🇸🇬', 'SG'),
  CountryItem('South Africa', '🇿🇦', 'ZA'),
  CountryItem('South Korea', '🇰🇷', 'KR'),
  CountryItem('Spain', '🇪🇸', 'ES'),
  CountryItem('Sudan', '🇸🇩', 'SD'),
  CountryItem('Sweden', '🇸🇪', 'SE'),
  CountryItem('Switzerland', '🇨🇭', 'CH'),
  CountryItem('Syria', '🇸🇾', 'SY'),
  CountryItem('Thailand', '🇹🇭', 'TH'),
  CountryItem('Tunisia', '🇹🇳', 'TN'),
  CountryItem('Turkey', '🇹🇷', 'TR'),
  CountryItem('Ukraine', '🇺🇦', 'UA'),
  CountryItem('United Arab Emirates', '🇦🇪', 'AE'),
  CountryItem('United Kingdom', '🇬🇧', 'GB'),
  CountryItem('United States', '🇺🇸', 'US'),
  CountryItem('Yemen', '🇾🇪', 'YE'),
];

// ── 2. Bottom-sheet launcher ──────────────────────────────────

Future<CountryItem?> showNationalityPicker(
  BuildContext context, {
  required dynamic t, // your theme object
}) {
  return showModalBottomSheet<CountryItem>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _NationalitySheet(t: t),
  );
}

// ── 3. The sheet widget ───────────────────────────────────────

class _NationalitySheet extends StatefulWidget {
  final dynamic t;
  const _NationalitySheet({required this.t});

  @override
  State<_NationalitySheet> createState() => _NationalitySheetState();
}

class _NationalitySheetState extends State<_NationalitySheet> {
  final TextEditingController _search = TextEditingController();
  List<CountryItem> _filtered = kCountries;

  void _onSearch(String q) {
    setState(() {
      _filtered = q.isEmpty
          ? kCountries
          : kCountries
              .where((c) => c.name.toLowerCase().contains(q.toLowerCase()))
              .toList();
    });
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.t;
    final mq = MediaQuery.of(context);

    return Container(
      height: mq.size.height * 0.85,
      decoration: BoxDecoration(
        color: t.card,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // ── drag handle
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: t.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          // ── title row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Nationality',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: t.title,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: t.bg,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close, size: 18, color: t.label),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // ── search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _search,
              onChanged: _onSearch,
              style: TextStyle(color: t.title, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Search country…',
                hintStyle: TextStyle(color: t.label, fontSize: 14),
                prefixIcon: Icon(Icons.search, color: t.label, size: 20),
                suffixIcon: _search.text.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          _search.clear();
                          _onSearch('');
                        },
                        child: Icon(Icons.clear, color: t.label, size: 18),
                      )
                    : null,
                filled: true,
                fillColor: t.bg,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),

          Divider(color: t.divider, height: 1),

          // ── list
          Expanded(
            child: _filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('🌍',
                            style: const TextStyle(fontSize: 40)),
                        const SizedBox(height: 10),
                        Text('No country found',
                            style:
                                TextStyle(color: t.label, fontSize: 14)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    itemCount: _filtered.length,
                    itemBuilder: (_, i) {
                      final country = _filtered[i];
                      return InkWell(
                        onTap: () => Navigator.pop(context, country),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          child: Row(
                            children: [
                              // flag
                              Text(
                                country.flag,
                                style: const TextStyle(fontSize: 26),
                              ),
                              const SizedBox(width: 14),
                              // name
                              Expanded(
                                child: Text(
                                  country.name,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: t.title,
                                  ),
                                ),
                              ),
                              // ISO code badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: t.accent.withOpacity(0.10),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  country.code,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: t.accent,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),

          SizedBox(height: mq.padding.bottom),
        ],
      ),
    );
  }
}

// ── 4. The tap-to-open field (replaces your TextField) ────────
//
//  Usage inside your passenger sheet form:
//
//    NationalityField(
//      t: t,
//      value: p['nationality'],        // current value string
//      onSelected: (country) {
//        setState(() => p['nationality'] = country.name);
//      },
//    )

class NationalityField extends StatelessWidget {
  final dynamic t;
  final String? value;
  final ValueChanged<CountryItem> onSelected;

  const NationalityField({
    super.key,
    required this.t,
    required this.value,
    required this.onSelected,
  });

  CountryItem? get _selected =>
      value == null || value!.isEmpty
          ? null
          : kCountries.firstWhere(
              (c) => c.name == value,
              orElse: () => CountryItem(value!, '🏳', '??'),
            );

  @override
  Widget build(BuildContext context) {
    final sel = _selected;
    final bool hasValue = sel != null;

    return GestureDetector(
      onTap: () async {
        final picked = await showNationalityPicker(context, t: t);
        if (picked != null) onSelected(picked);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: t.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: hasValue
                ? t.accent.withOpacity(0.5)
                : t.cardBorder.withOpacity(0.5),
            width: hasValue ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            // flag or placeholder icon
            hasValue
                ? Text(sel.flag, style: const TextStyle(fontSize: 22))
                : Icon(Icons.flag_outlined, color: t.label, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nationality *',
                    style: TextStyle(
                      fontSize: 11,
                      color: hasValue ? t.accent : t.label,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    hasValue ? sel.name : 'Select your nationality',
                    style: TextStyle(
                      fontSize: 15,
                      color: hasValue ? t.title : t.label,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.keyboard_arrow_down_rounded,
                color: hasValue ? t.accent : t.label, size: 22),
          ],
        ),
      ),
    );
  }
}