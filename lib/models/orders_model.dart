class Order {
  final String orderId;
  final String date;
  final String items;
  final String deliveryType;
  final String status;
  final String lastUpdate;
  final String cost;

  Order({
    required this.orderId,
    required this.date,
    required this.items,
    required this.deliveryType,
    required this.status,
    required this.lastUpdate,
    required this.cost,
  });
}