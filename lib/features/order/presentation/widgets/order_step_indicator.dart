import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Step indicator widget that shows progress through order creation
/// Matches the Java progress view in BaseNewOrderActivity
class OrderStepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<String> stepLabels;

  const OrderStepIndicator({
    Key? key,
    required this.currentStep,
    required this.totalSteps,
    required this.stepLabels,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Progress bar
          Row(
            children: List.generate(totalSteps, (index) {
              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                    right: index < totalSteps - 1 ? 4 : 0,
                  ),
                  height: 4,
                  decoration: BoxDecoration(
                    color: index < currentStep
                        ? AppColors.washyGreen
                        : AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
          
          const SizedBox(height: 12),
          
          // Step indicators with labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(totalSteps, (index) {
              final isCompleted = index < currentStep;
              final isCurrent = index == currentStep;
              final isUpcoming = index > currentStep;
              
              return Expanded(
                child: Column(
                  children: [
                    // Circle indicator
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isCompleted
                            ? AppColors.washyGreen
                            : isCurrent
                                ? AppColors.washyGreen.withOpacity(0.3)
                                : AppColors.lightGrey,
                        border: Border.all(
                          color: isCompleted || isCurrent
                              ? AppColors.washyGreen
                              : AppColors.lightGrey,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: isCompleted
                            ? const Icon(
                                Icons.check,
                                color: AppColors.white,
                                size: 14,
                              )
                            : Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: isCurrent
                                      ? AppColors.washyGreen
                                      : isUpcoming
                                          ? AppColors.lightGrey
                                          : AppColors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // Step label
                    if (index < stepLabels.length)
                      Text(
                        stepLabels[index],
                        style: TextStyle(
                          color: isCompleted || isCurrent
                              ? AppColors.darkGrey
                              : AppColors.lightGrey,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Cairo',
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
