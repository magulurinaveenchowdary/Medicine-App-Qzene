/// PRD §6.5.1 form-to-unit mapping (default + compatible presets).
class CategoryFormUnitMappingConstants {
  CategoryFormUnitMappingConstants._();

  static const Map<String, String> defaultUnitByFormLabel = {
    'Tablet': 'tablet(s)',
    'Capsule': 'capsule(s)',
    'Softgel': 'softgel(s)',
    'Liquid / Syrup': 'ml',
    'Drops': 'drop(s)',
    'Injection': 'ml',
    'Inhaler': 'puff(s)',
    'Cream': 'application(s)',
    'Ointment': 'application(s)',
    'Gel': 'application(s)',
    'Lotion': 'application(s)',
    'Spray': 'spray(s)',
    'Sublingual': 'tablet(s)',
    'Patch': 'patch(es)',
    'Chewable': 'tablet(s)',
    'Gummy': 'gummy(ies)',
    'Lozenge': 'lozenge(s)',
    'Powder / Sachet': 'sachet(s)',
    'Suppository': 'suppository(ies)',
    'Foam': 'application(s)',
    'Chew bite': 'piece(s)',
    'Nasal capsule': 'capsule(s)',
    'Toothpaste': 'application(s)',
    'Shampoo': 'application(s)',
    'Herb': 'tablet(s)',
    'Others': 'unit(s)',
  };

  static const Map<String, List<String>> compatibleUnitsByFormLabel = {
    'Tablet': ['tablet(s)', 'piece(s)', 'unit(s)'],
    'Capsule': ['capsule(s)', 'piece(s)', 'unit(s)'],
    'Softgel': ['softgel(s)', 'capsule(s)', 'piece(s)', 'unit(s)'],
    'Liquid / Syrup': ['ml', 'tsp', 'tbsp', 'drop(s)'],
    'Drops': ['drop(s)', 'ml'],
    'Injection': ['ml', 'IU', 'unit(s)', 'ampoule(s)', 'injection(s)'],
    'Inhaler': ['puff(s)', 'inhalation(s)'],
    'Cream': ['application(s)', 'g', 'mm'],
    'Ointment': ['application(s)', 'g', 'mm'],
    'Gel': ['application(s)', 'g', 'ml'],
    'Lotion': ['application(s)', 'ml', 'g'],
    'Spray': ['spray(s)', 'puff(s)', 'ml'],
    'Sublingual': ['tablet(s)', 'piece(s)', 'unit(s)'],
    'Patch': ['patch(es)', 'piece(s)'],
    'Chewable': ['tablet(s)', 'piece(s)', 'unit(s)'],
    'Gummy': ['gummy(ies)', 'piece(s)'],
    'Lozenge': ['lozenge(s)', 'piece(s)'],
    'Powder / Sachet': ['sachet(s)', 'packet(s)', 'g', 'portion(s)', 'tsp', 'tbsp'],
    'Suppository': ['suppository(ies)', 'piece(s)', 'pessary(ies)'],
    'Foam': ['application(s)', 'ml', 'g'],
    'Chew bite': ['piece(s)', 'chew(s)'],
    'Nasal capsule': ['capsule(s)', 'piece(s)', 'inhalation(s)'],
    'Toothpaste': ['application(s)', 'g'],
    'Shampoo': ['application(s)', 'ml', 'g'],
    'Herb': ['tablet(s)', 'capsule(s)', 'g', 'ml', 'portion(s)', 'tsp', 'tbsp', 'piece(s)'],
    'Others': [
      'unit(s)',
      'tablet(s)',
      'capsule(s)',
      'ml',
      'drop(s)',
      'puff(s)',
      'application(s)',
      'g',
    ],
  };

  static String defaultUnitForForm(String formLabel) {
    return defaultUnitByFormLabel[formLabel] ?? 'unit(s)';
  }

  static List<String> compatibleUnitsForForm(String formLabel) {
    return compatibleUnitsByFormLabel[formLabel] ??
        compatibleUnitsByFormLabel['Others']!;
  }
}
