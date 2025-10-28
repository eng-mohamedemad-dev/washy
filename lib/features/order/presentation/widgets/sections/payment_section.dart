import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../domain/entities/payment_method.dart';

/// Payment section widget for selecting payment method and applying coupons
/// Matches the payment selection functionality in Java NewOrderActivity
class PaymentSection extends StatefulWidget {
  final Map<String, dynamic> data;
  final Function(Map<String, dynamic>) onChanged;

  const PaymentSection({
    Key? key,
    required this.data,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<PaymentSection> createState() => _PaymentSectionState();
}

class _PaymentSectionState extends State<PaymentSection> {
  PaymentMethod selectedPaymentMethod = PaymentMethod.CASH;
  String? redeemCode;
  bool isRedeemCodeApplied = false;
  
  final TextEditingController _redeemController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    selectedPaymentMethod = widget.data['selectedPaymentMethod'] ?? PaymentMethod.CASH;
    redeemCode = widget.data['redeemCode'];
    isRedeemCodeApplied = widget.data['isRedeemCodeApplied'] ?? false;
    
    if (redeemCode != null) {
      _redeemController.text = redeemCode!;
    }
  }

  @override
  void dispose() {
    _redeemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Payment method selection
          _buildPaymentMethodSelection(),
          
          const SizedBox(height: 20),
          
          // Redeem code section
          _buildRedeemCodeSection(),
        ],
      ),
    );
  }

  /// Build payment method selection
  Widget _buildPaymentMethodSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'طريقة الدفع',
          style: TextStyle(
            color: AppColors.darkGrey,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: 'Cairo',
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Payment options
        Column(
          children: PaymentMethod.values.map((method) {
            return _buildPaymentOption(method);
          }).toList(),
        ),
      ],
    );
  }

  /// Build individual payment option
  Widget _buildPaymentOption(PaymentMethod method) {
    final isSelected = selectedPaymentMethod == method;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => _selectPaymentMethod(method),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected 
                ? AppColors.washyGreen.withOpacity(0.1)
                : AppColors.white,
            border: Border.all(
              color: isSelected 
                  ? AppColors.washyGreen 
                  : AppColors.lightGrey,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              // Radio button
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected 
                        ? AppColors.washyGreen 
                        : AppColors.lightGrey,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? Center(
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.washyGreen,
                          ),
                        ),
                      )
                    : null,
              ),
              
              const SizedBox(width: 12),
              
              // Payment method icon
              Icon(
                _getPaymentMethodIcon(method),
                color: isSelected ? AppColors.washyGreen : AppColors.grey,
                size: 24,
              ),
              
              const SizedBox(width: 12),
              
              // Payment method name
              Expanded(
                child: Text(
                  _getPaymentMethodName(method),
                  style: TextStyle(
                    color: isSelected ? AppColors.washyGreen : AppColors.darkGrey,
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build redeem code section
  Widget _buildRedeemCodeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'كود الخصم',
          style: TextStyle(
            color: AppColors.darkGrey,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: 'Cairo',
          ),
        ),
        
        const SizedBox(height: 8),
        
        Row(
          children: [
            // Redeem code input
            Expanded(
              child: TextField(
                controller: _redeemController,
                enabled: !isRedeemCodeApplied,
                decoration: InputDecoration(
                  hintText: 'أدخل كود الخصم',
                  hintStyle: const TextStyle(
                    color: AppColors.grey,
                    fontSize: 14,
                    fontFamily: 'Cairo',
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.lightGrey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.lightGrey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.washyGreen),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.lightGrey.withOpacity(0.5)),
                  ),
                  filled: true,
                  fillColor: isRedeemCodeApplied 
                      ? AppColors.washyGreen.withOpacity(0.1)
                      : AppColors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  suffixIcon: isRedeemCodeApplied
                      ? const Icon(
                          Icons.check_circle,
                          color: AppColors.washyGreen,
                        )
                      : null,
                ),
                onChanged: (value) {
                  redeemCode = value.isNotEmpty ? value : null;
                },
              ),
            ),
            
            const SizedBox(width: 8),
            
            // Apply button
            ElevatedButton(
              onPressed: isRedeemCodeApplied ? null : _applyRedeemCode,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.washyGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              child: Text(
                isRedeemCodeApplied ? 'مُطبق' : 'تطبيق',
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
          ],
        ),
        
        // Applied redeem code status
        if (isRedeemCodeApplied)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle,
                  color: AppColors.washyGreen,
                  size: 16,
                ),
                const SizedBox(width: 4),
                const Text(
                  'تم تطبيق كود الخصم بنجاح',
                  style: TextStyle(
                    color: AppColors.washyGreen,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Cairo',
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: _removeRedeemCode,
                  child: const Text(
                    'إزالة',
                    style: TextStyle(
                      color: AppColors.grey,
                      fontSize: 12,
                      decoration: TextDecoration.underline,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  /// Select payment method
  void _selectPaymentMethod(PaymentMethod method) {
    setState(() {
      selectedPaymentMethod = method;
    });
    _notifyChange();
  }

  /// Apply redeem code
  void _applyRedeemCode() {
    if (redeemCode != null && redeemCode!.isNotEmpty) {
      _notifyChange(applyRedeemCode: true);
    }
  }

  /// Remove redeem code
  void _removeRedeemCode() {
    setState(() {
      isRedeemCodeApplied = false;
      redeemCode = null;
      _redeemController.clear();
    });
    _notifyChange();
  }

  /// Get payment method icon
  IconData _getPaymentMethodIcon(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.CASH:
        return Icons.money;
      case PaymentMethod.CREDIT_CARD:
        return Icons.credit_card;
      case PaymentMethod.WALLET:
        return Icons.account_balance_wallet;
      case PaymentMethod.BANK_TRANSFER:
        return Icons.account_balance;
      default:
        return Icons.payment;
    }
  }

  /// Get payment method name
  String _getPaymentMethodName(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.CASH:
        return 'الدفع عند الاستلام';
      case PaymentMethod.CREDIT_CARD:
        return 'بطاقة ائتمان';
      case PaymentMethod.WALLET:
        return 'محفظة إلكترونية';
      case PaymentMethod.BANK_TRANSFER:
        return 'تحويل بنكي';
      default:
        return 'طريقة أخرى';
    }
  }

  /// Notify parent about changes
  void _notifyChange({bool applyRedeemCode = false}) {
    widget.onChanged({
      'selectedPaymentMethod': selectedPaymentMethod,
      'redeemCode': redeemCode,
      'isRedeemCodeApplied': isRedeemCodeApplied,
      'applyRedeemCode': applyRedeemCode,
    });
  }
}
