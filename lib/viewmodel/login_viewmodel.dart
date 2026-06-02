import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import '../utils/snackbar.dart';

class LoginState {
  final bool obscurePassword;
  final bool isLoading;

  LoginState({
    this.obscurePassword = true,
    this.isLoading = false,
  });

  LoginState copyWith({
    bool? obscurePassword,
    bool? isLoading,
  }) {
    return LoginState(
      obscurePassword: obscurePassword ?? this.obscurePassword,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class LoginViewModel extends AutoDisposeNotifier<LoginState> {
  final formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneFocus = FocusNode();
  final passwordFocus = FocusNode();
  final ApiService apiService = ApiService();

  @override
  LoginState build() {
    ref.onDispose(() {
      phoneController.dispose();
      passwordController.dispose();
      phoneFocus.dispose();
      passwordFocus.dispose();
    });
    return LoginState();
  }

  void togglePasswordVisibility() {
    state = state.copyWith(obscurePassword: !state.obscurePassword);
  }

  void onPhoneChanged(String value, BuildContext context) {
    if (value.length == 10) {
      FocusScope.of(context).requestFocus(passwordFocus);
    }
  }

  Future<bool> login() async {
    if (!formKey.currentState!.validate()) return false;

    try {
      state = state.copyWith(isLoading: true);

      final response = await apiService.loginPostAPI(
        phone: phoneController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (response["success"] == true) {
        final token = response["data"]["token"];
        await StorageService.saveToken(token);
        AppToast.showSuccess(response["message"]);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      AppToast.showError(e.toString());
      return false;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

final loginViewModelProvider =
    NotifierProvider.autoDispose<LoginViewModel, LoginState>(
  LoginViewModel.new,
);
