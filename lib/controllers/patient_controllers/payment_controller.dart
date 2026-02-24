import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/patient_controllers/appointment_controllers/book_appointment_controller.dart';
import 'package:intl/intl.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:patient_app/models/card_model.dart';
import 'package:dio/dio.dart' as dio_instance;

class PaymentController extends GetxController {
  RxString selectedPayment = "".obs;
  BookAppointmentController bookAppointmentController = Get.put(BookAppointmentController());

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

  RxBool isProcessingPayment = false.obs;
  RxBool isLoadingSavedCards = false.obs;
  RxString paymentError = "".obs;

  final paymentAmount = 5000;
  final paymentCurrency = 'usd';

  final String stripePublishableKey = 'pk_test_TYooMQauvdEDq54NiTphI7jx';
  // NEVER use secret key here in production - only for temporary local testing
  // Move ALL secret-key operations to your backend!
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
    if (savedCards.isEmpty) {
      CardModel demoCard = CardModel(id: 'demo', cardHolderName: 'Test User', cardNumber: '4242 4242 4242 4242', expiryDate: '12/34', cvv: '123', cardBrand: '');
      demoCard.id = 'demo';
      demoCard.cardHolderName = 'Test User';
      demoCard.cardNumber = '4242 4242 4242 4242';
      demoCard.expiryDate = '12/34';
      demoCard.cvv = '123';
      demoCard.isDefault = true;
      savedCards.add(demoCard);
      selectedCard.value = demoCard;
      selectedPayment.value = "Credit/Debit Card";
    }
  }

  Future<void> initStripe() async {
    try {
      Stripe.publishableKey = stripePublishableKey;
      await Stripe.instance.applySettings();
    } catch (e) {
      debugPrint('Error: $e');
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

    if (holderName.trim().isEmpty) {
      paymentError.value = "Card holder name is required";
      return false;
    }

    paymentError.value = "";
    return true;
  }

  String detectCardBrand(String cardNumber) {
    String cleanNumber = cardNumber.replaceAll(' ', '');
    if (cleanNumber.startsWith('4')) return 'Visa';
    if (cleanNumber.startsWith('5')) return 'Mastercard';
    if (cleanNumber.startsWith('34') || cleanNumber.startsWith('37')) return 'American Express';
    return 'Card';
  }

  void formatCardNumber(String value) {
    String formatted = value.replaceAll(' ', '');
    StringBuffer buffer = StringBuffer();
    for (int i = 0; i < formatted.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
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

  Future<Map<String, dynamic>> createPaymentIntentOnBackend(String paymentMethodId) async {
    try {
      dio_instance.Dio dio = dio_instance.Dio();
      final response = await dio.post(
        'https://api.stripe.com/v1/payment_intents',
        options: dio_instance.Options(
          headers: {
            'Authorization': 'Bearer $stripeSecretKey',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
        data: {
          'amount': (paymentAmount * 100).toString(),
          'currency': paymentCurrency,
          'payment_method': paymentMethodId,
          'confirmation_method': 'manual',
          'capture_method': 'automatic',
        },
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Backend failed: ${response.statusCode} - ${response.data}');
      }
    } catch (e) {
      throw Exception('Failed to create PaymentIntent: $e');
    }
  }

  Future<bool> processCardPayment() async {
    try {
      isProcessingPayment.value = true;
      paymentError.value = "";

      if (selectedCard.value == null) {
        paymentError.value = "No card selected";
        return false;
      }

      final card = selectedCard.value!;
      final cleanNumber = card.cardNumber.replaceAll(RegExp(r'\s+'), '');

      final expiryParts = card.expiryDate.split('/');
      if (expiryParts.length != 2) {
        paymentError.value = "Invalid expiry format";
        return false;
      }

      final expMonth = int.tryParse(expiryParts[0].trim());
      final expYearRaw = expiryParts[1].trim();
      final expYear = int.tryParse(expYearRaw.length == 2 ? '20$expYearRaw' : expYearRaw);

      if (expMonth == null || expMonth < 1 || expMonth > 12 || expYear == null) {
        paymentError.value = "Invalid expiry date";
        return false;
      }

      await Stripe.instance.dangerouslyUpdateCardDetails(
        CardDetails(
          number: cleanNumber,
          cvc: card.cvv.trim(),
          expirationMonth: expMonth,
          expirationYear: expYear,
        ),
      );

      await Future.delayed(const Duration(milliseconds: 100));

      final paymentMethod = await Stripe.instance.createPaymentMethod(
        params: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails: BillingDetails(name: card.cardHolderName.trim()),
          ),
        ),
      );

      debugPrint('PaymentMethod created: ${paymentMethod.id}');

      final paymentIntentData = await createPaymentIntentOnBackend(paymentMethod.id);

      final clientSecret = paymentIntentData['client_secret'] as String?;
      if (clientSecret == null || clientSecret.isEmpty) {
        paymentError.value = "No client secret received";
        return false;
      }

      final confirmationResult = await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: clientSecret,
        data:  PaymentMethodParams.affirm(paymentMethodData: PaymentMethodData()),
      );

      if (confirmationResult.status == PaymentIntentsStatus.Succeeded) {
        Get.snackbar('Success', 'Payment completed', backgroundColor: Colors.green, colorText: Colors.white);
        return true;
      } else {
        paymentError.value = "Confirmation failed: ${confirmationResult.status}";
        return false;
      }
    } on StripeException catch (e) {
      paymentError.value = e.error.localizedMessage ?? e.toString();
      Get.snackbar('Payment Error', paymentError.value, backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    } catch (e) {
      paymentError.value = e.toString();
      Get.snackbar('Error', paymentError.value, backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    } finally {
      isProcessingPayment.value = false;
    }
  }

  Future<bool> processPaypalPayment() async {
    isProcessingPayment.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isProcessingPayment.value = false;
    return true;
  }

  Future<bool> processOrangeMoneyPayment() async {
    isProcessingPayment.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isProcessingPayment.value = false;
    return true;
  }

  Future<bool> processWavePayment() async {
    isProcessingPayment.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isProcessingPayment.value = false;
    return true;
  }

  Future<bool> processPayment() async {
    if (selectedPayment.value.isEmpty) {
      Get.snackbar('Error', 'Please select a payment method', backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }

    if (selectedPayment.value == "Credit/Debit Card") {
      if (savedCards.isEmpty || selectedCard.value == null) {
        Get.snackbar('Error', 'Please select a valid card', backgroundColor: Colors.red, colorText: Colors.white);
        return false;
      }
      return await processCardPayment();
    }

    switch (selectedPayment.value) {
      case "Paypal": return await processPaypalPayment();
      case "Orange Money": return await processOrangeMoneyPayment();
      case "Wave": return await processWavePayment();
      case "Cash":
        if (bookAppointmentController.appointmentType.value != "homeVisit") {
          Get.snackbar('Error', 'Cash only for home visits', backgroundColor: Colors.red, colorText: Colors.white);
          return false;
        }
        return true;
      default: return false;
    }
  }

  void resetPaymentState() {
    isProcessingPayment.value = false;
    paymentError.value = "";
    selectedPayment.value = "";
    if (savedCards.isNotEmpty) {
      selectedCard.value = savedCards.firstWhere((c) => c.isDefault, orElse: () => savedCards.first);
    }
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