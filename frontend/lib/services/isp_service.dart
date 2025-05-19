import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart';
import '../models/service_http_response.dart';
import '../models/entities/isp.dart';

class IspService {
  List<Isp> Service = [];
  Future<void> fetchAll() async{
    
    final String lectura = await rootBundle.loadString('assets/jsons/isp.json');
    final List<dynamic> data = jsonDecode(lectura);
    Service = data.map((element) => Isp.fromJson(element as Map<String, dynamic>)).toList();

  }


  Future<ServiceHttpResponse?> getIspById(int id) async {
    ServiceHttpResponse serviceResponse = ServiceHttpResponse();
    if (Service.isEmpty) {
      await fetchAll();
    }
    try {
      serviceResponse.status = 200;
      serviceResponse.body = Service.firstWhere((service) => service.id == id);
      return serviceResponse;
    } catch (e) {
      serviceResponse.status = 400;
      serviceResponse.body = null;
      return serviceResponse;
    }
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

