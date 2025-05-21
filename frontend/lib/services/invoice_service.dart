import 'dart:convert';
import 'package:flutter/services.dart';

import '../models/entities/invoice.dart';
import '../models/entities/isp_service.dart';
import '../models/entities/provider_service.dart';
import '../models/service_http_response.dart';

class InvoiceService {
  List<Invoice> _allInvoices = [];

  Future<void> _loadData() async {
    if (_allInvoices.isNotEmpty) return;

    final String jsonString =
        await rootBundle.loadString('assets/jsons/invoice.json');
    final List<dynamic> jsonList = jsonDecode(jsonString);
    _allInvoices = jsonList
        .map((map) => Invoice.fromJson(map as Map<String, dynamic>))
        .toList();
  }

  Future<ServiceHttpResponse> getIspInvoice(List<IspService> ispServices) async {
    await _loadData();

    final ids = ispServices.map((s) => s.id).toSet();
    final filtered = _allInvoices.where((invoice) =>
        invoice.serviceType == "ISP" && ids.contains(invoice.serviceId)).toList();

    return ServiceHttpResponse(status: 200, body: filtered);
  }

  Future<ServiceHttpResponse> getProviderInvoice(List<ProviderService> providerServices) async {
    await _loadData();

    final ids = providerServices.map((s) => s.id).toSet();
    final filtered = _allInvoices.where((invoice) =>
        invoice.serviceType == "Proveedor" && ids.contains(invoice.serviceId)).toList();

    return ServiceHttpResponse(status: 200, body: filtered);
  }

  Future<ServiceHttpResponse> invoicing(Invoice invoice) async {
  await _loadData();

  try {
    final index = _allInvoices.indexWhere((i) => i.id == invoice.id);

    if (index == -1) {
      return ServiceHttpResponse(status: 404, body: false);
    }

    _allInvoices[index].invoiced = true;

    return ServiceHttpResponse(status: 200, body: true);
  } catch (e) {
    return ServiceHttpResponse(status: 500, body: false);
  }
}

}
