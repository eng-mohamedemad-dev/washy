import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../domain/entities/washy_address.dart';

/// Address section widget for selecting pickup and delivery addresses
/// Matches the address selection functionality in Java NewOrderActivity
class AddressSection extends StatefulWidget {
  final Map<String, dynamic> data;
  final Function(Map<String, dynamic>) onChanged;

  const AddressSection({
    Key? key,
    required this.data,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<AddressSection> createState() => _AddressSectionState();
}

class _AddressSectionState extends State<AddressSection> {
  WashyAddress? selectedPickupAddress;
  WashyAddress? selectedDeliveryAddress;
  List<WashyAddress> addresses = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    selectedPickupAddress = widget.data['pickupAddress'];
    selectedDeliveryAddress = widget.data['deliveryAddress'];
    addresses = widget.data['addresses'] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pickup address selection
          _buildAddressSelection(
            title: 'عنوان الاستلام',
            selectedAddress: selectedPickupAddress,
            onAddressSelected: (address) {
              setState(() {
                selectedPickupAddress = address;
              });
              _notifyChange();
            },
          ),
          
          const SizedBox(height: 16),
          
          // Delivery address selection
          _buildAddressSelection(
            title: 'عنوان التسليم',
            selectedAddress: selectedDeliveryAddress,
            onAddressSelected: (address) {
              setState(() {
                selectedDeliveryAddress = address;
              });
              _notifyChange();
            },
          ),
          
          const SizedBox(height: 16),
          
          // Add new address button
          _buildAddNewAddressButton(),
        ],
      ),
    );
  }

  /// Build address selection dropdown
  Widget _buildAddressSelection({
    required String title,
    required WashyAddress? selectedAddress,
    required Function(WashyAddress) onAddressSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.darkGrey,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: 'Cairo',
          ),
        ),
        
        const SizedBox(height: 8),
        
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.lightGrey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<WashyAddress>(
              value: selectedAddress,
              isExpanded: true,
              hint: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'اختر العنوان',
                  style: TextStyle(
                    color: AppColors.grey,
                    fontSize: 14,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
              items: addresses.map((address) {
                return DropdownMenuItem<WashyAddress>(
                  value: address,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          address.addressTitle ?? 'عنوان غير محدد',
                          style: const TextStyle(
                            color: AppColors.darkGrey,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        if (address.fullAddress != null && address.fullAddress!.isNotEmpty)
                          Text(
                            address.fullAddress!,
                            style: const TextStyle(
                              color: AppColors.grey,
                              fontSize: 12,
                              fontFamily: 'Cairo',
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
              onChanged: (address) {
                if (address != null) {
                  onAddressSelected(address);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  /// Build add new address button
  Widget _buildAddNewAddressButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _addNewAddress,
        icon: const Icon(
          Icons.add_location,
          color: AppColors.washyGreen,
          size: 20,
        ),
        label: const Text(
          'إضافة عنوان جديد',
          style: TextStyle(
            color: AppColors.washyGreen,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: 'Cairo',
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.washyGreen),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  /// Handle adding new address
  void _addNewAddress() {
    // TODO: Navigate to add address page
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('إضافة عنوان جديد قيد التطوير'),
        backgroundColor: AppColors.washyGreen,
      ),
    );
  }

  /// Notify parent about changes
  void _notifyChange() {
    widget.onChanged({
      'pickupAddress': selectedPickupAddress,
      'deliveryAddress': selectedDeliveryAddress,
      'addresses': addresses,
    });
  }
}
