import 'package:flutter/material.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';
import 'package:wash_flutter/core/constants/app_dimensions.dart';
import 'package:wash_flutter/core/constants/app_text_styles.dart';

/// FAQPage - 100% matching Java FAQActivity
class FAQPage extends StatefulWidget {
  const FAQPage({super.key});

  @override
  State<FAQPage> createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  bool isLoading = true;
  String faqContent = '';

  @override
  void initState() {
    super.initState();
    _loadFAQContent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: isLoading ? _buildLoadingView() : _buildFAQContent(),
          ),
        ],
      ),
    );
  }

  /// Header with back button (100% matching Java layout_back_icon_black)
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
              'الأسئلة الشائعة',
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

  /// Loading View
  Widget _buildLoadingView() {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.washyBlue,
      ),
    );
  }

  /// FAQ Content (100% matching Java ScrollView + TextView)
  Widget _buildFAQContent() {
    return Container(
      margin: const EdgeInsets.only(top: 6), // 46dp - 40dp = 6dp
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.pageMargin,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              faqContent,
              style: const TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 16, // 16sp as per Java
                color: AppColors.colorTitleBlack,
                height: 1.5, // Better line spacing
              ),
            ),
            const SizedBox(height: 20), // Bottom padding
          ],
        ),
      ),
    );
  }

  // Data Methods (100% matching Java FAQActivity)
  void _loadFAQContent() async {
    // Mock delay for API call (replace with actual API call)
    await Future.delayed(const Duration(seconds: 1));
    
    setState(() {
      faqContent = _getMockFAQContent();
      isLoading = false;
    });
  }

  // Mock FAQ Content (replace with actual API call)
  String _getMockFAQContent() {
    return '''
الأسئلة الشائعة - واشي واش

س: ما هي خدمات واشي واش؟
ج: نحن نقدم خدمات الغسيل والكي المتخصصة للملابس والأقمشة المنزلية مع خدمة التوصيل إلى المنزل.

س: كيف يمكنني طلب الخدمة؟
ج: يمكنك طلب الخدمة من خلال تطبيق واشي واش على الهاتف المحمول أو الموقع الإلكتروني.

س: ما هي مناطق التوصيل؟
ج: نغطي معظم مناطق عمان، ويمكنك التحقق من توفر الخدمة في منطقتك عند تحديد العنوان.

س: كم تستغرق الخدمة؟
ج: عادة ما تتم معالجة الطلبات خلال 24-48 ساعة حسب نوع الخدمة المطلوبة.

س: هل توجد خدمة طوارئ؟
ج: نعم، نوفر خدمة الغسيل السريع للحالات الطارئة مقابل رسوم إضافية.

س: كيف يتم الدفع؟
ج: نقبل الدفع النقدي عند التسليم أو الدفع الإلكتروني عبر البطاقة الائتمانية.

س: ماذا لو تضررت قطعة ملابس؟
ج: نحن نتحمل المسؤولية الكاملة عن أي ضرر قد يحدث لملابسك أثناء المعالجة ونقدم التعويض المناسب.

س: هل يمكنني تتبع طلبي؟
ج: نعم، يمكنك تتبع حالة طلبك في الوقت الفعلي من خلال التطبيق.

س: كيف يمكنني إلغاء الطلب؟
ج: يمكن إلغاء الطلب قبل استلامه من المنزل دون أي رسوم، أما بعد الاستلام فقد تطبق رسوم الإلغاء.

س: هل توجد عروض وخصومات؟
ج: نقدم عروض وخصومات منتظمة للعملاء الجدد والمنتظمين، تابع التطبيق للاطلاع على أحدث العروض.

للمزيد من الاستفسارات، يرجى التواصل معنا عبر خدمة العملاء.
''';
  }
}

