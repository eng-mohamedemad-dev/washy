import 'package:flutter/material.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';
import 'package:wash_flutter/core/constants/app_text_styles.dart';
import 'package:wash_flutter/features/notifications/data/datasources/notifications_remote_data_source.dart';
import 'package:wash_flutter/features/notifications/domain/entities/notification_item.dart';
import 'package:wash_flutter/injection_container.dart' as di;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wash_flutter/core/managers/deep_link_manager.dart';

/// NotificationsPage - 100% matching Java NotificationListActivity
class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final NotificationsRemoteDataSource _notificationsDataSource =
      di.getIt<NotificationsRemoteDataSource>();
  final SharedPreferences _prefs = di.getIt<SharedPreferences>();

  List<NotificationItem> notifications = [];
  bool isLoading = true;
  int currentPage = 1;
  int totalPages = 1;
  int unreadCount = 0;
  bool isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _loadNotifications(page: 1, clearList: true);
  }

  String _getToken() {
    return _prefs.getString('token') ?? '';
  }

  /// Load notifications from API (matching Java getNotificationList)
  Future<void> _loadNotifications(
      {int page = 1, bool clearList = false}) async {
    if (page == 1) {
      setState(() => isLoading = true);
    } else {
      setState(() => isLoadingMore = true);
    }

    try {
      final token = _getToken();
      if (token.isEmpty) {
        print('[NotificationsPage] No token found');
        if (mounted) {
          setState(() {
            isLoading = false;
            isLoadingMore = false;
          });
        }
        return;
      }

      final response =
          await _notificationsDataSource.getNotificationList(token, page);

      if (mounted) {
        final data = response['data'] as Map<String, dynamic>?;
        if (data != null) {
          final notificationsList =
              (data['notification_items'] as List<dynamic>? ??
                      data['notifications'] as List<dynamic>? ??
                      [])
                  .map((json) =>
                      NotificationItem.fromJson(json as Map<String, dynamic>))
                  .toList();

          final totalPagesCount = data['total_pages'] as int? ?? 1;
          final unread = data['unread'] as int? ?? 0;

          setState(() {
            if (clearList || page == 1) {
              notifications = notificationsList;
            } else {
              notifications.addAll(notificationsList);
            }
            currentPage = page;
            totalPages = totalPagesCount;
            unreadCount = unread;
            isLoading = false;
            isLoadingMore = false;
          });
        }
      }
    } catch (e) {
      print('[NotificationsPage] Error loading notifications: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
          isLoadingMore = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ في تحميل الإشعارات: $e'),
            backgroundColor: AppColors.colorRedBadge,
          ),
        );
      }
    }
  }

  /// Mark notification as read (matching Java setNotificationAsRead)
  Future<void> _markAsRead(NotificationItem notification, int index) async {
    try {
      final token = _getToken();
      if (token.isEmpty || token == '') return;

      await _notificationsDataSource.setNotificationAsRead(
          token, notification.notificationId);

      if (mounted) {
        setState(() {
          notifications[index] = notification.copyWith(read: 'yes');
          if (unreadCount > 0) unreadCount--;
        });
      }
    } catch (e) {
      print('[NotificationsPage] Error marking notification as read: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ في تحديث الإشعار'),
            backgroundColor: AppColors.colorRedBadge,
          ),
        );
      }
    }
  }

  /// Mark all notifications as read (matching Java setAllNotificationRead)
  Future<void> _markAllAsRead() async {
    try {
      final token = _getToken();
      if (token.isEmpty || token == '') return;

      await _notificationsDataSource.setAllNotificationRead(token);

      // Reload notifications after marking all as read
      await _loadNotifications(page: 1, clearList: true);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم تحديد جميع الإشعارات كمقروءة'),
            backgroundColor: AppColors.washyGreen,
          ),
        );
      }
    } catch (e) {
      print('[NotificationsPage] Error marking all as read: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ في تحديث الإشعارات'),
            backgroundColor: AppColors.colorRedBadge,
          ),
        );
      }
    }
  }

  /// Delete notification
  Future<void> _deleteNotification(
      NotificationItem notification, int index) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف الإشعار'),
        content: const Text('هل أنت متأكد من حذف هذا الإشعار؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('حذف',
                style: TextStyle(color: AppColors.colorRedBadge)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final token = _getToken();
      if (token.isEmpty || token == '') return;

      // TODO: Add delete API endpoint when available
      // For now, just remove from local list
      if (mounted) {
        setState(() {
          notifications.removeAt(index);
          if (!notification.isRead) {
            if (unreadCount > 0) unreadCount--;
          }
        });
      }
    } catch (e) {
      print('[NotificationsPage] Error deleting notification: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ في حذف الإشعار'),
            backgroundColor: AppColors.colorRedBadge,
          ),
        );
      }
    }
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

  /// Header (100% matching Java Header_RelativeLayout: 86dp height, background_toolbar_gradient)
  Widget _buildHeader() {
    return Container(
      height: 86, // Matching Java: android:layout_height="86dp"
      decoration: BoxDecoration(
        // Matching Java: background="@drawable/background_toolbar_gradient"
        // Gradient: startColor="#73D9A1" to endColor="#62B5B3", angle="74"
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(
                0xFF73D9A1), // Matching Java: android:startColor="#73D9A1"
            const Color(
                0xFF62B5B3), // Matching Java: android:endColor="#62B5B3"
          ],
          // Note: Flutter's LinearGradient uses begin/end instead of angle
          // angle="74" translates to approximately topLeft to bottomRight
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(
              7), // Matching Java: android:bottomLeftRadius="7dp"
          bottomRight: Radius.circular(
              7), // Matching Java: android:bottomRightRadius="7dp"
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // Back Icon (matching Java: BackIcon_RelativeLayout, 80dp × 60dp, ic_back_custom_white)
            Positioned(
              left: 16, // Matching Java: activity_horizontal_margin
              top: 10, // Matching Java: activity_vertical_margin
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 80, // Matching Java: android:layout_width="80dp"
                  height: 60, // Matching Java: android:layout_height="60dp"
                  alignment: Alignment.centerLeft,
                  child: Image.asset(
                    'assets/images/ic_back_custom_white.png',
                    width: 24,
                    height: 24,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            // Title with unread count (matching Java: PageTitle_TextView, 22sp, white, marginLeft="66dp")
            Center(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 66, // Matching Java: android:layout_marginLeft="66dp"
                  top: 10, // Matching Java: android:layout_marginTop="10dp"
                ),
                child: Text(
                  unreadCount > 0 ? 'الإشعارات ($unreadCount)' : 'الإشعارات',
                  style: const TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 22, // Matching Java: android:textSize="22sp"
                    fontWeight: FontWeight.normal,
                    color: AppColors
                        .white, // Matching Java: android:textColor="@color/white"
                  ),
                ),
              ),
            ),

            // Mark All Read (matching Java: ShowAllAsRead_TextView, 12sp, white, paddingEnd)
            if (unreadCount > 0)
              Positioned(
                right:
                    16, // Matching Java: paddingEnd="@dimen/activity_horizontal_margin"
                top: 10, // Matching Java: android:layout_marginTop="10dp"
                child: GestureDetector(
                  onTap: _markAllAsRead,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical:
                          8, // Matching Java: paddingTop/Bottom="@dimen/activity_vertical_margin"
                      horizontal:
                          16, // Matching Java: paddingEnd="@dimen/activity_horizontal_margin"
                    ),
                    child: const Text(
                      'قراءة الكل',
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: 12, // Matching Java: android:textSize="12sp"
                        color: AppColors
                            .white, // Matching Java: android:textColor="@color/white"
                      ),
                    ),
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

  /// Notifications List (100% matching Java NotificationsRecyclerView with load more)
  Widget _buildNotificationsList() {
    if (notifications.isEmpty) {
      return _buildEmptyView();
    }

    return ListView.builder(
      // No padding - matching Java NotificationsRecyclerView (padding is in row_notification.xml)
      padding: EdgeInsets.zero,
      itemCount: notifications.length +
          (isLoadingMore ? 1 : 0) +
          (currentPage < totalPages ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == notifications.length && isLoadingMore) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(color: AppColors.washyBlue),
            ),
          );
        }

        if (index == notifications.length &&
            currentPage < totalPages &&
            !isLoadingMore) {
          // Load more trigger
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _loadNotifications(page: currentPage + 1, clearList: false);
          });
          return const SizedBox.shrink();
        }

        return _buildNotificationItem(notifications[index], index);
      },
    );
  }

  /// Empty View (100% matching Java EmptyLayout_LinearLayout)
  Widget _buildEmptyView() {
    return Container(
      color: AppColors.white,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 70),
            // Sleeping bell icon image (matching Java: 218dp × 130dp)
            Image.asset(
              'assets/images/ic_no_notification.png',
              width: 218,
              height: 130,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 60),
            // First text: "لا يوجد اشعارات" (matching Java: 27sp, bold, colorTitleBlack)
            const Text(
              'لا يوجد اشعارات',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 27,
                fontWeight: FontWeight.bold,
                color: AppColors.colorTitleBlack,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            // Second text: "ارجع هنا للاشعارات" (matching Java: 18sp, alpha 0.7, color #8c96a8)
            Text(
              'ارجع هنا للاشعارات',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 18,
                color: const Color(0xFF8c96a8).withOpacity(0.7),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 56),
            // Button: "رجوع لحسابي" (matching Java: 200dp × 60dp, background_submit_button style)
            SizedBox(
              width: 200,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to home page (matching Java behavior: finish and go to home)
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.pushReplacementNamed(context, '/home');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.washyGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: 0,
                  padding: EdgeInsets.zero,
                ),
                child: const Text(
                  'رجوع لحسابي',
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                    letterSpacing: 0.05,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Notification Item (100% matching Java row_notification.xml layout)
  Widget _buildNotificationItem(NotificationItem notification, int index) {
    final bool isRead = notification.isRead;

    return Dismissible(
      key: Key('notification_${notification.notificationId}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: AppColors.colorRedBadge,
        child: const Icon(
          Icons.delete,
          color: AppColors.white,
          size: 28,
        ),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          await _deleteNotification(notification, index);
          return false; // Don't dismiss, we handle it in _deleteNotification
        }
        return false;
      },
      child: GestureDetector(
        onTap: () => _onNotificationClicked(notification, index),
        child: Container(
          // Matching Java: marginTop="6dp", padding="20dp"
          margin: const EdgeInsets.only(top: 6),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          color: AppColors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // NotificationTitle_TextView (matching Java: 17sp, marginStart="10dp", marginTop="20dp")
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  top: 20,
                ),
                child: Text(
                  notification.title,
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 17, // Matching Java: 17sp
                    fontWeight: isRead
                        ? FontWeight.normal // Normal if read
                        : FontWeight.bold, // Bold if unread (matching Java)
                    color: AppColors
                        .colorTitleBlack, // Matching Java: @color/colorTitleBlack
                  ),
                ),
              ),

              // NotificationTime_TextView (matching Java: 10sp, marginStart="10dp", marginTop="8dp")
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  top: 8,
                ),
                child: Text(
                  notification.dateAdded,
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 10, // Matching Java: 10sp
                    fontWeight: isRead
                        ? FontWeight.normal // Normal if read
                        : FontWeight.bold, // Bold if unread (matching Java)
                    color: isRead
                        ? AppColors
                            .colorTextNotSelected // Matching Java: @color/colorTextNotSelected when read
                        : AppColors
                            .colorGreenButton, // Matching Java: @color/colorGreenButton when unread
                  ),
                ),
              ),

              // NotificationMessage_TextView (matching Java: 13sp, marginStart="10dp", marginTop="8dp", lineSpacingExtra="7sp")
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  top: 8,
                ),
                child: Text(
                  notification.message,
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 13, // Matching Java: 13sp
                    height: 1.0 +
                        (7.0 /
                            13.0), // Matching Java: lineSpacingExtra="7sp" (7sp / 13sp = line height)
                    color: AppColors
                        .colorTitleBlack, // Matching Java: @color/colorTitleBlack
                  ),
                ),
              ),

              // Separator_View (matching Java: height="1dp", background="@color/colorViewSeparators", marginTop="15dp")
              Container(
                margin: const EdgeInsets.only(top: 15),
                height: 1,
                color: AppColors
                    .colorViewSeparators, // Matching Java: @color/colorViewSeparators
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Handle notification click (matching Java onNotificationClicked)
  void _onNotificationClicked(NotificationItem notification, int index) {
    // Mark as read if unread (matching Java behavior)
    if (!notification.isRead) {
      _markAsRead(notification, index);
    }

    // Handle deep link navigation (matching Java DeepLinkManager)
    if (notification.deepLink.isNotEmpty) {
      DeepLinkManager.handleDeepLink(
          context, notification.deepLink, notification.id);
    }
  }
}
