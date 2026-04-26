import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/patient_controllers/appointment_controllers/book_appointment_controller.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:patient_app/services/api_service.dart';
import 'package:patient_app/utils/api_urls.dart';

class PaymentController extends GetxController {
  BookAppointmentController bookAppointmentController = Get.find<BookAppointmentController>();

  RxBool isLoadingPaymentIntent = false.obs;
  RxBool isProcessingPayment = false.obs;
  RxString paymentError = "".obs;
  RxString paymentIntentError = "".obs;
  RxString selectedPaymentMethod = "".obs;

  RxMap<String, dynamic> paymentIntentData = RxMap<String, dynamic>();
  RxString clientSecret = "".obs;
  RxList<Map<String, dynamic>> availablePaymentMethods = <Map<String, dynamic>>[].obs;

  final int paymentAmount = 5000;
  final String paymentCurrency = 'usd';

  final String stripePublishableKey = 'pk_test_51SuZPRLJmcY8uAQzqHTJTLKAUSKxTnMYMTcqVY2TypaZ8ikuOjnftgdrDcLs2tnoPiOt9VliWSltD0wFDl3Uh4g000bhBK6DDn';

  @override
  void onInit() {
    super.onInit();
    initStripe();
    createPaymentIntent();
  }

  Future<void> initStripe() async {
    try {
      Stripe.publishableKey = stripePublishableKey;
      await Stripe.instance.applySettings();
    } catch (e) {
      paymentError.value = "Failed to initialize payment system";
    }
  }

  Future<void> createPaymentIntent() async {
    try {
      isLoadingPaymentIntent.value = true;
      paymentIntentError.value = "";

      ApiService apiService = ApiService();

      final response = await apiService.post(
        ApiUrls.paymentIntent,
        data: {
          'appointmentId': bookAppointmentController.appointmentId.value,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        paymentIntentData.value = response.data;

        if (paymentIntentData.containsKey('clientSecret')) {
          clientSecret.value = paymentIntentData['clientSecret'] as String;
        } else if (paymentIntentData.containsKey('client_secret')) {
          clientSecret.value = paymentIntentData['client_secret'] as String;
        }

        // Parse payment methods from the response
        if (paymentIntentData.containsKey('paymentMethodTypes')) {
          final List<dynamic> methods = paymentIntentData['paymentMethodTypes'];
          availablePaymentMethods.value = methods.map((method) {
            return {
              'id': method.toString(),
              'type': method.toString(),
              'isAvailable': true,
            };
          }).toList();
        } else {
          // Default payment methods if not provided by backend
          availablePaymentMethods.value = [
            {'id': 'card', 'type': 'card', 'isAvailable': true},
          ];
        }
      } else {
        paymentIntentError.value = "Failed to create payment intent";
      }
    } catch (e) {
      paymentIntentError.value = "Error creating payment: $e";
    } finally {
      isLoadingPaymentIntent.value = false;
    }
  }

  void selectPaymentMethod(String methodId) {
    selectedPaymentMethod.value = methodId;
  }

  Future<bool> processPayment() async {
    try {
      isProcessingPayment.value = true;
      paymentError.value = "";

      if (clientSecret.value.isEmpty) {
        paymentError.value = "Payment not initialized properly";
        return false;
      }

      PaymentSheetGooglePay? googlePay;
      PaymentSheetApplePay? applePay;

      if (selectedPaymentMethod.value == 'google_pay') {
        googlePay = const PaymentSheetGooglePay(
          merchantCountryCode: 'US',
          currencyCode: 'usd',
          testEnv: true,
        );
      } else if (selectedPaymentMethod.value == 'apple_pay') {
        applePay = const PaymentSheetApplePay(
          merchantCountryCode: 'US',
        );
      }

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret.value,
          merchantDisplayName: 'Healthcare App',
          allowsDelayedPaymentMethods: true,
          style: ThemeMode.light,
          returnURL: 'yourapp://stripe-redirect',
          googlePay: googlePay,
          applePay: applePay,
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      Get.snackbar(
        'Success',
        'Payment completed successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );

      return true;

    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) {
        paymentError.value = "Payment was cancelled";
      } else {
        paymentError.value = e.error.localizedMessage ?? "Payment failed";
      }

      Get.snackbar(
        'Payment Failed',
        paymentError.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;

    } catch (e) {
      paymentError.value = e.toString();
      Get.snackbar(
        'Error',
        paymentError.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;

    } finally {
      isProcessingPayment.value = false;
    }
  }

  void resetPaymentState() {
    isProcessingPayment.value = false;
    paymentError.value = "";
    paymentIntentError.value = "";
    selectedPaymentMethod.value = "";
    clientSecret.value = "";
    availablePaymentMethods.clear();
  }
}