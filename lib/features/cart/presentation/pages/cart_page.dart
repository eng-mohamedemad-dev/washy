import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../injection_container.dart' as di;
import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';
import '../bloc/cart_state.dart';
import '../widgets/cart_app_bar.dart';
import '../widgets/cart_empty_view.dart';
import '../widgets/cart_items_list.dart';
import '../widgets/cart_summary_section.dart';
import '../widgets/cart_order_button.dart';

/// Cart Page - 100% matching Java CartActivity
class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.getIt<CartBloc>()..add(const LoadCartSummary()),
      child: const CartView(),
    );
  }
}

/// Cart View Widget
class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: BlocConsumer<CartBloc, CartState>(
          listener: (context, state) {
            if (state is CartError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.colorRedError,
                ),
              );
            } else if (state is CartNavigateToOrder) {
              _handleOrderNavigation(context, state);
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                // Header section (matching Java layout header)
                CartAppBar(
                  onBackPressed: () => Navigator.of(context).pop(),
                  onEditPressed: () => context.read<CartBloc>().add(
                    const ToggleEditMode(),
                  ),
                  showEditButton: state is CartLoaded && state.cartSummary.hasItems,
                  isEditMode: state is CartLoaded ? state.isEditMode : false,
                ),

                // Content section
                Expanded(
                  child: _buildContent(context, state),
                ),

                // Order button (matching Java OrderNow_TextView)
                if (state is CartLoaded && state.cartSummary.hasItems)
                  CartOrderButton(
                    onPressed: () => _handleMainOrderPress(context, state),
                    cartSummary: state.cartSummary,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Build content based on state
  Widget _buildContent(BuildContext context, CartState state) {
    if (state is CartLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.washyBlue),
        ),
      );
    }

    if (state is CartEmpty) {
      return CartEmptyView(
        onBrowseItemsPressed: () => Navigator.of(context).pop(),
      );
    }

    if (state is CartLoaded) {
      return Column(
        children: [
          // Summary section (matching Java SubTotalSection_RelativeLayout)
          CartSummarySection(
            cartSummary: state.cartSummary,
          ),

          // Separator (matching Java separator view)
          Container(
            height: 1,
            color: AppColors.grey3,
            margin: const EdgeInsets.symmetric(horizontal: 16),
          ),

          const SizedBox(height: 10),

          // Cart items list (matching Java CartRecyclerView)
          Expanded(
            child: CartItemsList(
              cartSummary: state.cartSummary,
              isEditMode: state.isEditMode,
              onQuantityChanged: (productId, newQuantity) {
                context.read<CartBloc>().add(
                  UpdateItemQuantity(
                    productId: productId,
                    newQuantity: newQuantity,
                  ),
                );
              },
              onRemoveItem: (productId) {
                context.read<CartBloc>().add(
                  RemoveItemFromCart(productId: productId),
                );
              },
              onCategoryOrderPressed: (categoryType) {
                context.read<CartBloc>().add(
                  NavigateToOrder(categoryType: categoryType),
                );
              },
            ),
          ),
        ],
      );
    }

    if (state is CartError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.colorRedError,
            ),
            const SizedBox(height: 16),
            Text(
              'خطأ في تحميل السلة',
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.colorRedError,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              state.message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.grey2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.read<CartBloc>().add(
                const LoadCartSummary(),
              ),
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  /// Handle main order button press (matching Java navigateToOrderPage)
  void _handleMainOrderPress(BuildContext context, CartLoaded state) {
    // Determine primary category type for navigation
    final nonEmptyCategories = state.cartSummary.nonEmptyCategories;
    if (nonEmptyCategories.isNotEmpty) {
      final primaryCategory = nonEmptyCategories.first;
      context.read<CartBloc>().add(
        NavigateToOrder(categoryType: primaryCategory.type),
      );
    }
  }

  /// Handle order navigation (matching Java CartNavigationManager)
  void _handleOrderNavigation(BuildContext context, CartNavigateToOrder state) {
    switch (state.destination) {
      case 'DISINFECTION':
        Navigator.pushNamed(context, '/disinfection_order');
        break;
      case 'FURNITURE':
        Navigator.pushNamed(context, '/furniture_order');
        break;
      case 'HOUSEKEEPING':
        Navigator.pushNamed(context, '/housekeeping_order');
        break;
      case 'CAR_CLEANING':
        Navigator.pushNamed(context, '/car_cleaning_order');
        break;
      case 'CREATE_ORDER_PAGE':
      default:
        Navigator.pushNamed(context, '/new_order');
        break;
    }
  }
}
