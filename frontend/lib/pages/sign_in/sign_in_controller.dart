import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/admin_service.dart';
import '../../models/entities/admin.dart';

class SignInController extends GetxController {
  final userController = TextEditingController();
  final passwordController = TextEditingController();
  final isPasswordHidden = true.obs;

  final AdminService _adminService = AdminService();

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  Future<void> login(BuildContext context) async {
    final username = userController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor complete todos los campos')),
      );
      return;
    }

    final response = await _adminService.signIn(Admin(
      id: 0, // No se usa para el login
      username: username,
      password: password,
    ));

    if (response?.status == 200 && response!.body != null) {
      final List<int> providerIds = List<int>.from(response.body.listProvider);

      Navigator.pushNamed(
        context,
        '/select-company',
        arguments: {
          'providerIds': providerIds,
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Credenciales incorrectas')),
      );
    }
  }
}
