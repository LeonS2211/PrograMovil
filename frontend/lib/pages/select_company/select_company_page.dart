import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectCompanyController extends GetxController {
  var selectedCompany = RxnString();

  final List<String> companies = ['Empresa A', 'Empresa B', 'Empresa C'];

  void setSelectedCompany(String? company) {
    selectedCompany.value = company;
  }
}

class SelectCompanyPage extends StatelessWidget {
  final SelectCompanyController controller = Get.put(SelectCompanyController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Seleccione su empresa',
          style: TextStyle(color: Color(0xFF2E3281), fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ...controller.companies.map((company) {
              return Obx(() {
                final isSelected = controller.selectedCompany.value == company;
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isSelected ? Color(0xFFE7C5F8) : Color(0xFFF5E6FF),
                      foregroundColor: Colors.black,
                      side: const BorderSide(color: Colors.black),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.apartment),
                    label: Text(
                      company,
                      style: const TextStyle(fontSize: 18),
                    ),
                    onPressed: () => controller.setSelectedCompany(company),
                  ),
                );
              });
            }).toList(),
            const Spacer(),
            SizedBox(
              height: 45,
              child: Obx(() {
                final enabled = controller.selectedCompany.value != null;
                return ElevatedButton(
                  onPressed: enabled
                      ? () {
                          // Navegar o hacer acción con la empresa seleccionada
                          Navigator.pushNamed(context, '/financial-statement');
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFBBCFFC),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'CONTINUAR',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
