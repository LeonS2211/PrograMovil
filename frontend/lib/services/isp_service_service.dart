import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:helloworld/models/entities/isp_service.dart';
import '../models/service_http_response.dart';
import '../models/entities/provider.dart';


class IspServiceService {
  Future<ServiceHttpResponse> createNewService(IspService newService) async {
    ServiceHttpResponse serviceResponse = ServiceHttpResponse();

    try {
      print("📤 Enviando datos al backend...");
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/ispServices'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(newService.toJson()),
      );

      print("🌐 Status Code: ${response.statusCode}");
      print("📦 Respuesta: ${response.body}");

      if (response.statusCode == 201) {
        serviceResponse.status = 201;
        serviceResponse.body = jsonDecode(response.body);
      } else if (response.statusCode == 409) {
        serviceResponse.status = 409;
        serviceResponse.body = jsonDecode(response.body);
      } else {
        serviceResponse.status = response.statusCode;
        serviceResponse.body = jsonDecode(response.body);
      }
    } catch (e) {
      print("❌ Error al enviar POST al backend: $e");
      serviceResponse.status = 500;
      serviceResponse.body = null;
    }

    return serviceResponse;
  }

  Future<ServiceHttpResponse> fetchByProvider(Provider provider) async {
  ServiceHttpResponse serviceResponse = ServiceHttpResponse();

  try {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:3000/ispServices?provider_id=${provider.id}'),
    );

    print("🌐 GET /ispServices?provider_id=${provider.id} Status: ${response.statusCode}");
    print("📦 Respuesta: ${response.body}");

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final List<IspService> services = data.map((e) => IspService.fromJson(e)).toList();
      serviceResponse.status = 200;
      serviceResponse.body = services;
    } else {
      serviceResponse.status = response.statusCode;
      serviceResponse.body = null;
    }
  } catch (e) {
    print("❌ Error al obtener servicios por provider: $e");
    serviceResponse.status = 500;
    serviceResponse.body = null;
  }

  return serviceResponse;
}

}
