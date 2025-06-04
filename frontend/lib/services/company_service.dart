import 'dart:convert';

import 'package:flutter/services.dart';
import '../models/service_http_response.dart';
import '../models/entities/company.dart';

class CompanyService {
  List<Company> companies = [];
  Future<ServiceHttpResponse?> fetchAll() async {
    ServiceHttpResponse serviceResponse = ServiceHttpResponse();
    final String body =
        await rootBundle.loadString('assets/jsons/company.json');
    final List<dynamic> data = jsonDecode(body);
    companies = data
        .map((map) => Company.fromJson(map as Map<String, dynamic>))
        .toList();
    serviceResponse.status = 200;
    serviceResponse.body = companies;
    return serviceResponse;
  }

  Future<ServiceHttpResponse?> getCompanyRucById(int id) async {
    ServiceHttpResponse serviceResponse = ServiceHttpResponse();
    if (companies.isEmpty) {
      await fetchAll(); // Asegúrate de que los datos estén cargados
    }
    try {
      serviceResponse.status = 200;
      serviceResponse.body =
          companies.firstWhere((company) => company.id == id).ruc;
      return serviceResponse;
    } catch (e) {
      serviceResponse.status = 404;
      serviceResponse.body = null;
      return serviceResponse;
    }
  }
}
