/// Navigation Destination enumeration (matching Java NavigationDestination)
enum NavigationDestination {
  disinfection,
  furniture,
  createOrderPage,
  housekeeping,
  carCleaning,
  package;

  /// Get display name
  String get displayName {
    switch (this) {
      case NavigationDestination.disinfection:
        return 'Disinfection';
      case NavigationDestination.furniture:
        return 'Furniture';
      case NavigationDestination.createOrderPage:
        return 'Create Order';
      case NavigationDestination.housekeeping:
        return 'Housekeeping';
      case NavigationDestination.carCleaning:
        return 'Car Cleaning';
      case NavigationDestination.package:
        return 'Package';
    }
  }

  /// Get Arabic display name
  String get arabicDisplayName {
    switch (this) {
      case NavigationDestination.disinfection:
        return 'التعقيم';
      case NavigationDestination.furniture:
        return 'الأثاث';
      case NavigationDestination.createOrderPage:
        return 'إنشاء طلب';
      case NavigationDestination.housekeeping:
        return 'تدبير منزلي';
      case NavigationDestination.carCleaning:
        return 'تنظيف السيارات';
      case NavigationDestination.package:
        return 'باقة';
    }
  }

  /// Convert from string
  static NavigationDestination? fromString(String value) {
    switch (value.toLowerCase()) {
      case 'disinfection':
        return NavigationDestination.disinfection;
      case 'furniture':
        return NavigationDestination.furniture;
      case 'create_order_page':
      case 'createorderpage':
        return NavigationDestination.createOrderPage;
      case 'housekeeping':
        return NavigationDestination.housekeeping;
      case 'car_cleaning':
      case 'carcleaning':
        return NavigationDestination.carCleaning;
      case 'package':
        return NavigationDestination.package;
      default:
        return null;
    }
  }

  /// Convert to API string
  String toApiString() {
    switch (this) {
      case NavigationDestination.disinfection:
        return 'disinfection';
      case NavigationDestination.furniture:
        return 'furniture';
      case NavigationDestination.createOrderPage:
        return 'create_order_page';
      case NavigationDestination.housekeeping:
        return 'housekeeping';
      case NavigationDestination.carCleaning:
        return 'car_cleaning';
      case NavigationDestination.package:
        return 'package';
    }
  }
}
