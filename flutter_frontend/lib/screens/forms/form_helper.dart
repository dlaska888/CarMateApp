class FormHelper {
  static String? validateFloatInput(value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    try {
      double displacement = double.parse(value);
      if (displacement <= 0) {
        return 'Displacement must be a positive number';
      }
      return null;
    } catch (e) {
      return 'Invalid Displacement format';
    }
  }

  static String? validateIntInput(value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    try {
      int mileage = int.parse(value);
      if (mileage <= 0) {
        return 'Mileage must be a positive number';
      }
      return null;
    } catch (e) {
      return 'Invalid Mileage format';
    }
  }
}
