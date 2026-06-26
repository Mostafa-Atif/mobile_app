// ─────────────────────────────────────────────────────────────
//  nationality_selector.dart
//  Contains:
//   • NationalityField  — country picker with flags
//   • PhoneCodeField    — dial-code picker with flags
// ─────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

// ── 1. Data ──────────────────────────────────────────────────

class CountryItem {
  final String name;
  final String nameAr;
  final String flag;
  final String code;

  const CountryItem(this.name, this.nameAr, this.flag, this.code);
}

// Dial codes mapped per country
const Map<String, String> kDialCodes = {
  'AF': '+93',  'AL': '+355', 'DZ': '+213', 'AR': '+54',  'AU': '+61',
  'AT': '+43',  'BH': '+973', 'BD': '+880', 'BE': '+32',  'BR': '+55',
  'CA': '+1',   'CL': '+56',  'CN': '+86',  'CO': '+57',  'HR': '+385',
  'CZ': '+420', 'DK': '+45',  'EG': '+20',  'ET': '+251', 'FI': '+358',
  'FR': '+33',  'DE': '+49',  'GH': '+233', 'GR': '+30',  'HU': '+36',
  'IN': '+91',  'ID': '+62',  'IR': '+98',  'IQ': '+964', 'IE': '+353',
  'IL': '+972', 'IT': '+39',  'JP': '+81',  'JO': '+962', 'KE': '+254',
  'KW': '+965', 'LB': '+961', 'LY': '+218', 'MY': '+60',  'MX': '+52',
  'MA': '+212', 'NL': '+31',  'NZ': '+64',  'NG': '+234', 'NO': '+47',
  'OM': '+968', 'PK': '+92',  'PS': '+970', 'PH': '+63',  'PL': '+48',
  'PT': '+351', 'QA': '+974', 'RO': '+40',  'RU': '+7',   'SA': '+966',
  'SG': '+65',  'ZA': '+27',  'KR': '+82',  'ES': '+34',  'SD': '+249',
  'SE': '+46',  'CH': '+41',  'SY': '+963', 'TH': '+66',  'TN': '+216',
  'TR': '+90',  'UA': '+380', 'AE': '+971', 'GB': '+44',  'US': '+1',
  'YE': '+967',
};

const List<CountryItem> kCountries = [
  CountryItem('Afghanistan', 'أفغانستان', '🇦🇫', 'AF'),
  CountryItem('Albania', 'ألبانيا', '🇦🇱', 'AL'),
  CountryItem('Algeria', 'الجزائر', '🇩🇿', 'DZ'),
  CountryItem('Argentina', 'الأرجنتين', '🇦🇷', 'AR'),
  CountryItem('Australia', 'أستراليا', '🇦🇺', 'AU'),
  CountryItem('Austria', 'النمسا', '🇦🇹', 'AT'),
  CountryItem('Bahrain', 'البحرين', '🇧🇭', 'BH'),
  CountryItem('Bangladesh', 'بنغلاديش', '🇧🇩', 'BD'),
  CountryItem('Belgium', 'بلجيكا', '🇧🇪', 'BE'),
  CountryItem('Brazil', 'البرازيل', '🇧🇷', 'BR'),
  CountryItem('Canada', 'كندا', '🇨🇦', 'CA'),
  CountryItem('Chile', 'تشيلي', '🇨🇱', 'CL'),
  CountryItem('China', 'الصين', '🇨🇳', 'CN'),
  CountryItem('Colombia', 'كولومبيا', '🇨🇴', 'CO'),
  CountryItem('Croatia', 'كرواتيا', '🇭🇷', 'HR'),
  CountryItem('Czech Republic', 'جمهورية التشيك', '🇨🇿', 'CZ'),
  CountryItem('Denmark', 'الدنمارك', '🇩🇰', 'DK'),
  CountryItem('Egypt', 'مصر', '🇪🇬', 'EG'),
  CountryItem('Ethiopia', 'إثيوبيا', '🇪🇹', 'ET'),
  CountryItem('Finland', 'فنلندا', '🇫🇮', 'FI'),
  CountryItem('France', 'فرنسا', '🇫🇷', 'FR'),
  CountryItem('Germany', 'ألمانيا', '🇩🇪', 'DE'),
  CountryItem('Ghana', 'غانا', '🇬🇭', 'GH'),
  CountryItem('Greece', 'اليونان', '🇬🇷', 'GR'),
  CountryItem('Hungary', 'المجر', '🇭🇺', 'HU'),
  CountryItem('India', 'الهند', '🇮🇳', 'IN'),
  CountryItem('Indonesia', 'إندونيسيا', '🇮🇩', 'ID'),
  CountryItem('Iran', 'إيران', '🇮🇷', 'IR'),
  CountryItem('Iraq', 'العراق', '🇮🇶', 'IQ'),
  CountryItem('Ireland', 'أيرلندا', '🇮🇪', 'IE'),
  CountryItem('Italy', 'إيطاليا', '🇮🇹', 'IT'),
  CountryItem('Japan', 'اليابان', '🇯🇵', 'JP'),
  CountryItem('Jordan', 'الأردن', '🇯🇴', 'JO'),
  CountryItem('Kenya', 'كينيا', '🇰🇪', 'KE'),
  CountryItem('Kuwait', 'الكويت', '🇰🇼', 'KW'),
  CountryItem('Lebanon', 'لبنان', '🇱🇧', 'LB'),
  CountryItem('Libya', 'ليبيا', '🇱🇾', 'LY'),
  CountryItem('Malaysia', 'ماليزيا', '🇲🇾', 'MY'),
  CountryItem('Mexico', 'المكسيك', '🇲🇽', 'MX'),
  CountryItem('Morocco', 'المغرب', '🇲🇦', 'MA'),
  CountryItem('Netherlands', 'هولندا', '🇳🇱', 'NL'),
  CountryItem('New Zealand', 'نيوزيلندا', '🇳🇿', 'NZ'),
  CountryItem('Nigeria', 'نيجيريا', '🇳🇬', 'NG'),
  CountryItem('Norway', 'النرويج', '🇳🇴', 'NO'),
  CountryItem('Oman', 'عُمان', '🇴🇲', 'OM'),
  CountryItem('Pakistan', 'باكستان', '🇵🇰', 'PK'),
  CountryItem('Palestine', 'فلسطين', '🇵🇸', 'PS'),
  CountryItem('Philippines', 'الفلبين', '🇵🇭', 'PH'),
  CountryItem('Poland', 'بولندا', '🇵🇱', 'PL'),
  CountryItem('Portugal', 'البرتغال', '🇵🇹', 'PT'),
  CountryItem('Qatar', 'قطر', '🇶🇦', 'QA'),
  CountryItem('Romania', 'رومانيا', '🇷🇴', 'RO'),
  CountryItem('Russia', 'روسيا', '🇷🇺', 'RU'),
  CountryItem('Saudi Arabia', 'المملكة العربية السعودية', '🇸🇦', 'SA'),
  CountryItem('Singapore', 'سنغافورة', '🇸🇬', 'SG'),
  CountryItem('South Africa', 'جنوب أفريقيا', '🇿🇦', 'ZA'),
  CountryItem('South Korea', 'كوريا الجنوبية', '🇰🇷', 'KR'),
  CountryItem('Spain', 'إسبانيا', '🇪🇸', 'ES'),
  CountryItem('Sudan', 'السودان', '🇸🇩', 'SD'),
  CountryItem('Sweden', 'السويد', '🇸🇪', 'SE'),
  CountryItem('Switzerland', 'سويسرا', '🇨🇭', 'CH'),
  CountryItem('Syria', 'سوريا', '🇸🇾', 'SY'),
  CountryItem('Thailand', 'تايلاند', '🇹🇭', 'TH'),
  CountryItem('Tunisia', 'تونس', '🇹🇳', 'TN'),
  CountryItem('Turkey', 'تركيا', '🇹🇷', 'TR'),
  CountryItem('Ukraine', 'أوكرانيا', '🇺🇦', 'UA'),
  CountryItem('United Arab Emirates', 'الإمارات العربية المتحدة', '🇦🇪', 'AE'),
  CountryItem('United Kingdom', 'المملكة المتحدة', '🇬🇧', 'GB'),
  CountryItem('United States', 'الولايات المتحدة', '🇺🇸', 'US'),
  CountryItem('Yemen', 'اليمن', '🇾🇪', 'YE'),
];

// ── 2. Bottom-sheet launcher ──────────────────────────────────

Future<CountryItem?> showNationalityPicker(
  BuildContext context, {
  required dynamic t, // your theme object
  required dynamic l,
}) {
  return showModalBottomSheet<CountryItem>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _NationalitySheet(t: t , l: l),
  );
}

// ── 3. The sheet widget ───────────────────────────────────────

class _NationalitySheet extends StatefulWidget {
  final dynamic t;
  final dynamic l;
  const _NationalitySheet({required this.t, required this.l});

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
              .where((c) => c.name.toLowerCase().contains(q.toLowerCase()) ||
              c.nameAr.contains(q))
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
  final l = widget.l; // add this
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
                  l.selectNationality,
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
                hintText: l.searchCountry,
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
                        Text(l.noCountryFound,
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
                                  l.localeName == 'ar' ? country.nameAr : country.name,
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
//     l: l,
//      value: p['nationality'],        // current value string
//      onSelected: (country) {
//        setState(() => p['nationality'] = country.name);
//      },
//    )

class NationalityField extends StatelessWidget {
  final dynamic t;
  final dynamic l;
  final String? value;
  final ValueChanged<CountryItem> onSelected;

  const NationalityField({
    super.key,
    required this.t,
    required this.l,
    required this.value,
    required this.onSelected,
  });

  CountryItem? get _selected =>
      value == null || value!.isEmpty
          ? null
          : kCountries.firstWhere(
              (c) => c.name == value,
              orElse: () => CountryItem(value!, '', '🏳', '??'),
            );

  @override
  Widget build(BuildContext context) {
    final sel = _selected;
    final bool hasValue = sel != null;

    return GestureDetector(
      onTap: () async {
        final picked = await showNationalityPicker(context, t: t , l: l);
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
            hasValue
                ? Text(sel.flag, style: const TextStyle(fontSize: 22))
                : Icon(Icons.flag_outlined, color: t.label, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
  l.nationalityLabel,
  style: TextStyle(
    fontSize: 11,
    color: hasValue ? t.accent : t.label,
  ),
),
const SizedBox(height: 2),
Text(
  hasValue
    ? (l.localeName == 'ar' ? sel.nameAr : sel.name)
    : l.selectNationality,
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

// ═════════════════════════════════════════════════════════════
//  PHONE CODE SELECTOR
// ═════════════════════════════════════════════════════════════

// ── Data model for a dial-code entry ─────────────────────────

class DialCodeItem {
  final String name;
  final String nameAr;
  final String flag;
  final String dialCode;
  final String isoCode;

  const DialCodeItem({
    required this.name,
    required this.nameAr,
    required this.flag,
    required this.dialCode,
    required this.isoCode,
  });
}

// Build the dial-code list from kCountries + kDialCodes
List<DialCodeItem> get kDialItems => kCountries
    .where((c) => kDialCodes.containsKey(c.code))
    .map((c) => DialCodeItem(
      name: c.name,
      nameAr: c.nameAr,
      flag: c.flag,
      dialCode: kDialCodes[c.code]!,
      isoCode: c.code,
    ))
    .toList();

// ── Bottom-sheet launcher ─────────────────────────────────────

Future<DialCodeItem?> showPhoneCodePicker(
  BuildContext context, {
  required dynamic t,
  required dynamic l, // add this

}) {
  return showModalBottomSheet<DialCodeItem>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _PhoneCodeSheet(t: t , l: l),
    
  );
}

// ── The sheet ─────────────────────────────────────────────────

class _PhoneCodeSheet extends StatefulWidget {
  final dynamic t;
  final dynamic l; // add this
  const _PhoneCodeSheet({required this.t, required this.l});

  @override
  State<_PhoneCodeSheet> createState() => _PhoneCodeSheetState();
}

class _PhoneCodeSheetState extends State<_PhoneCodeSheet> {
  final TextEditingController _search = TextEditingController();
  late List<DialCodeItem> _filtered;

  @override
  void initState() {
    super.initState();
    _filtered = kDialItems;
  }

  void _onSearch(String q) {
    setState(() {
      _filtered = q.isEmpty
          ? kDialItems
          : kDialItems
              .where((d) =>
    d.name.toLowerCase().contains(q.toLowerCase()) ||
    d.nameAr.contains(q) ||
    d.dialCode.contains(q))
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
  final l = widget.l; // add this
  final mq = MediaQuery.of(context);

    return Container(
      height: mq.size.height * 0.85,
      decoration: BoxDecoration(
        color: t.card,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // drag handle
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

          // title row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l.selectCountryCode,
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

          // search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _search,
              onChanged: _onSearch,
              style: TextStyle(color: t.title, fontSize: 14),
              decoration: InputDecoration(
                hintText: l.searchCountryOrCode,
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

          // list
          Expanded(
            child: _filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('📵', style: TextStyle(fontSize: 40)),
                        const SizedBox(height: 10),
                        Text(l.noCodeFound,
                            style: TextStyle(color: t.label, fontSize: 14)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    itemCount: _filtered.length,
                    itemBuilder: (_, i) {
                      final item = _filtered[i];
                      return InkWell(
                        onTap: () => Navigator.pop(context, item),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          child: Row(
                            children: [
                              // flag
                              Text(item.flag,
                                  style: const TextStyle(fontSize: 26)),
                              const SizedBox(width: 14),
                              // country name
                              Expanded(
                                child: Text(
                                  l.localeName == 'ar' ? item.nameAr : item.name,
                                  style: TextStyle(
                                      fontSize: 15, color: t.title),
                                ),
                              ),
                              // dial code badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: t.accent.withOpacity(0.10),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  item.dialCode,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: t.accent,
                                    fontWeight: FontWeight.w700,
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

// ── Tap-to-open button (replaces the old DropdownButton) ──────
//
//  Usage in _openPassengerSheet:
//
//    PhoneCodeField(
//      t: t,
//      l: l,
//      dialCode: countryCode,        // e.g. '+20'
//      onSelected: (item) {
//        setSheet(() => countryCode = item.dialCode);
//      },
//    )

class PhoneCodeField extends StatelessWidget {
  final dynamic t;
  final dynamic l;
  final String dialCode;
  final ValueChanged<DialCodeItem> onSelected;

  const PhoneCodeField({
    super.key,
    required this.t,
    required this.l,
    required this.dialCode,
    required this.onSelected,
  });

  DialCodeItem? get _selected => kDialItems.firstWhere(
        (d) => d.dialCode == dialCode,
        orElse: () => DialCodeItem(
            name: '', nameAr: '', flag: '🏳', dialCode: dialCode, isoCode: ''),
      );

  @override
  Widget build(BuildContext context) {
    final sel = _selected;

    return GestureDetector(
      onTap: () async {
        final picked = await showPhoneCodePicker(context, t: t , l: l);
        if (picked != null) onSelected(picked);
      },
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: t.field,
          border: Border.all(color: t.fieldBorder),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(sel?.flag ?? '🏳', style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 6),
            Text(
              dialCode,
              style: TextStyle(
                fontSize: 14,
                color: t.title,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.keyboard_arrow_down, size: 18, color: t.label),
          ],
        ),
      ),
    );
  }
}