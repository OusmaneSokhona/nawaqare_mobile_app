import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/patient_controllers/appointment_controllers/book_appointment_controller.dart';
import 'package:patient_app/models/card_model.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:intl/intl.dart';
class PaymentController extends GetxController{
  RxString selectedPayment="".obs;
  BookAppointmentController bookAppointmentController=Get.put(BookAppointmentController());
  List<String> payments=["Credit/Debit Card","Paypal","Orange Money","Wave","Cash"];
  List<String> paymentIcons=["assets/images/logos_mastercard.png","assets/images/logos_paypal.png","assets/images/orange_money.png","assets/images/wave_icon.png","assets/images/cash_icon.png"];
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