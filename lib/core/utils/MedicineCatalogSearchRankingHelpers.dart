/// Ranking helpers for PRD §6.8 catalog autocomplete (prefix → fuzzy → phonetic).
class MedicineCatalogSearchRankingHelpers {
  MedicineCatalogSearchRankingHelpers._();

  static Iterable<String> trigrams(String input) sync* {
    final padded = '  ${input.toLowerCase()}  ';
    for (var i = 0; i < padded.length - 2; i++) {
      yield padded.substring(i, i + 3);
    }
  }

  static int levenshteinDistance(
    String a,
    String b, {
    int maxDistance = 2,
  }) {
    if (a == b) return 0;
    if (a.isEmpty) return b.length;
    if (b.isEmpty) return a.length;
    if ((a.length - b.length).abs() > maxDistance) return maxDistance + 1;

    var previous = List<int>.generate(b.length + 1, (i) => i);
    for (var i = 0; i < a.length; i++) {
      final current = List<int>.filled(b.length + 1, 0);
      current[0] = i + 1;
      var rowMin = current[0];
      for (var j = 0; j < b.length; j++) {
        final cost = a.codeUnitAt(i) == b.codeUnitAt(j) ? 0 : 1;
        current[j + 1] = _min3(
          current[j] + 1,
          previous[j + 1] + 1,
          previous[j] + cost,
        );
        if (current[j + 1] < rowMin) rowMin = current[j + 1];
      }
      if (rowMin > maxDistance) return maxDistance + 1;
      previous = current;
    }
    return previous[b.length];
  }

  static int _min3(int a, int b, int c) => a < b ? (a < c ? a : c) : (b < c ? b : c);

  /// Simplified Metaphone key for phonetic tier matching.
  static String metaphoneKey(String input) {
    if (input.isEmpty) return '';
    var word = input.toUpperCase().replaceAll(RegExp(r'[^A-Z]'), '');
    if (word.isEmpty) return '';

    final buffer = StringBuffer();
    if ('AEIOU'.contains(word[0])) {
      buffer.write(word[0]);
    } else {
      buffer.write(_metaphoneInitial(word));
    }

    var index = 1;
    while (index < word.length && buffer.length < 6) {
      final ch = word[index];
      final next = index + 1 < word.length ? word[index + 1] : '';
      final code = _metaphoneCode(ch, next);
      if (code.isNotEmpty) {
        final current = buffer.toString();
        if (current.isEmpty || current.codeUnitAt(current.length - 1) != code.codeUnitAt(0)) {
          buffer.write(code);
        }
      }
      index++;
    }
    return buffer.toString();
  }

  static String _metaphoneInitial(String word) {
    if (word.startsWith('KN') ||
        word.startsWith('GN') ||
        word.startsWith('PN') ||
        word.startsWith('AE') ||
        word.startsWith('WR')) {
      return word.substring(1, 2);
    }
    if (word.startsWith('X')) return 'S';
    return word[0];
  }

  static String _metaphoneCode(String ch, String next) {
    switch (ch) {
      case 'B':
        return 'B';
      case 'C':
        if (next == 'H') return 'X';
        return 'K';
      case 'D':
        return 'T';
      case 'F':
        return 'F';
      case 'G':
        if (next == 'H' || next == 'N') return '';
        return 'K';
      case 'H':
        return '';
      case 'J':
        return 'J';
      case 'K':
        return next == 'N' ? '' : 'K';
      case 'L':
        return 'L';
      case 'M':
        return 'M';
      case 'N':
        return 'N';
      case 'P':
        return next == 'H' ? 'F' : 'P';
      case 'Q':
        return 'K';
      case 'R':
        return 'R';
      case 'S':
        if (next == 'H') return 'X';
        return 'S';
      case 'T':
        if (next == 'H') return 'T';
        return 'T';
      case 'V':
        return 'F';
      case 'W':
        return next == 'R' ? '' : 'W';
      case 'X':
        return 'KS';
      case 'Y':
        return 'Y';
      case 'Z':
        return 'S';
      default:
        return '';
    }
  }

  static int scoreCatalogHit({
    required String query,
    required String displayNameLower,
    required String entryLower,
  }) {
    if (displayNameLower.startsWith(query)) return 10000;
    if (entryLower.startsWith(query)) return 9000;
    if (displayNameLower.contains(query)) return 5000;

    final displayDistance = levenshteinDistance(
      query,
      displayNameLower.length > query.length + 3
          ? displayNameLower.substring(0, query.length + 3)
          : displayNameLower,
    );
    if (displayDistance <= 2) return 4000 - displayDistance;

    final queryPhonetic = metaphoneKey(query);
    final namePhonetic = metaphoneKey(displayNameLower);
    if (queryPhonetic.isNotEmpty &&
        (namePhonetic == queryPhonetic || namePhonetic.startsWith(queryPhonetic))) {
      return 3000;
    }

    return 0;
  }
}
