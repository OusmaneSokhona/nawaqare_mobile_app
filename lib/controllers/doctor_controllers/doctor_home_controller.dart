import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_app/models/doctor_model.dart';
import 'package:patient_app/services/api_service.dart';
import 'package:patient_app/utils/api_urls.dart';
import 'package:patient_app/utils/locat_storage.dart';
import 'package:patient_app/utils/app_strings.dart';

import '../../models/appointment_model.dart';
import '../../models/doctor_appointment_model.dart';

class DoctorHomeController extends GetxController {
  ScrollController scrollController = ScrollController();
  RxDouble scrollValue = 0.0.obs;
  ApiService _apiService = ApiService();
  Rx<DoctorModel?> currentUser = Rx<DoctorModel?>(null);
  RxBool isLoading = true.obs;
  RxList<DoctorAppointment> allAppointments = <DoctorAppointment>[].obs;
  Rx<DoctorAppointmentResponse?> appointmentResponse = Rx<DoctorAppointmentResponse?>(null);
  Rx<DoctorAppointment?> ongoingAppointment = Rx<DoctorAppointment?>(null);
  Rx<DoctorAppointment?> upcomingAppointment = Rx<DoctorAppointment?>(null);

  Future<void> fetchAppointments() async {
    try {
      ongoingAppointment.value = null;
      upcomingAppointment.value = null;

      final response = await _apiService.get(ApiUrls.getAppointments);


      if (response.statusCode == 200) {

        final jsonResponse = response.data is String
            ? json.decode(response.data)
            : response.data;

        appointmentResponse.value = DoctorAppointmentResponse.fromJson(jsonResponse);
        final List<DoctorAppointment> appointments = appointmentResponse.value?.appointments ?? [];
        allAppointments.value = appointments;



        if (appointments.isNotEmpty) {
          final now = DateTime.now();

          // First check for ongoing appointments
          for (var appointment in appointments) {
            try {


              // Check if appointment is ongoing
              if (appointment.status == "ongoing" ||
                  appointment.status == "confirmed") {

                final startTime = appointment.timeslot?.startTime;
                final endTime = appointment.timeslot?.endTime;

                print("Comparing: $now is after $startTime = ${now.isAfter(startTime!)}");
                print("Comparing: $now is before $endTime = ${now.isBefore(endTime!)}");

                if (now.isAfter(startTime) && now.isBefore(endTime)) {
                  ongoingAppointment.value = appointment;
                  break;
                }
              }
            } catch (e) {
              print("Error processing appointment: $e");
            }
          }

          // If no ongoing appointment, find the next upcoming appointment
          if (ongoingAppointment.value == null) {
            print("\nLooking for upcoming appointments...");
            List<DoctorAppointment> futureAppointments = [];

            for (var appointment in appointments) {
              try {
                final startTime = appointment.timeslot?.startTime;
                final isActive = appointment.status == AppointmentStatus.confirmed ||
                    appointment.status == "pending" ||
                    appointment.status == "upcoming";

                print("Appointment ${appointment.id}: start=$startTime, status=${appointment.status}, isActive=$isActive");

                if (isActive && startTime!.isAfter(now)) {
                  futureAppointments.add(appointment);
                  print("Added as future appointment");
                }
              } catch (e) {
                print("Error checking future appointment: $e");
              }
            }

            if (futureAppointments.isNotEmpty) {
              futureAppointments.sort((a, b) =>
                  a.timeslot!.startTime.compareTo(b.timeslot!.startTime));

              print("\nSorted future appointments:");
              for (var app in futureAppointments) {
                print("${app.id} - ${app.timeslot?.startTime}");
              }

              upcomingAppointment.value = futureAppointments.first;
              print("Selected upcoming appointment: ${upcomingAppointment.value?.id}");
            }
          }

          print("\nFinal results:");
          print("Ongoing appointment: ${ongoingAppointment.value?.id}");
          print("Upcoming appointment: ${upcomingAppointment.value?.id}");
        } else {
          print("No appointments found");
        }
      } else {
        print("Failed with status code: ${response.statusCode}");
        Get.snackbar(
            AppStrings.warning.tr,
            'Failed to fetch appointments: ${response.statusCode}',
            backgroundColor: Colors.red,
            colorText: Colors.white
        );
      }
    } catch (e) {
      print('Error fetching appointments: ${e.toString()}');
      print('Error type: ${e.runtimeType}');
      Get.snackbar(
          AppStrings.warning.tr,
          'Failed to load appointments',
          backgroundColor: Colors.red,
          colorText: Colors.white
      );
    } finally {
    }
  }

  Future<void> loadUserData() async {
    isLoading.value = true;
    try {
      final userFromStorage = LocalStorageUtils.getUser();
      if (userFromStorage != null) {
        try {
          currentUser.value = DoctorModel.fromJson(userFromStorage);
          print('Loaded doctor from storage: ${currentUser.value?.fullName}');
        } catch (e) {
          print('Error loading doctor from storage: $e');
        }
      }

      final response = await _apiService.get(ApiUrls.meUrl);
      if (response.statusCode == 200) {
        print('API Doctor data response received');

        if (response.data is Map<String, dynamic>) {
          final Map<String, dynamic> responseData = response.data as Map<String, dynamic>;

          if (responseData.containsKey('data') && responseData['data'] != null) {
            final userData = responseData['data'] as Map<String, dynamic>;
            final Map<String, dynamic> processedData = {};

            processedData.addAll(userData);
            processedData['role'] = 'doctor';

            if (userData.containsKey('userId')) {
              final userIdData = userData['userId'];
              if (userIdData is Map<String, dynamic>) {
                processedData['email'] = userIdData['email']?.toString() ?? processedData['email'];
                processedData['phoneNumber'] = userIdData['phoneNumber']?.toString() ?? processedData['phoneNumber'];
              }
            }

            if (!processedData.containsKey('fullName') || processedData['fullName'] == null) {
              processedData['fullName'] = 'Doctor';
            }

            final Map<String, dynamic> doctorData = {
              'profileImage': userData['profileImage']?.toString() ?? '',
              'userId': userData['_id']?.toString() ?? '',
              'email': processedData['email'] ?? '',
              'phoneNumber': processedData['phoneNumber'] ?? '',
              'specialization': userData['specialization'],
              'qualifications': userData['qualifications'] is List ? userData['qualifications'] : [],
              'experience': userData['experience'],
              'clinicAddress': userData['clinicAddress'],
              'consultationFee': userData['consultationFee'],
              'availableSlots': userData['availableSlots'] is List ? userData['availableSlots'] : [],
              'patients': userData['patients'] is List ? userData['patients'] : [],
              'ratings': userData['ratings'],
              'reviews': userData['reviews'] is List ? userData['reviews'] : [],
            };

            processedData['doctorData'] = doctorData;

            print('Processed data for DoctorModel creation');

            try {
              final doctor = DoctorModel.fromJson(processedData);
              currentUser.value = doctor;

              await LocalStorageUtils.setUser(doctor.toJson());
              print('Doctor data loaded successfully: ${doctor.fullName}');
              print('Doctor email: ${doctor.email}');
              print('Doctor profile image: ${doctor.profileImage}');
            } catch (e) {
              print('Error creating DoctorModel: $e');
              print('Error type: ${e.runtimeType}');
              print('Processed data keys: ${processedData.keys}');
            }
          } else {
            print('Response missing data field');
          }
        } else {
          print('Response data is not a Map');
        }
      } else {
        print('Failed to load doctor data. Status code: ${response.statusCode}');
        print('Response: ${response.data}');
      }
    } catch (e) {
      print('Error loading doctor data: $e');
      print('Stack trace: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> loadUserDataSecondTime() async {
    isLoading.value = true;
    try {
      final response = await _apiService.get(ApiUrls.meUrl);
      if (response.statusCode == 200) {
        print('API Doctor data response received');

        if (response.data is Map<String, dynamic>) {
          final Map<String, dynamic> responseData = response.data as Map<String, dynamic>;

          if (responseData.containsKey('data') && responseData['data'] != null) {
            final userData = responseData['data'] as Map<String, dynamic>;
            final Map<String, dynamic> processedData = {};

            processedData.addAll(userData);
            processedData['role'] = 'doctor';

            if (userData.containsKey('userId')) {
              final userIdData = userData['userId'];
              if (userIdData is Map<String, dynamic>) {
                processedData['email'] = userIdData['email']?.toString() ?? processedData['email'];
                processedData['phoneNumber'] = userIdData['phoneNumber']?.toString() ?? processedData['phoneNumber'];
              }
            }

            if (!processedData.containsKey('fullName') || processedData['fullName'] == null) {
              processedData['fullName'] = 'Doctor';
            }

            final Map<String, dynamic> doctorData = {
              'profileImage': userData['profileImage']?.toString() ?? '',
              'userId': userData['_id']?.toString() ?? '',
              'email': processedData['email'] ?? '',
              'phoneNumber': processedData['phoneNumber'] ?? '',
              'specialization': userData['specialization'],
              'qualifications': userData['qualifications'] is List ? userData['qualifications'] : [],
              'experience': userData['experience'],
              'clinicAddress': userData['clinicAddress'],
              'consultationFee': userData['consultationFee'],
              'availableSlots': userData['availableSlots'] is List ? userData['availableSlots'] : [],
              'patients': userData['patients'] is List ? userData['patients'] : [],
              'ratings': userData['ratings'],
              'reviews': userData['reviews'] is List ? userData['reviews'] : [],
            };

            processedData['doctorData'] = doctorData;

            print('Processed data for DoctorModel creation');

            try {
              final doctor = DoctorModel.fromJson(processedData);
              currentUser.value = doctor;

              await LocalStorageUtils.setUser(doctor.toJson());
              print('Doctor data loaded successfully: ${doctor.fullName}');
              print('Doctor email: ${doctor.email}');
              print('Doctor profile image: ${doctor.profileImage}');
            } catch (e) {
              print('Error creating DoctorModel: $e');
              print('Error type: ${e.runtimeType}');
              print('Processed data keys: ${processedData.keys}');
            }
          } else {
            print('Response missing data field');
          }
        } else {
          print('Response data is not a Map');
        }
      } else {
        print('Failed to load doctor data. Status code: ${response.statusCode}');
        print('Response: ${response.data}');
      }
    } catch (e) {
      print('Error loading doctor data: $e');
      print('Stack trace: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  void scrollChange() {
    scrollController.addListener(() {
      scrollValue.value = scrollController.offset;
    });
  }

  @override
  void onInit() {
    super.onInit();
    scrollChange();
    loadUserData();
    fetchAppointments();
  }

  Future<void> refreshUserData() async {
    await loadUserData();
  }
}