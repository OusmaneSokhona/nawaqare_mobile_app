import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/api_service.dart';
import '../../../utils/api_urls.dart';

class ServicePricingController extends GetxController {
  final ApiService _apiService = ApiService();

  final remoteFeeController = TextEditingController();
  final inPersonFeeController = TextEditingController();
  final homeVisitFeeController = TextEditingController();
  final currencyController = TextEditingController();

  RxBool isLoading = false.obs;
  RxString selectedCurrency = 'USD'.obs;

  final List<String> currencyList = [
    'USD', 'EUR', 'GBP', 'PKR', 'INR', 'CAD', 'AUD', 'AED', 'SAR'
  ];


  void updateSelectedCurrency(String? value) {
    if (value != null) {
      selectedCurrency.value = value;
      currencyController.text = value;
    }
  }


  Future<bool> updateFees() async {
    try {
      isLoading.value = true;

      final Map<String, dynamic> feeData = {
        "remoteFee": int.tryParse(remoteFeeController.text.trim()) ?? 0,
        "inPersonFee": int.tryParse(inPersonFeeController.text.trim()) ?? 0,
        "homeVisitFee": int.tryParse(homeVisitFeeController.text.trim()) ?? 0,
        "currency": selectedCurrency.value,
      };

      final response = await _apiService.post(ApiUrls.servicePricing, data: feeData);
      isLoading.value = false;

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back();
        Get.snackbar(
          "Success",
          "Fees updated successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return true;
      }
      return false;
    } catch (e) {
      print('Error updating fees: $e');
      isLoading.value = false;
      _handleError(e);
      return false;
    }
  }

  void _handleError(dynamic e) {
    String errorMessage = "An unexpected error occurred";
    if (e is DioException) {
      if (e.response != null && e.response!.data != null) {
        if (e.response!.data is Map) {
          errorMessage = e.response!.data["message"] ?? "Server Error";
        } else {
          errorMessage = e.response!.data.toString();
        }
      } else {
        errorMessage = "No response from server";
      }
    } else {
      errorMessage = e.toString();
    }
    Get.snackbar(
      "Error",
      errorMessage,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  @override
  void onClose() {
    remoteFeeController.dispose();
    inPersonFeeController.dispose();
    homeVisitFeeController.dispose();
    currencyController.dispose();
    super.onClose();
  }
}