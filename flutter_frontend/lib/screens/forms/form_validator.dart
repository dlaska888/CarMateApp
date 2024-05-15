class FormValidator {
  static String? validateFloatInput(value, {String? fieldName = 'Field'}) {
    if (value == null || value.isEmpty) {
      return null;
    }
    try {
      double displacement = double.parse(value);
      if (displacement <= 0) {
        return '$fieldName must be a positive number';
      }
      return null;
    } catch (e) {
      return 'Invalid $fieldName format';
    }
  }

  static String? validateIntInput(value, {String? fieldName = 'Field'}) {
    if (value == null || value.isEmpty) {
      return null;
    }
    try {
      int mileage = int.parse(value);
      if (mileage <= 0) {
        return '$fieldName must be a positive number';
      }
      return null;
    } catch (e) {
      return 'Invalid $fieldName format';
    }
  }
}
