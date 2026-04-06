import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ── Color Tokens ────────────────────────────────────────────────────────────

class AppColors {
  // Light (Ice White)
  static const lightBg           = Color(0xFFF0F8FC);
  static const lightCard         = Color(0xFFFFFFFF);
  static const lightCardBorder   = Color(0xFFA0D2EB);
  static const lightHeader       = Color(0xFFF0F8FC);
  static const lightField        = Color(0xFFFFFFFF);
  static const lightFieldBorder  = Color(0xFFA0D2EB);
  static const lightDivider      = Color(0xFFA0D2EB);
  static const lightLabel        = Color(0xFF88B0C8);
  static const lightSub          = Color(0xFFAAC8D8);
  static const lightTitle        = Color(0xFF1A3D55);
  static const lightAccent       = Color(0xFF3A9DC4);
  static const lightAccentLight  = Color(0xFFE8F6FC);
  static const lightPrice        = Color(0xFF3A9DC4);
  static const lightTag          = Color(0xFFE0F4FB);
  static const lightTagText      = Color(0xFF3A9DC4);
  static const lightBadge        = Color(0xFFFF6B6B);
  static const lightBackBg       = Color(0xFFE0F0F8);
  static const lightBackIcon     = Color(0xFF3A9DC4);

  // Dark
  static const darkBg            = Color(0xFF0D1B2A);
  static const darkCard          = Color(0xFF142233);
  static const darkCardBorder    = Color(0xFF1E3A52);
  static const darkHeader        = Color(0xFF0A1520);
  static const darkField         = Color(0xFF142233);
  static const darkFieldBorder   = Color(0xFF1E3A52);
  static const darkDivider       = Color(0xFF1A2E40);
  static const darkLabel         = Color(0xFF4A6A80);
  static const darkSub           = Color(0xFF3A5568);
  static const darkTitle         = Color(0xFFE8F4FA);
  static const darkAccent        = Color(0xFF4DB8E8);
  static const darkAccentLight   = Color(0x1F4DB8E8);
  static const darkPrice         = Color(0xFF4DB8E8);
  static const darkTag           = Color(0x264DB8E8);
  static const darkTagText       = Color(0xFF4DB8E8);
  static const darkBadge         = Color(0xFFFF6B6B);
  static const darkBackBg        = Color(0x121E3A52);
  static const darkBackIcon      = Color(0xFF4DB8E8);

  // Shared
  static const btnGradientLight  = [Color(0xFF1A3D55), Color(0xFF2A6080)];
  static const btnGradientDark   = [Color(0xFF1E6A90), Color(0xFF0D4A6A)];
  static const white             = Color(0xFFFFFFFF);
  static const error             = Color(0xFFFF6B6B);
}

// ── Theme Extension (custom colors accessible via Theme.of(context)) ────────

class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  final Color bg;
  final Color card;
  final Color cardBorder;
  final Color header;
  final Color field;
  final Color fieldBorder;
  final Color divider;
  final Color label;
  final Color sub;
  final Color title;
  final Color accent;
  final Color accentLight;
  final Color price;
  final Color tag;
  final Color tagText;
  final Color badge;
  final Color backBg;
  final Color backIcon;
  final List<Color> btnGradient;

  const AppThemeExtension({
    required this.bg,
    required this.card,
    required this.cardBorder,
    required this.header,
    required this.field,
    required this.fieldBorder,
    required this.divider,
    required this.label,
    required this.sub,
    required this.title,
    required this.accent,
    required this.accentLight,
    required this.price,
    required this.tag,
    required this.tagText,
    required this.badge,
    required this.backBg,
    required this.backIcon,
    required this.btnGradient,
  });

  static const light = AppThemeExtension(
    bg:           AppColors.lightBg,
    card:         AppColors.lightCard,
    cardBorder:   AppColors.lightCardBorder,
    header:       AppColors.lightHeader,
    field:        AppColors.lightField,
    fieldBorder:  AppColors.lightFieldBorder,
    divider:      AppColors.lightDivider,
    label:        AppColors.lightLabel,
    sub:          AppColors.lightSub,
    title:        AppColors.lightTitle,
    accent:       AppColors.lightAccent,
    accentLight:  AppColors.lightAccentLight,
    price:        AppColors.lightPrice,
    tag:          AppColors.lightTag,
    tagText:      AppColors.lightTagText,
    badge:        AppColors.lightBadge,
    backBg:       AppColors.lightBackBg,
    backIcon:     AppColors.lightBackIcon,
    btnGradient:  AppColors.btnGradientLight,
  );

  static const dark = AppThemeExtension(
    bg:           AppColors.darkBg,
    card:         AppColors.darkCard,
    cardBorder:   AppColors.darkCardBorder,
    header:       AppColors.darkHeader,
    field:        AppColors.darkField,
    fieldBorder:  AppColors.darkFieldBorder,
    divider:      AppColors.darkDivider,
    label:        AppColors.darkLabel,
    sub:          AppColors.darkSub,
    title:        AppColors.darkTitle,
    accent:       AppColors.darkAccent,
    accentLight:  AppColors.darkAccentLight,
    price:        AppColors.darkPrice,
    tag:          AppColors.darkTag,
    tagText:      AppColors.darkTagText,
    badge:        AppColors.darkBadge,
    backBg:       AppColors.darkBackBg,
    backIcon:     AppColors.darkBackIcon,
    btnGradient:  AppColors.btnGradientDark,
  );

  @override
  AppThemeExtension copyWith({
    Color? bg, Color? card, Color? cardBorder, Color? header,
    Color? field, Color? fieldBorder, Color? divider, Color? label,
    Color? sub, Color? title, Color? accent, Color? accentLight,
    Color? price, Color? tag, Color? tagText, Color? badge,
    Color? backBg, Color? backIcon, List<Color>? btnGradient,
  }) {
    return AppThemeExtension(
      bg:          bg          ?? this.bg,
      card:        card        ?? this.card,
      cardBorder:  cardBorder  ?? this.cardBorder,
      header:      header      ?? this.header,
      field:       field       ?? this.field,
      fieldBorder: fieldBorder ?? this.fieldBorder,
      divider:     divider     ?? this.divider,
      label:       label       ?? this.label,
      sub:         sub         ?? this.sub,
      title:       title       ?? this.title,
      accent:      accent      ?? this.accent,
      accentLight: accentLight ?? this.accentLight,
      price:       price       ?? this.price,
      tag:         tag         ?? this.tag,
      tagText:     tagText     ?? this.tagText,
      badge:       badge       ?? this.badge,
      backBg:      backBg      ?? this.backBg,
      backIcon:    backIcon    ?? this.backIcon,
      btnGradient: btnGradient ?? this.btnGradient,
    );
  }

  @override
  AppThemeExtension lerp(AppThemeExtension? other, double t) {
    if (other is! AppThemeExtension) return this;
    return AppThemeExtension(
      bg:          Color.lerp(bg,          other.bg,          t)!,
      card:        Color.lerp(card,        other.card,        t)!,
      cardBorder:  Color.lerp(cardBorder,  other.cardBorder,  t)!,
      header:      Color.lerp(header,      other.header,      t)!,
      field:       Color.lerp(field,       other.field,       t)!,
      fieldBorder: Color.lerp(fieldBorder, other.fieldBorder, t)!,
      divider:     Color.lerp(divider,     other.divider,     t)!,
      label:       Color.lerp(label,       other.label,       t)!,
      sub:         Color.lerp(sub,         other.sub,         t)!,
      title:       Color.lerp(title,       other.title,       t)!,
      accent:      Color.lerp(accent,      other.accent,      t)!,
      accentLight: Color.lerp(accentLight, other.accentLight, t)!,
      price:       Color.lerp(price,       other.price,       t)!,
      tag:         Color.lerp(tag,         other.tag,         t)!,
      tagText:     Color.lerp(tagText,     other.tagText,     t)!,
      badge:       Color.lerp(badge,       other.badge,       t)!,
      backBg:      Color.lerp(backBg,      other.backBg,      t)!,
      backIcon:    Color.lerp(backIcon,    other.backIcon,    t)!,
      btnGradient: [
        Color.lerp(btnGradient[0], other.btnGradient[0], t)!,
        Color.lerp(btnGradient[1], other.btnGradient[1], t)!,
      ],
    );
  }
}

// ── ThemeData ───────────────────────────────────────────────────────────────

ThemeData lightTheme() => ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: AppColors.lightBg,
  colorScheme: const ColorScheme.light(
    primary: AppColors.lightAccent,
    surface: AppColors.lightCard,
  ),
  textTheme: GoogleFonts.dmSansTextTheme(),
  extensions: const [AppThemeExtension.light],
);

ThemeData darkTheme() => ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.darkBg,
  colorScheme: const ColorScheme.dark(
    primary: AppColors.darkAccent,
    surface: AppColors.darkCard,
  ),
  textTheme: GoogleFonts.dmSansTextTheme(
    ThemeData(brightness: Brightness.dark).textTheme,
  ),
  extensions: const [AppThemeExtension.dark],
);

// ── Theme Provider ──────────────────────────────────────────────────────────

class ThemeProvider extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.light;

  ThemeMode get mode => _mode;
  bool get isDark => _mode == ThemeMode.dark;

  void toggle() {
    _mode = isDark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}