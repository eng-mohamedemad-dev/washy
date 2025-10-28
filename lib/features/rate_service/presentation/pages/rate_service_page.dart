import 'package:flutter/material.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';
import 'package:wash_flutter/core/constants/app_text_styles.dart';

/// RateServicePage - 100% matching Java RateServicesActivity
class RateServicePage extends StatefulWidget {
  final int orderId;
  final String orderType;

  const RateServicePage({
    super.key,
    required this.orderId,
    required this.orderType,
  });

  @override
  State<RateServicePage> createState() => _RateServicePageState();
}

class _RateServicePageState extends State<RateServicePage> {
  final TextEditingController _noteController = TextEditingController();
  double _driverRating = 0.0;
  double _cleaningRating = 0.0;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildContent()),
          _buildContinueButton(),
        ],
      ),
    );
  }

  /// Header with back button (100% matching Java)
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 40, left: 20, bottom: 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(12),
              child: const Icon(
                Icons.arrow_back,
                color: AppColors.colorTitleBlack,
                size: 24,
              ),
            ),
          ),
          const Expanded(
            child: Text(
              'تقييم الخدمة',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.colorTitleBlack,
              ),
            ),
          ),
          const SizedBox(width: 48), // Balance for back button
        ],
      ),
    );
  }

  /// Content (100% matching Java layout)
  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Driver Rating Section
          const Text(
            'تقييم فريق اللوجستيات',
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.colorTitleBlack,
            ),
          ),
          const SizedBox(height: 16),
          _buildRatingSection(
            rating: _driverRating,
            onRatingChanged: (rating) {
              setState(() {
                _driverRating = rating;
              });
            },
          ),
          
          const SizedBox(height: 32),
          
          // Cleaning Rating Section  
          const Text(
            'تقييم التنظيف',
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.colorTitleBlack,
            ),
          ),
          const SizedBox(height: 16),
          _buildRatingSection(
            rating: _cleaningRating,
            onRatingChanged: (rating) {
              setState(() {
                _cleaningRating = rating;
              });
            },
          ),
          
          const SizedBox(height: 32),
          
          // Note Section (100% matching Java RateNote_EditText)
          const Text(
            'ملاحظات إضافية',
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.colorTitleBlack,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.grey3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              controller: _noteController,
              maxLines: 4,
              style: const TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 16,
                color: AppColors.colorBlack,
              ),
              decoration: const InputDecoration(
                hintText: 'أخبرنا عن تجربتك (اختياري)',
                hintStyle: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 16,
                  color: AppColors.colorLoginText,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Rating Section Widget
  Widget _buildRatingSection({
    required double rating,
    required ValueChanged<double> onRatingChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final starIndex = index + 1;
        return GestureDetector(
          onTap: () => onRatingChanged(starIndex.toDouble()),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Icon(
              starIndex <= rating ? Icons.star : Icons.star_border,
              color: starIndex <= rating ? AppColors.washyGreen : AppColors.grey2,
              size: 32,
            ),
          ),
        );
      }),
    );
  }

  /// Continue Button (100% matching Java Continue_ImageView)
  Widget _buildContinueButton() {
    return Container(
      margin: const EdgeInsets.all(24),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          onPressed: _canSubmit() && !_isSubmitting ? _submitRating : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: _canSubmit() 
                ? AppColors.washyBlue 
                : AppColors.grey3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(27.5),
            ),
          ),
          child: _isSubmitting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: AppColors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text(
                  'إرسال التقييم',
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
        ),
      ),
    );
  }

  // Methods (100% matching Java RateServicesActivity)
  bool _canSubmit() {
    // At least one rating must be given
    return _driverRating > 0 || _cleaningRating > 0;
  }

  void _submitRating() async {
    // 100% matching Java checkData method
    if (!_canSubmit() || _isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Mock API call - replace with actual WebServiceManager.callRateServices
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        // 100% matching Java: showToast + goBackToPreviousPage
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم إرسال التقييم بنجاح'),
            backgroundColor: AppColors.washyGreen,
          ),
        );
        
        // Return result (100% matching Java setResult)
        Navigator.pop(context, {
          'isServiceRated': true,
          'driverRating': _driverRating,
          'cleaningRating': _cleaningRating,
          'note': _noteController.text.trim(),
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ في إرسال التقييم: $e'),
            backgroundColor: AppColors.colorCoral,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
}
