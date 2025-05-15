import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'view_dependencies_controller.dart';
import '../../components/custom_nav_bar.dart';

class ViewDependenciesPage extends StatelessWidget {
  ViewDependenciesController control = Get.put(ViewDependenciesController());

  /// Aquí va el contenido principal de la pantalla
  Widget _buildBody(BuildContext context) {
    return const SafeArea(
      child: Center(
        child: Text(
          'ViewDependencies',
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
          selectedIndex: 1), // cambia el índice según la posición
      body: _buildBody(context),
    );
  }
}
