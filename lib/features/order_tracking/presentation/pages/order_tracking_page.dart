import 'package:flutter/material.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';
import 'package:wash_flutter/core/constants/app_text_styles.dart';

/// OrderTrackingPage - Track order status and progress
class OrderTrackingPage extends StatefulWidget {
  const OrderTrackingPage({super.key});

  @override
  State<OrderTrackingPage> createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> {
  int currentStep = 2; // Mock current step
  
  final List<TrackingStep> steps = [
    TrackingStep(
      title: 'تم استلام الطلب',
      description: 'تم تأكيد طلبك بنجاح',
      time: '10:30 ص - اليوم',
      isCompleted: true,
    ),
    TrackingStep(
      title: 'تم استلام الملابس',
      description: 'تم استلام الملابس من عنوانك',
      time: '2:15 م - اليوم',
      isCompleted: true,
    ),
    TrackingStep(
      title: 'قيد المعالجة',
      description: 'جاري غسل وكي الملابس',
      time: 'الآن',
      isCompleted: true,
      isCurrent: true,
    ),
    TrackingStep(
      title: 'جاهز للتسليم',
      description: 'الملابس جاهزة للتسليم',
      time: 'غداً - 4:00 م',
      isCompleted: false,
    ),
    TrackingStep(
      title: 'تم التسليم',
      description: 'تم تسليم الطلب بنجاح',
      time: 'غداً - 6:00 م',
      isCompleted: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorBackground,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  /// Header
  Widget _buildHeader() {
    return Container(
      height: 110,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.washyBlue, AppColors.washyGreen],
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
                child: Container(
                  width: 66,
                  child: const Icon(
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
              right: 20,
              top: 0,
              bottom: 0,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'تتبع الطلب',
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

  /// Content
  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order Info Card
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'طلب #WW12345',
                            style: TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.colorTitleBlack,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '5 قطع ملابس',
                            style: TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              fontSize: 14,
                              color: AppColors.grey2,
                            ),
                          ),
                        ],
                      ),
                      
                      // Status Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.washyBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'قيد المعالجة',
                          style: TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.washyBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Progress Bar
                  LinearProgressIndicator(
                    value: (currentStep + 1) / steps.length,
                    backgroundColor: AppColors.grey3,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.washyGreen,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Text(
                    'مكتمل ${((currentStep + 1) / steps.length * 100).toInt()}%',
                    style: const TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 12,
                      color: AppColors.washyGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Tracking Steps
          const Text(
            'حالة الطلب',
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.colorTitleBlack,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Steps List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: steps.length,
            itemBuilder: (context, index) {
              return _buildTrackingStep(steps[index], index);
            },
          ),
          
          const SizedBox(height: 20),
          
          // Estimated Delivery Card
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [
                    AppColors.washyGreen.withOpacity(0.1),
                    AppColors.washyBlue.withOpacity(0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.local_shipping,
                        color: AppColors.washyGreen,
                        size: 24,
                      ),
                      SizedBox(width: 12),
                      Text(
                        'موعد التسليم المتوقع',
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.colorTitleBlack,
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 12),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'غداً',
                            style: TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.washyGreen,
                            ),
                          ),
                          Text(
                            '16 يناير 2024',
                            style: TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              fontSize: 14,
                              color: AppColors.grey2,
                            ),
                          ),
                        ],
                      ),
                      
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '6:00 مساءً',
                            style: TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.washyBlue,
                            ),
                          ),
                          Text(
                            'إلى 8:00 مساءً',
                            style: TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              fontSize: 14,
                              color: AppColors.grey2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.phone, size: 20),
                  label: const Text('اتصل بنا'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.washyBlue,
                    side: const BorderSide(color: AppColors.washyBlue),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(width: 12),
              
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.location_on, size: 20),
                  label: const Text('تتبع السائق'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.washyGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Tracking Step Widget
  Widget _buildTrackingStep(TrackingStep step, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step Indicator
          Column(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: step.isCompleted 
                      ? (step.isCurrent ? AppColors.washyBlue : AppColors.washyGreen)
                      : AppColors.grey3,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: step.isCompleted 
                        ? (step.isCurrent ? AppColors.washyBlue : AppColors.washyGreen)
                        : AppColors.grey2,
                    width: 2,
                  ),
                ),
                child: Icon(
                  step.isCompleted ? Icons.check : Icons.radio_button_unchecked,
                  color: step.isCompleted ? AppColors.white : AppColors.grey2,
                  size: 16,
                ),
              ),
              
              // Connecting Line
              if (index < steps.length - 1)
                Container(
                  width: 2,
                  height: 40,
                  color: step.isCompleted ? AppColors.washyGreen : AppColors.grey3,
                ),
            ],
          ),
          
          const SizedBox(width: 16),
          
          // Step Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: step.isCompleted 
                        ? AppColors.colorTitleBlack 
                        : AppColors.grey2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  step.description,
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 14,
                    color: step.isCompleted 
                        ? AppColors.greyDark 
                        : AppColors.grey2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  step.time,
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 12,
                    color: step.isCurrent 
                        ? AppColors.washyBlue 
                        : AppColors.grey2,
                    fontWeight: step.isCurrent 
                        ? FontWeight.bold 
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Tracking Step Model
class TrackingStep {
  final String title;
  final String description;
  final String time;
  final bool isCompleted;
  final bool isCurrent;

  TrackingStep({
    required this.title,
    required this.description,
    required this.time,
    required this.isCompleted,
    this.isCurrent = false,
  });
}



