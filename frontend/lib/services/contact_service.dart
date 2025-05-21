import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/service_http_response.dart';
import '../models/entities/contact.dart';
import '../models/entities/dependency.dart';

class ContactService {
  Future<ServiceHttpResponse?> fetchByDependency(Dependency dependency) async {
    List<Contact> contacts = [];
    ServiceHttpResponse serviceResponse = ServiceHttpResponse();

    final String body =
        await rootBundle.loadString('assets/jsons/contacts.json');
    final List<dynamic> data = jsonDecode(body);

    contacts = data
        .map((map) => Contact.fromJson(map as Map<String, dynamic>))
        .where((contact) => contact.dependencyId == dependency.id)
        .toList();

    if (contacts.isEmpty) {
      serviceResponse.status = 404;
      serviceResponse.body =
          'No se encontraron contactos para esta dependencia.';
    } else {
      serviceResponse.status = 200;
      serviceResponse.body = contacts;
    }

    return serviceResponse;
  }
}
