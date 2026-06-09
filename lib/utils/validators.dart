class Validator {
  static String? validate(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return "$fieldName is Required";
    }
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Phone Number is required";
    }

    if (!RegExp(r'^[0-9]{10}$').hasMatch(value!.trim())) {
      return "Enter valid 10 digit Phone Number";
    }

    return null;
  }

  static String? accountNumber(String? value) {
    if (!RegExp(r'^[0-9]{9,18}$').hasMatch(value!.trim())) {
      return "Enter Valid Account Number";
    }

    return null;
  }

  static String? ifsc(String? value) {
    if (!RegExp(
      r'^[A-Z]{4}0[A-Z0-9]{6}$',
    ).hasMatch(value!.trim().toUpperCase())) {
      return "Enter Valid IFSC Code";
    }

    return null;
  }

  static String? upi(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    if (!RegExp(r'^[a-zA-Z0-9.\-_]{2,}@[a-zA-Z]{2,}$').hasMatch(value.trim())) {
      return "Enter Valid UPI ID";
    }

    return null;
  }

  static String? positiveNumber(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return "$fieldName is Required";
    }

    final cleanedValue = value.replaceAll(',', '');

    final numValue = int.tryParse(cleanedValue);

    if (numValue == null || numValue < 0) {
      return "Enter Valid $fieldName";
    }

    return null;
  }

  static String? optionalPositiveNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // not mandatory
    }

    final cleanedValue = value.replaceAll(',', '');

    final numValue = int.tryParse(cleanedValue);

    if (numValue == null || numValue < 0) {
      return "Enter a Valid Number";
    }

    return null;
  }

  static String? rating(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    final rating = double.tryParse(value);

    if (rating == null) {
      return "Invalid Rating";
    }

    if (rating < 1 || rating > 5) {
      return "Rating must be between 1 and 5";
    }

    return null;
  }

  static String? name(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return "$fieldName is Required";
    }

    if (!RegExp(r'^[a-zA-Z0-9 .&()-]+$').hasMatch(value.trim())) {
      return "Enter Valid $fieldName";
    }

    return null;
  }

  static String? bankName(String? value) {
    if (!RegExp(r'^[a-zA-Z.& ]+$').hasMatch(value!.trim())) {
      return "Enter Valid Bank Name";
    }

    return null;
  }
}
