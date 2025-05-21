import 'dart:convert';

import 'package:flutter/services.dart';
import '../models/service_http_response.dart';
import '../models/entities/company.dart';

class CompanyService  {
  Future<ServiceHttpResponse?> fetchAll() async {
    List<Company> companies = [];
    ServiceHttpResponse serviceResponse = ServiceHttpResponse();
    final String body =
        await rootBundle.loadString('assets/jsons/company.json');
    final List<dynamic> data = jsonDecode(body);
    companies =
        data.map((map) => Company.fromJson(map as Map<String, dynamic>)).toList();
    serviceResponse.status = 200;
    serviceResponse.body = companies;
    return serviceResponse;
  }
}
