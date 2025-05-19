import 'dart:convert';

import 'package:flutter/services.dart';
import '../models/service_http_response.dart';
import '../models/entities/provider.dart';

class ProviderService {
  Future<ServiceHttpResponse?> fetchByIds(List<int> ids) async {
    List<Provider> selectedProviders = [];
    ServiceHttpResponse serviceResponse = ServiceHttpResponse();

      final String body =
          await rootBundle.loadString('assets/jsons/provider.json');
      final List<dynamic> data = jsonDecode(body);

      final allProviders = data
          .map((map) => Provider.fromJson(map as Map<String, dynamic>))
          .toList();

      selectedProviders =
          allProviders.where((p) => ids.contains(p.id)).toList();
      if(selectedProviders.isNotEmpty){
        serviceResponse.status = 200;
        serviceResponse.body = selectedProviders;
      }
      else{
        serviceResponse.status = 400;
        serviceResponse.body = "Hubo un error en encontrar un Provider";
      }
    return serviceResponse;
  }
}
