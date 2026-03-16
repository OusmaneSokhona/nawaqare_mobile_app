import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:patient_app/utils/api_urls.dart';
import 'package:patient_app/utils/locat_storage.dart';
import '../../models/appointment_model.dart';
import '../../models/user_model.dart' hide Appointment;
import '../../services/api_service.dart';
import '../../utils/app_strings.dart';

class HomeController extends GetxController {
  ScrollController scrollController = ScrollController();
  RxDouble scrollValue = 0.0.obs;
  ApiService apiService = ApiService();
  Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  RxBool isLoading = true.obs;
  RxList<Appointment> allAppointments = <Appointment>[].obs;
  Rx<AppointmentResponse?> appointmentResponse = Rx<AppointmentResponse?>(null);
  Rx<Appointment?> ongoingAppointment = Rx<Appointment?>(null);
  Rx<Appointment?> upcomingAppointment = Rx<Appointment?>(null);

  Future<void> fetchAppointments() async {
    print("token= ${await LocalStorageUtils.getToken()}");
    try {
      final response = await apiService.get(ApiUrls.getAppointments);

      if (response.statusCode == 200) {
        final jsonResponse = response.data is String
            ? json.decode(response.data)
            : response.data;

        appointmentResponse.value = AppointmentResponse.fromJson(jsonResponse);
        final List<Appointment> appointments = appointmentResponse.value?.appointments ?? [];
        allAppointments.value = appointments;

        // Reset states
        ongoingAppointment.value = null;
        upcomingAppointment.value = null;

        if (appointments.isNotEmpty) {
          final now = DateTime.now();

          // 1. Find Ongoing: Only consider appointments with non-null timeslot
          try {
            ongoingAppointment.value = appointments.firstWhere((appointment) {
              // Check if timeslot exists first
              if (appointment.timeslot == null) return false;

              final startTime = appointment.timeslot!.startTime;
              final endTime = appointment.timeslot!.endTime;
              final isActive = appointment.status == AppointmentStatus.confirmed ||
                  appointment.status == AppointmentStatus.pending;

              return isActive && now.isAfter(startTime) && now.isBefore(endTime);
            });
          } catch (_) {
            ongoingAppointment.value = null; // No ongoing found
          }

          // 2. Find Upcoming: Filter for future appointments with non-null timeslot
          List<Appointment> futureAppointments = appointments.where((appointment) {
            // Check if timeslot exists first
            if (appointment.timeslot == null) return false;

            final startTime = appointment.timeslot!.startTime;
            final isActive = appointment.status == AppointmentStatus.confirmed ||
                appointment.status == AppointmentStatus.pending;

            return isActive && startTime.isAfter(now);
          }).toList();

          if (futureAppointments.isNotEmpty) {
            // Sort by start time to get the absolute next one
            futureAppointments.sort((a, b) {
              // We already filtered out null timeslots, so it's safe to use ! here
              return a.timeslot!.startTime.compareTo(b.timeslot!.startTime);
            });

            upcomingAppointment.value = futureAppointments.first;
          }
        }
      } else {
        throw Exception('Failed to load appointments: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching appointments: $e');
      Get.snackbar(AppStrings.warning.tr, 'Failed to fetch appointments: $e');
    } finally {

    }
  }

  @override
  void onInit() {
    super.onInit();
    scrollChange();
    loadUserData();
    fetchAppointments();
  }

  void scrollChange() {
    scrollController.addListener(() {
      scrollValue.value = scrollController.offset;
    });
  }

  Future<void> loadUserData() async {
    isLoading.value = true;
    try {
      // Try to load from local storage first
      final userFromStorage = LocalStorageUtils.getUser();
      if (userFromStorage != null) {
        try {
          currentUser.value = UserModel.fromJson(userFromStorage);
          print('Loaded user from storage: ${currentUser.value?.fullName}');
        } catch (e) {
          print('Error loading user from storage: $e');
        }
      }

      // Fetch fresh data from API
      final response = await apiService.get(ApiUrls.meUrl);
      if (response.statusCode == 200) {
        print('API User data response received');

        if (response.data is Map<String, dynamic>) {
          final Map<String, dynamic> responseData = response.data as Map<String, dynamic>;

          if (responseData.containsKey('data') &&
              responseData['data'] != null) {

            final userData = responseData['data'] as Map<String, dynamic>;
            final Map<String, dynamic> processedData = {};

            // Copy all data from userData
            processedData.addAll(userData);

            // Add role from response
            processedData['role'] = responseData['role']?.toString() ?? 'patient';

            // Handle userId - extract from nested object if needed
            if (userData.containsKey('userId')) {
              final userIdData = userData['userId'];
              if (userIdData is Map<String, dynamic>) {
                // Extract email and phone from nested userId object
                processedData['email'] = userIdData['email']?.toString() ?? processedData['email'];
                processedData['phoneNumber'] = userIdData['phoneNumber']?.toString() ?? processedData['phoneNumber'];
              }
            }

            // Ensure fullName exists
            if (!processedData.containsKey('fullName') || processedData['fullName'] == null) {
              processedData['fullName'] = 'User';
            }

            // Prepare patientData for the UserModel with bloodGroup included
            final Map<String, dynamic> patientData = {
              '_id': userData['_id']?.toString() ?? '',
              'userId': userData['userId'],
              'fullName': userData['fullName']?.toString() ?? '',
              'phoneNumber': userData['phoneNumber']?.toString() ?? '',
              'email': processedData['email'] ?? '',
              'allergies': userData['allergies'] is List ? userData['allergies'] : [],
              'appointments': userData['appointments'] is List ? userData['appointments'] : [],
              'reports': userData['reports'] is List ? userData['reports'] : [],
              'createdAt': userData['createdAt'],
              'updatedAt': userData['updatedAt'],
              '__v': userData['__v'],
              'address': userData['address'],
              'bloodPressure': userData['bloodPressure'],
              'bmi': userData['bmi'],
              'country': userData['country'],
              'dob': userData['dob'],
              'gender': userData['gender'],
              'heartRate': userData['heartRate'],
              'height': userData['height'],
              'profileImage': userData['profileImage']?.toString() ?? '',
              'religion': userData['religion'],
              'weight': userData['weight'],
              'bloodGroup': userData['bloodGroup'], // This is the key addition
            };

            processedData['patientData'] = patientData;

            print('Processed data for UserModel creation');
            print('Blood group data: ${userData}');

            try {
              final user = UserModel.fromJson(processedData);
              currentUser.value = user;

              // Save to local storage
              await LocalStorageUtils.setUser(user.toJson());
              print('User data loaded successfully: ${user.fullName}');
              print('User email: ${user.email}');
              print('User profile image: ${user.patientData?.profileImage}');
              print('User blood group: ${user.patientData?.bloodGroup?.type}');
            } catch (e) {
              print('Error creating UserModel: $e');
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
        print('Failed to load user data. Status code: ${response.statusCode}');
        print('Response: ${response.data}');
      }
    } catch (e) {
      print('Error loading user data: $e');
      print('Stack trace: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadUserDataSecondTime() async {
    isLoading.value = true;
    try {
      // Fetch fresh data from API
      final response = await apiService.get(ApiUrls.meUrl);
      if (response.statusCode == 200) {
        print('API User data response received');

        if (response.data is Map<String, dynamic>) {
          final Map<String, dynamic> responseData = response.data as Map<String, dynamic>;

          if (responseData.containsKey('data') &&
              responseData['data'] != null) {

            final userData = responseData['data'] as Map<String, dynamic>;
            final Map<String, dynamic> processedData = {};

            // Copy all data from userData
            processedData.addAll(userData);

            // Add role from response
            processedData['role'] = responseData['role']?.toString() ?? 'patient';

            // Handle userId - extract from nested object if needed
            if (userData.containsKey('userId')) {
              final userIdData = userData['userId'];
              if (userIdData is Map<String, dynamic>) {
                // Extract email and phone from nested userId object
                processedData['email'] = userIdData['email']?.toString() ?? processedData['email'];
                processedData['phoneNumber'] = userIdData['phoneNumber']?.toString() ?? processedData['phoneNumber'];
              }
            }

            // Ensure fullName exists
            if (!processedData.containsKey('fullName') || processedData['fullName'] == null) {
              processedData['fullName'] = 'User';
            }

            // Prepare patientData for the UserModel with bloodGroup included
            final Map<String, dynamic> patientData = {
              '_id': userData['_id']?.toString() ?? '',
              'userId': userData['userId'],
              'fullName': userData['fullName']?.toString() ?? '',
              'phoneNumber': userData['phoneNumber']?.toString() ?? '',
              'email': processedData['email'] ?? '',
              'allergies': userData['allergies'] is List ? userData['allergies'] : [],
              'appointments': userData['appointments'] is List ? userData['appointments'] : [],
              'reports': userData['reports'] is List ? userData['reports'] : [],
              'createdAt': userData['createdAt'],
              'updatedAt': userData['updatedAt'],
              '__v': userData['__v'],
              'address': userData['address'],
              'bloodPressure': userData['bloodPressure'],
              'bmi': userData['bmi'],
              'country': userData['country'],
              'dob': userData['dob'],
              'gender': userData['gender'],
              'heartRate': userData['heartRate'],
              'height': userData['height'],
              'profileImage': userData['profileImage']?.toString() ?? '',
              'religion': userData['religion'],
              'weight': userData['weight'],
              'bloodGroup': userData['bloodGroup'], // This is the key addition
            };

            processedData['patientData'] = patientData;

            print('Processed data for UserModel creation');
            print('Blood group data: ${userData['bloodGroup']}');

            try {
              final user = UserModel.fromJson(processedData);
              currentUser.value = user;

              // Save to local storage
              await LocalStorageUtils.setUser(user.toJson());
              print('User data loaded successfully: ${user.fullName}');
              print('User email: ${user.email}');
              print('User profile image: ${user.patientData?.profileImage}');
              print('User blood group: ${user.patientData?.bloodGroup?.type}');
            } catch (e) {
              print('Error creating UserModel: $e');
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
        print('Failed to load user data. Status code: ${response.statusCode}');
        print('Response: ${response.data}');
      }
    } catch (e) {
      print('Error loading user data: $e');
      print('Stack trace: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshUserData() async {
    await loadUserData();
  }
}