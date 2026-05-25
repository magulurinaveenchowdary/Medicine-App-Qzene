import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:med_reminder/core/constants/MedicineAutocompleteSearchConstants.dart';
import 'package:med_reminder/core/utils/MedicineCatalogSearchRankingHelpers.dart';

import '../domain/MedicineReminderDataModels.dart';

/// Offline autocomplete over bundled [assets/medicines_combined.json] (PRD §6.8).
class MedicineCatalogSearchService {
  List<Map<String, dynamic>>? _catalogEntries;
  List<String>? _displayNamesLower;
  List<String>? _entryLower;
  Map<String, List<int>>? _trigramIndex;
  bool _isLoading = false;

  Future<void> ensureLoaded() async {
    if (_catalogEntries != null || _isLoading) return;
    _isLoading = true;
    try {
      final raw = await rootBundle.loadString('assets/medicines_db.json');
      final decoded = jsonDecode(raw) as List<dynamic>;
      final entries = decoded.map((e) => Map<String, dynamic>.from(e as Map)).toList();
      _catalogEntries = entries;
      _displayNamesLower = List<String>.filled(entries.length, '');
      _entryLower = List<String>.filled(entries.length, '');
      final index = <String, List<int>>{};
      for (var i = 0; i < entries.length; i++) {
        final entry = entries[i];
        final name = entry['name'] as String;
        final ingredient = entry['ingredient'] as String;
        final nameLower = name.toLowerCase();
        _displayNamesLower![i] = nameLower;
        _entryLower![i] = "$name [$ingredient]".toLowerCase();
        for (final tri in MedicineCatalogSearchRankingHelpers.trigrams(nameLower)) {
          index.putIfAbsent(tri, () => <int>[]).add(i);
        }
      }
      _trigramIndex = index;
    } finally {
      _isLoading = false;
    }
  }

  List<MedicineCatalogSuggestionModel> searchSuggestions(
    String query, {
    List<String> profileCustomDisplayNames = const [],
  }) {
    final trimmed = query.trim();
    if (trimmed.length < MedicineAutocompleteSearchConstants.minQueryLength) {
      return const [];
    }

    final normalizedQuery = trimmed.toLowerCase();
    final limit = MedicineAutocompleteSearchConstants.maxSuggestionCount;
    final results = <MedicineCatalogSuggestionModel>[];
    final seenNames = <String>{};

    final customHits = <_RankedSuggestion>[];
    for (final name in profileCustomDisplayNames) {
      final lower = name.toLowerCase();
      if (!lower.contains(normalizedQuery)) continue;
      var score = 12000;
      if (lower.startsWith(normalizedQuery)) score += 500;
      customHits.add(
        _RankedSuggestion(
          suggestion: MedicineCatalogSuggestionModel(
            catalogEntryRaw: name,
            displayName: name,
            ingredientLine: 'Added by you',
            isProfileCustom: true,
          ),
          score: score,
        ),
      );
    }
    customHits.sort((a, b) => b.score.compareTo(a.score));
    for (final hit in customHits) {
      final key = hit.suggestion.displayName.toLowerCase();
      if (seenNames.contains(key)) continue;
      seenNames.add(key);
      results.add(hit.suggestion);
      if (results.length >= limit) return results;
    }

    final entries = _catalogEntries;
    final displayNamesLower = _displayNamesLower;
    final entryLower = _entryLower;
    final trigramIndex = _trigramIndex;
    if (entries == null ||
        displayNamesLower == null ||
        entryLower == null ||
        trigramIndex == null) {
      return results;
    }

    final candidateScores = <int, int>{};
    for (final tri in MedicineCatalogSearchRankingHelpers.trigrams(normalizedQuery)) {
      final bucket = trigramIndex[tri];
      if (bucket == null) continue;
      for (final index in bucket) {
        candidateScores[index] = (candidateScores[index] ?? 0) + 1;
      }
    }

    final ranked = <_RankedSuggestion>[];
    void considerIndex(int index) {
      final score = MedicineCatalogSearchRankingHelpers.scoreCatalogHit(
        query: normalizedQuery,
        displayNameLower: displayNamesLower[index],
        entryLower: entryLower[index],
      );
      if (score <= 0) return;
      final overlap = candidateScores[index] ?? 0;
      ranked.add(
        _RankedSuggestion(
          suggestion: _toSuggestion(entries[index]),
          score: score + overlap,
        ),
      );
    }

    final sortedCandidates = candidateScores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    for (final entry in sortedCandidates.take(600)) {
      considerIndex(entry.key);
      if (ranked.length >= 400) break;
    }

    if (ranked.length < limit) {
      for (var i = 0; i < entries.length && ranked.length < 400; i++) {
        if (candidateScores.containsKey(i)) continue;
        if (!displayNamesLower[i].contains(normalizedQuery) &&
            !entryLower[i].contains(normalizedQuery)) {
          continue;
        }
        considerIndex(i);
      }
    }

    ranked.sort((a, b) => b.score.compareTo(a.score));
    for (final hit in ranked) {
      final key = hit.suggestion.displayName.toLowerCase();
      if (seenNames.contains(key)) continue;
      seenNames.add(key);
      results.add(hit.suggestion);
      if (results.length >= limit) return results;
    }

    return results;
  }

  static MedicineCatalogSuggestionModel _toSuggestion(Map<String, dynamic> entry) {
    final name = entry['name'] as String;
    final ingredient = entry['ingredient'] as String;
    return MedicineCatalogSuggestionModel(
      catalogEntryRaw: "$name [$ingredient]",
      displayName: name,
      ingredientLine: ingredient,
    );
  }
}

class _RankedSuggestion {
  const _RankedSuggestion({required this.suggestion, required this.score});

  final MedicineCatalogSuggestionModel suggestion;
  final int score;
}
