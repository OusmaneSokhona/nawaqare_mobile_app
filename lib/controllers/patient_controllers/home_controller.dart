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
      final userFromStorage = LocalStorageUtils.getUser();
      if (userFromStorage != null) {
        currentUser.value = UserModel.fromJson(userFromStorage);
      }

      final response = await apiService.get(ApiUrls.meUrl);
      if (response.statusCode == 200) {
        if (response.data is Map) {
          final Map<String, dynamic> responseData = response.data;
          if (responseData.containsKey('data') && responseData['data'] != null) {
            final dynamic userData = responseData['data'];
            if (userData is Map<String, dynamic>) {
              final Map<String, dynamic> userJson = Map<String, dynamic>.from(userData);

              userJson['role'] = responseData['role'] ?? 'patient';

              if (userData.containsKey('userId')) {
                final userIdData = userData['userId'];
                if (userIdData is Map<String, dynamic>) {
                  userJson['email'] = userIdData['email'] ?? userJson['email'];
                  userJson['phoneNumber'] = userIdData['phoneNumber'] ?? userJson['phoneNumber'];
                }
              }

              userJson['patientData'] = {
                'profileImage': userJson['profileImage'] ?? '',
                'userId': userJson['_id'],
                'email': userJson['email'],
                'phoneNumber': userJson['phoneNumber'],
                'dob': userJson['dob'],
                'gender': userJson['gender'],
                'country': userJson['country'],
                'allergies': userJson['allergies'] ?? [],
                'appointments': userJson['appointments'] ?? [],
                'address': userJson['address'],
                'height': userJson['height'],
                'weight': userJson['weight'],
                'bmi': userJson['bmi'],
                'bloodPressure': userJson['bloodPressure'],
                'heartRate': userJson['heartRate'],
                'reports': userJson['reports'] ?? [],
              };

              final user = UserModel.fromJson(userJson);
              currentUser.value = user;
              await LocalStorageUtils.setUser(user.toJson());
            }
          }
        }
      }
    } catch (e) {
      print('Error loading user data: $e');
    } finally {
      isLoading.value = false;
    }
  }
}