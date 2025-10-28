import 'package:flutter/material.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';

/// LauncherPage - Handles deep linking like Java LauncherActivity
class LauncherPage extends StatefulWidget {
  final String? deepLink;
  final Map<String, dynamic>? params;

  const LauncherPage({
    super.key,
    this.deepLink,
    this.params,
  });

  @override
  State<LauncherPage> createState() => _LauncherPageState();
}

class _LauncherPageState extends State<LauncherPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleDeepLink();
    });
  }

  /// Handle deep link navigation (like Java LauncherActivity)
  void _handleDeepLink() {
    if (widget.deepLink == null) {
      // No deep link, navigate to normal flow
      _navigateToHome();
      return;
    }

    final uri = Uri.tryParse(widget.deepLink!);
    if (uri == null) {
      _navigateToHome();
      return;
    }

    // Handle different deep link patterns (like Java)
    switch (uri.pathSegments.first.toLowerCase()) {
      case 'categories':
        _handleCategoryLink(uri);
        break;
      case 'orders':
        _handleOrderLink(uri);
        break;
      case 'profile':
        _handleProfileLink();
        break;
      case 'cart':
        _handleCartLink();
        break;
      case 'notifications':
        _handleNotificationLink(uri);
        break;
      default:
        _navigateToHome();
    }
  }

  /// Handle category deep link (like Java's category navigation)
  void _handleCategoryLink(Uri uri) {
    final categoryId = uri.queryParameters['id'];
    final categoryName = uri.queryParameters['name'];
    
    if (categoryId != null) {
      // Navigate to category details
      Navigator.pushReplacementNamed(
        context,
        '/category',
        arguments: {
          'categoryId': categoryId,
          'categoryName': categoryName,
        },
      );
    } else {
      _navigateToHome();
    }
  }

  /// Handle order deep link (like Java's order navigation)
  void _handleOrderLink(Uri uri) {
    final orderId = uri.queryParameters['id'];
    
    if (orderId != null) {
      // Navigate to order details
      Navigator.pushReplacementNamed(
        context,
        '/order-details',
        arguments: {'orderId': orderId},
      );
    } else {
      // Navigate to orders list
      Navigator.pushReplacementNamed(context, '/orders');
    }
  }

  /// Handle profile deep link (like Java's profile navigation)
  void _handleProfileLink() {
    Navigator.pushReplacementNamed(context, '/profile');
  }

  /// Handle cart deep link (like Java's cart navigation)
  void _handleCartLink() {
    Navigator.pushReplacementNamed(context, '/cart');
  }

  /// Handle notification deep link (like Java's notification handling)
  void _handleNotificationLink(Uri uri) {
    final notificationId = uri.queryParameters['id'];
    final type = uri.queryParameters['type'];
    
    if (notificationId != null) {
      // Mark notification as read (like Java)
      _markNotificationAsRead(notificationId);
      
      // Navigate based on notification type
      switch (type?.toLowerCase()) {
        case 'order':
          final orderId = uri.queryParameters['order_id'];
          if (orderId != null) {
            Navigator.pushReplacementNamed(
              context,
              '/order-details',
              arguments: {'orderId': orderId},
            );
          } else {
            _navigateToHome();
          }
          break;
        case 'promotion':
          // Navigate to promotions
          _navigateToHome();
          break;
        default:
          _navigateToHome();
      }
    } else {
      _navigateToHome();
    }
  }

  /// Mark notification as read (like Java's notification handling)
  void _markNotificationAsRead(String notificationId) {
    // TODO: Implement API call to mark notification as read
    debugPrint('Marking notification $notificationId as read');
  }

  /// Navigate to home/main screen (like Java's default navigation)
  void _navigateToHome() {
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Loading indicator while processing deep link
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.washyBlue),
            ),
            SizedBox(height: 20),
            Text(
              'Loading...',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.grey1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
