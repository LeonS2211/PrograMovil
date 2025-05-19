import 'dart:convert';
import 'package:flutter/services.dart';

import '../models/entities/provider_service.dart';
import '../models/service_http_response.dart';
import '../models/entities/provider.dart';

class ProviderServiceService {
  List<ProviderService> _allServices = [];

  Future<void> _loadData() async {
    if (_allServices.isEmpty) {
      final String body = await rootBundle.loadString('assets/jsons/provider_service.json');
      final List<dynamic> data = jsonDecode(body);
      _allServices = data
          .map((map) => ProviderService.fromJson(map as Map<String, dynamic>))
          .toList();
    }
  }

  Future<ServiceHttpResponse> fetchByProvider(Provider provider) async {
    await _loadData();
    final filtered = _allServices
        .where((service) => service.providerId == provider.id)
        .toList();

    return ServiceHttpResponse(status: 200, body: filtered);
  }

  Future<ServiceHttpResponse> createNewService(ProviderService newService) async {
    await _loadData();

    // Simular que se guarda (en memoria)
    final exists = _allServices.any((s) =>
        s.description == newService.description &&
        s.providerId == newService.providerId);

    if (exists) {
      return ServiceHttpResponse(status: 409, body: false); // conflicto
    }

    _allServices.add(newService);
    return ServiceHttpResponse(status: 201, body: true);
  }
}
