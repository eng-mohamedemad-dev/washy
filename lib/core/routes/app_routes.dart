import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';
import 'package:wash_flutter/features/auth/presentation/pages/signup_page.dart';
import 'package:wash_flutter/features/auth/presentation/pages/login_page.dart';
import 'package:wash_flutter/features/auth/presentation/pages/email_page.dart';
import 'package:wash_flutter/features/auth/presentation/pages/verification_page.dart';
import 'package:wash_flutter/features/auth/presentation/pages/password_page.dart';
import 'package:wash_flutter/features/auth/presentation/bloc/signup/signup_bloc.dart';
import 'package:wash_flutter/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:wash_flutter/features/auth/presentation/bloc/email/email_bloc.dart';
import 'package:wash_flutter/features/splash/presentation/pages/index_page.dart';
import 'package:wash_flutter/features/splash/presentation/pages/splash_page.dart';
import 'package:wash_flutter/features/intro/presentation/pages/intro_page.dart';
import 'package:wash_flutter/features/home/presentation/pages/landing_page.dart';
import 'package:wash_flutter/features/launcher/presentation/pages/launcher_page.dart';
import 'package:wash_flutter/features/cart/presentation/pages/cart_page.dart';
import 'package:wash_flutter/features/order/presentation/pages/new_order_page.dart';
import 'package:wash_flutter/features/order/domain/entities/order_type.dart';
import 'package:wash_flutter/features/orders/presentation/pages/orders_page.dart';
import 'package:wash_flutter/features/order_status/presentation/pages/order_status_page.dart';
import 'package:wash_flutter/features/payment/presentation/pages/payment_page.dart' as PaymentFeature;
import 'package:wash_flutter/features/address/presentation/pages/address_page.dart';
import 'package:wash_flutter/features/addresses/presentation/pages/addresses_page.dart';
import 'package:wash_flutter/features/addresses/domain/entities/address_navigation_type.dart';
import 'package:wash_flutter/features/profile/presentation/pages/profile_page.dart';
import 'package:wash_flutter/features/contact/presentation/pages/contact_us_page.dart';
import 'package:wash_flutter/features/faq/presentation/pages/faq_page.dart';
import 'package:wash_flutter/features/feedback/presentation/pages/feedback_page.dart';
import 'package:wash_flutter/features/help/presentation/pages/get_help_page.dart';
import 'package:wash_flutter/features/profile_settings/presentation/pages/profile_settings_page.dart';
import 'package:wash_flutter/features/reminder_settings/presentation/pages/reminder_settings_page.dart';
import 'package:wash_flutter/features/update_profile/presentation/pages/update_name_page.dart';
import 'package:wash_flutter/features/update_profile/presentation/pages/update_email_page.dart';
import 'package:wash_flutter/features/update_profile/presentation/pages/update_password_page.dart';
import 'package:wash_flutter/features/update_profile/presentation/pages/update_mobile_page.dart';
import 'package:wash_flutter/features/rate_service/presentation/pages/rate_service_page.dart';
import 'package:wash_flutter/features/notifications/presentation/pages/notifications_page.dart';
import 'package:wash_flutter/features/language/presentation/pages/language_selection_page.dart';
import 'package:wash_flutter/features/about_us/presentation/pages/about_us_page.dart';
import 'package:wash_flutter/features/privacy_policy/presentation/pages/privacy_policy_page.dart';
import 'package:wash_flutter/features/terms/presentation/pages/terms_and_conditions_page.dart';
import 'package:wash_flutter/features/express_delivery/presentation/pages/express_delivery_page.dart';
import 'package:wash_flutter/features/furniture/presentation/pages/furniture_service_page.dart';
import 'package:wash_flutter/features/share/presentation/pages/share_with_friends_page.dart';
import 'package:wash_flutter/features/splash/presentation/pages/splash_page.dart';
import 'package:wash_flutter/features/settings/presentation/pages/settings_page.dart';
import 'package:wash_flutter/features/order_summary/presentation/pages/order_summary_page.dart';
import 'package:wash_flutter/features/order_tracking/presentation/pages/order_tracking_page.dart';
import 'package:wash_flutter/features/service_selection/presentation/pages/service_selection_page.dart';
import 'package:wash_flutter/features/welcome/presentation/pages/welcome_page.dart';
import 'package:wash_flutter/features/home/presentation/pages/home_page.dart';
import 'package:wash_flutter/features/order_status/presentation/pages/order_status_page.dart';
import 'package:wash_flutter/features/premium/presentation/pages/premium_details_page.dart';
import 'package:wash_flutter/features/create_password/presentation/pages/create_password_page.dart';
import 'package:wash_flutter/injection_container.dart' as di;

/// App routes configuration
class AppRoutes {
  static const String initial = '/';
  static const String splash = '/splash';
  static const String intro = '/intro';
  static const String signup = '/signup';
  static const String login = '/login';
  static const String email = '/email';
  static const String verification = '/verification';
  static const String password = '/password';
  static const String home = '/home';
  static const String launcher = '/launcher';
  static const String cart = '/cart';
  static const String newOrder = '/new-order';
  static const String orders = '/orders';
  static const String orderStatus = '/order-status';
  static const String payment = '/payment';
  static const String address = '/address';
  static const String addresses = '/addresses';
  static const String addAddress = '/add-address';
  static const String editAddress = '/edit-address';
  static const String profile = '/profile';
  static const String creditCards = '/credit-cards';
  static const String thankYou = '/thank-you';
  static const String contactUs = '/contact-us';
  static const String faq = '/faq';
  static const String feedback = '/feedback';
  static const String getHelp = '/get-help';
  static const String profileSettings = '/profile-settings';
  static const String reminderSettings = '/reminder-settings';
  static const String updateName = '/update-name';
  static const String updateEmail = '/update-email';
  static const String updatePassword = '/update-password';
  static const String updateMobile = '/update-mobile';
  static const String rateService = '/rate-service';
  static const String notificationList = '/notifications';
  static const String languageSelection = '/language-selection';
  static const String aboutUs = '/about-us';
  static const String privacyPolicy = '/privacy-policy';
  static const String termsAndConditions = '/terms-and-conditions';
  static const String expressDelivery = '/express-delivery';
  static const String furnitureService = '/furniture-service';
  static const String shareWithFriends = '/share-with-friends';
  static const String settings = '/settings';
  static const String orderSummary = '/order-summary';
  static const String orderTracking = '/order-tracking';
  static const String orderStatus = '/order-status';
  static const String premiumDetails = '/premium-details';
  static const String createPassword = '/create-password';
  static const String serviceSelection = '/service-selection';
  static const String welcome = '/welcome';
  
  /// Generate routes for the app
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case initial:
        return MaterialPageRoute(builder: (_) => const IndexPage());
        
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());
        
      case intro:
        return MaterialPageRoute(builder: (_) => const IntroPage());
        
      case signup:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => di.getIt<SignUpBloc>(),
            child: const SignUpPage(),
          ),
        );
        
      case login:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => di.getIt<LoginBloc>(),
            child: const LoginPage(),
          ),
        );
        
      case email:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => di.getIt<EmailBloc>(),
            child: const EmailPage(),
          ),
        );
        
      case verification:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => VerificationPage(
            identifier: args?['identifier'] ?? '',
            isPhone: args?['isPhone'] ?? true,
            isFromForgetPassword: args?['isFromForgetPassword'] ?? false,
          ),
        );
        
      case password:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => PasswordPage(
            user: args?['user'],
            isNewUser: args?['isNewUser'] ?? false,
          ),
        );
        
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
        
      case launcher:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => LauncherPage(
            deepLink: args?['deepLink'],
            params: args?['params'],
          ),
        );
        
      case cart:
        return MaterialPageRoute(builder: (_) => const CartPage());
        
      case newOrder:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => NewOrderPageWrapper(
            orderType: args?['orderType'] ?? OrderType.NORMAL,
            products: args?['products'],
            skipSelectionId: args?['skipSelectionId'],
          ),
        );
        
      case orders:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => OrdersPageWrapper(
            isFromThankYouPage: args?['isFromThankYouPage'] ?? false,
          ),
        );
        
      case orderStatus:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => OrderStatusPage(
            orderId: args?['orderId'] ?? 0,
          ),
        );
        
      case payment:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => PaymentFeature.PaymentPage(
            orderId: args?['orderId'] ?? 0,
            amount: args?['amount']?.toDouble() ?? 0.0,
          ),
        );
        
      case address:
        return MaterialPageRoute(builder: (_) => const AddressPage());
        
      case addresses:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => AddressesPage(
            navigationType: args?['navigationType'] ?? AddressNavigationType.openAddressPageFromProfile,
            pageTitle: args?['pageTitle'],
          ),
        );
        
      case addAddress:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Add Address Page\n(To be implemented)'),
            ),
          ),
        );
        
      case editAddress:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Edit Address Page\n(To be implemented)'),
            ),
          ),
        );
        
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage());
        
      case creditCards:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Credit Cards Page\n(To be implemented)'),
            ),
          ),
        );
        
      case thankYou:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            backgroundColor: AppColors.colorBackground,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.washyGreen,
                    size: 80,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'تم إتمام طلبك بنجاح!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.greyDark,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'رقم الطلب: ${args?['orderId'] ?? 'غير محدد'}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.grey2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'المبلغ: ${args?['total'] ?? '0.00'} ريال',
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.grey2,
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        _,
                        '/home',
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.washyBlue,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                    child: const Text(
                      'العودة للرئيسية',
                      style: TextStyle(color: AppColors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        
      case contactUs:
        return MaterialPageRoute(builder: (_) => const ContactUsPage());
        
      case faq:
        return MaterialPageRoute(builder: (_) => const FAQPage());
        
      case feedback:
        return MaterialPageRoute(builder: (_) => const FeedbackPage());
        
      case getHelp:
        return MaterialPageRoute(builder: (_) => const GetHelpPage());
        
      case profileSettings:
        return MaterialPageRoute(builder: (_) => const ProfileSettingsPage());
        
      case reminderSettings:
        return MaterialPageRoute(builder: (_) => const ReminderSettingsPage());
        
      case updateName:
        return MaterialPageRoute(builder: (_) => const UpdateNamePage());
        
      case updateEmail:
        return MaterialPageRoute(builder: (_) => const UpdateEmailPage());
        
      case updatePassword:
        return MaterialPageRoute(builder: (_) => const UpdatePasswordPage());
        
      case updateMobile:
        return MaterialPageRoute(builder: (_) => const UpdateMobilePage());
        
      case rateService:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => RateServicePage(
            orderId: args?['orderId'] ?? 0,
            orderType: args?['orderType'] ?? 'normal',
          ),
        );
        
      case notificationList:
        return MaterialPageRoute(builder: (_) => const NotificationsPage());
        
      case languageSelection:
        return MaterialPageRoute(builder: (_) => const LanguageSelectionPage());
        
      case aboutUs:
        return MaterialPageRoute(builder: (_) => const AboutUsPage());
        
      case privacyPolicy:
        return MaterialPageRoute(builder: (_) => const PrivacyPolicyPage());
        
      case termsAndConditions:
        return MaterialPageRoute(builder: (_) => const TermsAndConditionsPage());
        
      case expressDelivery:
        return MaterialPageRoute(builder: (_) => const ExpressDeliveryPage());
        
      case furnitureService:
        return MaterialPageRoute(builder: (_) => const FurnitureServicePage());
        
      case shareWithFriends:
        return MaterialPageRoute(builder: (_) => const ShareWithFriendsPage());
        
      case settings:
        return MaterialPageRoute(builder: (_) => const SettingsPage());
        
      case orderSummary:
        return MaterialPageRoute(builder: (_) => const OrderSummaryPage());
        
      case orderTracking:
        return MaterialPageRoute(builder: (_) => const OrderTrackingPage());
        
      case orderStatus:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => OrderStatusPage(
            orderId: args?['orderId'] ?? 1,
          ),
        );
        
      case premiumDetails:
        return MaterialPageRoute(builder: (_) => const PremiumDetailsPage());
        
      case createPassword:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => CreatePasswordPage(
            isFromEmail: args?['isFromEmail'] ?? false,
          ),
        );
        
      case serviceSelection:
        return MaterialPageRoute(builder: (_) => const ServiceSelectionPage());
        
      case welcome:
        return MaterialPageRoute(builder: (_) => const WelcomePage());
        
      default:
        return MaterialPageRoute(
          builder: (_) => const NotFoundPage(),
        );
    }
  }
}

/// 404 Not Found page
class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page Not Found'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              '404 - Page Not Found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'The page you are looking for does not exist.',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
