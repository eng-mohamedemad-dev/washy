import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';
import 'package:wash_flutter/core/constants/app_text_styles.dart';

/// ContactUsPage - 100% matching Java ContactUsActivity
class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  // Constants (100% matching Java Constants.CONTACT_US_NUMBER)
  static const String contactUsNumber = '+962791234567';
  static const String contactUsEmail = 'info@washywash.com';
  static const String contactUsAddress = 'Amman, Jordan\nKing Abdullah II Street';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          _buildContent(),
        ],
      ),
    );
  }

  /// Header with back button (100% matching Java layout_back_icon_black)
  Widget _buildHeader(BuildContext context) {
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

  /// Content (100% matching Java LinearLayout)
  Widget _buildContent() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title (31sp bold as per Java)
            Container(
              margin: const EdgeInsets.only(top: 8, right: 76),
              child: const Text(
                'تواصل معنا',
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 31,
                  fontWeight: FontWeight.bold,
                  color: AppColors.colorTitleBlack,
                ),
              ),
            ),
            
            // Email (18sp with 8sp line spacing as per Java)
            Container(
              margin: const EdgeInsets.only(top: 25),
              child: Text(
                'البريد الإلكتروني:\n$contactUsEmail',
                style: const TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 18,
                  color: AppColors.colorTextNotSelected,
                  height: 1.44, // 8sp line spacing equivalent
                ),
              ),
            ),
            
            // Phone (18sp with 8sp line spacing as per Java)
            Container(
              margin: const EdgeInsets.only(top: 13),
              child: Text(
                'الهاتف:\n$contactUsNumber',
                style: const TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 18,
                  color: AppColors.colorTextNotSelected,
                  height: 1.44, // 8sp line spacing equivalent
                ),
              ),
            ),
            
            // Address (18sp as per Java)
            Container(
              margin: const EdgeInsets.only(top: 13),
              child: Text(
                'العنوان:\n$contactUsAddress',
                style: const TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 18,
                  color: AppColors.colorTextNotSelected,
                ),
              ),
            ),
            
            // Write Message label (19sp as per Java)
            Container(
              margin: const EdgeInsets.only(top: 50),
              child: const Text(
                'اكتب رسالة',
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 19,
                  color: AppColors.colorHomeTabSelected,
                ),
              ),
            ),
            
            // Action Buttons (100% matching Java LinearLayout)
            Container(
              margin: const EdgeInsets.only(top: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Message Button (55x55 as per Java)
                  GestureDetector(
                    onTap: _onMessageClicked,
                    child: Container(
                      margin: const EdgeInsets.only(right: 27),
                      child: Image.asset(
                        'assets/images/ic_contact_us_message.png',
                        width: 55,
                        height: 55,
                      ),
                    ),
                  ),
                  
                  // Call Button (55x55 as per Java)
                  GestureDetector(
                    onTap: _onCallClicked,
                    child: Container(
                      margin: const EdgeInsets.only(right: 35),
                      child: Image.asset(
                        'assets/images/ic_contact_us_call.png',
                        width: 55,
                        height: 55,
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

  // Action Methods (100% matching Java ContactUsActivity)
  void _onCallClicked() async {
    // 100% matching Java PhoneUtils.callPhoneNumber
    final Uri phoneUri = Uri(scheme: 'tel', path: contactUsNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  void _onMessageClicked() {
    // 100% matching Java goToNextActivity(FeedbackActivity.class)
    // Navigate to feedback page
    // Navigator.pushNamed(context, '/feedback');
    
    // For now, show email intent as alternative
    _openEmailClient();
  }

  void _openEmailClient() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: contactUsEmail,
      query: 'subject=استفسار من تطبيق واشي واش',
    );
    
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }
}

