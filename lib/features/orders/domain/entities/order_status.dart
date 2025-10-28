import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Order status enumeration matching Java OrderStatus enum
enum OrderStatus {
  PENDING,
  PROCESSING,
  CONFIRMED,
  PICKED_UP,
  IN_PROGRESS,
  READY_FOR_DELIVERY,
  DELIVERED,
  COMPLETED,
  CANCELLED;

  /// Get the display name in Arabic
  String get displayName {
    switch (this) {
      case OrderStatus.PENDING:
        return 'في الانتظار';
      case OrderStatus.PROCESSING:
        return 'قيد المعالجة';
      case OrderStatus.CONFIRMED:
        return 'مؤكد';
      case OrderStatus.PICKED_UP:
        return 'تم الاستلام';
      case OrderStatus.IN_PROGRESS:
        return 'قيد التنفيذ';
      case OrderStatus.READY_FOR_DELIVERY:
        return 'جاهز للتسليم';
      case OrderStatus.DELIVERED:
        return 'تم التسليم';
      case OrderStatus.COMPLETED:
        return 'مكتمل';
      case OrderStatus.CANCELLED:
        return 'ملغي';
    }
  }

  /// Get the status color
  Color get color {
    switch (this) {
      case OrderStatus.PENDING:
        return Colors.orange;
      case OrderStatus.PROCESSING:
        return Colors.blue;
      case OrderStatus.CONFIRMED:
        return AppColors.washyGreen;
      case OrderStatus.PICKED_UP:
        return AppColors.washyBlue;
      case OrderStatus.IN_PROGRESS:
        return Colors.purple;
      case OrderStatus.READY_FOR_DELIVERY:
        return Colors.teal;
      case OrderStatus.DELIVERED:
        return AppColors.washyGreen;
      case OrderStatus.COMPLETED:
        return AppColors.washyGreen;
      case OrderStatus.CANCELLED:
        return Colors.red;
    }
  }

  /// Get the status icon
  IconData get icon {
    switch (this) {
      case OrderStatus.PENDING:
        return Icons.hourglass_empty;
      case OrderStatus.PROCESSING:
        return Icons.auto_awesome;
      case OrderStatus.CONFIRMED:
        return Icons.check_circle;
      case OrderStatus.PICKED_UP:
        return Icons.local_shipping;
      case OrderStatus.IN_PROGRESS:
        return Icons.cleaning_services;
      case OrderStatus.READY_FOR_DELIVERY:
        return Icons.inventory;
      case OrderStatus.DELIVERED:
        return Icons.delivery_dining;
      case OrderStatus.COMPLETED:
        return Icons.done_all;
      case OrderStatus.CANCELLED:
        return Icons.cancel;
    }
  }

  /// Check if the order can be cancelled
  bool get canBeCancelled {
    return this == OrderStatus.PENDING || 
           this == OrderStatus.PROCESSING ||
           this == OrderStatus.CONFIRMED;
  }

  /// Check if the order can be tracked
  bool get canBeTracked {
    return this != OrderStatus.CANCELLED && 
           this != OrderStatus.COMPLETED;
  }

  /// Check if the order is in a final state
  bool get isFinalState {
    return this == OrderStatus.COMPLETED || 
           this == OrderStatus.CANCELLED;
  }

  /// Create OrderStatus from string
  static OrderStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'pending':
        return OrderStatus.PENDING;
      case 'processing':
        return OrderStatus.PROCESSING;
      case 'confirmed':
        return OrderStatus.CONFIRMED;
      case 'picked_up':
        return OrderStatus.PICKED_UP;
      case 'in_progress':
        return OrderStatus.IN_PROGRESS;
      case 'ready_for_delivery':
        return OrderStatus.READY_FOR_DELIVERY;
      case 'delivered':
        return OrderStatus.DELIVERED;
      case 'completed':
        return OrderStatus.COMPLETED;
      case 'cancelled':
        return OrderStatus.CANCELLED;
      default:
        return OrderStatus.PENDING;
    }
  }

  /// Convert to API string
  String get apiValue {
    return name.toLowerCase();
  }
}
