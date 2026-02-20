import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/patient_controllers/appointment_controllers/book_appointment_controller.dart';
import 'package:intl/intl.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:patient_app/models/card_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PaymentController extends GetxController {
  RxString selectedPayment = "".obs;
  BookAppointmentController bookAppointmentController =
  Get.put(BookAppointmentController());

  List<String> payments = [
    "Credit/Debit Card",
    "Paypal",
    "Orange Money",
    "Wave",
    "Cash"
  ];

  List<String> paymentIcons = [
    "assets/images/logos_mastercard.png",
    "assets/images/logos_paypal.png",
    "assets/images/orange_money.png",
    "assets/images/wave_icon.png",
    "assets/images/cash_icon.png"
  ];

  RxList<CardModel> savedCards = <CardModel>[].obs;
  Rx<CardModel?> selectedCard = Rx<CardModel?>(null);

  TextEditingController cardHolderNameController = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController cvvController = TextEditingController();
  TextEditingController expiryDateController = TextEditingController();

  final selectedDate = DateTime(DateTime.now().year + 2, 1).obs;
  final cvv = '1234'.obs;

  RxBool isProcessingPayment = false.obs;
  RxString paymentError = "".obs;
  RxString paymentIntentId = "".obs;
  RxBool isLoadingSavedCards = false.obs;

  final paymentAmount = 5000;
  final paymentCurrency = 'usd';

  final String stripePublishableKey = 'pk_test_TYooMQauvdEDq54NiTphI7jx';
  final String stripeSecretKey = 'STRIPE_KEY_REMOVED';

  String get formattedDate {
    return DateFormat('MM/yy').format(selectedDate.value);
  }

  String get formattedDisplayDate {
    return DateFormat('dd/MMM/yyyy').format(selectedDate.value);
  }

  @override
  void onInit() {
    super.onInit();
    initStripe();
  }

  Future<void> initStripe() async {
    try {
      Stripe.publishableKey = stripePublishableKey;
      await Stripe.instance.applySettings();
    } catch (e) {
      debugPrint('Error initializing Stripe: $e');
    }
  }

  void selectCard(CardModel card) {
    selectedCard.value = card;
    selectedPayment.value = "Credit/Debit Card";
  }

  Future<bool> addNewCard(CardModel newCard) async {
    try {
      isLoadingSavedCards.value = true;

      newCard.id = DateTime.now().millisecondsSinceEpoch.toString();

      if (savedCards.isEmpty || newCard.isDefault) {
        for (var card in savedCards) {
          card.isDefault = false;
        }
        newCard.isDefault = true;
        selectedCard.value = newCard;
      }

      savedCards.add(newCard);

      Get.snackbar(
        'Success',
        'Card added successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      clearCardInputFields();

      return true;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add card: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoadingSavedCards.value = false;
    }
  }

  Future<bool> deleteCard(String cardId) async {
    try {
      isLoadingSavedCards.value = true;

      savedCards.removeWhere((card) => card.id == cardId);

      if (selectedCard.value?.id == cardId) {
        if (savedCards.isNotEmpty) {
          selectedCard.value = savedCards.first;
          selectedCard.value!.isDefault = true;
        } else {
          selectedCard.value = null;
          selectedPayment.value = "";
        }
      }

      Get.snackbar(
        'Success',
        'Card deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      return true;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete card: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoadingSavedCards.value = false;
    }
  }

  void setDefaultCard(String cardId) {
    for (var card in savedCards) {
      card.isDefault = card.id == cardId;
    }
    selectedCard.value = savedCards.firstWhere((card) => card.id == cardId);
    savedCards.refresh();

    Get.snackbar(
      'Success',
      'Default card updated',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 1),
    );
  }

  bool validateCardDetails({
    required String cardNumber,
    required String expiryDate,
    required String cvv,
    required String holderName,
  }) {
    String cleanCardNumber = cardNumber.replaceAll(' ', '');

    if (cleanCardNumber.isEmpty) {
      paymentError.value = "Card number is required";
      return false;
    }

    if (cleanCardNumber.length < 15 || cleanCardNumber.length > 16) {
      paymentError.value = "Invalid card number";
      return false;
    }

    if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(expiryDate)) {
      paymentError.value = "Invalid expiry date format (MM/YY)";
      return false;
    }

    List<String> expiryParts = expiryDate.split('/');
    int month = int.parse(expiryParts[0]);
    int year = int.parse('20${expiryParts[1]}');
    DateTime now = DateTime.now();

    if (month < 1 || month > 12) {
      paymentError.value = "Invalid expiry month";
      return false;
    }

    if (year < now.year || (year == now.year && month < now.month)) {
      paymentError.value = "Card has expired";
      return false;
    }

    if (cvv.isEmpty) {
      paymentError.value = "CVV is required";
      return false;
    }

    if (cvv.length < 3 || cvv.length > 4) {
      paymentError.value = "Invalid CVV";
      return false;
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(cvv)) {
      paymentError.value = "CVV must contain only numbers";
      return false;
    }

    if (holderName.trim().isEmpty) {
      paymentError.value = "Card holder name is required";
      return false;
    }

    paymentError.value = "";
    return true;
  }

  String detectCardBrand(String cardNumber) {
    String cleanNumber = cardNumber.replaceAll(' ', '');

    if (cleanNumber.startsWith('4')) {
      return 'Visa';
    } else if (cleanNumber.startsWith('5')) {
      return 'Mastercard';
    } else if (cleanNumber.startsWith('34') || cleanNumber.startsWith('37')) {
      return 'American Express';
    } else if (cleanNumber.startsWith('6')) {
      return 'Discover';
    } else if (cleanNumber.startsWith('2')) {
      return 'Mir';
    } else {
      return 'Card';
    }
  }

  void formatCardNumber(String value) {
    String formatted = value.replaceAll(' ', '');
    StringBuffer buffer = StringBuffer();

    for (int i = 0; i < formatted.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(formatted[i]);
    }

    cardNumberController.value = TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
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
            colorScheme: ColorScheme.light(
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
      selectedDate.value = picked;
      expiryDateController.text = DateFormat('MM/yy').format(picked);
    }
  }

  void clearCardInputFields() {
    cardHolderNameController.clear();
    cardNumberController.clear();
    cvvController.clear();
    expiryDateController.clear();
    selectedDate.value = DateTime(DateTime.now().year + 2, 1);
    paymentError.value = "";
  }

  Future<Map<String, dynamic>> createPaymentIntent(String paymentMethodId) async {
    try {
      final url = Uri.parse('https://api.stripe.com/v1/payment_intents');

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $stripeSecretKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'amount': (paymentAmount * 100).toString(),
          'currency': paymentCurrency,
          'payment_method': paymentMethodId,
          'confirmation_method': 'manual',
          'capture_method': 'automatic',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to create payment intent: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to create payment intent: $e');
    }
  }

  Future<PaymentMethod?> createStripePaymentMethod() async {
    try {
      if (selectedCard.value == null) return null;

      CardModel card = selectedCard.value!;
      String cleanCardNumber = card.cardNumber.replaceAll(' ', '');
      List<String> expiryParts = card.expiryDate.split('/');

      final params = PaymentMethodParams.card(
        paymentMethodData: PaymentMethodData(
        ),
      );

      PaymentMethod paymentMethod = await Stripe.instance.createPaymentMethod(
        params: params,
      );

      return paymentMethod;
    } catch (e) {
      paymentError.value = 'Failed to create payment method: $e';
      return null;
    }
  }

  Future<bool> processCardPayment() async {
    try {
      isProcessingPayment.value = true;
      paymentError.value = "";

      PaymentMethod? paymentMethod = await createStripePaymentMethod();
      if (paymentMethod == null) {
        isProcessingPayment.value = false;
        return false;
      }

      Map<String, dynamic> paymentIntent = await createPaymentIntent(paymentMethod.id);

      final result = await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: paymentIntent['client_secret'],
      );

      if (result.status == PaymentIntentsStatus.Succeeded) {
        Get.snackbar(
          'Success',
          'Payment completed successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        isProcessingPayment.value = false;
        return true;
      } else {
        paymentError.value = 'Payment failed: ${result.status}';
        isProcessingPayment.value = false;
        return false;
      }
    } catch (e) {
      isProcessingPayment.value = false;
      paymentError.value = e.toString();
      return false;
    }
  }

  Future<bool> processPaypalPayment() async {
    try {
      isProcessingPayment.value = true;
      paymentError.value = "";
      await Future.delayed(const Duration(seconds: 2));
      isProcessingPayment.value = false;
      Get.snackbar(
        'Success',
        'PayPal payment successful',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      return true;
    } catch (e) {
      isProcessingPayment.value = false;
      paymentError.value = e.toString();
      return false;
    }
  }

  Future<bool> processOrangeMoneyPayment() async {
    try {
      isProcessingPayment.value = true;
      paymentError.value = "";
      await Future.delayed(const Duration(seconds: 2));
      isProcessingPayment.value = false;
      Get.snackbar(
        'Success',
        'Orange Money payment successful',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      return true;
    } catch (e) {
      isProcessingPayment.value = false;
      paymentError.value = e.toString();
      return false;
    }
  }

  Future<bool> processWavePayment() async {
    try {
      isProcessingPayment.value = true;
      paymentError.value = "";
      await Future.delayed(const Duration(seconds: 2));
      isProcessingPayment.value = false;
      Get.snackbar(
        'Success',
        'Wave payment successful',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      return true;
    } catch (e) {
      isProcessingPayment.value = false;
      paymentError.value = e.toString();
      return false;
    }
  }

  Future<bool> processPayment() async {
    if (selectedPayment.value.isEmpty) {
      paymentError.value = "Please select a payment method";
      Get.snackbar(
        'Error',
        'Please select a payment method',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (selectedPayment.value == "Credit/Debit Card" && savedCards.isEmpty) {
      paymentError.value = "Please add a card first";
      Get.snackbar(
        'Error',
        'No cards found. Please add a card.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (selectedPayment.value == "Credit/Debit Card" && selectedCard.value == null) {
      paymentError.value = "Please select a card";
      Get.snackbar(
        'Error',
        'Please select a card',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    switch (selectedPayment.value) {
      case "Credit/Debit Card":
        return await processCardPayment();
      case "Paypal":
        return await processPaypalPayment();
      case "Orange Money":
        return await processOrangeMoneyPayment();
      case "Wave":
        return await processWavePayment();
      case "Cash":
        if (bookAppointmentController.appointmentType.value != "homeVisit") {
          Get.snackbar(
            'Error',
            'Cash payment is only available for home visits',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return false;
        }
        Get.snackbar(
          'Success',
          'Booking confirmed with Cash payment',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return true;
      default:
        return false;
    }
  }

  void resetPaymentState() {
    isProcessingPayment.value = false;
    paymentError.value = "";
    paymentIntentId.value = "";
    selectedPayment.value = "";
    selectedCard.value = savedCards.isNotEmpty ? savedCards.firstWhere(
          (card) => card.isDefault,
      orElse: () => savedCards.first,
    ) : null;
    clearCardInputFields();
  }

  void clearAllData() {
    savedCards.clear();
    selectedCard.value = null;
    resetPaymentState();
  }

  @override
  void onClose() {
    cvvController.dispose();
    cardHolderNameController.dispose();
    cardNumberController.dispose();
    expiryDateController.dispose();
    super.onClose();
  }
}