import 'package:flutter/material.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';
import 'package:wash_flutter/core/constants/app_text_styles.dart';

/// FurnitureServicePage - Furniture cleaning service
class FurnitureServicePage extends StatefulWidget {
  const FurnitureServicePage({super.key});

  @override
  State<FurnitureServicePage> createState() => _FurnitureServicePageState();
}

class _FurnitureServicePageState extends State<FurnitureServicePage> {
  final List<FurnitureItem> selectedItems = [];

  final List<FurnitureCategory> categories = [
    FurnitureCategory(
      name: 'الكنب والمقاعد',
      icon: Icons.chair,
      items: [
        FurnitureItem(name: 'كنبة صغيرة (مقعدان)', price: 15.0),
        FurnitureItem(name: 'كنبة كبيرة (3 مقاعد)', price: 25.0),
        FurnitureItem(name: 'كرسي مفرد', price: 8.0),
        FurnitureItem(name: 'كرسي هزاز', price: 12.0),
      ],
    ),
    FurnitureCategory(
      name: 'السجاد والمفروشات',
      icon: Icons.texture,
      items: [
        FurnitureItem(name: 'سجادة صغيرة (2x3 م)', price: 20.0),
        FurnitureItem(name: 'سجادة كبيرة (3x4 م)', price: 35.0),
        FurnitureItem(name: 'موكيت', price: 30.0),
        FurnitureItem(name: 'ستائر', price: 15.0),
      ],
    ),
    FurnitureCategory(
      name: 'المراتب والوسائد',
      icon: Icons.bed,
      items: [
        FurnitureItem(name: 'مرتبة مفردة', price: 25.0),
        FurnitureItem(name: 'مرتبة مزدوجة', price: 40.0),
        FurnitureItem(name: 'وسادة', price: 5.0),
        FurnitureItem(name: 'لحاف', price: 12.0),
      ],
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
          _buildOrderSummary(),
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
          colors: [AppColors.premiumColor, AppColors.washyGreen],
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
                  'تنظيف الأثاث',
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service Description
            Card(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: const Row(
                  children: [
                    Icon(
                      Icons.cleaning_services,
                      color: AppColors.premiumColor,
                      size: 32,
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'خدمة تنظيف الأثاث المنزلي',
                            style: TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.colorTitleBlack,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'تنظيف عميق وآمن لجميع أنواع الأثاث والمفروشات',
                            style: TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              fontSize: 14,
                              color: AppColors.greyDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Categories
            ...categories.map((category) => _buildCategorySection(category)),
          ],
        ),
      ),
    );
  }

  /// Category Section
  Widget _buildCategorySection(FurnitureCategory category) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        leading: Icon(
          category.icon,
          color: AppColors.premiumColor,
          size: 28,
        ),
        title: Text(
          category.name,
          style: const TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.colorTitleBlack,
          ),
        ),
        children: category.items.map((item) => _buildFurnitureItem(item)).toList(),
      ),
    );
  }

  /// Furniture Item
  Widget _buildFurnitureItem(FurnitureItem item) {
    final isSelected = selectedItems.contains(item);
    final quantity = selectedItems.where((i) => i.name == item.name).length;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Item Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.colorTitleBlack,
                  ),
                ),
                Text(
                  '${item.price.toStringAsFixed(3)} د.أ',
                  style: const TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 14,
                    color: AppColors.premiumColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          // Quantity Controls
          if (isSelected) ...[
            Row(
              children: [
                IconButton(
                  onPressed: () => _removeItem(item),
                  icon: const Icon(Icons.remove_circle_outline),
                  color: AppColors.colorCoral,
                ),
                Text(
                  '$quantity',
                  style: const TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.colorTitleBlack,
                  ),
                ),
                IconButton(
                  onPressed: () => _addItem(item),
                  icon: const Icon(Icons.add_circle_outline),
                  color: AppColors.washyGreen,
                ),
              ],
            ),
          ] else ...[
            ElevatedButton(
              onPressed: () => _addItem(item),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.premiumColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'إضافة',
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  color: AppColors.white,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Order Summary
  Widget _buildOrderSummary() {
    if (selectedItems.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        child: const Text(
          'اختر العناصر التي تريد تنظيفها',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontSize: 16,
            color: AppColors.grey2,
          ),
        ),
      );
    }

    final total = selectedItems.fold(0.0, (sum, item) => sum + item.price);

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'العناصر المحددة: ${selectedItems.length}',
                style: const TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 16,
                  color: AppColors.greyDark,
                ),
              ),
              Text(
                'الإجمالي: ${total.toStringAsFixed(3)} د.أ',
                style: const TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.premiumColor,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: _onOrderPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.premiumColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(27.5),
                ),
              ),
              child: const Text(
                'طلب خدمة تنظيف الأثاث',
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 16,
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
  void _addItem(FurnitureItem item) {
    setState(() {
      selectedItems.add(item);
    });
  }

  void _removeItem(FurnitureItem item) {
    setState(() {
      selectedItems.remove(item);
    });
  }

  void _onOrderPressed() {
    Navigator.pop(context, {
      'selectedItems': selectedItems,
      'totalCost': selectedItems.fold(0.0, (sum, item) => sum + item.price),
    });
  }
}

/// Furniture Category Model
class FurnitureCategory {
  final String name;
  final IconData icon;
  final List<FurnitureItem> items;

  FurnitureCategory({
    required this.name,
    required this.icon,
    required this.items,
  });
}

/// Furniture Item Model
class FurnitureItem {
  final String name;
  final double price;

  FurnitureItem({
    required this.name,
    required this.price,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FurnitureItem && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;
}
