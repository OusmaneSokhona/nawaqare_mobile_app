import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/payment_controller.dart';

class CardDateCvvWidget extends StatelessWidget {
  CardDateCvvWidget({super.key});

  PaymentController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final fieldHeight = 56.0;
    final borderRadius = BorderRadius.circular(12.0);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Expiration date',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8.0),
              InkWell(
                onTap: () => controller.selectDate(context),
                borderRadius: borderRadius,
                child: Container(
                  height: fieldHeight,
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: borderRadius,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    children: <Widget>[
                      // Calendar Icon (Blue)
                      const Icon(
                        Icons.calendar_today,
                        color: Colors.blue,
                        size: 20,
                      ),
                      const SizedBox(width: 10.0),
                      // Formatted Date Text wrapped in Obx
                      Obx(
                        () => Text(
                          controller.formattedDate, // Access reactive getter
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Cvv',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: controller.cvvController,
                keyboardType: TextInputType.number,
                maxLength: 4,
                obscureText: true,
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                onChanged: (value) => controller.cvv.value = value,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                  counterText: "",
                  filled: true,
                  fillColor: Colors.white,
                  hintText: '123',
                  border: OutlineInputBorder(
                    borderRadius: borderRadius,
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: borderRadius,
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: borderRadius,
                    borderSide: BorderSide(
                      color: Colors.blue.shade200,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
