import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/entities/user.dart';

import '../../models/service_http_response.dart';
import '../../services/user_service.dart' show UserService;

class SignInController extends GetxController {
  TextEditingController txtUser = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  RxString message = ''.obs;
  Rx<MaterialColor> messageColor = Colors.red.obs;
  UserService service = UserService();

  void signIn(BuildContext context) async {
    String user = txtUser.text;
    String password = txtPassword.text;
    User u = User(username: user, password: password);
    ServiceHttpResponse? response = await service.signIn(u);
    if (response == null) {
      print('error');
      message.value = "No hay comunicación con el servidor";
      messageColor.value = Colors.red;
    } else {
      if (response.status == 200) {
        print('ir a home');
        message.value = "Usario válido";
        messageColor.value = Colors.green;
        Navigator.pushNamed(context, '/home');
      } else {
        print('error');
        message.value = "Usario y/o contraseña no válidos";
        messageColor.value = Colors.red;
      }
    }
    Future.delayed(Duration(seconds: 5), () {
      message.value = '';
    });
  }

  void goToSignUp(BuildContext context) {
    Navigator.pushNamed(context, '/create-account');
  }

  void goToResetPassword(BuildContext context) {
    Navigator.pushNamed(context, '/recover-password');
  }
}
