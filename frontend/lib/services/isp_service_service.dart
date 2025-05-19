import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:helloworld/models/entities/isp_service.dart';
import '../models/service_http_response.dart';
import '../models/entities/provider.dart';


class IspServiceService {
  List<IspService> isp = [];

  Future<ServiceHttpResponse> fetchByProvider(Provider provider) async{ 
    ServiceHttpResponse serviceResponse = ServiceHttpResponse();
    await fetchAll();
    final filtered = isp
        .where((service) => service.providerId == provider.id)
        .toList();
    serviceResponse.status = 200;
    serviceResponse.body = filtered;
    return serviceResponse;
  
  }

Future<void> fetchAll() async {
  if(isp.isEmpty){
    final String lectura = await rootBundle.loadString('assets/jsons/isp.json');
    final List<dynamic> data = jsonDecode(lectura);
   
    isp = data.map((e) => IspService.fromJson(e)).toList();
    } 
  }



    Future<ServiceHttpResponse> createNewService(IspService newService) async {
    await fetchAll();
    // Simular que se guarda (en memoria)
    final exists = isp.any((s) =>
        s.description == newService.description &&
        s.providerId == newService.providerId);
    if (exists) {
      return ServiceHttpResponse(status: 409, body: false); // conflicto
    }
    isp.add(newService);
    return ServiceHttpResponse(status: 201, body: true);
  }
}