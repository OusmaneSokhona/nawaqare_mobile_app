import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_app/models/service_model.dart';
import 'package:patient_app/services/api_service.dart';
import 'package:patient_app/utils/api_urls.dart';

class ServiceController extends GetxController {
  final ApiService _apiService = ApiService();
  final RxList<ServiceModel> services = <ServiceModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isError = false.obs;
  final RxString errorMessage = ''.obs;
  final RxList<ServiceModel> filteredServices = <ServiceModel>[].obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchServices();
  }

  Future<void> fetchServices() async {
    try {
      isLoading.value = true;
      isError.value = false;

      final response = await _apiService.get(ApiUrls.getAllServices);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;

        if (responseData['message'] == 'Services fetched successfully' &&
            responseData['services'] != null) {

          final List<dynamic> servicesList = responseData['services'];
          services.value = servicesList
              .map((json) => ServiceModel.fromJson(json))
              .toList();

          filterServices(searchQuery.value);
        }
      } else {
        isError.value = true;
        errorMessage.value = 'Failed to load services';
      }
    } catch (e) {
      isError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void filterServices(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredServices.value = services;
    } else {
      filteredServices.value = services.where((service) =>
      service.serviceName.toLowerCase().contains(query.toLowerCase()) ||
          service.description.toLowerCase().contains(query.toLowerCase()) ||
          service.status.toLowerCase().contains(query.toLowerCase())||
          service.fee.toLowerCase().contains(query.toLowerCase())||
          service.duration.toLowerCase().contains(query.toLowerCase())||
          service.mode.toLowerCase().contains(query.toLowerCase())
      ).toList();
    }
  }

  int get activeServicesCount => services.where((s) => s.isActive).length;

  int get inactiveServicesCount => services.where((s) => !s.isActive).length;

  int get totalServicesCount => services.length;

  Future<bool> deActiveServiceStatus(String serviceId) async {
    try {
      isLoading.value = true;

      final response = await _apiService.patch(
        '${ApiUrls.updateServiceStatus}/$serviceId',
        data: {
          "status": "inactive"
        },
      );

      if (response.statusCode == 200) {
        final index = services.indexWhere((s) => s.id == serviceId);
        if (index != -1) {
          final currentService = services[index];
          final updatedService = ServiceModel.fromJson({
            ...currentService.toJson(),
            'status': 'inactive',
          });
          services[index] = updatedService;
          filterServices(searchQuery.value);
        }

        Get.snackbar(
          'Success',
          'Service deactivated successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );

        return true;
      } else {
        errorMessage.value = 'Failed to update service status: ${response.statusCode}';
        return false;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      print('Error updating service status: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
  Future<bool> createService(Map<String, dynamic> serviceData) async {
    try {
      isLoading.value = true;
      isError.value = false;

      final response = await _apiService.post(
        ApiUrls.createService,
        data: serviceData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchServices();
        return true;
      } else {
        isError.value = true;
        errorMessage.value = 'Failed to create service';
        return false;
      }
    } catch (e) {
      isError.value = true;
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }
  Future<bool> updateService(String serviceId, Map<String, dynamic> serviceData) async {
    try {
      isLoading.value = true;
      isError.value = false;

      final response = await _apiService.put(
        '${ApiUrls.updateService}$serviceId',
        data: serviceData,
      );

      if (response.statusCode == 200) {
        await fetchServices();
        return true;
      } else {
        isError.value = true;
        errorMessage.value = 'Failed to update service';
        return false;
      }
    } catch (e) {
      isError.value = true;
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }
  Future<bool> deleteService(String serviceId) async {
    try {
      final response = await _apiService.delete('api/service/delete/$serviceId');

      if (response.statusCode == 200) {
        services.removeWhere((s) => s.id == serviceId);
        filterServices(searchQuery.value);
        return true;
      }
      return false;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    }
  }

  Future<void> refreshServices() async {
    await fetchServices();
  }
}