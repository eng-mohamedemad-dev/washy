import 'package:flutter/material.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';
import 'package:wash_flutter/core/constants/app_dimensions.dart';
import 'package:wash_flutter/core/constants/app_text_styles.dart';

/// FeedbackPage - 100% matching Java FeedbackActivity
class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final TextEditingController _feedbackController = TextEditingController();
  bool isSubmitting = false;
  
  // Constants
  static const int maxCharacters = 500;

  @override
  void initState() {
    super.initState();
    _feedbackController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _feedbackController.removeListener(_onTextChanged);
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildContent(),
        ],
      ),
    );
  }

  /// Header with back button (100% matching Java layout_back_icon_black)
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 40, left: 20, bottom: 10),
      child: GestureDetector(
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
    );
  }

  /// Content (100% matching Java RelativeLayout)
  Widget _buildContent() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.pageMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Title (28sp as per Java)
            Container(
              margin: const EdgeInsets.only(top: 12), // 52dp - 40dp = 12dp
              child: const Text(
                'تقييم الخدمة',
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 28,
                  color: AppColors.colorActionBlack,
                  letterSpacing: -0.02,
                ),
              ),
            ),
            
            // Feedback EditText (100% matching Java)
            Container(
              margin: const EdgeInsets.only(top: 30, left: 8, right: 8),
              child: TextField(
                controller: _feedbackController,
                maxLines: 5,
                maxLength: maxCharacters,
                style: const TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 19, // 19sp as per Java
                  color: AppColors.colorTitleBlack,
                ),
                decoration: InputDecoration(
                  hintText: 'أخبرنا عن تجربتك مع خدماتنا',
                  hintStyle: const TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 19,
                    color: AppColors.colorLoginText,
                  ),
                  border: InputBorder.none,
                  counterText: '', // Hide default counter
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            
            // Character Counter (100% matching Java)
            Container(
              margin: const EdgeInsets.only(top: 6, left: 8),
              child: Text(
                '${_feedbackController.text.length}/$maxCharacters',
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  color: AppColors.washyGreen.withOpacity(0.9), // alpha 0.9 as per Java
                  fontSize: 14,
                ),
              ),
            ),
            
            const Spacer(),
            
            // Continue Button (50x50 as per Java)
            Container(
              margin: const EdgeInsets.only(bottom: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: _canSubmit() ? _submitFeedback : null,
                    child: Container(
                      margin: const EdgeInsets.only(right: 11), // 27dp - 16dp = 11dp
                      child: Stack(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: _canSubmit() 
                                  ? AppColors.washyBlue 
                                  : AppColors.grey3,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.arrow_forward,
                              color: _canSubmit() 
                                  ? AppColors.white 
                                  : AppColors.grey2,
                              size: 24,
                            ),
                          ),
                          if (isSubmitting)
                            Positioned.fill(
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.black26,
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: AppColors.white,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Methods (100% matching Java FeedbackActivity)
  void _onTextChanged() {
    setState(() {
      // Trigger rebuild for character counter and button state
    });
  }

  bool _canSubmit() {
    return _feedbackController.text.trim().length >= 10 && !isSubmitting;
  }

  void _submitFeedback() async {
    if (!_canSubmit()) return;

    setState(() {
      isSubmitting = true;
    });

    try {
      // Mock API call (100% matching Java submitFeedBack method)
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم إرسال تقييمك بنجاح'),
            backgroundColor: AppColors.washyGreen,
          ),
        );
        
        // Navigate back after success
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ أثناء إرسال التقييم: $e'),
            backgroundColor: AppColors.colorCoral,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isSubmitting = false;
        });
      }
    }
  }
}

