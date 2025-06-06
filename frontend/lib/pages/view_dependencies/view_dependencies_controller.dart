import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:helloworld/models/entities/dependency.dart'; 

class ViewDependenciesController extends GetxController {
  var isLoading = true.obs;
  var dependencies = <Dependency>[].obs;

  Future<void> loadDependencies(String companyId) async {
    try {
      isLoading.value = true;
      final jsonString = await rootBundle.loadString('assets/jsons/dependency.json');
      final jsonData = json.decode(jsonString) as List;
      
      final companyIdInt = int.tryParse(companyId) ?? 0;
      dependencies.value = jsonData
          .where((json) => json['company_id'] == companyIdInt)
          .map((json) => Dependency.fromJson(json))
          .toList();
          
    } catch (e) {
      Get.snackbar('Error', 'Error al cargar dependencias: $e');
    } finally {
      isLoading.value = false;
    }
  }
}