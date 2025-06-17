import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/service_http_response.dart';
import '../models/entities/dependency.dart';
import '../models/entities/provider.dart';
import '../models/entities/company.dart';

class DependencyService {
  List<Dependency> dependencies = [];

  // Carga las dependencias desde el archivo JSON solo si no se ha hecho antes
  Future<void> _loadData() async {
    if (dependencies.isNotEmpty) return; // Si ya están cargadas, no cargar de nuevo

    final String body = await rootBundle.loadString('assets/jsons/dependency.json');
    final List<dynamic> data = jsonDecode(body);

    dependencies = data.map((map) => Dependency.fromJson(map as Map<String, dynamic>)).toList();
  }

  // Devuelve las dependencias asociadas a un proveedor y una compañía
  Future<ServiceHttpResponse?> fetchByProviderAndCompany(
      Provider provider, Company company) async {
    ServiceHttpResponse serviceResponse = ServiceHttpResponse();

    // Cargar datos si aún no se han cargado
    await _loadData();

    // Filtrar dependencias por proveedor y compañía
    List<Dependency> filteredDependencies = dependencies.where((dependency) =>
        dependency.providerId == provider.id && dependency.companyId == company.id).toList();

    if (filteredDependencies.isEmpty) {
      serviceResponse.status = 404;
      serviceResponse.body = 'No se encontraron dependencias para el proveedor y la compañía especificados.';
    } else {
      serviceResponse.status = 200;
      serviceResponse.body = filteredDependencies;
    }

    return serviceResponse;
  }

  // Devuelve una dependencia específica por su id
  Future<ServiceHttpResponse?> getDependencyById(int id) async {
    ServiceHttpResponse serviceResponse = ServiceHttpResponse();
    await _loadData(); // Asegúrate de que los datos estén cargados

    try {
      serviceResponse.status = 200;
      serviceResponse.body = dependencies.firstWhere((dependency) => dependency.id == id);
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
  final String lectura = await rootBundle.loadString('assets/jsons/provider.json');
  final List<dynamic> data = jsonDecode(lectura);

  // Convertir los datos JSON en una lista de objetos Provider
  List<Provider> names = data.map((e) => Provider.fromJson(e)).toList();

  // Crear una lista de mapas con los valores de id y name
  List<Map<String, dynamic>> providerNamesWithId = names.map((provider) {
    return {
      'id': provider.id,  // Obtener el id
      'name': provider.name  // Obtener el name
    };
  }).toList();

  // Configurar la respuesta del servicio
  serviceResponse.status = 200;
  serviceResponse.body = providerNamesWithId;

  return serviceResponse;
}
}
