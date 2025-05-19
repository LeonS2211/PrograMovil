import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/service_http_response.dart';
import '../models/entities/dependency.dart';
import '../models/entities/provider.dart';
import '../models/entities/company.dart';

class DependencyService {
  Future<ServiceHttpResponse?> fetchByProviderAndCompany(
      Provider provider, Company company) async {
    List<Dependency> dependencies = [];
    ServiceHttpResponse serviceResponse = ServiceHttpResponse();

    final String body =
        await rootBundle.loadString('assets/jsons/dependencies.json');
    final List<dynamic> data = jsonDecode(body);

    dependencies = data
        .map((map) => Dependency.fromJson(map as Map<String, dynamic>))
        .where((dependency) =>
            dependency.providerId == provider.id &&
            dependency.companyId == company.id)
        .toList();

    if (dependencies.isEmpty) {
      serviceResponse.status = 404;
      serviceResponse.body =
          'No se encontraron dependencias para el proveedor y la compañía especificados.';
    } else {
      serviceResponse.status = 200;
      serviceResponse.body = dependencies;
    }

    return serviceResponse;
  }
}
