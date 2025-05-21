import 'dart:convert';
import 'package:flutter/services.dart';

import '../models/entities/address.dart';
import '../models/entities/company.dart';
import '../models/service_http_response.dart';

class AddressService {
  List<Address> _allAddresses = [];

  // Carga las direcciones desde el archivo JSON, si no se han cargado antes
  Future<void> _loadData() async {
    if (_allAddresses.isNotEmpty) return;

    final String jsonString =
        await rootBundle.loadString('assets/jsons/address.json');
    final List<dynamic> data = jsonDecode(jsonString);

    _allAddresses = data
        .map((map) => Address.fromJson(map as Map<String, dynamic>))
        .toList();
  }

  // Devuelve la dirección asociada a una empresa
  Future<ServiceHttpResponse> getAddress(Company company) async {
    await _loadData();

    Address? addressFound;

    for (var address in _allAddresses) {
      if (address.id == company.addressId) {
        addressFound = address;
        break;
      }
    }

    if (addressFound != null) {
      return ServiceHttpResponse(
        status: 200,
        body: addressFound,
      );
    } else {
      return ServiceHttpResponse(
        status: 404,
        body: null,
      );
    }
  }
}

