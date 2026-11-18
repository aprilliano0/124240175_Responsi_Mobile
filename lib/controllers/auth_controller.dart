import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_constants.dart';
import '../routes/app_routes.dart';
import '../services/session_service.dart';
import 'cart_controller.dart';

class AuthController extends GetxController {
  final RxBool isLoggedIn = false.obs;
  final RxString email = ''.obs;
  final RxBool isPasswordVisible = false.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> checkLoginStatus() async {
    final loggedIn = await SessionService.isLoggedIn();
    if (loggedIn) {
      final savedEmail = await SessionService.getEmail();
      if (savedEmail != null &&
          savedEmail.toLowerCase() == AppConstants.demoEmail) {
        email.value = savedEmail;
        isLoggedIn.value = true;
        // Inisialisasi Cart untuk user ini
        if (Get.isRegistered<CartController>()) {
          Get.find<CartController>().loadUserCart(savedEmail);
        }
      }
    }
  }

  Future<bool> login(String inputEmail, String inputPassword) async {
    final trimmedEmail = inputEmail.trim();
    final trimmedPassword = inputPassword.trim();

    if (!GetUtils.isEmail(trimmedEmail)) {
      Get.snackbar(
        'Peringatan',
        'Masukkan alamat email yang valid',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.amber.shade700,
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        borderRadius: 8,
      );
      return false;
    }

    if (trimmedPassword.isEmpty) {
      Get.snackbar(
        'Peringatan',
        'Password tidak boleh kosong',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.amber.shade700,
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        borderRadius: 8,
      );
      return false;
    }

    if (trimmedEmail.toLowerCase() != AppConstants.demoEmail ||
        trimmedPassword != AppConstants.demoPassword) {
      Get.snackbar(
        'Login Gagal',
        'Email atau password salah',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        borderRadius: 8,
      );
      return false;
    }

    isLoading.value = true;
    try {
      await SessionService.saveSession(AppConstants.demoEmail);
      email.value = AppConstants.demoEmail;
      isLoggedIn.value = true;

      if (Get.isRegistered<CartController>()) {
        Get.find<CartController>().loadUserCart(AppConstants.demoEmail);
      }

      Get.snackbar(
        'Login Berhasil',
        'Selamat datang, ${AppConstants.demoEmail}!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade700,
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        borderRadius: 8,
      );

      Get.offAllNamed(AppRoutes.main);
      return true;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await SessionService.clearSession();
    email.value = '';
    isLoggedIn.value = false;

    Get.snackbar(
      'Logout',
      'Anda telah keluar dari aplikasi',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.grey.shade800,
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
      borderRadius: 8,
    );

    Get.offAllNamed(AppRoutes.login);
  }
}
