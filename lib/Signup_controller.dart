import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // ✅ Observable to track loading state
  var isLoading = false.obs;

  void signUpUser() async {
    if (isLoading.value) return; // Prevent multiple submissions

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    try {
      isLoading.value = true;

      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await credential.user?.sendEmailVerification();

      Get.snackbar(
        "Verification Sent",
        "A verification email has been sent. Please verify your email.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue.shade100,
        colorText: Colors.black,
      );

      Get.toNamed('/phone');

      emailController.clear();
      passwordController.clear();
    } on FirebaseAuthException catch (e) {
      String message = "";
      switch (e.code) {
        case 'email-already-in-use':
          message = "Email is already in use.";
          break;
        case 'invalid-email':
          message = "The email address is badly formatted.";
          break;
        case 'weak-password':
          message = "Password is too weak. Use at least 6 characters.";
          break;
        default:
          message = e.message ?? "Something went wrong.";
      }

      Get.snackbar(
        "Sign Up Failed",
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.black,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "An unexpected error occurred: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.black,
      );
    } finally {
      isLoading.value = false; // Reset loading state
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
