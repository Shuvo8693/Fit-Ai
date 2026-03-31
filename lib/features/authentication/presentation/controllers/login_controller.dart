import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pler_to_pler_app/core/utils/helpers/toast_message_helper.dart';
import 'package:pler_to_pler_app/core/utils/validators/app_validator.dart';
import 'package:pler_to_pler_app/features/authentication/domain/usecases/login_usecase.dart';
import 'package:pler_to_pler_app/features/nav_bar/presentation/screens/nav_bar.dart';

class LoginController extends GetxController {
  // Dependencies
  final LoginUseCase loginUseCase;

  LoginController({required this.loginUseCase});

  // UI State Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Observable States
  final selectedTab = "Trainer".obs;
  final passwordNotVisible = true.obs;
  final isValidate = false.obs;
  final isLoading = false.obs;

  // Change role tab
  void changeTab(value) {
    selectedTab.value = value;
    validateField();
  }

  // Toggle password visibility
  void changeVisibility() {
    passwordNotVisible.value = !passwordNotVisible.value;
  }

  // Validate form fields
  void validateField() {
    if (AppValidator.validateEmail(emailController.text) == null &&
        AppValidator.validatePassword(passwordController.text) == null) {
      isValidate.value = true;
    } else {
      isValidate.value = false;
    }
  }

  // Handle login action
  Future<void> handleLogin() async {
    // Validate form first
    if (AppValidator.validateEmail(emailController.text) != null) {
      ToastMessageHelper.showError('Invalid email address');
      return;
    }

    if (AppValidator.validatePassword(passwordController.text) != null) {
      ToastMessageHelper.showError('Invalid password');
      return;
    }

    try {
      isLoading.value = true;

      // Execute use case
      await loginUseCase(
        email: emailController.text.trim(),
        password: passwordController.text,
        role: selectedTab.value,
      );

      isLoading.value = false;

      // Navigate to home on success
      ToastMessageHelper.showSuccess('Login successful');
      Get.offAll(() => NavBar());
    } catch (e) {
      isLoading.value = false;
      ToastMessageHelper.showError(e.toString().replaceAll('Exception: ', ''));
    }
  }

  @override
  void onInit() {
    super.onInit();
    validateField();
  }

  @override
  void onClose() {
    emailController.clear();
    passwordController.clear();
    super.onClose();
  }
}
