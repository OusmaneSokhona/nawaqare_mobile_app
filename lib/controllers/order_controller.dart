import 'package:get/get.dart';

import '../models/orders_model.dart';

class OrderController extends GetxController{
  RxString orderType="ongoingOrders".obs;
  RxString searchQuery = ''.obs;

  List<Order> demoOrders = [
    Order(
      orderId: '12456',
      date: 'Sep 30, 2025',
      items: '2 items – Amoxicillin, Paracetamol',
      deliveryType: 'Home Delivery',
      status: 'In Progress',
      lastUpdate: 'Today, 5:30 PM',
      cost: '\$158',
    ),
    Order(
      orderId: '12457',
      date: 'Sep 30, 2025',
      items: '2 items – Amoxicillin, Paracetamol',
      deliveryType: 'Home Delivery',
      status: 'Out For Delivered',
      lastUpdate: 'Today, 5:30 PM',
      cost: '\$158',
    ),
    Order(
      orderId: '12458',
      date: 'Sep 30, 2025',
      items: '2 items – Amoxicillin, Paracetamol',
      deliveryType: 'Home Delivery',
      status: 'Awaiting Confirmation',
      lastUpdate: 'Today, 5:30 PM',
      cost: '\$158',
    ),
    Order(
      orderId: '12459',
      date: 'Sep 30, 2025',
      items: '2 items – Amoxicillin, Paracetamol',
      deliveryType: 'Home Delivery',
      status: 'Out For Delivered',
      lastUpdate: 'Today, 5:30 PM',
      cost: '\$158',
    ),
  ];
  List<Order> demoOrdersHistory = [
    Order(
      orderId: '12460',
      date: 'Sep 30, 2025',
      items: '2 items – Amoxicillin, Paracetamol',
      deliveryType: 'Home Delivery',
      status: 'Delivered',
      lastUpdate: 'Today, 5:30 PM',
      cost: '\$158',
    ),
    Order(
      orderId: '12461',
      date: 'Sep 30, 2025',
      items: '2 items – Amoxicillin, Paracetamol',
      deliveryType: 'Home Delivery',
      status: 'Cancelled',
      lastUpdate: 'Today, 5:30 PM',
      cost: '\$158',
    ),
    Order(
      orderId: '12462',
      date: 'Sep 30, 2025',
      items: '2 items – Amoxicillin, Paracetamol',
      deliveryType: 'Home Delivery',
      status: 'Delivered',
      lastUpdate: 'Today, 5:30 PM',
      cost: '\$158',
    ),
    Order(
      orderId: '12463',
      date: 'Sep 30, 2025',
      items: '2 items – Amoxicillin, Paracetamol',
      deliveryType: 'Home Delivery',
      status: 'Cancelled',
      lastUpdate: 'Today, 5:30 PM',
      cost: '\$158',
    ),
  ];

  List<Order> get currentOrderList =>
      orderType.value == "ongoingOrders" ? demoOrders : demoOrdersHistory;

  List<Order> get filteredOrders {
    if (searchQuery.value.isEmpty) {
      return currentOrderList;
    }

    final query = searchQuery.value.toLowerCase();

    return currentOrderList.where((order) {
      return order.orderId.toLowerCase().contains(query) ||
          order.status.toLowerCase().contains(query) ||
          order.items.toLowerCase().contains(query);
    }).toList();
  }
}