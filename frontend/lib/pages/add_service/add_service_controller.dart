import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  // Validación de los datos ingresados (puedes adaptarlo más)
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

