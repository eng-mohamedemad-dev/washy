import 'package:equatable/equatable.dart';
import '../../domain/entities/cart_item.dart';

/// Cart BLoC Events (matching CartActivity functionality)
abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

/// Load cart summary event
class LoadCartSummary extends CartEvent {
  const LoadCartSummary();
}

/// Add item to cart event
class AddItemToCart extends CartEvent {
  final CartItem item;

  const AddItemToCart({required this.item});

  @override
  List<Object?> get props => [item];
}

/// Update item quantity event
class UpdateItemQuantity extends CartEvent {
  final int productId;
  final int newQuantity;

  const UpdateItemQuantity({
    required this.productId,
    required this.newQuantity,
  });

  @override
  List<Object?> get props => [productId, newQuantity];
}

/// Remove item from cart event
class RemoveItemFromCart extends CartEvent {
  final int productId;

  const RemoveItemFromCart({required this.productId});

  @override
  List<Object?> get props => [productId];
}

/// Clear entire cart event
class ClearCart extends CartEvent {
  final String? orderType; // null means clear entire cart

  const ClearCart({this.orderType});

  @override
  List<Object?> get props => [orderType];
}

/// Toggle edit mode event (matching Java handleEditMode)
class ToggleEditMode extends CartEvent {
  const ToggleEditMode();
}

/// Navigate to order page event (matching Java navigateToOrderPage)
class NavigateToOrder extends CartEvent {
  final String categoryType;

  const NavigateToOrder({required this.categoryType});

  @override
  List<Object?> get props => [categoryType];
}

/// Sync cart with server event
class SyncCartWithServer extends CartEvent {
  const SyncCartWithServer();
}

/// Refresh cart UI event (matching Java refreshUI)
class RefreshCart extends CartEvent {
  const RefreshCart();
}
