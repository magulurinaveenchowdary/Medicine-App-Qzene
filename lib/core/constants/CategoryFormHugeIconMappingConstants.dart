import 'package:hugeicons/hugeicons.dart';

/// Hugeicons for each medicine form tile (stroke-rounded, free bundle).
class CategoryFormHugeIconMappingConstants {
  CategoryFormHugeIconMappingConstants._();

  static const Map<String, List<List<dynamic>>> iconByFormLabel = {
    'Tablet': HugeIcons.strokeRoundedPillsTablet,
    'Capsule': HugeIcons.strokeRoundedMedicine02,
    'Softgel': HugeIcons.strokeRoundedMedicine01,
    'Liquid / Syrup': HugeIcons.strokeRoundedMedicineSyrup,
    'Drops': HugeIcons.strokeRoundedDropper,
    'Injection': HugeIcons.strokeRoundedInjection,
    'Inhaler': HugeIcons.strokeRoundedLungs,
    'Cream': HugeIcons.strokeRoundedBodySoap,
    'Ointment': HugeIcons.strokeRoundedMedicineBottle01,
    'Gel': HugeIcons.strokeRoundedDroplet,
    'Lotion': HugeIcons.strokeRoundedHandSanitizer,
    'Spray': HugeIcons.strokeRoundedSprayCan,
    'Sublingual': HugeIcons.strokeRoundedWave,
    'Patch': HugeIcons.strokeRoundedBandage,
    'Chewable': HugeIcons.strokeRoundedCookie,
    'Gummy': HugeIcons.strokeRoundedCandy,
    'Lozenge': HugeIcons.strokeRoundedHexagon,
    'Powder / Sachet': HugeIcons.strokeRoundedPackage01,
    'Suppository': HugeIcons.strokeRoundedMedicineBottle02,
    'Foam': HugeIcons.strokeRoundedBubbles,
    'Chew bite': HugeIcons.strokeRoundedCandy,
    'Nasal capsule': HugeIcons.strokeRoundedPerfume,
    'Toothpaste': HugeIcons.strokeRoundedDentalTooth,
    'Shampoo': HugeIcons.strokeRoundedShampoo,
    'Herb': HugeIcons.strokeRoundedLeaf01,
    'Others': HugeIcons.strokeRoundedQuestion,
  };

  static List<List<dynamic>> iconForLabel(String label) {
    return iconByFormLabel[label] ?? HugeIcons.strokeRoundedQuestion;
  }
}
