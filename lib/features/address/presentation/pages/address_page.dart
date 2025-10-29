import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Address Page matching Java AddressActivity
/// Manages user addresses for pickup and delivery
class AddressPage extends StatefulWidget {
  const AddressPage({Key? key}) : super(key: key);

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  final List<Map<String, dynamic>> addresses = [
    {
      'id': 1,
      'title': 'المنزل',
      'address': 'شارع الملك فهد، الرياض 12345',
      'isDefault': true,
    },
    {
      'id': 2,
      'title': 'العمل',
      'address': 'طريق الملك عبدالعزيز، الرياض 12346',
      'isDefault': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.washyGreen,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'العناوين',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Cairo',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.white),
            onPressed: _addNewAddress,
          ),
        ],
      ),
      body: addresses.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: addresses.length,
              itemBuilder: (context, index) {
                final address = addresses[index];
                return _buildAddressCard(address, index);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewAddress,
        backgroundColor: AppColors.washyGreen,
        child: const Icon(Icons.add, color: AppColors.white),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.lightGrey.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.location_on_outlined,
              size: 60,
              color: AppColors.grey,
            ),
          ),
          
          const SizedBox(height: 24),
          
          const Text(
            'لا توجد عناوين محفوظة',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.darkGrey,
              fontFamily: 'Cairo',
            ),
          ),
          
          const SizedBox(height: 8),
          
          const Text(
            'أضف عنوانك الأول لتسهيل عملية الطلب',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.grey,
              fontFamily: 'Cairo',
            ),
          ),
          
          const SizedBox(height: 32),
          
          ElevatedButton.icon(
            onPressed: _addNewAddress,
            icon: const Icon(Icons.add_location, color: AppColors.white),
            label: const Text(
              'إضافة عنوان جديد',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Cairo',
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.washyGreen,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(Map<String, dynamic> address, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and default badge
            Row(
              children: [
                Expanded(
                  child: Text(
                    address['title'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkGrey,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
                if (address['isDefault'])
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.washyGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'افتراضي',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.washyGreen,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            // Address
            Text(
              address['address'],
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.grey,
                fontFamily: 'Cairo',
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _editAddress(address, index),
                    icon: const Icon(
                      Icons.edit_outlined,
                      size: 18,
                      color: AppColors.washyBlue,
                    ),
                    label: const Text(
                      'تعديل',
                      style: TextStyle(
                        color: AppColors.washyBlue,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.washyBlue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(width: 12),
                
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _deleteAddress(index),
                    icon: const Icon(
                      Icons.delete_outline,
                      size: 18,
                      color: Colors.red,
                    ),
                    label: const Text(
                      'حذف',
                      style: TextStyle(
                        color: Colors.red,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _addNewAddress() {
    // TODO: Navigate to address details page
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('إضافة عنوان جديد قيد التطوير'),
        backgroundColor: AppColors.washyGreen,
      ),
    );
  }

  void _editAddress(Map<String, dynamic> address, int index) {
    // TODO: Navigate to address details page for editing
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تعديل ${address['title']} قيد التطوير'),
        backgroundColor: AppColors.washyBlue,
      ),
    );
  }

  void _deleteAddress(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'حذف العنوان',
          style: TextStyle(fontFamily: 'Cairo'),
        ),
        content: const Text(
          'هل أنت متأكد من رغبتك في حذف هذا العنوان؟',
          style: TextStyle(fontFamily: 'Cairo'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'إلغاء',
              style: TextStyle(
                color: AppColors.grey,
                fontFamily: 'Cairo',
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                addresses.removeAt(index);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم حذف العنوان بنجاح'),
                  backgroundColor: AppColors.washyGreen,
                ),
              );
            },
            child: const Text(
              'حذف',
              style: TextStyle(
                color: Colors.red,
                fontFamily: 'Cairo',
              ),
            ),
          ),
        ],
      ),
    );
  }
}



