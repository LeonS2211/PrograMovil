import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'invoices_controller.dart';

class InvoicesPage extends StatelessWidget {
  final InvoicesController controller = Get.put(InvoicesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Servicios a facturar',
          style: TextStyle(color: Color(0xFF2E3281)),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        leading: BackButton(),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Selector mes/año
            Obx(() => DropdownButton<String>(
              value: controller.selectedMonth.value,
              items: controller.months
                  .map((month) => DropdownMenuItem(
                        value: month,
                        child: Text(month),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  controller.selectedMonth.value = value;
                }
              },
            )),

            const SizedBox(height: 16),

            // Tabla con servicios
            Obx(() => Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFF5563BC)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      // Encabezado tabla
                      Container(
                        padding:
                            const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        color: const Color(0xFFE7E8F2),
                        child: Row(
                          children: const [
                            SizedBox(width: 40), // espacio checkbox
                            Expanded(child: Text('Servicio', style: TextStyle(fontWeight: FontWeight.bold))),
                            Expanded(child: Text('ISP', style: TextStyle(fontWeight: FontWeight.bold))),
                            Expanded(child: Text('Monto', style: TextStyle(fontWeight: FontWeight.bold))),
                            Expanded(child: Text('Estado', style: TextStyle(fontWeight: FontWeight.bold))),
                          ],
                        ),
                      ),
                      // Filas
                      ...controller.services.asMap().entries.map((entry) {
                        int index = entry.key;
                        var item = entry.value;
                        bool selected = controller.selectedServices.contains(index);

                        return InkWell(
                          onTap: () => controller.toggleServiceSelection(index),
                          child: Container(
                            color: selected
                                ? Color(0xFFCBD7F1)
                                : Colors.transparent,
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: selected,
                                  onChanged: (val) =>
                                      controller.toggleServiceSelection(index),
                                ),
                                Expanded(child: Text('${item.servicio}')),
                                Expanded(child: Text('${item.isp}')),
                                Expanded(child: Text('${item.monto}')),
                                Expanded(child: Text('${item.estado}')),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                )),

            const SizedBox(height: 20),

            // Botón Facturar
            Obx(() {
              final enabled = controller.selectedServices.isNotEmpty;
              return SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: enabled ? () {
                    // Acción facturar
                    Get.snackbar(
                      'Facturar',
                      'Facturando servicios seleccionados...',
                    );
                  } : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFBBCFFC),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'FACTURAR',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2, // posición Facturar
        selectedItemColor: Color(0xFF5563BC),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Estado Financiero'),
          BottomNavigationBarItem(icon: Icon(Icons.business), label: 'Información de empresas'),
          BottomNavigationBarItem(icon: Icon(Icons.attach_money), label: 'Facturar'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Agregar Servicios'),
        ],
        onTap: (index) {
          // Aquí podrías hacer navegación por pestañas
          // Ejemplo (solo si tienes las rutas configuradas)
          switch (index) {
            case 0:
              Get.toNamed('/financial-statement');
              break;
            case 1:
              Get.toNamed('/view-companies');
              break;
            case 2:
              // Ya estás en facturar
              break;
            case 3:
              Get.toNamed('/add-service');
              break;
          }
        },
      ),
    );
  }
}
