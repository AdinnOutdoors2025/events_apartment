import 'package:apartment_project/screens/bottom_nav_screen.dart';
import 'package:apartment_project/screens/home_screen.dart';
import 'package:apartment_project/utils/snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneFocus = FocusNode();
  final passwordFocus = FocusNode();
  final obscurePassword = true.obs;
  final isLoading = false.obs;
  final ApiService apiService = ApiService();

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void onPhoneChanged(String value) {
    if (value.length == 10) {
      FocusScope.of(Get.context!).requestFocus(passwordFocus);
    }
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    try {
      isLoading.value = true;

      final response = await apiService.loginPostAPI(
        phone: phoneController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (response["success"] == true) {
        final token = response["data"]["token"];
        if (kDebugMode) {
          print("TOKEN => $token");
        }
        await StorageService.saveToken(token);

        AppToast.showSuccess(response["message"]);
        Get.offAll(() => BottomNavScreen());
      } else {
        // AppToast.showError(response["message"]);
      }
    } catch (e) {
      AppToast.showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    phoneController.dispose();
    passwordController.dispose();
    phoneFocus.dispose();
    passwordFocus.dispose();
    super.onClose();
  }
}
