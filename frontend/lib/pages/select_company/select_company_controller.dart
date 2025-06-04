import 'package:get/get.dart';

class SelectCompanyController extends GetxController {
  var selectedCompany = RxnString(); // puede ser null al inicio

  final List<String> companies = ['Empresa A', 'Empresa B', 'Empresa C'];

  void setSelectedCompany(String? company) {
    selectedCompany.value = company;
  }
}
