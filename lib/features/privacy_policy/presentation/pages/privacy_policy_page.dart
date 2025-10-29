import 'package:flutter/material.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';
import 'package:wash_flutter/core/constants/app_text_styles.dart';

/// PrivacyPolicyPage - Privacy policy and terms information
class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorBackground,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  /// Header with back button and title
  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 110,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.washyBlue,
            AppColors.washyGreen,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            // Back Button
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const SizedBox(
                  width: 66,
                  child: Icon(
                    Icons.arrow_back,
                    color: AppColors.white,
                    size: 24,
                  ),
                ),
              ),
            ),

            // Title
            const Positioned(
              left: 66,
              top: 0,
              bottom: 0,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'سياسة الخصوصية',
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 30,
                    color: AppColors.white,
                    letterSpacing: -0.02,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Content with privacy policy
  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Last Updated
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.washyBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.update,
                  color: AppColors.washyBlue,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  'آخر تحديث: 1 يناير 2024',
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 14,
                    color: AppColors.washyBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Introduction
          _buildSection(
            title: 'مقدمة',
            content:
                'نحن في واشي واش نحترم خصوصية مستخدمينا ونلتزم بحماية المعلومات الشخصية التي تشاركونها معنا. تشرح هذه السياسة كيفية جمع واستخدام وحماية المعلومات الخاصة بك عند استخدام تطبيقنا وخدماتنا.',
            icon: Icons.security,
          ),

          const SizedBox(height: 20),

          // Information Collection
          _buildSection(
            title: 'المعلومات التي نجمعها',
            content:
                '• المعلومات الشخصية: الاسم، رقم الهاتف، والعنوان\n• معلومات الطلب: تفاصيل الخدمات المطلوبة والتوقيت\n• معلومات الدفع: معلومات بطاقات الائتمان (مشفرة وآمنة)\n• معلومات الموقع: لتحديد عنوان التسليم والاستلام\n• معلومات الجهاز: نوع الجهاز ونظام التشغيل لتحسين الخدمة',
            icon: Icons.info_outline,
          ),

          const SizedBox(height: 20),

          // How We Use Information
          _buildSection(
            title: 'كيف نستخدم المعلومات',
            content:
                '• تقديم وتنفيذ خدمات الغسيل والتنظيف\n• التواصل معك بخصوص طلباتك\n• معالجة المدفوعات بشكل آمن\n• تحسين جودة الخدمة وتطوير التطبيق\n• إرسال إشعارات حول حالة الطلب\n• التسويق للخدمات الجديدة (مع إمكانية إلغاء الاشتراك)',
            icon: Icons.build_outlined,
          ),

          const SizedBox(height: 20),

          // Information Sharing
          _buildSection(
            title: 'مشاركة المعلومات',
            content:
                'نحن لا نبيع أو نؤجر معلوماتك الشخصية لأطراف ثالثة. قد نشارك المعلومات في الحالات التالية:\n• مع شركاء الخدمة المعتمدين لتنفيذ الطلبات\n• مع معالجات الدفع الآمنة\n• عندما يتطلب القانون ذلك\n• لحماية حقوقنا أو سلامة المستخدمين',
            icon: Icons.share_outlined,
          ),

          const SizedBox(height: 20),

          // Data Security
          _buildSection(
            title: 'أمان البيانات',
            content:
                'نستخدم أحدث تقنيات الحماية لضمان أمان معلوماتك:\n• تشفير البيانات أثناء النقل والتخزين\n• خوادم آمنة ومحمية\n• وصول محدود للموظفين المخولين فقط\n• مراجعة دورية لأنظمة الأمان\n• تحديث مستمر لبروتوكولات الحماية',
            icon: Icons.security,
          ),

          const SizedBox(height: 20),

          // User Rights
          _buildSection(
            title: 'حقوقك',
            content:
                'لديك الحق في:\n• الوصول إلى معلوماتك الشخصية\n• تصحيح المعلومات غير الصحيحة\n• حذف حسابك ومعلوماتك\n• سحب الموافقة على استخدام المعلومات\n• تقديم شكوى إلى السلطات المختصة\n• طلب نسخة من بياناتك',
            icon: Icons.account_circle_outlined,
          ),

          const SizedBox(height: 20),

          // Cookies and Tracking
          _buildSection(
            title: 'ملفات تعريف الارتباط',
            content:
                'نستخدم ملفات تعريف الارتباط (Cookies) وتقنيات مشابهة لـ:\n• تذكر تفضيلاتك وإعداداتك\n• تحليل استخدام التطبيق لتحسين الخدمة\n• تخصيص المحتوى والإعلانات\n• ضمان أمان الجلسات\n\nيمكنك التحكم في هذه الملفات من إعدادات المتصفح.',
            icon: Icons.cookie_outlined,
          ),

          const SizedBox(height: 20),

          // Contact Information
          _buildSection(
            title: 'التواصل معنا',
            content:
                'إذا كان لديك أي أسئلة حول سياسة الخصوصية هذه، يمكنك التواصل معنا:\n\n📞 الهاتف: +962 6 123 4567\n📧 البريد الإلكتروني: privacy@washywash.com\n📍 العنوان: عمان - الأردن\n🌐 الموقع: www.washywash.com',
            icon: Icons.contact_support_outlined,
          ),

          const SizedBox(height: 20),

          // Changes to Policy
          _buildSection(
            title: 'التغييرات على السياسة',
            content:
                'قد نقوم بتحديث سياسة الخصوصية من وقت لآخر. سيتم إشعارك بأي تغييرات مهمة عبر:\n• إشعار في التطبيق\n• رسالة بريد إلكتروني\n• تحديث تاريخ "آخر تحديث" أعلى هذه الصفحة\n\nننصحك بمراجعة هذه السياسة بانتظام للبقاء على اطلاع بكيفية حماية معلوماتك.',
            icon: Icons.update,
          ),

          const SizedBox(height: 32),

          // Acceptance
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.washyGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.washyGreen.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: AppColors.washyGreen,
                      size: 24,
                    ),
                    SizedBox(width: 12),
                    Text(
                      'الموافقة على السياسة',
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.washyGreen,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  'باستخدامك لتطبيق واشي واش وخدماتنا، فإنك توافق على جمع واستخدام معلوماتك وفقاً لهذه السياسة. إذا كنت لا توافق على أي جزء من هذه السياسة، يرجى عدم استخدام التطبيق.',
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 15,
                    color: AppColors.greyDark,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildSection({
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: AppColors.washyBlue,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.colorTitleBlack,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: const TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 15,
                color: AppColors.greyDark,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}



