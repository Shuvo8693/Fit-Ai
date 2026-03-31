import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pler_to_pler_app/core/utils/helpers/toast_message_helper.dart';
import 'package:pler_to_pler_app/core/utils/validators/app_validator.dart';
import 'package:pler_to_pler_app/features/authentication/domain/usecases/register_usecase.dart';
import 'package:pler_to_pler_app/features/authentication/presentation/screens/complete_profile/complete_profile_screen.dart';

class SignUpController extends GetxController {
  // Dependencies
  final RegisterUseCase registerUseCase;

  SignUpController({required this.registerUseCase});

  // UI State Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final conPasswordController = TextEditingController();
  final facilityNameController = TextEditingController();
  final facilityAccountNumberController = TextEditingController();

  // Observable States
  final selectedFacilityType = "".obs;
  final facilityList = ["Gym Facility", "Others Facility"].obs;
  final selectedTab = "Trainer".obs;
  final passwordNotVisible = true.obs;
  final passwordNotVisible2 = true.obs;
  final filePath = "".obs;
  final isValidate = false.obs;
  final isValidateFacility = false.obs;
  final isLoading = false.obs;

  // Change facility type
  void changeFacilityType(value) {
    selectedFacilityType.value = value;
    validateFieldFacility();
  }

  // Change role tab
  void changeTab(value) {
    selectedTab.value = value;
  }

  // Toggle password visibility
  void changeVisibility() {
    passwordNotVisible.value = !passwordNotVisible.value;
  }

  // Toggle confirm password visibility
  void changeVisibility2() {
    passwordNotVisible2.value = !passwordNotVisible2.value;
  }

  // Pick file (facility document)
  Future<void> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result != null) {
        PlatformFile file = result.files.first;
        filePath.value = file.path ?? "";
        validateFieldFacility();
      }
    } catch (e) {
      ToastMessageHelper.showError('Failed to pick file');
    }
  }

  // Validate basic fields
  void validateField() {
    if (AppValidator.validateEmail(emailController.text) == null &&
        AppValidator.validatePassword(passwordController.text) == null &&
        AppValidator.validateConfirmPassword(
              conPasswordController.text,
              passwordController.text,
            ) ==
            null) {
      isValidate.value = true;
    } else {
      isValidate.value = false;
    }
  }

  // Validate facility fields
  void validateFieldFacility() {
    if (facilityNameController.text.isNotEmpty &&
        facilityAccountNumberController.text.isNotEmpty &&
        selectedFacilityType.value.isNotEmpty &&
        filePath.value.isNotEmpty) {
      isValidateFacility.value = true;
    } else {
      isValidateFacility.value = false;
    }
  }

  // Handle registration
  Future<void> handleSignUp() async {
    // Validate basic fields
    if (AppValidator.validateEmail(emailController.text) != null) {
      ToastMessageHelper.showError('Invalid email address');
      return;
    }

    if (AppValidator.validatePassword(passwordController.text) != null) {
      ToastMessageHelper.showError('Password must be at least 6 characters with letters and numbers');
      return;
    }

    if (AppValidator.validateConfirmPassword(
          conPasswordController.text,
          passwordController.text,
        ) !=
        null) {
      ToastMessageHelper.showError('Passwords do not match');
      return;
    }

    try {
      isLoading.value = true;

      // Execute use case
      await registerUseCase(
        email: emailController.text.trim(),
        password: passwordController.text,
        role: selectedTab.value,
      );

      isLoading.value = false;

      // Navigate to complete profile on success
      ToastMessageHelper.showSuccess('Registration successful');
      Get.to(() => CompleteProfileScreen());
    } catch (e) {
      isLoading.value = false;
      ToastMessageHelper.showError(e.toString().replaceAll('Exception: ', ''));
    }
  }

  @override
  void onInit() {
    super.onInit();
    validateField();
    validateFieldFacility();
  }

  @override
  void onClose() {
    emailController.clear();
    passwordController.clear();
    conPasswordController.clear();
    facilityNameController.clear();
    facilityAccountNumberController.clear();
    super.onClose();
  }
}
