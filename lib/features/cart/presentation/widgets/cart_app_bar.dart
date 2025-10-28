import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

/// Cart App Bar Widget - matching Java header section
class CartAppBar extends StatelessWidget {
  final VoidCallback onBackPressed;
  final VoidCallback onEditPressed;
  final bool showEditButton;
  final bool isEditMode;

  const CartAppBar({
    super.key,
    required this.onBackPressed,
    required this.onEditPressed,
    required this.showEditButton,
    required this.isEditMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        children: [
          // Header row (matching Java HeaderSection_RelativeLayout)
          Row(
            children: [
              // Cancel/Back button (matching Java CancelIcon_RelativeLayout)
              GestureDetector(
                onTap: onBackPressed,
                child: Container(
                  width: 48,
                  height: 48,
                  alignment: Alignment.centerLeft,
                  child: const Icon(
                    Icons.close,
                    color: AppColors.colorTitleBlack,
                    size: 24,
                  ),
                ),
              ),

              // Title (matching Java Search_EditText)
              Expanded(
                child: Text(
                  'سلتي', // "My Basket"
                  style: AppTextStyles.titleLarge.copyWith(
                    color: AppColors.colorTitleBlack,
                    fontSize: 30,
                  ),
                ),
              ),

              // Edit button (matching Java EditCart_TextView)
              if (showEditButton)
                GestureDetector(
                  onTap: onEditPressed,
                  child: Container(
                    width: 100,
                    height: 48,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      isEditMode ? 'تم' : 'تعديل', // "Done" : "Edit"
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.colorTitleBlack,
                        fontSize: 17,
                        letterSpacing: -0.02,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          // Separator (matching Java CartHeaderSeparator_View)
          if (showEditButton) ...[
            const SizedBox(height: 22),
            Container(
              height: 1,
              color: AppColors.grey3,
            ),
          ],
        ],
      ),
    );
  }
}
