import 'package:flutter/material.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';
import 'package:wash_flutter/core/constants/app_text_styles.dart';

/// TermsAndConditionsPage - 100% matching Java TermsAndConditionsActivity
class TermsAndConditionsPage extends StatefulWidget {
  const TermsAndConditionsPage({super.key});

  @override
  State<TermsAndConditionsPage> createState() => _TermsAndConditionsPageState();
}

class _TermsAndConditionsPageState extends State<TermsAndConditionsPage> {
  bool isPage1 = true; // Track current page
  bool canContinue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorBackground,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildContent()),
          _buildContinueButton(),
        ],
      ),
    );
  }

  /// Header (100% matching Java layout)
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
              'الشروط والأحكام',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.colorTitleBlack,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  /// Content (100% matching Java TermsPage1 & TermsPage2)
  Widget _buildContent() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: isPage1 ? _buildPage1() : _buildPage2(),
    );
  }

  /// Terms Page 1 (100% matching Java TermsPage1_RelativeLayout)
  Widget _buildPage1() {
    return SingleChildScrollView(
      key: const ValueKey('page1'),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Text
          const Text(
            'مرحباً بك في واشي واش',
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.colorTitleBlack,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Terms Introduction
          const Text(
            'يرجى قراءة الشروط والأحكام التالية بعناية قبل استخدام خدماتنا:',
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: 16,
              color: AppColors.greyDark,
              height: 1.5,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Terms Sections
          _buildTermsSection(
            title: '1. قبول الشروط',
            content: 'باستخدامك لتطبيق واشي واش وخدماتنا، فإنك توافق على الالتزام بهذه الشروط والأحكام. إذا كنت لا توافق على أي من هذه الشروط، يرجى عدم استخدام التطبيق.',
          ),
          
          _buildTermsSection(
            title: '2. وصف الخدمة',
            content: 'واشي واش يقدم خدمات الغسيل والتنظيف للملابس والمنسوجات مع خدمة التوصيل والاستلام. نحن نسعى لتقديم أفضل جودة ممكنة في الوقت المحدد.',
          ),
          
          _buildTermsSection(
            title: '3. التسجيل والحساب',
            content: 'يجب عليك التسجيل وإنشاء حساب لاستخدام خدماتنا. أنت مسؤول عن الحفاظ على سرية معلومات حسابك وكلمة المرور.',
          ),
          
          _buildTermsSection(
            title: '4. الطلبات والأسعار',
            content: 'جميع الأسعار المعروضة تشمل ضريبة المبيعات. نحتفظ بالحق في تغيير الأسعار في أي وقت. الطلبات خاضعة للتوفر وقد نرفض أي طلب وفقاً لتقديرنا.',
          ),
          
          const SizedBox(height: 32),
          
          // Continue Reading Button
          Center(
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  isPage1 = false;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.washyBlue,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text(
                'متابعة القراءة',
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 16,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Terms Page 2 (100% matching Java TermsPage2_RelativeLayout)
  Widget _buildPage2() {
    return SingleChildScrollView(
      key: const ValueKey('page2'),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back to Page 1 Button
          TextButton.icon(
            onPressed: () {
              setState(() {
                isPage1 = true;
              });
            },
            icon: const Icon(Icons.arrow_back, color: AppColors.washyBlue),
            label: const Text(
              'العودة للصفحة الأولى',
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                color: AppColors.washyBlue,
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // More Terms Sections
          _buildTermsSection(
            title: '5. الدفع والفواتير',
            content: 'يمكن الدفع نقداً عند التسليم أو بالبطاقة الائتمانية. جميع المدفوعات مستحقة عند استلام الخدمة. في حالة تأخير الدفع، نحتفظ بالحق في تعليق الخدمة.',
          ),
          
          _buildTermsSection(
            title: '6. المسؤولية والضمان',
            content: 'نحن نتعامل مع ملابسك بأقصى درجات العناية، لكننا غير مسؤولين عن الأضرار الناتجة عن عيوب في النسيج أو الملابس التالفة مسبقاً. الضمان محدود بقيمة الملابس.',
          ),
          
          _buildTermsSection(
            title: '7. الإلغاء والاسترداد',
            content: 'يمكن إلغاء الطلب خلال ساعة من تقديمه. بعد بدء عملية الغسيل، لا يمكن إلغاء الطلب. سياسة الاسترداد تطبق حسب حالة كل طلب على حدة.',
          ),
          
          _buildTermsSection(
            title: '8. حماية البيانات',
            content: 'نحن ملتزمون بحماية خصوصيتك وفقاً لسياسة الخصوصية الخاصة بنا. معلوماتك الشخصية آمنة ولن تُشارك مع أطراف ثالثة دون موافقتك.',
          ),
          
          _buildTermsSection(
            title: '9. تعديل الشروط',
            content: 'نحتفظ بالحق في تعديل هذه الشروط في أي وقت. سيتم إشعارك بأي تغييرات مهمة عبر التطبيق أو البريد الإلكتروني.',
          ),
          
          _buildTermsSection(
            title: '10. القانون الساري',
            content: 'هذه الشروط محكومة بقوانين المملكة الأردنية الهاشمية. أي نزاع سيحل في المحاكم المختصة في عمان.',
          ),
          
          const SizedBox(height: 32),
          
          // Acceptance Checkbox
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.washyGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.washyGreen.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Checkbox(
                  value: canContinue,
                  onChanged: (value) {
                    setState(() {
                      canContinue = value ?? false;
                    });
                  },
                  activeColor: AppColors.washyGreen,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'أوافق على جميع الشروط والأحكام المذكورة أعلاه',
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 15,
                      color: AppColors.greyDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Continue Button (100% matching Java Continue_CardView)
  Widget _buildContinueButton() {
    return Container(
      margin: const EdgeInsets.all(24),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          onPressed: canContinue ? _onContinuePressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: canContinue ? AppColors.washyGreen : AppColors.grey3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(27.5),
            ),
          ),
          child: const Text(
            'المتابعة',
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

  /// Terms Section Widget
  Widget _buildTermsSection({required String title, required String content}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.colorTitleBlack,
            ),
          ),
          const SizedBox(height: 8),
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
    );
  }

  // Actions (100% matching Java TermsAndConditionsActivity)
  void _onContinuePressed() {
    // Return acceptance result
    Navigator.pop(context, true);
  }
}



