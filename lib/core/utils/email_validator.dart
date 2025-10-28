class EmailValidator {
  static bool isValidEmail(String email) {
    if (email.isEmpty) return false;
    
    // Basic email regex pattern
    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    return emailRegExp.hasMatch(email);
  }
  
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email is required';
    }
    
    if (!isValidEmail(email)) {
      return 'Please enter a valid email address';
    }
    
    return null; // Valid email
  }
}

