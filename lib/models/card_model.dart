class CardModel {
  String id;
  String cardHolderName;
  String cardNumber;
  String expiryDate;
  String cvv;
  String cardBrand;
  bool isDefault;

  CardModel({
    required this.id,
    required this.cardHolderName,
    required this.cardNumber,
    required this.expiryDate,
    required this.cvv,
    required this.cardBrand,
    this.isDefault = false,
  });

  String get maskedCardNumber {
    String clean = cardNumber.replaceAll(' ', '');
    if (clean.length <= 4) return cardNumber;
    String last4 = clean.substring(clean.length - 4);
    return '**** **** **** $last4';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cardHolderName': cardHolderName,
      'cardNumber': cardNumber,
      'expiryDate': expiryDate,
      'cvv': cvv,
      'cardBrand': cardBrand,
      'isDefault': isDefault,
    };
  }

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      id: json['id'],
      cardHolderName: json['cardHolderName'],
      cardNumber: json['cardNumber'],
      expiryDate: json['expiryDate'],
      cvv: json['cvv'],
      cardBrand: json['cardBrand'],
      isDefault: json['isDefault'] ?? false,
    );
  }
}