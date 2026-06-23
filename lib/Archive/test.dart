import 'package:flutter/material.dart';
import 'package:mobile_app/theme.dart';

const Map<String, List<String>> _citiesByCountry = {
  'Egypt': ['Cairo', 'Alexandria', 'Giza', 'Luxor', 'Aswan', 'Sharm El-Sheikh'],
  'Saudi Arabia': ['Riyadh', 'Jeddah', 'Dammam', 'Mecca', 'Medina'],
  'UAE': ['Dubai', 'Abu Dhabi', 'Sharjah', 'Ajman'],
  'Jordan': ['Amman', 'Aqaba', 'Zarqa'],
  'Kuwait': ['Kuwait City', 'Hawalli', 'Salmiya'],
  'Bahrain': ['Manama', 'Riffa', 'Muharraq'],
};

const Map<String, List<String>> _locationsByCity = {
  'Cairo': ['Cairo Airport', 'Tahrir Square', 'Nasr City', 'New Cairo'],
  'Alexandria': ['Borg El Arab Airport', 'Stanley', 'Smouha'],
  'Dubai': ['Dubai Airport', 'Downtown Dubai', 'Dubai Marina'],
  'Riyadh': ['King Khalid Airport', 'Olaya', 'Al Malaz'],
};

// Preview page — navigate here to see the card
class CitySelectorExamplePage extends StatelessWidget {
  const CitySelectorExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<AppThemeExtension>()!;
    return Scaffold(
      backgroundColor: t.bg,
      appBar: AppBar(
        backgroundColor: t.header,
        elevation: 0,
        title: Text(
          'Location selector preview',
          style: TextStyle(color: t.title, fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: LocationsCard(
          citiesByCountry: _citiesByCountry,
          locationsByCity: _locationsByCity,
          onPickupSelected: (city, location) => debugPrint('Pickup: $city / $location'),
          onDropoffSelected: (city, location) => debugPrint('Dropoff: $city / $location'),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// LocationsCard — the actual widget to drop into your screen
// Replace hardcoded strings with l.* when wiring into real screen
// ---------------------------------------------------------------------------
class LocationsCard extends StatefulWidget {
  final Map<String, List<String>> citiesByCountry;
  final Map<String, List<String>> locationsByCity;
  final void Function(String city, String location)? onPickupSelected;
  final void Function(String city, String location)? onDropoffSelected;

  const LocationsCard({
    super.key,
    required this.citiesByCountry,
    required this.locationsByCity,
    this.onPickupSelected,
    this.onDropoffSelected,
  });

  @override
  State<LocationsCard> createState() => _LocationsCardState();
}

class _LocationsCardState extends State<LocationsCard> {
  String? _selectedCountry;
  String? _selectedCity;
  String? _selectedPickup;
  String? _selectedDropoff;

  List<String> get _citiesForCountry =>
      _selectedCountry != null ? widget.citiesByCountry[_selectedCountry!] ?? [] : [];

  List<String> get _locationsForCity =>
      _selectedCity != null ? widget.locationsByCity[_selectedCity!] ?? [] : [];

  Future<T?> _showPicker<T>({
    required BuildContext context,
    required String title,
    required List<T> items,
    required String Function(T) label,
    required T? selected,
  }) {
    final t = Theme.of(context).extension<AppThemeExtension>()!;
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: t.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.85,
        expand: false,
        builder: (_, controller) => Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: t.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: t.title),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                controller: controller,
                itemCount: items.length,
                separatorBuilder: (_, __) => Divider(height: 1, color: t.divider),
                itemBuilder: (_, i) {
                  final item = items[i];
                  final isSelected = item == selected;
                  return ListTile(
                    title: Text(
                      label(item),
                      style: TextStyle(
                        fontSize: 14,
                        color: isSelected ? t.accent : t.title,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                    trailing: isSelected
                        ? Icon(Icons.check_rounded, color: t.accent, size: 18)
                        : null,
                    onTap: () => Navigator.pop(context, item),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dropdownField({
    required BuildContext context,
    required String placeholder,
    required String? value,
    required VoidCallback onTap,
    required AppThemeExtension t,
    bool enabled = true,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: enabled ? t.field : t.field.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: value != null ? t.accent.withOpacity(0.6) : t.fieldBorder.withOpacity(0.5),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value ?? placeholder,
                style: TextStyle(
                  fontSize: 14,
                  color: value != null ? t.title : t.label,
                  fontWeight: value != null ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: enabled ? t.label : t.label.withOpacity(0.4),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _locationChips({
    required List<String> locations,
    required String? selected,
    required void Function(String) onSelect,
    required AppThemeExtension t,
  }) {
    if (locations.isEmpty) {
      return Text('No locations available', style: TextStyle(fontSize: 13, color: t.label));
    }
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: locations.map((loc) {
        final isSelected = selected == loc;
        return GestureDetector(
          onTap: () => onSelect(loc),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? t.accentLight : t.field,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected ? t.accent : t.fieldBorder.withOpacity(0.5),
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Text(
              loc,
              style: TextStyle(
                fontSize: 13,
                color: isSelected ? t.accent : t.title,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _label(String text, AppThemeExtension t) => Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          color: t.label,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<AppThemeExtension>()!;
    final countries = widget.citiesByCountry.keys.toList();

    return Container(
      decoration: BoxDecoration(
        color: t.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: t.cardBorder.withOpacity(0.4)),
        boxShadow: [
          BoxShadow(
            color: t.cardBorder.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Country dropdown
          _label('COUNTRY', t), // → l.selectCountry
          const SizedBox(height: 8),
          _dropdownField(
            context: context,
            placeholder: 'Select country', // → l.selectCountry
            value: _selectedCountry,
            t: t,
            onTap: () async {
              final result = await _showPicker<String>(
                context: context,
                title: 'Select country', // → l.selectCountry
                items: countries,
                label: (c) => c,
                selected: _selectedCountry,
              );
              if (result != null && result != _selectedCountry) {
                setState(() {
                  _selectedCountry = result;
                  _selectedCity = null;
                  _selectedPickup = null;
                  _selectedDropoff = null;
                });
              }
            },
          ),

          // City dropdown — appears after country picked
          if (_selectedCountry != null) ...[
            const SizedBox(height: 14),
            _label('CITY', t), // → l.selectCity
            const SizedBox(height: 8),
            _dropdownField(
              context: context,
              placeholder: 'Select city', // → l.selectCity
              value: _selectedCity,
              t: t,
              onTap: () async {
                final result = await _showPicker<String>(
                  context: context,
                  title: 'Select city', // → l.selectCity
                  items: _citiesForCountry,
                  label: (c) => c,
                  selected: _selectedCity,
                );
                if (result != null && result != _selectedCity) {
                  setState(() {
                    _selectedCity = result;
                    _selectedPickup = null;
                    _selectedDropoff = null;
                  });
                  // wire up: _geocodeLocationsForCity(result);
                }
              },
            ),
          ],

          // Pickup location chips — appears after city picked
          if (_selectedCity != null) ...[
            const SizedBox(height: 20),
            Divider(color: t.divider, height: 1),
            const SizedBox(height: 20),
            _label('PICKUP LOCATION', t), // → l.selectPickupLocation
            const SizedBox(height: 12),
            _locationChips(
              locations: _locationsForCity,
              selected: _selectedPickup,
              t: t,
              onSelect: (loc) {
                setState(() => _selectedPickup = loc);
                widget.onPickupSelected?.call(_selectedCity!, loc);
              },
            ),
          ],

          // Dropoff location chips — appears after pickup picked
          if (_selectedPickup != null) ...[
            const SizedBox(height: 20),
            Divider(color: t.divider, height: 1),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _label('DROPOFF LOCATION', t), // → l.selectDropoffLocation
                ),
                Text(
                  _selectedCity ?? '',
                  style: TextStyle(fontSize: 12, color: t.label),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _locationChips(
              locations: _locationsForCity,
              selected: _selectedDropoff,
              t: t,
              onSelect: (loc) {
                setState(() => _selectedDropoff = loc);
                widget.onDropoffSelected?.call(_selectedCity!, loc);
              },
            ),
          ],
        ],
      ),
    );
  }
}