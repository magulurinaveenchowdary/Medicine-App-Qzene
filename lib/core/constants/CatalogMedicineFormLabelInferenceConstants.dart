/// Infers add-medicine category tile from catalog / typed medicine text.
class CatalogMedicineFormLabelInferenceConstants {
  CatalogMedicineFormLabelInferenceConstants._();

  static const List<_FormInferenceRule> _rules = [
    _FormInferenceRule(
      ['prefilled syringe', 'auto-injector', 'injectable', 'injection', 'ampoule'],
      'Injection',
    ),
    _FormInferenceRule(['nasal spray', 'nasal aerosol'], 'Nasal capsule'),
    _FormInferenceRule(
      [
        'metered dose inhaler',
        'dry powder inhaler',
        'inhalation aerosol',
        'inhalation powder',
        'inhaler',
        'diskus',
        'respimat',
        'nebulizer',
      ],
      'Inhaler',
    ),
    _FormInferenceRule(
      ['eye drops', 'ear drops', 'ophthalmic', 'otic solution', 'ophthalmic solution'],
      'Drops',
    ),
    _FormInferenceRule(
      ['oral solution', 'oral suspension', 'oral liquid', 'syrup', 'suspension'],
      'Liquid / Syrup',
    ),
    _FormInferenceRule(['softgel', 'soft gel'], 'Softgel'),
    _FormInferenceRule(['capsule', 'caplet'], 'Capsule'),
    _FormInferenceRule(['sublingual'], 'Sublingual'),
    _FormInferenceRule(['chewable'], 'Chewable'),
    _FormInferenceRule(['gummy', 'gummies'], 'Gummy'),
    _FormInferenceRule(['lozenge'], 'Lozenge'),
    _FormInferenceRule(['transdermal', 'patch'], 'Patch'),
    _FormInferenceRule(['suppository'], 'Suppository'),
    _FormInferenceRule(['ointment'], 'Ointment'),
    _FormInferenceRule(['cream'], 'Cream'),
    _FormInferenceRule(['lotion'], 'Lotion'),
    _FormInferenceRule(['toothpaste'], 'Toothpaste'),
    _FormInferenceRule(['shampoo'], 'Shampoo'),
    _FormInferenceRule(['foam'], 'Foam'),
    _FormInferenceRule(['chew bite', 'chewable tablet'], 'Chew bite'),
    _FormInferenceRule(['powder', 'sachet', 'granules'], 'Powder / Sachet'),
    _FormInferenceRule(['herb', 'ayurved', 'kashayam'], 'Herb'),
    _FormInferenceRule(['topical gel', 'gel'], 'Gel'),
    _FormInferenceRule(['spray'], 'Spray'),
    _FormInferenceRule(
      ['tablet', 'tab ', ' tab', 'oral tablet', 'film coated tablet'],
      'Tablet',
    ),
  ];

  static const String defaultFormLabel = 'Others';

  static String inferFormLabel({
    required String displayName,
    String catalogEntryRaw = '',
  }) {
    final text = '${displayName.trim()} ${catalogEntryRaw.trim()}'.toLowerCase();
    if (text.trim().isEmpty) {
      return defaultFormLabel;
    }

    for (final rule in _rules) {
      if (rule.matches(text)) {
        return rule.formLabel;
      }
    }
    return defaultFormLabel;
  }
}

class _FormInferenceRule {
  const _FormInferenceRule(this.keywords, this.formLabel);

  final List<String> keywords;
  final String formLabel;

  bool matches(String lowerText) {
    for (final keyword in keywords) {
      final trimmed = keyword.trim();
      if (trimmed.isEmpty) continue;
      if (trimmed.contains(' ')) {
        if (lowerText.contains(trimmed)) return true;
      } else if (RegExp('\\b${RegExp.escape(trimmed)}\\b').hasMatch(lowerText)) {
        return true;
      }
    }
    return false;
  }
}
