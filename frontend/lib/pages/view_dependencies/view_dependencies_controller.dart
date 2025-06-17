import 'package:get/get.dart';
import 'package:helloworld/models/entities/dependency.dart';
import 'package:helloworld/models/entities/company.dart';
import 'package:helloworld/services/dependency_service.dart';
import 'package:helloworld/selected_provider_controller.dart';

class ViewDependenciesController extends GetxController {
  var isLoading = true.obs;
  var dependencies = <Dependency>[].obs;

  final DependencyService _dependencyService = DependencyService();
  final provider = Get.find<SelectedProviderController>().provider;
  Future<void> loadDependencies(String companyId) async {
    try {
      isLoading.value = true;

      final companyIdInt = int.tryParse(companyId) ?? 0;

      // Crear Provider dummy con todos los campos obligatorios
      final dummyProvider = provider;

      // Crear Company dummy con todos los campos obligatorios
      final company = Company(
        id: companyIdInt,
        addressId: 0,
        ruc: '',
        name: '',
      );

      final response = await _dependencyService.fetchByProviderAndCompany(dummyProvider, company);

      if (response != null && response.status == 200) {
        dependencies.value = List<Dependency>.from(response.body);
      } else {
        dependencies.clear();
        Get.snackbar('Aviso', response?.body?.toString() ?? 'No se encontraron dependencias.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Error al cargar dependencias: $e');
    } finally {
      isLoading.value = false;
    }
  }
}