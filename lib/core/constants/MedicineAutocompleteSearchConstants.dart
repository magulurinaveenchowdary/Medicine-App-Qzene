/// PRD §6.8 medicine name autocomplete limits.
class MedicineAutocompleteSearchConstants {
  MedicineAutocompleteSearchConstants._();

  static const int minQueryLength = 2;
  static const int maxSuggestionCount = 8;
  static const int searchDebounceMs = 100;
  static const int levenshteinMaxDistance = 2;
}
