import 'package:flutter/material.dart';
import 'package:mobile_app/data/destinations_repository.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import 'package:mobile_app/theme.dart';

class DestinationDetailScreen extends StatelessWidget {
  const DestinationDetailScreen({
    super.key,
    this.destinationName,
    this.destinationData,
  }) : assert(destinationName != null || destinationData != null);

  final String? destinationName;
  final Map<String, dynamic>? destinationData;
  static final DestinationsRepository _destinationsRepository =
      DestinationsRepository();

  Future<Map<String, dynamic>> _loadDestination() async {
    if (destinationData != null) {
      return destinationData!;
    }

    return _destinationsRepository.loadDestinationByName(destinationName!);
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<AppThemeExtension>()!;
    final l = AppLocalizations.of(context)!;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return FutureBuilder<Map<String, dynamic>>(
      future: _loadDestination(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: t.bg,
            appBar: AppBar(
              backgroundColor: t.bg,
              elevation: 0,
              foregroundColor: t.title,
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        final data = snapshot.data!;
        final nameEn = data['nameEn'] as String;
        final nameAr = data['nameAr'] as String;
        final countryEn = data['countryEn'] as String;
        final countryAr = data['countryAr'] as String;
        final descriptionEn = data['descriptionEn'] as String;
        final descriptionAr = data['descriptionAr'] as String;
        final imageUrl = data['imageUrl'] as String;
        final websiteUrl = data['websiteUrl'] as String;

        final infoSections = [
          {
            'title': l.destinationBestTimeTitle,
            'body': isAr
                ? l.destinationBestTimeBody(nameAr)
                : l.destinationBestTimeBody(nameEn),
          },
          {
            'title': l.destinationCuisineTitle,
            'body': isAr
                ? l.destinationCuisineBody(nameAr)
                : l.destinationCuisineBody(nameEn),
          },
          {
            'title': l.destinationStayTitle,
            'body': l.destinationStayBody,
          },
          {
            'title': l.destinationAttractionsTitle,
            'body': isAr
                ? l.destinationAttractionsBody(nameAr)
                : l.destinationAttractionsBody(nameEn),
          },
        ];

        return Scaffold(
          backgroundColor: t.bg,
          appBar: AppBar(
            backgroundColor: t.bg,
            elevation: 0,
            foregroundColor: t.title,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: AspectRatio(
                    aspectRatio: 16 / 10,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(color: t.card),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.45),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  isAr ? nameAr : nameEn,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: t.title,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  isAr ? countryAr : countryEn,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: t.accent,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  isAr ? descriptionAr : descriptionEn,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.7,
                    color: t.sub,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: t.card,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: t.cardBorder.withOpacity(0.5)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l.homeOfficialWebsite,
                        style: TextStyle(
                          color: t.title,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SelectableText(
                        websiteUrl,
                        style: TextStyle(
                          color: t.accent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: infoSections.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisSpacing: 12,
                    childAspectRatio: 2.1,
                  ),
                  itemBuilder: (context, index) {
                    final section = infoSections[index];
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: t.card,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: t.cardBorder.withOpacity(0.5)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            section['title']!,
                            style: TextStyle(
                              color: t.title,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            section['body']!,
                            style: TextStyle(
                              color: t.sub,
                              fontSize: 14,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
