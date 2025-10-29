/// Login type enumeration (matching Java LoginType)
enum LoginType {
  phoneNumber,
  email,
  google,
  facebook,
  guest;

  // Static constants for backward compatibility
  static const LoginType PHONE_NUMBER = LoginType.phoneNumber;
  static const LoginType EMAIL = LoginType.email;
  static const LoginType GOOGLE = LoginType.google;
  static const LoginType FACEBOOK = LoginType.facebook;
  static const LoginType GUEST = LoginType.guest;

  /// Get display name
  String get displayName {
    switch (this) {
      case LoginType.phoneNumber:
        return 'Phone Number';
      case LoginType.email:
        return 'Email';
      case LoginType.google:
        return 'Google';
      case LoginType.facebook:
        return 'Facebook';
      case LoginType.guest:
        return 'Guest';
    }
  }

  /// Convert from string
  static LoginType? fromString(String value) {
    switch (value.toLowerCase()) {
      case 'phone_number':
      case 'phonenumber':
      case 'phone':
        return LoginType.phoneNumber;
      case 'email':
        return LoginType.email;
      case 'google':
        return LoginType.google;
      case 'facebook':
        return LoginType.facebook;
      case 'guest':
        return LoginType.guest;
      default:
        return null;
    }
  }

  /// Convert to API string
  String toApiString() {
    switch (this) {
      case LoginType.phoneNumber:
        return 'phone_number';
      case LoginType.email:
        return 'email';
      case LoginType.google:
        return 'google';
      case LoginType.facebook:
        return 'facebook';
      case LoginType.guest:
        return 'guest';
    }
  }
}



