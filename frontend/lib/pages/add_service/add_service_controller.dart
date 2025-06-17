import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helloworld/models/entities/company.dart';
import 'package:helloworld/models/entities/dependency.dart';
import 'package:helloworld/models/entities/isp.dart';
import 'package:helloworld/models/entities/isp_service.dart' as model;
import 'package:helloworld/models/entities/provider.dart';
import 'package:helloworld/models/entities/provider_service.dart';
import 'package:helloworld/services/dependency_service.dart';
import 'package:helloworld/services/provider_service_service.dart';
import 'package:helloworld/services/isp_service_service.dart' as service;
import 'package:helloworld/services/isp_service.dart'as service;

class AddServiceController extends GetxController {
  // Controladores para la versión simple
  final descripcion = TextEditingController();
  final precio = TextEditingController();

  // Controladores para la versión detallada (ISP)
  final descripcionController = TextEditingController();
  final precioController = TextEditingController();
  final codigoPagoController = TextEditingController();
  final selectedIsp = RxnString(); // para el Dropdown

  // Método para limpiar todos los campos
  void limpiarCampos(bool isp) {
    if (isp) {
      descripcionController.clear();
      precioController.clear();
      codigoPagoController.clear();
      selectedIsp.value = null;
    } else {
      descripcion.clear();
      precio.clear();
    }
  }

  // Navegación a la pantalla de servicios registrados
  void gotoRegisterService(BuildContext context, bool volver) {
    Navigator.pushNamed(context, '/registerService', arguments: volver);
  }

  // Validación de los datos ingresados
  bool validarCampos(bool isp) {
    if (isp) {
      return descripcionController.text.isNotEmpty &&
             precioController.text.isNotEmpty &&
             codigoPagoController.text.isNotEmpty &&
             selectedIsp.value != null;
    } else {
      return descripcion.text.isNotEmpty && precio.text.isNotEmpty;
    }
  }

  // Muestra los dos modales en cascada
  void mostrarDialogosConfirmacion(BuildContext context, bool isp) async {
    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 240, 161, 225),
          title: const Text(
            '¿Estás seguro de que \n la información es \n correcta?',
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Confirmar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: const Color.fromARGB(255, 240, 161, 225),
            title: const Text(
              'Información registrada \n correctamente',
              textAlign: TextAlign.center,
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      limpiarCampos(isp);
                    },
                    child: const Text('Registrar otro'),
                  ),
                  const SizedBox(width: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      gotoRegisterService(context, true);
                    },
                    child: const Text('Volver'),
                  ),
                ],
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> guardarNuevoServicio(BuildContext context, int providerId) async {
    if (!validarCampos(true)) {
      Get.snackbar('Error', 'Todos los campos son obligatorios.',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    try {
      final ispService = model.IspService(
        id: null,
        ispId: selectedIspId.value!,
        providerId: providerId,
        description: descripcionController.text.trim(),
        cost: double.tryParse(precioController.text.trim()) ?? 0.0,
        payCode: codigoPagoController.text.trim(),
      );

      final response = await service.IspServiceService().createNewService(ispService);

      if (response.status == 201) {
        mostrarDialogosConfirmacion(context, true);
      } else if (response.status == 409) {
        Get.snackbar('Duplicado', 'El servicio ya existe.',
            backgroundColor: Colors.orange, colorText: Colors.black);
      } else {
        Get.snackbar('Error', 'No se pudo registrar el servicio.',
            backgroundColor: Colors.redAccent, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'Ocurrió un problema: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> guardarNuevoProviderService(BuildContext context, int providerId, int dependencyId) async {
    if (!validarCampos(false)) {
      Get.snackbar('Error', 'Todos los campos son obligatorios.',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    try {
      final nuevoServicio = ProviderService(
        id: null,
        dependencyId: dependencyId,
        providerId: providerId,
        description: descripcion.text.trim(),
        price: double.tryParse(precio.text.trim()) ?? 0.0,
      );

      final response = await ProviderServiceService().createNewService(nuevoServicio);

      if (response.status == 201) {
        mostrarDialogosConfirmacion(context, false);
      } else if (response.status == 409) {
        Get.snackbar('Duplicado', 'El servicio ya existe.',
            backgroundColor: Colors.orange, colorText: Colors.black);
      } else {
        Get.snackbar('Error', 'No se pudo registrar el servicio.',
            backgroundColor: Colors.redAccent, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'Ocurrió un problema: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  // Lista reactiva para los ISPs
  var ispList = <Isp>[].obs;

  final selectedIspId = RxnInt();

  Future<void> cargarIsps() async {
    try {
      final ispService = service.IspService();
      final response = await ispService.fetchAllNamesWithId();

      if (response?.status == 200 && response?.body != null) {
        ispList.assignAll(response!.body as List<Isp>);
      } else {
        ispList.clear();
        Get.snackbar('Info', 'No hay ISPs disponibles',
            backgroundColor: Colors.orange, colorText: Colors.black);
      }
    } catch (e) {
      Get.snackbar('Error', 'No se pudo cargar las dependencias',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }

  // Lista reactiva para dependencias
  var dependencyList = <Dependency>[].obs;

  final selectedDependencyId = RxnInt();

  Provider? currentProvider;
  Company? currentCompany;

  Future<void> cargarDependencias() async {
    if (currentProvider == null || currentCompany == null) {
      Get.snackbar('Error', 'Provider o Company no definidos',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    try {
      final dependencyService = DependencyService();
      final response = await dependencyService.fetchByProviderAndCompany(currentProvider!, currentCompany!);

      if (response?.status == 200 && response?.body != null) {
        dependencyList.assignAll(response!.body as List<Dependency>);
      } else {
        dependencyList.clear();
        Get.snackbar('Info', 'No hay dependencias disponibles',
            backgroundColor: Colors.orange, colorText: Colors.black);
      }
    } catch (e) {
      Get.snackbar('Error', 'No se pudo cargar dependencias',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }

  @override
  void onInit() {
    super.onInit();
    cargarIsps();
    cargarDependencias();
  }

  @override
  void onClose() {
    descripcion.dispose();
    precio.dispose();
    descripcionController.dispose();
    precioController.dispose();
    codigoPagoController.dispose();
    super.onClose();
  }
}


  




