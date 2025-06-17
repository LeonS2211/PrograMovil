import 'package:get/get.dart';
import 'package:helloworld/models/entities/contact.dart';
import 'package:helloworld/models/entities/dependency.dart';
import 'package:helloworld/models/service_http_response.dart';
import 'package:helloworld/services/contact_service.dart';

class ViewContactsController extends GetxController {
  final ContactService contactService = Get.find<ContactService>();
  var isLoading = true.obs;
  var contacts = <Contact>[].obs;
  var errorMessage = ''.obs;

  void loadContacts(Dependency dependency) async {
    try {
      isLoading(true);
      errorMessage('');
      
      final ServiceHttpResponse? response = await contactService.fetchByDependency(dependency);
      
      if (response == null) {
        errorMessage('No se recibió respuesta del servicio');
        return;
      }
      
      if (response.status == 200) {
        if (response.body is List<Contact>) {
          contacts.assignAll(response.body as List<Contact>);
        } else if (response.body is List) {
          // Conversión adicional por si acaso el tipo no se infiere correctamente
          contacts.assignAll((response.body as List).map((e) => Contact.fromJson(e)).toList());
        }
      } else {
        errorMessage(response.body?.toString() ?? 'Error al cargar contactos');
      }
    } catch (e) {
      errorMessage('Error al cargar contactos: $e');
    } finally {
      isLoading(false);
    }
  }
}