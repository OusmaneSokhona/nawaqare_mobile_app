import 'package:get/get.dart';

import '../models/notification_model.dart';
class NotificationController extends GetxController{
  final List<NotificationGroup> mockData = [
    NotificationGroup('Today', [
      const NotificationItem(
        'Appointment Success',
        'You have successfully booked your appointment with Dr. Emily Walker.',
        '1h',
        NotificationType.success,
      ),
      const NotificationItem(
        'Appointment Cancelled',
        'You have successfully cancelled your appointment with Dr. David Patel.',
        '8h',
        NotificationType.cancelled,
      ),
      const NotificationItem(
        'Scheduled Changed',
        'You have successfully changes your appointment with Dr. Jesica Turner.',
        '13h',
        NotificationType.changed,
      ),
    ]),
    NotificationGroup('Yesterday', [
      const NotificationItem(
        'Appointment Success',
        'You have successfully booked your appointment with Dr. Emily Walker.',
        '2d',
        NotificationType.success,
      ),
      const NotificationItem(
        'Appointment Success',
        'You have successfully booked your appointment with Dr. Emily Walker.',
        '2d',
        NotificationType.success,
      ),
    ]),
  ];
}
