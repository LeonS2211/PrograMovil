import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helloworld/pages/view_contacts/view_contacts_controller.dart';
import '../../components/custom_nav_bar.dart';

class ViewContactsPage extends StatelessWidget {
  ViewContactsController control = Get.put(ViewContactsController());

  /// Aquí va el contenido principal de la pantalla
  Widget _buildBody(BuildContext context) {
    return const SafeArea(
      child: Center(
        child: Text(
          'ViewContacts',
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
