import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddServiceController extends GetxController {
    RxString view = ''.obs;

  void gotoRegisterService (BuildContext context , bool volver){
    Navigator.pushNamed(context, '/registerService', arguments: volver);
  }
  
  
  


}
