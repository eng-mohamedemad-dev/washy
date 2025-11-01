import 'package:flutter/material.dart';

/// DeepLinkManager - Handles navigation based on deep links (matching Java DeepLinkManager)
class DeepLinkManager {
  static final DeepLinkManager _instance = DeepLinkManager._internal();
  factory DeepLinkManager() => _instance;
  DeepLinkManager._internal();

  /// Handle deep link navigation (matching Java gotoLauncherActivity)
  static void handleDeepLink(BuildContext context, String deepLink, int id) {
    if (deepLink.isEmpty) return;

    // Handle special cases
    if (deepLink.contains('update_email')) {
      // Handle update email flow
      Navigator.pushNamed(context, '/profile');
      return;
    }

    // Handle common deep links
    if (deepLink.startsWith('/')) {
      deepLink = deepLink.substring(1);
    }

    final parts = deepLink.split('/');
    if (parts.isEmpty) return;

    final route = parts[0].toLowerCase();

    switch (route) {
      case 'orders':
      case 'order':
        Navigator.pushNamed(context, '/orders');
        break;
      case 'profile':
      case 'account':
        Navigator.pushNamed(context, '/profile');
        break;
      case 'order':
      case 'order_details':
        if (id > 0) {
          Navigator.pushNamed(
            context,
            '/order-details',
            arguments: {'orderId': id},
          );
        } else {
          Navigator.pushNamed(context, '/orders');
        }
        break;
      default:
        // Unknown deep link, do nothing
        print('[DeepLinkManager] Unknown deep link: $deepLink');
        break;
    }
  }
}
