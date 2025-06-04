import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/service_http_response.dart';
import '../models/entities/isp.dart';

class IspService {
  List<Isp> services = [];
  Future<void> fetchAll() async {
    final String lectura = await rootBundle.loadString('assets/jsons/isp.json');
    final List<dynamic> data = jsonDecode(lectura);
    services = data
        .map((element) => Isp.fromJson(element as Map<String, dynamic>))
        .toList();
  }

  Future<ServiceHttpResponse?> getIspById(int id) async {
    ServiceHttpResponse serviceResponse = ServiceHttpResponse();
    if (services.isEmpty) {
      await fetchAll();
    }
    try {
      serviceResponse.status = 200;
      serviceResponse.body = services.firstWhere((service) => service.id == id);
      return serviceResponse;
    } catch (e) {
      serviceResponse.status = 404;
      serviceResponse.body = null;
      return serviceResponse;
    }
  }

  Future<ServiceHttpResponse?> fetchAllNames() async {
    ServiceHttpResponse serviceResponse = ServiceHttpResponse();
    final String lectura = await rootBundle.loadString('assets/jsons/isp.json');
    final List<dynamic> data = jsonDecode(lectura);
    List<Isp> names = data.map((e) => Isp.fromJson(e)).toList();
    serviceResponse.status = 200;
    serviceResponse.body = names.map((isp) => isp.name).toList();
    return serviceResponse;
  }
}
