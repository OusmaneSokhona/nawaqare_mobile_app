import 'package:flutter/cupertino.dart';
class CreditCardModel {
  final String cardNumber;
  final String cardHolderName;
  final String expiryDate; // Format 'MM/YY'
  final String cardType;
  final Color cardColor;
  final String? cardNickname;

  CreditCardModel({
    required this.cardNumber,
    required this.cardHolderName,
    required this.expiryDate,
    required this.cardType,
    required this.cardColor,
    this.cardNickname,
  });
}