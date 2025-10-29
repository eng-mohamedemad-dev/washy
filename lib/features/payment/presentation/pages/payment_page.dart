import 'package:flutter/material.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';
import 'package:wash_flutter/core/constants/app_dimensions.dart';
import 'package:wash_flutter/core/constants/app_text_styles.dart';
import 'package:wash_flutter/features/order/domain/entities/payment_method.dart';

/// PaymentPage - 100% matching Java PaymentActivity
class PaymentPage extends StatefulWidget {
  final int orderId;
  final double amount;

  const PaymentPage({
    super.key,
    required this.orderId,
    required this.amount,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  PaymentMethod? selectedPaymentMethod;
  bool hasCreditCard = false;
  bool isLoading = false;
  String? creditCardDisplay;

  @override
  void initState() {
    super.initState();
    _loadDefaultCreditCard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: _buildPaymentOptions(),
          ),
          _buildTotalSection(),
          if (selectedPaymentMethod != null) _buildMakePaymentButton(),
        ],
      ),
    );
  }

  /// Header (100% matching Java layout)
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 40),
      child: Column(
        children: [
          // Back Icon
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  margin: const EdgeInsets.only(left: 20),
                  padding: const EdgeInsets.all(12),
                  child: const Icon(
                    Icons.arrow_back,
                    color: AppColors.colorTitleBlack,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
          
          // Title
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: const Text(
              'طرق الدفع',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppColors.colorTitleBlack,
                letterSpacing: 7.5 / 26,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Payment Options (100% matching Java LinearLayout)
  Widget _buildPaymentOptions() {
    return Container(
      margin: const EdgeInsets.only(top: AppDimensions.pageMargin),
      child: Column(
        children: [
          // Progress Indicator (hidden as per Java)
          // _buildProgressIndicator(),
          
          _buildCreditCardSection(),
          _buildCODSection(),
          _buildCCODSection(),
        ],
      ),
    );
  }

  /// Credit Card Section
  Widget _buildCreditCardSection() {
    return Column(
      children: [
        // Label + Change Button
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'بطاقة ائتمانية',
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.colorTitleBlack,
                ),
              ),
              if (hasCreditCard)
                GestureDetector(
                  onTap: _changeCreditCard,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: const Text(
                      'تغيير',
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: 14,
                        color: AppColors.colorGreenButton,
                        letterSpacing: -0.03,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        
        // Add Credit Card / Show Credit Card
        Container(
          margin: const EdgeInsets.only(
            top: 8,
            left: AppDimensions.pageMargin,
            right: AppDimensions.pageMargin,
          ),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Container(
              height: 100,
              child: hasCreditCard ? _buildCreditCardDisplay() : _buildAddCreditCard(),
            ),
          ),
        ),
      ],
    );
  }

  /// Add Credit Card Option
  Widget _buildAddCreditCard() {
    return GestureDetector(
      onTap: _creditCardClicked,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.pageMargin),
        child: Row(
          children: [
            Image.asset(
              'assets/images/ic_other_payments.png',
              width: 77,
              height: 46,
            ),
            const SizedBox(width: 8),
            const Text(
              'إضافة بطاقة ائتمانية',
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 19,
                color: AppColors.colorHomeTabNotSelected,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Credit Card Display (when has credit card)
  Widget _buildCreditCardDisplay() {
    return GestureDetector(
      onTap: _creditCardClicked,
      child: Container(
        decoration: BoxDecoration(
          border: selectedPaymentMethod == PaymentMethod.creditCard
              ? Border.all(color: AppColors.washyBlue, width: 2)
              : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            // Credit Card Info
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Card Icon/Preview
                  Container(
                    width: 60,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.colorMasterCardBackground,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: Text(
                        'CARD',
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          creditCardDisplay ?? '**** **** **** 1234',
                          style: const TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.colorTitleBlack,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'البطاقة الافتراضية',
                          style: TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            fontSize: 12,
                            color: AppColors.grey2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Selection Indicator
            if (selectedPaymentMethod == PaymentMethod.creditCard)
              const Positioned(
                top: 10,
                right: 10,
                child: Icon(
                  Icons.check_circle,
                  color: AppColors.washyBlue,
                  size: 24,
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// COD Section (100% matching Java COD CardView)
  Widget _buildCODSection() {
    final bool isSelected = selectedPaymentMethod == PaymentMethod.cod;
    
    return Container(
      margin: const EdgeInsets.only(
        top: 10,
        left: AppDimensions.pageMargin,
        right: AppDimensions.pageMargin,
      ),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: GestureDetector(
          onTap: _codClicked,
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              border: isSelected 
                  ? Border.all(color: AppColors.washyBlue, width: 2) 
                  : null,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Stack(
              children: [
                // COD Content
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimensions.pageMargin),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/ic_cod.png',
                        width: 66,
                        height: 62,
                      ),
                      const SizedBox(width: 18),
                      const Text(
                        'الدفع نقداً عند التسليم',
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 19,
                          color: AppColors.colorHomeTabNotSelected,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Selection Indicator
                if (isSelected)
                  const Positioned(
                    top: 10,
                    right: 20,
                    child: Icon(
                      Icons.check_circle,
                      color: AppColors.washyBlue,
                      size: 35,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// CCOD Section (100% matching Java CCOD CardView)
  Widget _buildCCODSection() {
    final bool isSelected = selectedPaymentMethod == PaymentMethod.ccod;
    
    return Container(
      margin: const EdgeInsets.only(
        top: 10,
        left: AppDimensions.pageMargin,
        right: AppDimensions.pageMargin,
      ),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: GestureDetector(
          onTap: _cCODClicked,
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              border: isSelected 
                  ? Border.all(color: AppColors.washyBlue, width: 2) 
                  : null,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Stack(
              children: [
                // CCOD Content
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimensions.pageMargin),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/ic_ccod.png',
                        width: 66,
                        height: 62,
                      ),
                      const SizedBox(width: 18),
                      const Text(
                        'الدفع نقداً بدون تلامس',
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 19,
                          color: AppColors.colorHomeTabNotSelected,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Selection Indicator  
                if (isSelected)
                  const Positioned(
                    top: 10,
                    right: 20,
                    child: Icon(
                      Icons.check_circle,
                      color: AppColors.washyBlue,
                      size: 35,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Total Section (100% matching Java TotalSection_RelativeLayout)
  Widget _buildTotalSection() {
    return Container(
      margin: const EdgeInsets.only(
        top: AppDimensions.pageMargin,
        bottom: 8,
        left: 25,
        right: 25,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'المجموع',
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: 17,
              color: AppColors.colorTotalHint,
            ),
          ),
          Text(
            '${widget.amount.toStringAsFixed(2)} ريال',
            style: const TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: AppColors.colorTitleBlack,
            ),
          ),
        ],
      ),
    );
  }

  /// Make Payment Button (100% matching Java MakePayment_TextView)
  Widget _buildMakePaymentButton() {
    return Container(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: isLoading ? null : _makePayment,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.colorGreenButton,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
        ),
        child: isLoading
            ? const CircularProgressIndicator(color: AppColors.white)
            : const Text(
                'إتمام الطلب',
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 19,
                  color: AppColors.white,
                ),
              ),
      ),
    );
  }

  // Action Methods (100% matching Java PaymentActivity)
  void _loadDefaultCreditCard() {
    // Mock - replace with actual API call
    setState(() {
      hasCreditCard = false; // Change to true when user has credit card
      creditCardDisplay = '**** **** **** 1234';
    });
  }

  void _creditCardClicked() {
    if (hasCreditCard) {
      setState(() {
        selectedPaymentMethod = PaymentMethod.creditCard;
      });
    } else {
      // Navigate to add credit card
      Navigator.pushNamed(context, '/credit-cards').then((_) {
        _loadDefaultCreditCard();
      });
    }
  }

  void _codClicked() {
    setState(() {
      selectedPaymentMethod = PaymentMethod.cod;
    });
  }

  void _cCODClicked() {
    setState(() {
      selectedPaymentMethod = PaymentMethod.ccod;
    });
  }

  void _changeCreditCard() {
    // Navigate to credit cards page
    Navigator.pushNamed(context, '/credit-cards').then((_) {
      _loadDefaultCreditCard();
    });
  }

  void _makePayment() async {
    if (selectedPaymentMethod == null) return;

    setState(() {
      isLoading = true;
    });

    try {
      // Mock payment processing
      await Future.delayed(const Duration(seconds: 2));

      switch (selectedPaymentMethod!) {
        case PaymentMethod.creditCard:
          await _processCreditCardPayment();
          break;
        case PaymentMethod.cod:
          await _processCODPayment();
          break;
        case PaymentMethod.ccod:
          await _processCCODPayment();
          break;
        default:
          break;
      }

      // Navigate to Thank You page (100% matching Java orderCompleted)
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/thank-you',
          (route) => false,
          arguments: {
            'orderId': widget.orderId,
            'total': widget.amount,
            'paymentMethod': selectedPaymentMethod!.name,
          },
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في معالجة الدفع: $e'),
            backgroundColor: AppColors.colorCoral,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _processCreditCardPayment() async {
    // الانتقال إلى صفحة Payfort لإتمام الدفع ثم العودة
    await Navigator.pushNamed(
      context,
      '/payfort-payment',
      arguments: {
        'orderId': widget.orderId,
        'amount': widget.amount,
      },
    );
  }

  Future<void> _processCODPayment() async {
    // Mock COD payment
    print('Processing COD payment for order ${widget.orderId}');
  }

  Future<void> _processCCODPayment() async {
    // Mock CCOD payment  
    print('Processing CCOD payment for order ${widget.orderId}');
  }
}