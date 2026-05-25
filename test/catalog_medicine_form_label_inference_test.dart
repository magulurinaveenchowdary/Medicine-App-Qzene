import 'package:flutter_test/flutter_test.dart';
import 'package:med_reminder/core/constants/CatalogMedicineFormLabelInferenceConstants.dart';

void main() {
  test('infers tablet from catalog text', () {
    expect(
      CatalogMedicineFormLabelInferenceConstants.inferFormLabel(
        displayName: 'Metformin 500 MG',
        catalogEntryRaw: 'Metformin 500 MG Oral Tablet',
      ),
      'Tablet',
    );
  });

  test('infers injection', () {
    expect(
      CatalogMedicineFormLabelInferenceConstants.inferFormLabel(
        displayName: 'Lantus',
        catalogEntryRaw: '0.3 ML insulin glargine 100 UNT/ML Injection',
      ),
      'Injection',
    );
  });

  test('infers inhaler', () {
    expect(
      CatalogMedicineFormLabelInferenceConstants.inferFormLabel(
        displayName: 'Ventolin',
        catalogEntryRaw: 'albuterol Inhalation Aerosol',
      ),
      'Inhaler',
    );
  });

  test('falls back to Others', () {
    expect(
      CatalogMedicineFormLabelInferenceConstants.inferFormLabel(
        displayName: 'Mystery compound XYZ',
      ),
      'Others',
    );
  });
}
