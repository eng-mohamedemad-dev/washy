import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';

abstract class NotificationsRemoteDataSource {
  Future<Map<String, dynamic>> getNotificationList(String token, int page);
  Future<void> setNotificationAsRead(String token, int notificationId);
  Future<void> setAllNotificationRead(String token);
}

class NotificationsRemoteDataSourceImpl implements NotificationsRemoteDataSource {
  final http.Client client;
  NotificationsRemoteDataSourceImpl({required this.client});

  @override
  Future<Map<String, dynamic>> getNotificationList(String token, int page) async {
    final response = await client.post(
      Uri.parse('${AppConstants.baseUrl}customer/notification/get'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'token': token,
        'page': page.toString(),
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    }
    throw ServerException('Failed to get notifications: ${response.statusCode}');
  }

  @override
  Future<void> setNotificationAsRead(String token, int notificationId) async {
    final response = await client.post(
      Uri.parse('${AppConstants.baseUrl}customer/notification/read'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'token': token,
        'notification_id': notificationId.toString(),
      },
    );
    if (response.statusCode != 200) {
      throw ServerException('Failed to set notification read: ${response.statusCode}');
    }
  }

  @override
  Future<void> setAllNotificationRead(String token) async {
    final response = await client.post(
      Uri.parse('${AppConstants.baseUrl}customer/notification/read/all'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'token': token,
      },
    );
    if (response.statusCode != 200) {
      throw ServerException('Failed to set all notifications read: ${response.statusCode}');
    }
  }
}


