import 'package:equatable/equatable.dart';
import '../../domain/entities/cart_summary.dart';

/// Cart BLoC States (matching CartActivity states)
abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

/// Initial cart state
class CartInitial extends CartState {
  const CartInitial();
}

/// Cart loading state
class CartLoading extends CartState {
  const CartLoading();
}

/// Cart loaded successfully state
class CartLoaded extends CartState {
  final CartSummary cartSummary;
  final bool isEditMode;

  const CartLoaded({
    required this.cartSummary,
    this.isEditMode = false,
  });

  @override
  List<Object?> get props => [cartSummary, isEditMode];

  /// Copy with updated values
  CartLoaded copyWith({
    CartSummary? cartSummary,
    bool? isEditMode,
  }) {
    return CartLoaded(
      cartSummary: cartSummary ?? this.cartSummary,
      isEditMode: isEditMode ?? this.isEditMode,
    );
  }
}

/// Cart empty state (matching Java showEmptyView)
class CartEmpty extends CartState {
  const CartEmpty();
}

/// Cart error state
class CartError extends CartState {
  final String message;

  const CartError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Cart operation success state (for showing temporary success messages)
class CartOperationSuccess extends CartState {
  final String message;
  final CartSummary cartSummary;
  final bool isEditMode;

  const CartOperationSuccess({
    required this.message,
    required this.cartSummary,
    this.isEditMode = false,
  });

  @override
  List<Object?> get props => [message, cartSummary, isEditMode];
}

/// Navigate to order state (matching Java navigation logic)
class CartNavigateToOrder extends CartState {
  final String destination;
  final String categoryType;

  const CartNavigateToOrder({
    required this.destination,
    required this.categoryType,
  });

  @override
  List<Object?> get props => [destination, categoryType];
}

/// Cart sync in progress state
class CartSyncInProgress extends CartState {
  final CartSummary cartSummary;
  final bool isEditMode;

  const CartSyncInProgress({
    required this.cartSummary,
    this.isEditMode = false,
  });

  @override
  List<Object?> get props => [cartSummary, isEditMode];
}
