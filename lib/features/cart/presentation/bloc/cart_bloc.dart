import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/add_item_to_cart.dart' as use_cases;
import '../../domain/usecases/clear_cart.dart' as use_cases;
import '../../domain/usecases/get_cart_summary.dart' as use_cases;
import '../../domain/usecases/remove_item_from_cart.dart' as use_cases;
import '../../domain/usecases/update_item_quantity.dart' as use_cases;
import 'cart_event.dart';
import 'cart_state.dart';

/// Cart BLoC (matching CartActivity logic)
class CartBloc extends Bloc<CartEvent, CartState> {
  final use_cases.GetCartSummary getCartSummary;
  final use_cases.AddItemToCart addItemToCart;
  final use_cases.UpdateItemQuantity updateItemQuantity;
  final use_cases.RemoveItemFromCart removeItemFromCart;
  final use_cases.ClearCart clearCart;

  CartBloc({
    required this.getCartSummary,
    required this.addItemToCart,
    required this.updateItemQuantity,
    required this.removeItemFromCart,
    required this.clearCart,
  }) : super(const CartInitial()) {
    on<LoadCartSummary>(_onLoadCartSummary);
    on<AddItemToCart>(_onAddItemToCart);
    on<UpdateItemQuantity>(_onUpdateItemQuantity);
    on<RemoveItemFromCart>(_onRemoveItemFromCart);
    on<ClearCart>(_onClearCart);
    on<ToggleEditMode>(_onToggleEditMode);
    on<NavigateToOrder>(_onNavigateToOrder);
    on<RefreshCart>(_onRefreshCart);
  }

  /// Handle load cart summary event
  Future<void> _onLoadCartSummary(
    LoadCartSummary event,
    Emitter<CartState> emit,
  ) async {
    emit(const CartLoading());

    final result = await getCartSummary(NoParams());

    result.fold(
      (failure) => emit(CartError(message: failure.message)),
      (cartSummary) {
        if (cartSummary.isEmpty || !cartSummary.hasItems) {
          emit(const CartEmpty());
        } else {
          emit(CartLoaded(cartSummary: cartSummary));
        }
      },
    );
  }

  /// Handle add item to cart event
  Future<void> _onAddItemToCart(
    AddItemToCart event,
    Emitter<CartState> emit,
  ) async {
    if (state is CartLoaded) {
      final currentState = state as CartLoaded;
      emit(CartLoading());

      final result = await addItemToCart(
        use_cases.AddItemToCartParams(item: event.item),
      );

      result.fold(
        (failure) => emit(CartError(message: failure.message)),
        (_) {
          // Reload cart summary after adding item
          add(const LoadCartSummary());
        },
      );
    } else {
      // If not loaded, add item and then load
      final result = await addItemToCart(
        use_cases.AddItemToCartParams(item: event.item),
      );

      result.fold(
        (failure) => emit(CartError(message: failure.message)),
        (_) {
          add(const LoadCartSummary());
        },
      );
    }
  }

  /// Handle update item quantity event
  Future<void> _onUpdateItemQuantity(
    UpdateItemQuantity event,
    Emitter<CartState> emit,
  ) async {
    if (state is CartLoaded) {
      final currentState = state as CartLoaded;

      final result = await updateItemQuantity(
        use_cases.UpdateItemQuantityParams(
          productId: event.productId,
          newQuantity: event.newQuantity,
        ),
      );

      result.fold(
        (failure) => emit(CartError(message: failure.message)),
        (_) {
          // Reload cart summary after updating quantity
          add(const LoadCartSummary());
        },
      );
    }
  }

  /// Handle remove item from cart event
  Future<void> _onRemoveItemFromCart(
    RemoveItemFromCart event,
    Emitter<CartState> emit,
  ) async {
    if (state is CartLoaded) {
      final currentState = state as CartLoaded;

      final result = await removeItemFromCart(
        use_cases.RemoveItemFromCartParams(productId: event.productId),
      );

      result.fold(
        (failure) => emit(CartError(message: failure.message)),
        (_) {
          // Reload cart summary after removing item
          add(const LoadCartSummary());
        },
      );
    }
  }

  /// Handle clear cart event
  Future<void> _onClearCart(
    ClearCart event,
    Emitter<CartState> emit,
  ) async {
    final result = await clearCart(
      use_cases.ClearCartParams(orderType: event.orderType),
    );

    result.fold(
      (failure) => emit(CartError(message: failure.message)),
      (_) {
        if (event.orderType == null) {
          // Cleared entire cart
          emit(const CartEmpty());
        } else {
          // Cleared specific type, reload to show updated cart
          add(const LoadCartSummary());
        }
      },
    );
  }

  /// Handle toggle edit mode event (matching Java handleEditMode)
  void _onToggleEditMode(
    ToggleEditMode event,
    Emitter<CartState> emit,
  ) {
    if (state is CartLoaded) {
      final currentState = state as CartLoaded;
      emit(currentState.copyWith(isEditMode: !currentState.isEditMode));
    }
  }

  /// Handle navigate to order event (matching Java navigateToOrderPage)
  void _onNavigateToOrder(
    NavigateToOrder event,
    Emitter<CartState> emit,
  ) {
    if (state is CartLoaded) {
      final currentState = state as CartLoaded;
      
      // Determine navigation destination based on category type
      String destination;
      switch (event.categoryType.toLowerCase()) {
        case 'disinfection':
          destination = 'DISINFECTION';
          break;
        case 'furniture':
          destination = 'FURNITURE';
          break;
        case 'housekeeping':
          destination = 'HOUSEKEEPING';
          break;
        case 'car_cleaning':
          destination = 'CAR_CLEANING';
          break;
        default:
          // Check if should navigate to disinfection based on products
          if (currentState.cartSummary.shouldNavigateToDisinfection) {
            destination = 'DISINFECTION';
          } else {
            destination = 'CREATE_ORDER_PAGE';
          }
      }

      emit(CartNavigateToOrder(
        destination: destination,
        categoryType: event.categoryType,
      ));

      // Return to loaded state after navigation
      emit(currentState);
    }
  }

  /// Handle refresh cart event (matching Java refreshUI)
  void _onRefreshCart(
    RefreshCart event,
    Emitter<CartState> emit,
  ) {
    add(const LoadCartSummary());
  }
}
