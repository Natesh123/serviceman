import 'package:get/get.dart';
import 'package:demandium_serviceman/utils/core_export.dart';


class NotificationRepo {
final ApiClient apiClient;
final SharedPreferences sharedPreferences;
NotificationRepo({required this.sharedPreferences, required this.apiClient});

Future<Response> getNotification(int offset) async {
  return await apiClient.getData(
      '${AppConstants.notificationUrl}?limit=20&offset=$offset');
}

Future<Response> getBroadcastNotifications() async {
  return await apiClient.getData('/api/v1/serviceman/booking/broadcast-notifications');
}

  Future <int?> getNotificationCount() async {
    return sharedPreferences.getInt(AppConstants.notificationCount);
  }
  void setNotificationCount(int count){
    sharedPreferences.setInt(AppConstants.notificationCount, count);
  }

  Future <int?> getBroadcastNotificationCount() async {
    return sharedPreferences.getInt('broadcast_notification_count');
  }
  void setBroadcastNotificationCount(int count){
    sharedPreferences.setInt('broadcast_notification_count', count);
  }

  List<String> getReadNotifications() {
    return sharedPreferences.getStringList('read_notifications') ?? [];
  }

  Future<void> markAsRead(String notificationId) async {
    List<String> readList = sharedPreferences.getStringList('read_notifications') ?? [];
    if (!readList.contains(notificationId)) {
      readList.add(notificationId);
      await sharedPreferences.setStringList('read_notifications', readList);
    }
  }
}

