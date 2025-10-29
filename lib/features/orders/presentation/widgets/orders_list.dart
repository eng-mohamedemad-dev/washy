import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/order_summary.dart';
import '../../domain/entities/order_details.dart';
import '../../domain/entities/orders_type.dart';

/// Orders list widget matching Java OrdersRecyclerView
class OrdersList extends StatelessWidget {
  final List<OrderSummary> orders;
  final OrdersType orderType;
  final bool isLoadingMore;
  final bool canLoadMore;
  final OrderDetails? expandedOrderDetails;
  final int? expandedPosition;
  final Function(int orderId, int position) onOrderExpanded;
  final Function(int orderId) onOrderCancelled;
  final VoidCallback onLoadMore;

  const OrdersList({
    Key? key,
    required this.orders,
    required this.orderType,
    required this.isLoadingMore,
    required this.canLoadMore,
    this.expandedOrderDetails,
    this.expandedPosition,
    required this.onOrderExpanded,
    required this.onOrderCancelled,
    required this.onLoadMore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.extentAfter < 200 &&
            canLoadMore &&
            !isLoadingMore) {
          onLoadMore();
        }
        return false;
      },
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: orders.length + (isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == orders.length) {
            return const Padding(
              padding: EdgeInsets.all(20),
              child: Center(
                child: CircularProgressIndicator(
                  color: AppColors.washyGreen,
                ),
              ),
            );
          }

          final order = orders[index];
          final isExpanded = expandedPosition == index;

          return _OrderItem(
            order: order,
            isExpanded: isExpanded,
            expandedDetails: isExpanded ? expandedOrderDetails : null,
            onExpanded: () => onOrderExpanded(order.orderId, index),
            onCancelled: () => onOrderCancelled(order.orderId),
          );
        },
      ),
    );
  }
}

/// Individual order item widget
class _OrderItem extends StatelessWidget {
  final OrderSummary order;
  final bool isExpanded;
  final OrderDetails? expandedDetails;
  final VoidCallback onExpanded;
  final VoidCallback onCancelled;

  const _OrderItem({
    required this.order,
    required this.isExpanded,
    this.expandedDetails,
    required this.onExpanded,
    required this.onCancelled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Order header
          _buildOrderHeader(context),

          // Expanded details
          if (isExpanded && expandedDetails != null)
            _buildExpandedDetails(expandedDetails!),
        ],
      ),
    );
  }

  /// Build order header
  Widget _buildOrderHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order ID and Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'طلب #${order.orderId}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkGrey,
                  fontFamily: 'Cairo',
                ),
              ),
              _buildStatusChip(),
            ],
          ),

          const SizedBox(height: 8),

          // Order items
          if (order.orderItems != null)
            Text(
              order.orderItems!,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.grey,
                fontFamily: 'Cairo',
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

          const SizedBox(height: 12),

          // Date and Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDate(order.dateAddedDateTime),
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.grey,
                  fontFamily: 'Cairo',
                ),
              ),
              Text(
                '${order.total} ريال',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.washyGreen,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Action buttons
          Row(
            children: [
              // Expand button
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onExpanded,
                  icon: Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    size: 18,
                    color: AppColors.washyBlue,
                  ),
                  label: Text(
                    isExpanded ? 'إخفاء التفاصيل' : 'عرض التفاصيل',
                    style: const TextStyle(
                      color: AppColors.washyBlue,
                      fontFamily: 'Cairo',
                      fontSize: 14,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.washyBlue),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // Cancel button (if order can be cancelled)
              if (order.canBeCancelled)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onCancelled,
                    icon: const Icon(
                      Icons.cancel_outlined,
                      size: 18,
                      color: Colors.red,
                    ),
                    label: const Text(
                      'إلغاء الطلب',
                      style: TextStyle(
                        color: Colors.red,
                        fontFamily: 'Cairo',
                        fontSize: 14,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 8),
          // Navigation buttons: Details and Tracking
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/order-details',
                      arguments: {
                        'orderId': order.orderId,
                      },
                    );
                  },
                  icon: const Icon(Icons.receipt_long,
                      size: 18, color: AppColors.washyBlue),
                  label: const Text(
                    'تفاصيل الطلب',
                    style: TextStyle(
                        color: AppColors.washyBlue,
                        fontFamily: 'Cairo',
                        fontSize: 14),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.washyBlue),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/order-status',
                      arguments: {
                        'orderId': order.orderId,
                      },
                    );
                  },
                  icon: const Icon(Icons.local_shipping,
                      size: 18, color: AppColors.washyGreen),
                  label: const Text(
                    'تتبع الطلب',
                    style: TextStyle(
                        color: AppColors.washyGreen,
                        fontFamily: 'Cairo',
                        fontSize: 14),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.washyGreen),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build status chip
  Widget _buildStatusChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getStatusColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _getStatusColor()),
      ),
      child: Text(
        order.orderStatus,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: _getStatusColor(),
          fontFamily: 'Cairo',
        ),
      ),
    );
  }

  /// Build expanded details section
  Widget _buildExpandedDetails(OrderDetails details) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'تفاصيل الطلب',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.darkGrey,
              fontFamily: 'Cairo',
            ),
          ),
          const SizedBox(height: 12),

          // Addresses
          if (details.pickupAddress != null || details.deliveryAddress != null)
            _buildAddressInfo(details),

          // Products list
          if (details.products.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildProductsList(details.products),
          ],

          // Notes
          if (details.hasNotes) ...[
            const SizedBox(height: 12),
            _buildNotesSection(details.notes!),
          ],
        ],
      ),
    );
  }

  /// Build address information
  Widget _buildAddressInfo(OrderDetails details) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (details.pickupAddress != null)
          _buildAddressRow(
              'عنوان الاستلام:', details.pickupAddress!.fullAddress ?? ''),
        if (details.deliveryAddress != null) ...[
          const SizedBox(height: 8),
          _buildAddressRow(
              'عنوان التسليم:', details.deliveryAddress!.fullAddress ?? ''),
        ],
      ],
    );
  }

  /// Build address row
  Widget _buildAddressRow(String label, String address) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.darkGrey,
            fontFamily: 'Cairo',
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            address,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.grey,
              fontFamily: 'Cairo',
            ),
          ),
        ),
      ],
    );
  }

  /// Build products list
  Widget _buildProductsList(List<dynamic> products) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'المنتجات:',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.darkGrey,
            fontFamily: 'Cairo',
          ),
        ),
        const SizedBox(height: 8),
        ...products.map((product) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                '• x${product.quantity} ${product.name}',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.grey,
                  fontFamily: 'Cairo',
                ),
              ),
            )),
      ],
    );
  }

  /// Build notes section
  Widget _buildNotesSection(String notes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ملاحظات:',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.darkGrey,
            fontFamily: 'Cairo',
          ),
        ),
        const SizedBox(height: 8),
        Text(
          notes,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.grey,
            fontFamily: 'Cairo',
          ),
        ),
      ],
    );
  }

  /// Get status color based on order status
  Color _getStatusColor() {
    switch (order.orderStatus.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'processing':
        return Colors.blue;
      case 'confirmed':
        return AppColors.washyGreen;
      case 'delivered':
        return AppColors.washyGreen;
      case 'cancelled':
        return Colors.red;
      default:
        return AppColors.grey;
    }
  }

  /// Format date for display
  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.day}/${date.month}/${date.year}';
  }
}
