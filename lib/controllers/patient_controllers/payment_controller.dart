import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_app/models/card_model.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:intl/intl.dart';
class PaymentController extends GetxController{
  RxBool isCardSelected=false.obs;
  RxBool isPayPalSelected=false.obs;
  final List<CreditCardModel> cards=[
    CreditCardModel(
      cardNumber: '5282 3456 7890',
      cardHolderName: 'Roronoa Zoro',
      expiryDate: '09/25',
      cardType: "Visa",
      cardColor:   AppColors.primaryColor, // Main Blue Color
      cardNickname: 'Blue Savings',
    ),
    CreditCardModel(
      cardNumber: '4123 0001 3445',
      cardHolderName: 'Nami San',
      expiryDate: '12/28',
      cardType: "MasterCard",
      cardColor:  AppColors.green, // Green Color
      cardNickname: 'Travel Visa',
    ),
    CreditCardModel(
      cardNumber: '3782 9876 5432',
      cardHolderName: 'Monkey D. Luffy',
      expiryDate: '05/26',
      cardType: "Debit Card",
      cardColor: AppColors.orange, // Orange Color
      cardNickname: 'Reward Card',
    ),
  ];
  final selectedDate = DateTime(DateTime.now().year + 2, 1).obs;
  TextEditingController cvvController=TextEditingController();
  final cvv = '1234'.obs;
  String get formattedDate {
    return DateFormat('dd/MMM/yyyy').format(selectedDate.value);
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 10),

      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate.value) {
      // Update the Rx variable. GetX automatically rebuilds Obx widgets listening to it.
      selectedDate.value = picked;
      // In a real application, you might only save the month and year here.
    }
  }
}