class PhoneValidator {
  // Jordan country code and phone validation
  static const String jordanCountryCode = '+962';
  static const String jordanCountryCodeNumber = '962';
  static const int jordanPhoneLength = 10; // Without country code
  
  static bool isValidJordanianMobile(String phoneNumber) {
    // Remove any formatting
    String cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
    
    // Remove country code if present
    if (cleanNumber.startsWith(jordanCountryCodeNumber)) {
      cleanNumber = cleanNumber.substring(jordanCountryCodeNumber.length);
    }
    
    // Remove leading zero if present
    if (cleanNumber.startsWith('0')) {
      cleanNumber = cleanNumber.substring(1);
    }
    
    // Check length (should be 9 digits after removing 0)
    if (cleanNumber.length != 9) {
      return false;
    }
    
    // Check if it starts with valid Jordanian mobile prefixes
    // Jordanian mobile numbers start with 7 after the country code and zero
    return cleanNumber.startsWith('7');
  }

  // Alias for backward compatibility
  static bool isValidJordanianPhoneNumber(String phoneNumber) {
    return isValidJordanianMobile(phoneNumber);
  }
  
  static String formatJordanianPhone(String phoneNumber) {
    String cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
    
    // Remove country code if present
    if (cleanNumber.startsWith(jordanCountryCodeNumber)) {
      cleanNumber = cleanNumber.substring(jordanCountryCodeNumber.length);
    }
    
    // Ensure it starts with 0
    if (!cleanNumber.startsWith('0') && cleanNumber.length == 9) {
      cleanNumber = '0$cleanNumber';
    }
    
    return cleanNumber;
  }
  
  static String getPhoneWithCountryCode(String phoneNumber) {
    String formatted = formatJordanianPhone(phoneNumber);
    
    // Remove leading zero and add country code
    if (formatted.startsWith('0')) {
      formatted = formatted.substring(1);
    }
    
    return '$jordanCountryCodeNumber$formatted';
  }
  
  static bool isValidPhoneNumberLength(String phoneNumber, int expectedLength) {
    String cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
    return cleanNumber.length == expectedLength;
  }
  
  static String getPhoneNumberWithLeadingZero(String phoneNumber) {
    String cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
    
    if (!cleanNumber.startsWith('0') && cleanNumber.length == 9) {
      return '0$cleanNumber';
    }
    
    return cleanNumber;
  }
}

