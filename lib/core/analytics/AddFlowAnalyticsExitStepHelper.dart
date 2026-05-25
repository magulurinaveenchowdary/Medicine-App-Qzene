/// Maps add-flow step labels to PRD `addmed_cancelled.exit_step` values.
class AddFlowAnalyticsExitStepHelper {
  AddFlowAnalyticsExitStepHelper._();

  static String fromStepLabel(String? stepLabel) {
    if (stepLabel == null) return 'name';
    final parts = stepLabel.split('/');
    final stepNumber = int.tryParse(parts.first.trim()) ?? 1;
    return switch (stepNumber) {
      1 => 'name',
      2 => 'category',
      3 => 'dose',
      4 => 'schedule',
      5 => 'schedule',
      6 => 'duration',
      7 => 'preview',
      _ => 'name',
    };
  }
}
