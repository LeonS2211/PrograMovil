import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInController extends GetxController {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  var isPasswordHidden = true.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  // Ahora solo valida y devuelve mensaje de error o null si está OK
  String? validateLogin() {
    final user = userController.text.trim();
    final password = passwordController.text.trim();

    if (user.isEmpty || password.isEmpty) {
      return 'Por favor ingrese usuario y contraseña';
    }
    // Aquí puedes agregar más validaciones o lógica de login real

    return null;
  }

  @override
  void onClose() {
    userController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
