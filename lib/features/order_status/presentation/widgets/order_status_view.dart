import 'package:flutter/material.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';
import 'package:wash_flutter/core/constants/app_text_styles.dart';
import 'package:wash_flutter/features/order_status/domain/entities/order_status.dart';

/// OrderStatusView - Custom progress indicator (100% matching Java OrderStatusView)
class OrderStatusView extends StatefulWidget {
  final OrderStatus currentStatus;
  final int orderId;

  const OrderStatusView({
    super.key,
    required this.currentStatus,
    required this.orderId,
  });

  @override
  State<OrderStatusView> createState() => _OrderStatusViewState();
}

class _OrderStatusViewState extends State<OrderStatusView>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  final List<StatusStep> steps = [
    StatusStep(
      title: 'تأكيد',
      subtitle: 'الطلب',
      icon: Icons.check_circle_outline,
    ),
    StatusStep(
      title: 'استلام',
      subtitle: 'الملابس',
      icon: Icons.local_shipping_outlined,
    ),
    StatusStep(
      title: 'معالجة',
      subtitle: 'الطلب',
      icon: Icons.settings_outlined,
    ),
    StatusStep(
      title: 'جاهز',
      subtitle: 'للتسليم',
      icon: Icons.done_all_outlined,
    ),
    StatusStep(
      title: 'خارج',
      subtitle: 'للتسليم',
      icon: Icons.delivery_dining_outlined,
    ),
    StatusStep(
      title: 'تم',
      subtitle: 'التسليم',
      icon: Icons.celebration_outlined,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initAnimation();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _initAnimation() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: (widget.currentStatus.stepNumber + 1) / steps.length,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      child: Column(
        children: [
          // Progress Line with Steps
          SizedBox(
            height: 80,
            child: Stack(
              children: [
                // Background Line
                Positioned(
                  top: 25,
                  left: 30,
                  right: 30,
                  child: Container(
                    height: 3,
                    decoration: BoxDecoration(
                      color: AppColors.grey3,
                      borderRadius: BorderRadius.circular(1.5),
                    ),
                  ),
                ),
                
                // Progress Line (Animated)
                Positioned(
                  top: 25,
                  left: 30,
                  right: 30,
                  child: AnimatedBuilder(
                    animation: _progressAnimation,
                    builder: (context, child) {
                      return Container(
                        height: 3,
                        child: FractionallySizedBox(
                          widthFactor: _progressAnimation.value,
                          alignment: Alignment.centerLeft,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [AppColors.washyBlue, AppColors.washyGreen],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(1.5),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                
                // Step Circles
                Positioned.fill(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(steps.length, (index) {
                      return _buildStepCircle(index);
                    }),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Step Labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(steps.length, (index) {
              return _buildStepLabel(index);
            }),
          ),
        ],
      ),
    );
  }

  /// Build Step Circle
  Widget _buildStepCircle(int index) {
    final isCompleted = index <= widget.currentStatus.stepNumber;
    final isCurrent = index == widget.currentStatus.stepNumber;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        color: isCompleted 
            ? (isCurrent ? AppColors.washyBlue : AppColors.washyGreen)
            : AppColors.grey3,
        shape: BoxShape.circle,
        border: Border.all(
          color: isCompleted 
              ? (isCurrent ? AppColors.washyBlue : AppColors.washyGreen)
              : AppColors.grey2,
          width: 2,
        ),
        boxShadow: isCurrent ? [
          BoxShadow(
            color: AppColors.washyBlue.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ] : null,
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: isCompleted
            ? Icon(
                isCurrent ? steps[index].icon : Icons.check,
                color: AppColors.white,
                size: 14,
                key: ValueKey('step_$index'),
              )
            : Container(
                key: ValueKey('empty_$index'),
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.grey2,
                  shape: BoxShape.circle,
                ),
              ),
      ),
    );
  }

  /// Build Step Label
  Widget _buildStepLabel(int index) {
    final isCompleted = index <= widget.currentStatus.stepNumber;
    final isCurrent = index == widget.currentStatus.stepNumber;
    
    return SizedBox(
      width: 40,
      child: Column(
        children: [
          Text(
            steps[index].title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: 10,
              fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
              color: isCompleted 
                  ? (isCurrent ? AppColors.washyBlue : AppColors.washyGreen)
                  : AppColors.grey2,
            ),
          ),
          Text(
            steps[index].subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: 9,
              color: isCompleted 
                  ? (isCurrent ? AppColors.washyBlue : AppColors.greyDark)
                  : AppColors.grey2,
            ),
          ),
        ],
      ),
    );
  }
}

/// Status Step Model
class StatusStep {
  final String title;
  final String subtitle;
  final IconData icon;

  StatusStep({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}
