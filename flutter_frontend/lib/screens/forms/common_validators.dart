import 'package:form_validator/form_validator.dart';

class CommonValidators {
  static getUsernameValidator() {
    return ValidationBuilder()
        .minLength(3)
        .regExp(RegExp('^[a-zA-Z0-9_]+\$'),
            'Only letters, numbers and underscores are allowed')
        .build();
  }

  static getPasswordValidator() {
    return ValidationBuilder()
        .minLength(8)
        .maxLength(128)
        .regExp(RegExp(r'^(?=.*?[A-Z])'),
            'Password must contain at least one uppercase letter')
        .regExp(RegExp(r'^(?=.*?[a-z])'),
            'Password must contain at least one lowercase letter')
        .regExp(RegExp(r'^(?=.*?[0-9])'),
            'Password must contain at least one number')
        .regExp(RegExp(r'^(?=.*?[!@#$%^&*()_\-+={}[\]|;:"<>,./?])'),
            'Password must contain at least one special character')
        .build();
  }
}
