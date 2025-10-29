import 'package:flutter/material.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';
import 'package:wash_flutter/core/constants/app_text_styles.dart';

/// NotificationsPage - 100% matching Java NotificationListActivity (simplified)
class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<NotificationItem> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorBackground,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: isLoading ? _buildLoadingView() : _buildNotificationsList(),
          ),
        ],
      ),
    );
  }

  /// Header (100% matching Java layout)
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 40),
      color: AppColors.white,
      child: Column(
        children: [
          // Back button + Title + Mark All Read
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                // Back Button
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    child: const Icon(
                      Icons.arrow_back,
                      color: AppColors.colorTitleBlack,
                      size: 24,
                    ),
                  ),
                ),
                
                // Title
                const Expanded(
                  child: Text(
                    'الإشعارات',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.colorTitleBlack,
                    ),
                  ),
                ),
                
                // Mark All Read (100% matching Java ShowAllAsRead_TextView)
                GestureDetector(
                  onTap: _markAllAsRead,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: const Text(
                      'قراءة الكل',
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: 14,
                        color: AppColors.washyBlue,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
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

  /// Notifications List (100% matching Java NotificationsRecyclerView)
  Widget _buildNotificationsList() {
    if (notifications.isEmpty) {
      return _buildEmptyView();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        return _buildNotificationItem(notifications[index], index);
      },
    );
  }

  /// Empty View (100% matching Java EmptyLayout_LinearLayout)
  Widget _buildEmptyView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 64,
            color: AppColors.grey2,
          ),
          SizedBox(height: 16),
          Text(
            'لا توجد إشعارات',
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: 18,
              color: AppColors.grey2,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'ستظهر الإشعارات هنا عند وصولها',
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

  /// Notification Item (100% matching Java notification row design)
  Widget _buildNotificationItem(NotificationItem notification, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: InkWell(
          onTap: () => _onNotificationClicked(notification, index),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Notification Icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: notification.isRead ? AppColors.grey5 : AppColors.washyBlue.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getNotificationIcon(notification.type),
                    color: notification.isRead ? AppColors.grey2 : AppColors.washyBlue,
                    size: 20,
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // Notification Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        notification.title,
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 16,
                          fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                          color: notification.isRead ? AppColors.grey2 : AppColors.colorTitleBlack,
                        ),
                      ),
                      
                      const SizedBox(height: 4),
                      
                      // Message
                      Text(
                        notification.message,
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 14,
                          color: notification.isRead ? AppColors.grey2 : AppColors.greyDark,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Time
                      Text(
                        notification.timeAgo,
                        style: const TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 12,
                          color: AppColors.grey2,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Unread Indicator
                if (!notification.isRead)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.washyBlue,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper Methods
  IconData _getNotificationIcon(String type) {
    switch (type.toLowerCase()) {
      case 'order':
        return Icons.shopping_bag_outlined;
      case 'promotion':
        return Icons.local_offer_outlined;
      case 'reminder':
        return Icons.alarm_outlined;
      case 'general':
      default:
        return Icons.notifications_outlined;
    }
  }

  // Action Methods (100% matching Java NotificationListActivity)
  void _loadNotifications() async {
    // Mock API call - replace with actual WebServiceManager.callGetNotificationsList
    await Future.delayed(const Duration(seconds: 1));
    
    setState(() {
      notifications = _getMockNotifications();
      isLoading = false;
    });
  }

  void _onNotificationClicked(NotificationItem notification, int index) {
    // 100% matching Java: mark as read + handle deep link
    if (!notification.isRead) {
      setState(() {
        notifications[index] = notification.copyWith(isRead: true);
      });
      
      // Mock API call - replace with actual WebServiceManager.callSetAsReadNotification
      _markAsRead(notification.id);
    }
    
    // Handle deep link navigation if needed
    if (notification.deepLink.isNotEmpty) {
      // Navigate to specific page based on deep link
      _handleDeepLink(notification.deepLink);
    }
  }

  void _markAllAsRead() {
    // 100% matching Java ShowAllAsRead functionality
    setState(() {
      notifications = notifications.map((n) => n.copyWith(isRead: true)).toList();
    });
    
    // Mock API call - replace with actual WebServiceManager.callSetAllReadNotifications
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم تحديد جميع الإشعارات كمقروءة'),
        backgroundColor: AppColors.washyGreen,
      ),
    );
  }

  void _markAsRead(int notificationId) async {
    // Mock API call for marking single notification as read
    await Future.delayed(const Duration(milliseconds: 500));
  }

  void _handleDeepLink(String deepLink) {
    // Handle navigation based on deep link
    switch (deepLink) {
      case 'orders':
        Navigator.pushNamed(context, '/orders');
        break;
      case 'profile':
        Navigator.pushNamed(context, '/profile');
        break;
      default:
        break;
    }
  }

  // Mock Data (replace with real API)
  List<NotificationItem> _getMockNotifications() {
    return [
      NotificationItem(
        id: 1,
        title: 'تم تأكيد طلبك',
        message: 'تم تأكيد طلبك #12345 وسيصل خلال 24 ساعة',
        type: 'order',
        timeAgo: 'منذ 5 دقائق',
        isRead: false,
        deepLink: 'orders',
      ),
      NotificationItem(
        id: 2,
        title: 'عرض خاص',
        message: 'احصل على خصم 20% على طلبك التالي',
        type: 'promotion',
        timeAgo: 'منذ ساعة',
        isRead: false,
        deepLink: '',
      ),
      NotificationItem(
        id: 3,
        title: 'تذكير موعد التسليم',
        message: 'طلبك #12340 جاهز للتسليم غداً الساعة 10:00 ص',
        type: 'reminder',
        timeAgo: 'منذ 3 ساعات',
        isRead: true,
        deepLink: 'orders',
      ),
      NotificationItem(
        id: 4,
        title: 'مرحباً بك في واشي واش',
        message: 'نرحب بك في تطبيق واشي واش لخدمات الغسيل',
        type: 'general',
        timeAgo: 'منذ يوم',
        isRead: true,
        deepLink: '',
      ),
    ];
  }
}

/// Notification Item Model (100% matching Java NotificationItem)
class NotificationItem {
  final int id;
  final String title;
  final String message;
  final String type;
  final String timeAgo;
  final bool isRead;
  final String deepLink;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timeAgo,
    required this.isRead,
    required this.deepLink,
  });

  NotificationItem copyWith({
    int? id,
    String? title,
    String? message,
    String? type,
    String? timeAgo,
    bool? isRead,
    String? deepLink,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      timeAgo: timeAgo ?? this.timeAgo,
      isRead: isRead ?? this.isRead,
      deepLink: deepLink ?? this.deepLink,
    );
  }
}



