class DeliveryOption {
  final String name;
  final double price;
  final bool isFree;

  DeliveryOption({required this.name, required this.price})
      : isFree = price == 0.0;

  String get priceText => isFree ? 'Free' : '\$${price.toStringAsFixed(2)}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is DeliveryOption &&
              runtimeType == other.runtimeType &&
              name == other.name;

  @override
  int get hashCode => name.hashCode;
}