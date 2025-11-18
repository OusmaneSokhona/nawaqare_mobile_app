enum NotificationType { success, cancelled, changed }

class NotificationItem {
  final String title;
  final String subtitle;
  final String time;
  final NotificationType type;

  const NotificationItem(this.title, this.subtitle, this.time, this.type);
}

class NotificationGroup {
  final String day;
  final List<NotificationItem> items;

  const NotificationGroup(this.day, this.items);
}