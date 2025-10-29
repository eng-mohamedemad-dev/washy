import 'package:flutter/material.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';
import 'package:wash_flutter/core/constants/app_text_styles.dart';

/// ServiceSelectionPage - Select washing service type
class ServiceSelectionPage extends StatefulWidget {
  const ServiceSelectionPage({super.key});

  @override
  State<ServiceSelectionPage> createState() => _ServiceSelectionPageState();
}

class _ServiceSelectionPageState extends State<ServiceSelectionPage> {
  String? selectedService;

  final List<ServiceOption> services = [
    ServiceOption(
      id: 'regular',
      title: 'الغسيل العادي',
      description: 'غسيل وكي الملابس العادية والقطنية',
      price: 'يبدأ من 2.500 د.أ',
      icon: Icons.local_laundry_service,
      color: AppColors.washyBlue,
      estimatedTime: '24 ساعة',
    ),
    ServiceOption(
      id: 'dry_clean',
      title: 'التنظيف الجاف',
      description: 'تنظيف الملابس الحساسة والبدلات',
      price: 'يبدأ من 8.000 د.أ',
      icon: Icons.dry_cleaning,
      color: AppColors.washyGreen,
      estimatedTime: '48 ساعة',
    ),
    ServiceOption(
      id: 'shoes',
      title: 'غسيل الأحذية',
      description: 'تنظيف وتلميع جميع أنواع الأحذية',
      price: 'يبدأ من 5.000 د.أ',
      icon: Icons.cleaning_services,
      color: AppColors.premiumColor,
      estimatedTime: '12 ساعة',
    ),
    ServiceOption(
      id: 'express',
      title: 'الخدمة السريعة',
      description: 'غسيل سريع خلال ساعات قليلة',
      price: '+2.000 د.أ إضافية',
      icon: Icons.flash_on,
      color: AppColors.colorCoral,
      estimatedTime: '4-6 ساعات',
    ),
    ServiceOption(
      id: 'furniture',
      title: 'تنظيف الأثاث',
      description: 'تنظيف الكنب والسجاد والمفروشات',
      price: 'يبدأ من 15.000 د.أ',
      icon: Icons.chair,
      color: AppColors.brownGrey,
      estimatedTime: '24-48 ساعة',
    ),
    ServiceOption(
      id: 'premium',
      title: 'الخدمة المميزة',
      description: 'عناية فائقة بالملابس الراقية',
      price: 'يبدأ من 12.000 د.أ',
      icon: Icons.diamond,
      color: AppColors.premiumColor,
      estimatedTime: '48-72 ساعة',
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
          _buildContinueButton(),
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
                  'اختيار الخدمة',
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
          // Introduction Text
          const Text(
            'اختر نوع الخدمة المناسبة لاحتياجاتك',
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: 18,
              color: AppColors.greyDark,
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Services Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.85,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: services.length,
            itemBuilder: (context, index) {
              return _buildServiceCard(services[index]);
            },
          ),
        ],
      ),
    );
  }

  /// Service Card Widget
  Widget _buildServiceCard(ServiceOption service) {
    final isSelected = selectedService == service.id;
    
    return GestureDetector(
      onTap: () => _selectService(service.id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? service.color : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected 
                  ? service.color.withOpacity(0.3)
                  : Colors.black.withOpacity(0.1),
              blurRadius: isSelected ? 12 : 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon & Selection Indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: service.color.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      service.icon,
                      color: service.color,
                      size: 24,
                    ),
                  ),
                  
                  if (isSelected)
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: service.color,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: AppColors.white,
                        size: 16,
                      ),
                    ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Title
              Text(
                service.title,
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isSelected 
                      ? service.color 
                      : AppColors.colorTitleBlack,
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Description
              Text(
                service.description,
                style: const TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 13,
                  color: AppColors.greyDark,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              const Spacer(),
              
              // Price & Time
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.price,
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: service.color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: AppColors.grey2,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          service.estimatedTime,
                          style: const TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            fontSize: 12,
                            color: AppColors.grey2,
                          ),
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
    );
  }

  /// Continue Button
  Widget _buildContinueButton() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (selectedService != null) ...[
            // Selected Service Info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.washyGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: AppColors.washyGreen,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'تم اختيار: ${_getSelectedServiceTitle()}',
                      style: const TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.washyGreen,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
          ],
          
          // Continue Button
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: selectedService != null ? _onContinue : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedService != null 
                    ? AppColors.washyGreen 
                    : AppColors.grey3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(27.5),
                ),
              ),
              child: Text(
                selectedService != null 
                    ? 'متابعة الطلب' 
                    : 'اختر نوع الخدمة',
                style: const TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Actions
  void _selectService(String serviceId) {
    setState(() {
      selectedService = serviceId;
    });
  }

  String _getSelectedServiceTitle() {
    final service = services.firstWhere(
      (s) => s.id == selectedService,
      orElse: () => services.first,
    );
    return service.title;
  }

  void _onContinue() {
    if (selectedService == null) return;
    
    final service = services.firstWhere((s) => s.id == selectedService);

    if (service.id == 'furniture') {
      Navigator.pushNamed(context, '/furniture-service');
      return;
    }

    Navigator.pop(context, {
      'selectedService': selectedService,
      'serviceTitle': service.title,
      'serviceType': service.id,
    });
  }
}

/// Service Option Model
class ServiceOption {
  final String id;
  final String title;
  final String description;
  final String price;
  final IconData icon;
  final Color color;
  final String estimatedTime;

  ServiceOption({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.icon,
    required this.color,
    required this.estimatedTime,
  });
}

