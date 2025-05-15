import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'view_companies_controller.dart';
import '../../components/custom_nav_bar.dart';

class ViewCompaniesPage extends StatelessWidget {
  ViewCompaniesController control = Get.put(ViewCompaniesController());

  /// Aquí va el contenido principal de la pantalla
  Widget _buildBody(BuildContext context) {
    return const SafeArea(
      child: Center(
        child: Text(
          'ViewCompanies',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (!didPop) {
          Navigator.pushReplacementNamed(context, '/select-company');
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: null,
        bottomNavigationBar: const CustomNavBar(selectedIndex: 1),
        body: _buildBody(context),
      ),
    );
  }
}
