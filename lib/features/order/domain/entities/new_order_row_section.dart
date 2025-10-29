import 'package:equatable/equatable.dart';
import 'new_order_section_type.dart';

/// New Order Row Section entity (matching Java NewOrderRowSection)
class NewOrderRowSection extends Equatable {
  final NewOrderSectionType newOrderSectionType;
  final dynamic data; // Can be NewOrderRequest, Product, CreditCard, etc.
  final int spanSize;

  const NewOrderRowSection({
    required this.newOrderSectionType,
    required this.data,
    this.spanSize = 2, // Default span size for GridLayout
  });

  /// Get section title
  String get sectionTitle {
    switch (newOrderSectionType) {
      case NewOrderSectionType.newOrderHeaderSection:
        return 'Order Information';
      case NewOrderSectionType.productsSection:
        return 'Products';
      case NewOrderSectionType.redeemSection:
        return 'Promotions & Discounts';
      case NewOrderSectionType.recycleHanger:
        return 'Recycle Hangers';
      case NewOrderSectionType.terms:
        return 'Terms & Conditions';
      case NewOrderSectionType.newOrderTotalSection:
        return 'Order Total';
      case NewOrderSectionType.importantNoteSection:
        return 'Important Notes';
      case NewOrderSectionType.paymentSection:
        return 'Payment Method';
      default:
        return '';
    }
  }

  /// Get Arabic section title
  String get arabicSectionTitle {
    switch (newOrderSectionType) {
      case NewOrderSectionType.newOrderHeaderSection:
        return 'معلومات الطلب';
      case NewOrderSectionType.productsSection:
        return 'المنتجات';
      case NewOrderSectionType.redeemSection:
        return 'العروض والخصومات';
      case NewOrderSectionType.recycleHanger:
        return 'إعادة تدوير الشماعات';
      case NewOrderSectionType.terms:
        return 'الشروط والأحكام';
      case NewOrderSectionType.newOrderTotalSection:
        return 'إجمالي الطلب';
      case NewOrderSectionType.importantNoteSection:
        return 'ملاحظات مهمة';
      case NewOrderSectionType.paymentSection:
        return 'طريقة الدفع';
      default:
        return '';
    }
  }

  @override
  List<Object?> get props => [
        newOrderSectionType,
        data,
        spanSize,
      ];

  /// Copy with updated values
  NewOrderRowSection copyWith({
    NewOrderSectionType? newOrderSectionType,
    dynamic data,
    int? spanSize,
  }) {
    return NewOrderRowSection(
      newOrderSectionType: newOrderSectionType ?? this.newOrderSectionType,
      data: data ?? this.data,
      spanSize: spanSize ?? this.spanSize,
    );
  }
}
