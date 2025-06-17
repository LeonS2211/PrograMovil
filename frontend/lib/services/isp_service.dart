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

Future<ServiceHttpResponse?> fetchAllNamesWithId() async {
  ServiceHttpResponse serviceResponse = ServiceHttpResponse();

  // Cargar el archivo JSON
  final String lectura = await rootBundle.loadString('assets/jsons/isp.json');
  final List<dynamic> data = jsonDecode(lectura);

  // Convertir los datos JSON en una lista de objetos Isp
  List<Isp> names = data.map((e) => Isp.fromJson(e)).toList();

  // Crear una lista de mapas con los valores de id y name
  List<Map<String, dynamic>> ispNamesWithId = names.map((isp) {
    return {
      'id': isp.id,  // Obtener el id
      'name': isp.name  // Obtener el name
    };
  }).toList();

  // Configurar la respuesta del servicio
  serviceResponse.status = 200;
  serviceResponse.body = ispNamesWithId;

  return serviceResponse;
}
}
