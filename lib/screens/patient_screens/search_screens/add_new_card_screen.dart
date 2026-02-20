import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/patient_controllers/payment_controller.dart';
import 'package:patient_app/models/card_model.dart';
import 'package:patient_app/widgets/custom_text_field.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';
import '../../../utils/app_strings.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/patient_widgets/search_widgets/card_date_cvv_widget.dart';

class AddNewCardScreen extends StatelessWidget {
  AddNewCardScreen({super.key});

  final PaymentController paymentController = Get.find<PaymentController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 1.sh,
        width: 1.sw,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.onboardingBackground, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              70.verticalSpace,
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Image.asset(
                      AppImages.backIcon,
                      height: 33.h,
                      fit: BoxFit.fill,
                    ),
                  ),
                  10.horizontalSpace,
                  Text(
                    AppStrings.addNewCard.tr,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 23.sp,
                      fontWeight: FontWeight.w800,
                      fontFamily: AppFonts.jakartaBold,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        30.verticalSpace,
                        CustomTextField(
                          controller: paymentController.cardHolderNameController,
                          labelText: AppStrings.cardHolderName.tr,
                          prefixIcon: Icons.person_outline_outlined,
                          hintText: AppStrings.enterName.tr,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Card holder name is required';
                            }
                            return null;
                          },
                        ),
                        10.verticalSpace,
                        CustomTextField(
                          controller: paymentController.cardNumberController,
                          labelText: AppStrings.cardNumber.tr,
                          prefixIcon: Icons.credit_card_outlined,
                          hintText: "XXXX-XXXX-XXXX",
                          keyboardType: TextInputType.number,
                          maxLength: 19,
                          onChanged: (value) {
                            paymentController.formatCardNumber(value);
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Card number is required';
                            }
                            String cleanNumber = value.replaceAll(' ', '');
                            if (cleanNumber.length < 15 || cleanNumber.length > 16) {
                              return 'Invalid card number';
                            }
                            return null;
                          },
                        ),
                        10.verticalSpace,
                        CardDateCvvWidget(),
                        20.verticalSpace,
                        Row(
                          children: [
                            Obx(() => Checkbox(
                              value: paymentController.savedCards.isEmpty ? true : false,
                              onChanged: (value) {},
                              activeColor: AppColors.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                            )),
                            Expanded(
                              child: Text(
                                'Set as default payment method',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontFamily: AppFonts.jakartaMedium,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                        10.verticalSpace,
                        Row(
                          children: [
                            Expanded(
                              child: CustomButton(
                                borderRadius: 15,
                                text: AppStrings.saveDetail.tr,
                                onTap: () async {
                                  if (_formKey.currentState!.validate()) {
                                    String cardNumber = paymentController.cardNumberController.text;
                                    String expiryDate = paymentController.formattedDate;
                                    String cvv = paymentController.cvvController.text;
                                    String holderName = paymentController.cardHolderNameController.text;

                                    CardModel newCard = CardModel(
                                      id: '',
                                      cardHolderName: holderName,
                                      cardNumber: cardNumber,
                                      expiryDate: expiryDate,
                                      cvv: cvv,
                                      cardBrand: paymentController.detectCardBrand(cardNumber),
                                      isDefault: paymentController.savedCards.isEmpty ? true : false,
                                    );

                                    bool success = await paymentController.addNewCard(newCard);

                                    if (success) {
                                      paymentController.cardHolderNameController.clear();
                                      paymentController.cardNumberController.clear();
                                      paymentController.cvvController.clear();
                                      Get.back();
                                    }
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        15.verticalSpace,
                        Row(
                          children: [
                            Expanded(
                              child: CustomButton(
                                borderRadius: 15,
                                text: AppStrings.cancel.tr,
                                bgColor: AppColors.inACtiveButtonColor,
                                fontColor: Colors.black,
                                onTap: () {
                                  paymentController.cardHolderNameController.clear();
                                  paymentController.cardNumberController.clear();
                                  paymentController.cvvController.clear();
                                  Get.back();
                                },
                              ),
                            ),
                          ],
                        ),
                        30.verticalSpace,
                        Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: AppColors.primaryColor.withOpacity(0.3),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Demo Card Details',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: AppFonts.jakartaBold,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              10.verticalSpace,
                              _buildDemoCardItem(
                                context,
                                'Visa',
                                '4242 4242 4242 4242',
                                '12/25',
                                '123',
                                'John Doe',
                              ),
                              Divider(height: 20.h),
                              _buildDemoCardItem(
                                context,
                                'Mastercard',
                                '5555 5555 5555 4444',
                                '10/24',
                                '321',
                                'Jane Smith',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDemoCardItem(
      BuildContext context,
      String brand,
      String number,
      String expiry,
      String cvv,
      String holder,
      ) {
    return InkWell(
      onTap: () {
        paymentController.cardNumberController.text = number;
        paymentController.cardHolderNameController.text = holder;
        paymentController.cvvController.text = cvv;

        List<String> expiryParts = expiry.split('/');
        int month = int.parse(expiryParts[0]);
        int year = int.parse('20${expiryParts[1]}');
        paymentController.selectedDate.value = DateTime(year, month);
        paymentController.expiryDateController.text = expiry;
      },
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: AppColors.lightGrey),
            ),
            child: Icon(
              brand == 'Visa' ? Icons.credit_card : Icons.credit_card,
              color: brand == 'Visa' ? Colors.blue : Colors.orange,
              size: 24.sp,
            ),
          ),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  brand,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: AppFonts.jakartaBold,
                  ),
                ),
                Text(
                  '**** **** **** ${number.substring(number.length - 4)}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                    fontFamily: AppFonts.jakartaMedium,
                  ),
                ),
              ],
            ),
          ),
          Text(
            'Tap to use',
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.primaryColor,
              fontFamily: AppFonts.jakartaMedium,
            ),
          ),
        ],
      ),
    );
  }
}