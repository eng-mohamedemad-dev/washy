import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';
import 'package:wash_flutter/core/constants/app_dimensions.dart';
import 'package:wash_flutter/core/widgets/loading_widget.dart';
import 'package:wash_flutter/features/order/presentation/bloc/order_bloc.dart';
import 'package:wash_flutter/injection_container.dart' as di;

class CreditCardsPage extends StatelessWidget {
  const CreditCardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.getIt<OrderBloc>()..add(GetCreditCardsEvent()),
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.greyDark),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            'بطاقاتي',
            style: TextStyle(color: AppColors.greyDark, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                // TODO: Navigate to Add Credit Card flow if available
              },
              icon: const Icon(Icons.add_card, color: AppColors.washyBlue),
              tooltip: 'إضافة بطاقة',
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(AppDimensions.activityHorizontalMargin),
          child: BlocBuilder<OrderBloc, OrderState>(
            builder: (context, state) {
              if (state is OrderLoading) {
                return const LoadingWidget();
              }
              if (state is CreditCardsLoaded) {
                final cards = state.creditCards;
                if (cards.isEmpty) {
                  return const _EmptyCardsView();
                }
                return ListView.separated(
                  itemCount: cards.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final card = cards[index];
                    return _CreditCardTile(
                      brand: card.brand,
                      last4: card.last4,
                      holder: card.holderName,
                      isDefault: card.isDefault,
                      onMakeDefault: () {
                        // TODO: Implement make default
                      },
                      onDelete: () {
                        // TODO: Implement delete card
                      },
                    );
                  },
                );
              }
              if (state is OrderError) {
                return Center(
                  child: Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                );
              }
              return const LoadingWidget();
            },
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            // TODO: Navigate to Add Credit Card
          },
          backgroundColor: AppColors.washyBlue,
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text('إضافة بطاقة', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}

class _EmptyCardsView extends StatelessWidget {
  const _EmptyCardsView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.credit_card_off, size: 72, color: AppColors.grey2),
          SizedBox(height: 12),
          Text('لا توجد بطاقات محفوظة', style: TextStyle(color: AppColors.greyDark)),
          SizedBox(height: 6),
          Text('أضف بطاقة جديدة لاستخدامها في الدفع', style: TextStyle(color: AppColors.grey2)),
        ],
      ),
    );
  }
}

class _CreditCardTile extends StatelessWidget {
  final String brand;
  final String last4;
  final String holder;
  final bool isDefault;
  final VoidCallback onMakeDefault;
  final VoidCallback onDelete;

  const _CreditCardTile({
    required this.brand,
    required this.last4,
    required this.holder,
    required this.isDefault,
    required this.onMakeDefault,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Color(0x14000000), blurRadius: 12, offset: Offset(0, 6)),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(Icons.credit_card, color: AppColors.washyBlue),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$brand •••• $last4', style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(holder, style: const TextStyle(color: AppColors.grey2)),
              ],
            ),
          ),
          if (isDefault)
            const Chip(label: Text('افتراضية'), backgroundColor: Color(0xFFE9F5FF))
          else
            TextButton(onPressed: onMakeDefault, child: const Text('تعيين افتراضية')),
          IconButton(onPressed: onDelete, icon: const Icon(Icons.delete_outline, color: Colors.red)),
        ],
      ),
    );
  }
}


