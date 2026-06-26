import 'package:flutter/material.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import 'package:mobile_app/main.dart';
import 'package:mobile_app/providers/currency_provider.dart';
import 'package:mobile_app/theme.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final t = Theme.of(context).extension<AppThemeExtension>()!;
    final isDark = context.watch<ThemeProvider>().isDark;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      backgroundColor: t.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: t.card,
                        borderRadius: BorderRadius.circular(14),
                        border:
                            Border.all(color: t.cardBorder.withOpacity(0.45)),
                      ),
                      child: Icon(
                        isAr ? Icons.arrow_forward : Icons.arrow_back,
                        color: t.title,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    l.settingsTitle,
                    style: TextStyle(
                      color: t.title,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'DM Serif Display',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              _SectionCard(
                title: l.settingsAppearanceTitle,
                subtitle: l.settingsAppearanceSubtitle,
                child: Row(
                  children: [
                    Expanded(
                      child: _ChoiceTile(
                        label: l.settingsLight,
                        selected: !isDark,
                        onTap: () {
                          if (isDark) {
                            context.read<ThemeProvider>().toggle();
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ChoiceTile(
                        label: l.settingsDark,
                        selected: isDark,
                        onTap: () {
                          if (!isDark) {
                            context.read<ThemeProvider>().toggle();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              _SectionCard(
                title: l.settingsLanguageTitle,
                subtitle: l.settingsLanguageSubtitle,
                child: Row(
                  children: [
                    Expanded(
                      child: _ChoiceTile(
                        label: 'English',
                        selected: !isAr,
                        onTap: () =>
                            MyApp.setLocale(context, const Locale('en')),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ChoiceTile(
                        label: 'العربية',
                        selected: isAr,
                        onTap: () =>
                            MyApp.setLocale(context, const Locale('ar')),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              _SectionCard(
                title: l.settingsCurrencyTitle,
                subtitle: l.settingsCurrencySubtitle,
                child: DropdownButtonFormField<String>(
                  value: context.watch<CurrencyProvider>().currency,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    filled: true,
                    fillColor: t.accentLight,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide:
                          BorderSide(color: t.cardBorder.withOpacity(0.45)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide:
                          BorderSide(color: t.cardBorder.withOpacity(0.45)),
                    ),
                  ),
                  items: CurrencyProvider.supportedCurrencies.map((code) {
                    final label = isAr
                        ? '${CurrencyProvider.arabicNames[code]!} ($code)'
                        : '${CurrencyProvider.englishNames[code]!} ($code)';
                    return DropdownMenuItem(value: code, child: Text(label));
                  }).toList(),
                  onChanged: (value) {
                    if (value != null)
                      context.read<CurrencyProvider>().setCurrency(value);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<AppThemeExtension>()!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: t.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: t.cardBorder.withOpacity(0.45)),
        boxShadow: [
          BoxShadow(
            color: t.cardBorder.withOpacity(0.12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: t.title,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: t.sub,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _ChoiceTile extends StatelessWidget {
  const _ChoiceTile({
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
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: selected ? t.accent : t.accentLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? t.accent : t.cardBorder.withOpacity(0.45),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : t.title,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
