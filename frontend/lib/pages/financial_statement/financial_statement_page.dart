import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'financial_statement_controller.dart';
import '../../components/custom_nav_bar.dart';

class FinancialStatementPage extends StatelessWidget {
  FinancialStatementController control =
      Get.put(FinancialStatementController());

  /// Aquí va el contenido principal de la pantalla
  Widget _buildBody(BuildContext context) {
    return const SafeArea(
      child: Center(
        child: Text(
          'financialStatement',
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
        bottomNavigationBar: const CustomNavBar(selectedIndex: 0),
        body: _buildBody(context),
      ),
    );
  }
}
