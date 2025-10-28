import 'package:flutter/material.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';
import 'package:wash_flutter/core/constants/app_dimensions.dart';
import 'package:wash_flutter/core/constants/app_text_styles.dart';
import 'package:wash_flutter/features/order/domain/entities/washy_address.dart';
import 'package:wash_flutter/features/addresses/domain/entities/address_navigation_type.dart';

/// AddressesPage - 100% matching Java AllAddressesActivity
class AddressesPage extends StatefulWidget {
  final AddressNavigationType navigationType;
  final String? pageTitle;

  const AddressesPage({
    super.key,
    this.navigationType = AddressNavigationType.openAddressPageFromProfile,
    this.pageTitle,
  });

  @override
  State<AddressesPage> createState() => _AddressesPageState();
}

class _AddressesPageState extends State<AddressesPage> {
  List<WashyAddress> addresses = [];
  bool isLoading = true;
  WashyAddress? selectedAddress;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          _buildHeader(),
          _buildAddAddressButton(),
          Expanded(
            child: isLoading ? _buildLoadingView() : _buildAddressesList(),
          ),
          if (widget.navigationType == AddressNavigationType.selectAddressFromOrderPage)
            _buildContinueButton(),
        ],
      ),
    );
  }

  /// Header (100% matching Java layout)
  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.only(top: 40, left: 14, right: 14),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 34,
              height: 37,
              padding: const EdgeInsets.all(8),
              child: const Icon(
                Icons.arrow_back,
                color: AppColors.greyDark,
                size: 18,
              ),
            ),
          ),
          Expanded(
            child: Text(
              widget.pageTitle ?? 'العناوين',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.greyDark,
              ),
            ),
          ),
          const SizedBox(width: 34), // Balance for back button
        ],
      ),
    );
  }

  /// Add Address Button (100% matching Java AddAddresses_LinearLayout)
  Widget _buildAddAddressButton() {
    return Container(
      margin: const EdgeInsets.only(top: 40, left: 25, right: 25),
      child: GestureDetector(
        onTap: _onAddAddressClicked,
        child: Row(
          children: [
            Container(
              width: 34,
              height: 37,
              padding: const EdgeInsets.all(8),
              child: Image.asset(
                'assets/images/plus_address.png',
                width: 18,
                height: 21,
                color: AppColors.green1,
              ),
            ),
            const Expanded(
              child: Text(
                'إضافة عنوان جديد',
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.green1,
                ),
              ),
            ),
          ],
        ),
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

  /// Addresses List (100% matching Java AddressesRecyclerView)
  Widget _buildAddressesList() {
    if (addresses.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off_outlined,
              size: 64,
              color: AppColors.grey2,
            ),
            SizedBox(height: 16),
            Text(
              'لا توجد عناوين محفوظة',
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 18,
                color: AppColors.grey2,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'أضف عنوانك الأول للمتابعة',
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 14,
                color: AppColors.grey2,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8),
      itemCount: addresses.length,
      itemBuilder: (context, index) {
        return _buildAddressItem(addresses[index], index);
      },
    );
  }

  /// Address Item (100% matching Java row_address.xml)
  Widget _buildAddressItem(WashyAddress address, int index) {
    final bool isSelected = selectedAddress?.addressId == address.addressId;
    
    return Container(
      height: 137,
      margin: const EdgeInsets.only(top: 6),
      child: Container(
        margin: const EdgeInsets.only(
          top: 6,
          bottom: 6,
          left: AppDimensions.pageMargin,
          right: AppDimensions.pageMargin,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.washyBlue : AppColors.grey3,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Main Content
            Positioned.fill(
              child: GestureDetector(
                onTap: () => _onAddressClicked(address, index),
                child: Row(
                  children: [
                    // Address Type Icon (47x47 as per Java)
                    Container(
                      margin: const EdgeInsets.only(left: 16, top: 20, right: 10),
                      child: Container(
                        width: 47,
                        height: 47,
                        decoration: BoxDecoration(
                          color: AppColors.grey5,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(AppDimensions.topLeftRadius),
                            bottomLeft: Radius.circular(AppDimensions.bottomLeftRadius),
                          ),
                        ),
                        child: Icon(
                          _getAddressTypeIcon(address.addressType),
                          color: AppColors.grey2,
                          size: 22,
                        ),
                      ),
                    ),
                    
                    // Address Info
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(
                          top: 15,
                          left: AppDimensions.pageMargin,
                          right: AppDimensions.pageMargin,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Address Name + Primary indicator
                            Row(
                              children: [
                                Text(
                                  _getAddressTypeName(address.addressType),
                                  style: const TextStyle(
                                    fontFamily: AppTextStyles.fontFamily,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.grey1,
                                  ),
                                ),
                                if (address.isDefault) ...[
                                  const SizedBox(width: 3),
                                  const Text(
                                    'أساسي',
                                    style: TextStyle(
                                      fontFamily: AppTextStyles.fontFamily,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.green1,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            
                            // Phone Number
                            const SizedBox(height: 10),
                            Text(
                              address.mobile,
                              style: const TextStyle(
                                fontFamily: AppTextStyles.fontFamily,
                                fontSize: 14,
                                color: AppColors.grey1,
                              ),
                            ),
                            
                            // Address
                            Text(
                              address.address,
                              style: const TextStyle(
                                fontFamily: AppTextStyles.fontFamily,
                                fontSize: 14,
                                color: AppColors.grey1,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            
                            // Area
                            Text(
                              address.area,
                              style: const TextStyle(
                                fontFamily: AppTextStyles.fontFamily,
                                fontSize: 14,
                                color: AppColors.grey1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Selection Circle (top right)
            if (widget.navigationType == AddressNavigationType.selectAddressFromOrderPage)
              Positioned(
                top: 14,
                right: 14,
                child: GestureDetector(
                  onTap: () => _onAddressClicked(address, index),
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? AppColors.washyBlue : AppColors.grey2,
                        width: 2,
                      ),
                      color: isSelected ? AppColors.washyBlue : AppColors.white,
                    ),
                    child: isSelected
                        ? const Icon(
                            Icons.check,
                            color: AppColors.white,
                            size: 16,
                          )
                        : null,
                  ),
                ),
              ),
            
            // More Options Menu (bottom right)
            if (widget.navigationType == AddressNavigationType.openAddressPageFromProfile)
              Positioned(
                bottom: 20,
                right: 9,
                child: GestureDetector(
                  onTap: () => _showAddressMenu(context, address, index),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Image.asset(
                      'assets/images/ic_three_dot.png',
                      width: 16,
                      height: 16,
                      color: AppColors.grey2,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Continue Button (bottom CardView)
  Widget _buildContinueButton() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 30,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.all(17),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: selectedAddress != null ? _onContinuePressed : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: selectedAddress != null 
                  ? AppColors.washyBlue 
                  : AppColors.grey3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: const Text(
              'متابعة',
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
                letterSpacing: 0.05,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper Methods
  IconData _getAddressTypeIcon(AddressType type) {
    switch (type) {
      case AddressType.home:
        return Icons.home_outlined;
      case AddressType.work:
        return Icons.business_outlined;  
      case AddressType.other:
        return Icons.location_on_outlined;
    }
  }

  String _getAddressTypeName(AddressType type) {
    switch (type) {
      case AddressType.home:
        return 'المنزل';
      case AddressType.work:
        return 'العمل';
      case AddressType.other:
        return 'آخر';
    }
  }

  // Action Methods (100% matching Java AllAddressesActivity)
  void _onAddAddressClicked() {
    // Navigate to add address page (to be implemented)
    Navigator.pushNamed(context, '/add-address').then((_) {
      _loadAddresses(); // Refresh list after adding
    });
  }

  void _onAddressClicked(WashyAddress address, int index) {
    if (widget.navigationType == AddressNavigationType.openAddressPageFromProfile) {
      // Edit address
      Navigator.pushNamed(
        context, 
        '/edit-address',
        arguments: {'address': address},
      ).then((_) {
        _loadAddresses(); // Refresh list after editing
      });
    } else {
      // Select address for order
      setState(() {
        selectedAddress = address;
      });
    }
  }

  void _showAddressMenu(BuildContext context, WashyAddress address, int index) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Edit Address
            ListTile(
              leading: const Icon(Icons.edit_outlined, color: AppColors.washyBlue),
              title: const Text(
                'تعديل العنوان',
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 16,
                  color: AppColors.greyDark,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _editAddress(address);
              },
            ),
            
            // Delete Address (only if not default)
            if (!address.isDefault)
              ListTile(
                leading: const Icon(Icons.delete_outline, color: AppColors.colorCoral),
                title: const Text(
                  'حذف العنوان',
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 16,
                    color: AppColors.colorCoral,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _deleteAddress(address, index);
                },
              ),
            
            // Set as Default (only if not already default)
            if (!address.isDefault)
              ListTile(
                leading: const Icon(Icons.star_outline, color: AppColors.washyGreen),
                title: const Text(
                  'تحديد كعنوان أساسي',
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 16,
                    color: AppColors.washyGreen,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _setAsDefault(address, index);
                },
              ),
          ],
        ),
      ),
    );
  }

  void _onContinuePressed() {
    if (selectedAddress != null) {
      Navigator.pop(context, selectedAddress);
    }
  }

  // Data Methods
  void _loadAddresses() {
    setState(() {
      isLoading = true;
    });

    // Mock data - replace with actual API call
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        addresses = _getMockAddresses();
        isLoading = false;
      });
    });
  }

  void _editAddress(WashyAddress address) {
    Navigator.pushNamed(
      context,
      '/edit-address',
      arguments: {'address': address},
    ).then((_) {
      _loadAddresses();
    });
  }

  void _deleteAddress(WashyAddress address, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف العنوان'),
        content: const Text('هل أنت متأكد من حذف هذا العنوان؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.colorCoral,
            ),
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                addresses.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم حذف العنوان')),
              );
            },
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  void _setAsDefault(WashyAddress address, int index) {
    setState(() {
      // Remove default from all addresses
      for (var addr in addresses) {
        addresses[addresses.indexOf(addr)] = addr.copyWith(isDefault: false);
      }
      // Set current as default
      addresses[index] = address.copyWith(isDefault: true);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم تحديد العنوان كأساسي')),
    );
  }

  // Mock Data (replace with real API)
  List<WashyAddress> _getMockAddresses() {
    return [
      const WashyAddress(
        addressId: 1,
        address: 'شارع الملك عبدالله الثاني، بناية 123',
        area: 'عمان، الأردن',
        latitude: 31.9511,
        longitude: 35.9066,
        mobile: '+962 79 514 1234',
        addressType: AddressType.home,
        isDefault: true,
        building: '123',
        apartment: '4A',
        floor: '4',
        additionalInfo: 'بجانب مركز الخالدي الطبي',
      ),
      const WashyAddress(
        addressId: 2,
        address: 'شارع وصفي التل، المقابلين',
        area: 'عمان، الأردن',
        latitude: 31.9539,
        longitude: 35.9106,
        mobile: '+962 79 514 5678',
        addressType: AddressType.work,
        isDefault: false,
        building: '45',
        apartment: '2B',
        floor: '2',
      ),
      const WashyAddress(
        addressId: 3,
        address: 'طريق المطار، شارع الأردن',
        area: 'عمان، الأردن',
        latitude: 31.9515,
        longitude: 35.9110,
        mobile: '+962 79 514 9999',
        addressType: AddressType.other,
        isDefault: false,
        building: '67',
        apartment: '1C',
        floor: '1',
      ),
    ];
  }
}
