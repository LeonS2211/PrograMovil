import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'select_company_controller.dart';

class SelectCompanyPage extends StatelessWidget {
  SelectCompanyController control = Get.put(SelectCompanyController());

  /// Aquí va el contenido principal de la pantalla
  Widget _buildBody(BuildContext context) {
    return const SafeArea(
      child: Center(
        child: Text(
          'selectCompany',
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
          Navigator.pushReplacementNamed(context, '/sign-in');
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: null,
        body: _buildBody(context),
      ),
    );
  }
}
