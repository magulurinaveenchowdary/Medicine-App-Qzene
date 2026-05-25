import 'package:flutter_test/flutter_test.dart';
import 'package:med_reminder/core/utils/MedicineCatalogSearchRankingHelpers.dart';
import 'package:med_reminder/features/medicines/data/MedicineCatalogSearchService.dart';

void main() {
  test('prefix ranks above fuzzy for catalog scoring', () {
    final prefixScore = MedicineCatalogSearchRankingHelpers.scoreCatalogHit(
      query: 'tel',
      displayNameLower: 'telma 40',
      entryLower: 'telma 40 mg tablet',
    );
    final fuzzyScore = MedicineCatalogSearchRankingHelpers.scoreCatalogHit(
      query: 'tel',
      displayNameLower: 'xelma 40',
      entryLower: 'xelma 40 mg tablet',
    );
    expect(prefixScore, greaterThan(fuzzyScore));
  });

  test('levenshtein distance respects max distance', () {
    expect(
      MedicineCatalogSearchRankingHelpers.levenshteinDistance('cat', 'cut'),
      1,
    );
    expect(
      MedicineCatalogSearchRankingHelpers.levenshteinDistance('abc', 'xyz'),
      greaterThan(2),
    );
  });

  test('profile custom names appear first when both match', () {
    final service = MedicineCatalogSearchService();
    final results = service.searchSuggestions(
      'my',
      profileCustomDisplayNames: const ['My Crocin'],
    );
    expect(results, isNotEmpty);
    expect(results.first.isProfileCustom, isTrue);
    expect(results.first.displayName, 'My Crocin');
  });

  test('queries shorter than 2 characters return empty', () {
    final service = MedicineCatalogSearchService();
    expect(service.searchSuggestions('a'), isEmpty);
  });
}
