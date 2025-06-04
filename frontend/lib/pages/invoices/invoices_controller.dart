import 'package:get/get.dart';

class ServiceItem {
  final String servicio;
  final String isp;
  final String monto;
  final String estado;

  ServiceItem({
    required this.servicio,
    required this.isp,
    required this.monto,
    required this.estado,
  });
}

class InvoicesController extends GetxController {
  var selectedMonth = 'Abril 2025'.obs;

  final List<String> months = ['Abril 2025', 'Mayo 2025', 'Junio 2025'];

  // Lista de servicios simulada
  final services = <ServiceItem>[
    ServiceItem(servicio: 'Servicio 1', isp: 'ISP A', monto: 'S/1000', estado: 'Pendiente'),
    ServiceItem(servicio: 'Servicio 2', isp: 'ISP B', monto: 'S/800', estado: 'Pendiente'),
    ServiceItem(servicio: 'Servicio 3', isp: 'ISP C', monto: 'S/600', estado: 'Facturado'),
  ].obs;

  // Servicios seleccionados (checkbox)
  var selectedServices = <int>[].obs; // guardamos índices seleccionados

  void toggleServiceSelection(int index) {
    if (selectedServices.contains(index)) {
      selectedServices.remove(index);
    } else {
      selectedServices.add(index);
    }
  }
}
  