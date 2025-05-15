import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'register_service_controller.dart';
import '../../components/custom_nav_bar.dart';

class RegisterServicePage extends StatelessWidget {
  RegisterServiceController control = Get.put(RegisterServiceController());

  /// Aquí va el contenido principal de la pantalla
  Widget _buildBody(BuildContext context) {
    return const SafeArea(
      child: Center(
        child: Text(
          'registerService',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: null,
      bottomNavigationBar: const CustomNavBar(
          selectedIndex: 3), // cambia el índice según la posición
      body: _buildBody(context),
    );
  }
}
