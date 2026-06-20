import 'package:flutter/material.dart';
import 'package:mobile_app/data/destinations_repository.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import 'package:mobile_app/screens/home/destination_detail_screen.dart';
import 'package:mobile_app/theme.dart';

class AllDestinationsScreen extends StatefulWidget {
  const AllDestinationsScreen({super.key});

  @override
  State<AllDestinationsScreen> createState() => _AllDestinationsScreenState();
}

enum DestinationViewMode { popular, all }

class _AllDestinationsScreenState extends State<AllDestinationsScreen> {
  final DestinationsRepository _destinationsRepository =
      DestinationsRepository();
  final TextEditingController _searchController = TextEditingController();
  DestinationViewMode _viewMode = DestinationViewMode.popular;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<List<Map<String, dynamic>>> _loadDestinations() async {
    return _destinationsRepository.loadDestinations();
  }

  List<Map<String, dynamic>> _filteredDestinations(
    List<Map<String, dynamic>> destinations,
    bool isAr,
  ) {
    var result = destinations;

    if (_viewMode == DestinationViewMode.popular) {
      result = result
          .where((destination) => destination['isPopular'] == true)
          .toList();
    }

    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) {
      result.sort((a, b) {
        final nameA = (isAr ? a['nameAr'] : a['nameEn']) as String;
        final nameB = (isAr ? b['nameAr'] : b['nameEn']) as String;
        return nameA.compareTo(nameB);
      });
      return result;
    }

    final filtered = result.where((destination) {
      final fields = [
        destination['nameEn'],
        destination['nameAr'],
        destination['countryEn'],
        destination['countryAr'],
        destination['descriptionEn'],
        destination['descriptionAr'],
      ].whereType<String>();

      return fields.any((field) => field.toLowerCase().contains(query));
    }).toList();

    filtered.sort((a, b) {
      final nameA = (isAr ? a['nameAr'] : a['nameEn']) as String;
      final nameB = (isAr ? b['nameAr'] : b['nameEn']) as String;
      return nameA.compareTo(nameB);
    });

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<AppThemeExtension>()!;
    final l = AppLocalizations.of(context)!;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      backgroundColor: t.bg,
      appBar: AppBar(
        backgroundColor: t.bg,
        elevation: 0,
        foregroundColor: t.title,
        title: Text(l.allDestinationsTitle),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _loadDestinations(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final destinations = _filteredDestinations(snapshot.data!, isAr);

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                child: Column(
                  children: [
                    TextField(
                      controller: _searchController,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: l.homeSearchHint,
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchController.text.isEmpty
                            ? null
                            : IconButton(
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {});
                                },
                                icon: const Icon(Icons.close),
                              ),
                        filled: true,
                        fillColor: t.card,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: t.cardBorder.withOpacity(0.5),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: t.cardBorder.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _ModeChip(
                            label: l.popularDestinations,
                            selected: _viewMode == DestinationViewMode.popular,
                            onTap: () => setState(
                              () => _viewMode = DestinationViewMode.popular,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _ModeChip(
                            label: l.allDestinationsTab,
                            selected: _viewMode == DestinationViewMode.all,
                            onTap: () => setState(
                              () => _viewMode = DestinationViewMode.all,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: destinations.isEmpty
                    ? Center(
                        child: Text(
                          l.noDestinationResults,
                          style: TextStyle(color: t.sub, fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        itemCount: destinations.length,
                        itemBuilder: (context, index) {
                          final destination = destinations[index];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DestinationDetailScreen(
                                    destinationData: destination,
                                  ),
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: SizedBox(
                                  height: 150,
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Image.network(
                                        destination['imageUrl'] as String,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            Container(color: t.card),
                                      ),
                                      Container(
                                        decoration: const BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.transparent,
                                              Colors.black54,
                                            ],
                                            stops: [0.4, 1.0],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 10,
                                        left: 12,
                                        right: 12,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              isAr
                                                  ? destination['nameAr']
                                                      as String
                                                  : destination['nameEn']
                                                      as String,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              isAr
                                                  ? destination['countryAr']
                                                      as String
                                                  : destination['countryEn']
                                                      as String,
                                              style: TextStyle(
                                                color: Colors.white
                                                    .withOpacity(0.88),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
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
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ModeChip extends StatelessWidget {
  const _ModeChip({
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

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? t.accent : t.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: t.cardBorder.withOpacity(0.5)),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : t.title,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
