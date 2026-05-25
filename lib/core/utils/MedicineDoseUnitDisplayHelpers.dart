/// Display helpers for dose/stock unit labels in add-medicine and detail UI.
class MedicineDoseUnitDisplayHelpers {
  MedicineDoseUnitDisplayHelpers._();

  /// e.g. `tablet(s)` → `tablets left`, `drop(s)` → `drops left`.
  static String buildStockLeftUnitLabel(String doseUnit) {
    final trimmed = doseUnit.trim();
    if (trimmed.isEmpty) return 'left';
    final withoutOptionalPlural = trimmed.replaceAll(RegExp(r'\(s\)'), 's');
    return '$withoutOptionalPlural left';
  }
}
