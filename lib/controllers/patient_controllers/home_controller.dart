import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:patient_app/utils/api_urls.dart';
import 'package:patient_app/utils/locat_storage.dart';
import '../../models/user_model.dart';
import '../../services/api_service.dart';

class HomeController extends GetxController {
  ScrollController scrollController = ScrollController();
  RxDouble scrollValue = 0.0.obs;
  ApiService apiService = ApiService();
  Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    scrollChange();
    loadUserData();
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

            // Prepare patientData for the UserModel
            final Map<String, dynamic> patientData = {
              'profileImage': userData['profileImage']?.toString() ?? '',
              'userId': userData['_id']?.toString() ?? '',
              'email': processedData['email'] ?? '',
              'phoneNumber': processedData['phoneNumber'] ?? '',
              'dob': userData['dob'],
              'gender': userData['gender'],
              'country': userData['country'],
              'allergies': userData['allergies'] is List ? userData['allergies'] : [],
              'appointments': userData['appointments'] is List ? userData['appointments'] : [],
              'address': userData['address'],
              'height': userData['height'],
              'weight': userData['weight'],
              'bmi': userData['bmi'],
              'bloodPressure': userData['bloodPressure'],
              'heartRate': userData['heartRate'],
              'reports': userData['reports'] is List ? userData['reports'] : [],
            };

            processedData['patientData'] = patientData;

            print('Processed data for UserModel creation');

            try {
              final user = UserModel.fromJson(processedData);
              currentUser.value = user;

              // Save to local storage
              await LocalStorageUtils.setUser(user.toJson());
              print('User data loaded successfully: ${user.fullName}');
              print('User email: ${user.email}');
              print('User profile image: ${user.patientData?.profileImage}');
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