import 'dart:convert';

import 'package:flutter/services.dart';
import '../models/service_http_response.dart';
import '../models/entities/admin.dart';

class AdminService {
Future<ServiceHttpResponse?> signIn(Admin inputAdmin) async {
  ServiceHttpResponse serviceResponse = ServiceHttpResponse();

  final String body =
      await rootBundle.loadString('assets/jsons/admin.json');
  final List<dynamic> data = jsonDecode(body);

  final List<Admin> admins =
      data.map((map) => Admin.fromJson(map as Map<String, dynamic>)).toList();

final matches = admins.where((admin) =>
  admin.username == inputAdmin.username &&
  admin.password == inputAdmin.password).toList();

if (matches.isNotEmpty) {
  serviceResponse.status = 200;
  serviceResponse.body = matches.first;
} else {
  serviceResponse.status = 401;
  serviceResponse.body = null;
}
  return serviceResponse;
}

}
