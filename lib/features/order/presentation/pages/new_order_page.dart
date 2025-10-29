import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wash_flutter/core/theme/app_colors.dart';
import 'package:wash_flutter/core/widgets/loading_widget.dart';
import 'package:wash_flutter/injection_container.dart' as di;
import '../../domain/entities/new_order_section_type.dart';
import '../../domain/entities/order_type.dart';
import '../../domain/entities/payment_method.dart';
import '../../domain/entities/washy_address.dart';
import '../bloc/order_bloc.dart';
import '../bloc/order_event.dart';
import '../bloc/order_state.dart';
import '../widgets/order_app_bar.dart';
import '../widgets/order_sections_list.dart';
import '../widgets/order_step_indicator.dart';
import '../widgets/order_confirm_button.dart';

/// New Order Page that matches NewOrderActivity functionality from Java
/// Handles creating new orders with various sections like address, time, payment, etc.
class NewOrderPage extends StatefulWidget {
  final OrderType orderType;
  final List<Map<String, dynamic>>? products;
  final int? skipSelectionId;

  const NewOrderPage({
    super.key,
    this.orderType = OrderType.NORMAL,
    this.products,
    this.skipSelectionId,
  });

  @override
  State<NewOrderPage> createState() => _NewOrderPageState();
}

class _NewOrderPageState extends State<NewOrderPage> {
  // Order state variables (matching Java BaseNewOrderActivity fields)
  List<WashyAddress> addresses = [];
  WashyAddress? selectedPickupAddress;
  WashyAddress? selectedDeliveryAddress;

  // Time and date slots
  DateTime? selectedDate;
  String? selectedTimeSlot;
  List<String> availableTimeSlots = [];

  // Payment and pricing
  PaymentMethod selectedPaymentMethod = PaymentMethod.CASH;
  double subtotal = 0.0;
  double deliveryFee = 0.0;
  double discount = 0.0;
  double total = 0.0;

  // Order details
  String orderNotes = '';
  String? redeemCode;
  bool isRedeemCodeApplied = false;

  // File uploads (matching Java audio/photo functionality)
  List<File> uploadedPhotos = [];
  File? uploadedAudio;

  // Step tracking (matching Java progress steps)
  int currentStep = 0;
  final int totalSteps = 5; // Address, Time, Payment, Notes, Confirm

  // Loading and error states
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeOrder();
  }

  /// Initialize order based on type (Normal vs Skip Selection)
  void _initializeOrder() {
    context.read<OrderBloc>().add(
          const LoadAllAddressesEvent(
              token: 'user_token'), // TODO: Get actual token
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: OrderAppBar(
        title: widget.orderType == OrderType.NORMAL ? 'طلب جديد' : 'طلب سريع',
        onBackPressed: () => Navigator.of(context).pop(),
      ),
      body: BlocConsumer<OrderBloc, OrderState>(
        listener: _handleBlocStateChanges,
        builder: (context, state) {
          return Column(
            children: [
              // Step indicator (matching Java progress view)
              OrderStepIndicator(
                currentStep: currentStep,
                totalSteps: totalSteps,
                stepLabels: _getStepLabels(),
              ),

              // Main content
              Expanded(
                child: _buildMainContent(state),
              ),

              // Confirm order button (matching Java button)
              OrderConfirmButton(
                isEnabled: _canConfirmOrder(),
                isLoading: state is OrderLoading,
                subtotal: subtotal,
                deliveryFee: deliveryFee,
                discount: discount,
                total: total,
                onPressed: _confirmOrder,
              ),
            ],
          );
        },
      ),
    );
  }

  /// Handle BLoC state changes
  void _handleBlocStateChanges(BuildContext context, OrderState state) {
    if (state is AddressesLoaded) {
      setState(() {
        addresses = state.addresses;
        if (addresses.isNotEmpty) {
          selectedPickupAddress = addresses.first;
          selectedDeliveryAddress = addresses.first;
        }
      });
    } else if (state is OrderSubmitted) {
      _showSuccessDialog('تم إرسال الطلب بنجاح');
      Navigator.of(context).pop();
    } else if (state is OrderError) {
      _showErrorDialog(state.message);
    } else if (state is RedeemCodeApplied) {
      setState(() {
        isRedeemCodeApplied = true;
        discount = state.redeemResult.discount ?? 0.0;
        _calculateTotal();
      });
      _showSuccessDialog('تم تطبيق كود الخصم بنجاح');
    }
  }

  /// Build main content based on current step
  Widget _buildMainContent(OrderState state) {
    if (state is OrderLoading) {
      return const LoadingWidget();
    }

    return OrderSectionsList(
      sections: _buildOrderSections(),
      onSectionChanged: _handleSectionChange,
    );
  }

  /// Build order sections based on current step and order type
  List<Map<String, dynamic>> _buildOrderSections() {
    final sections = <Map<String, dynamic>>[];

    // Address section (always first)
    sections.add({
      'type': NewOrderSectionType.ADDRESS,
      'title': 'العنوان',
      'isCompleted':
          selectedPickupAddress != null && selectedDeliveryAddress != null,
      'data': {
        'pickupAddress': selectedPickupAddress,
        'deliveryAddress': selectedDeliveryAddress,
        'addresses': addresses,
      },
    });

    // Time section
    sections.add({
      'type': NewOrderSectionType.TIME,
      'title': 'الوقت',
      'isCompleted': selectedDate != null && selectedTimeSlot != null,
      'data': {
        'selectedDate': selectedDate,
        'selectedTimeSlot': selectedTimeSlot,
        'availableTimeSlots': availableTimeSlots,
      },
    });

    // Payment section
    sections.add({
      'type': NewOrderSectionType.PAYMENT,
      'title': 'طريقة الدفع',
      'isCompleted': selectedPaymentMethod != PaymentMethod.CASH,
      'data': {
        'selectedPaymentMethod': selectedPaymentMethod,
        'redeemCode': redeemCode,
        'isRedeemCodeApplied': isRedeemCodeApplied,
      },
    });

    // Notes section
    sections.add({
      'type': NewOrderSectionType.NOTES,
      'title': 'ملاحظات',
      'isCompleted': orderNotes.isNotEmpty,
      'data': {
        'notes': orderNotes,
        'uploadedPhotos': uploadedPhotos,
        'uploadedAudio': uploadedAudio,
      },
    });

    // Skip selection specific sections
    if (widget.orderType == OrderType.SKIP_SELECTION) {
      sections.add({
        'type': NewOrderSectionType.SKIP_SELECTION_DETAILS,
        'title': 'تفاصيل الطلب السريع',
        'isCompleted': widget.skipSelectionId != null,
        'data': {
          'skipSelectionId': widget.skipSelectionId,
        },
      });
    }

    return sections;
  }

  /// Handle section changes
  void _handleSectionChange(
      NewOrderSectionType sectionType, Map<String, dynamic> data) {
    switch (sectionType) {
      case NewOrderSectionType.ADDRESS:
        setState(() {
          selectedPickupAddress = data['pickupAddress'];
          selectedDeliveryAddress = data['deliveryAddress'];
        });
        break;

      case NewOrderSectionType.TIME:
        setState(() {
          selectedDate = data['selectedDate'];
          selectedTimeSlot = data['selectedTimeSlot'];
        });
        break;

      case NewOrderSectionType.PAYMENT:
        setState(() {
          selectedPaymentMethod = data['selectedPaymentMethod'];
          redeemCode = data['redeemCode'];
        });

        // Apply redeem code if provided
        if (data['applyRedeemCode'] == true && redeemCode != null) {
          _applyRedeemCode();
        }
        break;

      case NewOrderSectionType.NOTES:
        setState(() {
          orderNotes = data['notes'] ?? '';
          uploadedPhotos = data['uploadedPhotos'] ?? [];
          uploadedAudio = data['uploadedAudio'];
        });
        break;

      default:
        break;
    }

    _calculateTotal();
    _updateCurrentStep();
  }

  /// Apply redeem code
  void _applyRedeemCode() {
    if (redeemCode != null && redeemCode!.isNotEmpty) {
      context.read<OrderBloc>().add(
            ApplyRedeemCodeEvent(
              token: 'user_token', // TODO: Get actual token
              redeemCode: redeemCode!,
              orderTypeString: widget.orderType.name,
              products: widget.products,
            ),
          );
    }
  }

  /// Calculate order total
  void _calculateTotal() {
    total = subtotal + deliveryFee - discount;
    setState(() {});
  }

  /// Update current step based on completed sections
  void _updateCurrentStep() {
    int step = 0;

    if (selectedPickupAddress != null && selectedDeliveryAddress != null)
      step++;
    if (selectedDate != null && selectedTimeSlot != null) step++;
    if (selectedPaymentMethod != PaymentMethod.CASH) step++;
    if (orderNotes.isNotEmpty) step++;

    setState(() {
      currentStep = step;
    });
  }

  /// Check if order can be confirmed
  bool _canConfirmOrder() {
    return selectedPickupAddress != null &&
        selectedDeliveryAddress != null &&
        selectedDate != null &&
        selectedTimeSlot != null;
  }

  /// Confirm order
  void _confirmOrder() {
    if (!_canConfirmOrder()) {
      _showErrorDialog('يرجى إكمال جميع الحقول المطلوبة');
      return;
    }

    // TODO: Create NewOrderRequest object and submit
    _showErrorDialog('تأكيد الطلب قيد التطوير');
  }

  /// Get step labels
  List<String> _getStepLabels() {
    return [
      'العنوان',
      'الوقت',
      'الدفع',
      'الملاحظات',
      'تأكيد',
    ];
  }

  /// Show success dialog
  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('نجح'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('موافق'),
          ),
        ],
      ),
    );
  }

  /// Show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('خطأ'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('موافق'),
          ),
        ],
      ),
    );
  }
}

/// Wrapper widget to provide OrderBloc
class NewOrderPageWrapper extends StatelessWidget {
  final OrderType orderType;
  final List<Map<String, dynamic>>? products;
  final int? skipSelectionId;

  const NewOrderPageWrapper({
    super.key,
    this.orderType = OrderType.NORMAL,
    this.products,
    this.skipSelectionId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.getIt<OrderBloc>(),
      child: NewOrderPage(
        orderType: orderType,
        products: products,
        skipSelectionId: skipSelectionId,
      ),
    );
  }
}
