import 'package:collection/collection.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart'; // Esto es necesario para usar PdfColors
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
// Importar los services y entities necesarios
import '../../services/provider_service_service.dart';
import '../../services/isp_service_service.dart';
import '../../services/invoice_service.dart';
import '../../services/dependency_service.dart';
import '../../services/company_service.dart';
import '../../services/isp_service.dart' as isp_svc;
import '../../models/entities/provider.dart';
import '../../models/entities/provider_service.dart';
import '../../models/entities/isp_service.dart';
import '../../models/entities/invoice.dart';
import '../../models/entities/dependency.dart';
import '../../models/entities/company.dart';
import '../../models/entities/isp.dart';
import '../../selected_provider_controller.dart';

// Modelo para estructurar los datos financieros
class FinancialItem {
  final String name;
  final String ruc;
  final String date;
  final String dependency;
  final String amount;
  final String? ispName;

  FinancialItem({
    required this.name,
    required this.ruc,
    required this.date,
    required this.dependency,
    required this.amount,
    this.ispName,
  });
}

class FinancialStatementController extends GetxController {
  final ProviderServiceService _providerServiceService =
      ProviderServiceService();
  final IspServiceService _ispServiceService = IspServiceService();
  final InvoiceService _invoiceService = InvoiceService();
  final DependencyService _dependencyService = DependencyService();
  final CompanyService _companyService = CompanyService();
  final isp_svc.IspService _ispService = isp_svc.IspService();

  var ingresos = <FinancialItem>[].obs;
  var egresos = <FinancialItem>[].obs;
  var isLoading = false.obs;
  var totalIngresos = 0.0.obs;
  var totalEgresos = 0.0.obs;
  var saldoTotal = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    loadFinancialData();
  }

  Future<void> loadFinancialData() async {
    try {
      isLoading.value = true;

      // Obtener el provider seleccionado correctamente
      final selectedProviderController = Get.find<SelectedProviderController>();
      final provider = selectedProviderController.provider; // Usar el getter

      print('=== INICIO CARGA DE DATOS ===');
      print('Provider seleccionado: ID=${provider.id}, Name=${provider.name}');
      print('RUC: ${provider.ruc}');

      await _loadIngresos(provider);
      print('Ingresos cargados: ${ingresos.length}');

      await _loadEgresos(provider);
      print('Egresos cargados: ${egresos.length}');

      _calculateTotals();
      print('=== FIN CARGA DE DATOS ===');
    } catch (e) {
      print('ERROR EN loadFinancialData: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadIngresos(Provider provider) async {
    try {
      print('Cargando ingresos para provider ID: ${provider.id}');

      // 1. Obtener Provider Services
      final providerServicesResponse =
          await _providerServiceService.fetchByProvider(provider);

      print(
          'Provider Services Response Status: ${providerServicesResponse.status}');

      if (providerServicesResponse.status == 200) {
        final List<ProviderService> providerServices =
            providerServicesResponse.body;

        print('Provider Services encontrados: ${providerServices.length}');

        if (providerServices.isEmpty) {
          print(
              'No hay servicios de provider para el provider ID: ${provider.id}');
          return;
        }

        // 2. Obtener facturas de Provider Services
        final invoicesResponse =
            await _invoiceService.getProviderInvoice(providerServices);

        print('Invoices Response Status: ${invoicesResponse.status}');

        if (invoicesResponse.status == 200) {
          final List<Invoice> invoices = invoicesResponse.body;

          print('Facturas encontradas: ${invoices.length}');

          List<FinancialItem> ingresosTemp = [];

          for (Invoice invoice in invoices) {
            try {
              // Encontrar el service correspondiente
              final service = providerServices.firstWhereOrNull(
                (s) => s.id == invoice.serviceId,
              );

              if (service == null) {
                print('Service not found for invoice ${invoice.id}');
                continue;
              }

              // Obtener información de la dependencia
              final dependencyResponse = await _dependencyService
                  .getDependencyById(service.dependencyId);

              String dependencyName = '';
              String companyRuc = '';

              if (dependencyResponse?.status == 200) {
                final Dependency dependency = dependencyResponse!.body;
                dependencyName = dependency.name;

                // Obtener información de la compañía
                final companyResponse = await _companyService
                    .getCompanyRucById(dependency.companyId);

                if (companyResponse?.status == 200) {
                  companyRuc = companyResponse!.body;
                }
              }

              ingresosTemp.add(FinancialItem(
                name: service.description,
                ruc: companyRuc,
                date: _formatDate(invoice.issueDate),
                dependency: dependencyName,
                amount: 'S/ ${service.price.toStringAsFixed(2)}',
              ));

              print(
                  'Ingreso agregado: ${service.description} - S/ ${service.price}');
            } catch (e) {
              print('Error procesando factura ${invoice.id}: $e');
            }
          }

          ingresos.value = ingresosTemp;
          print('Total ingresos cargados: ${ingresosTemp.length}');
        } else {
          print('Error obteniendo facturas: ${invoicesResponse.status}');
        }
      } else {
        print(
            'Error obteniendo provider services: ${providerServicesResponse.status}');
      }
    } catch (e) {
      print('Error loading ingresos: $e');
    }
  }

  Future<void> _loadEgresos(Provider provider) async {
    try {
      print('Cargando egresos para provider ID: ${provider.id}');

      // 1. Obtener ISP Services
      final ispServicesResponse =
          await _ispServiceService.fetchByProvider(provider);

      print('ISP Services Response Status: ${ispServicesResponse.status}');

      if (ispServicesResponse.status == 200) {
        final List<IspService> ispServices = ispServicesResponse.body;

        print('ISP Services encontrados: ${ispServices.length}');

        if (ispServices.isEmpty) {
          print('No hay servicios ISP para el provider ID: ${provider.id}');
          return;
        }

        // 2. Obtener facturas de ISP Services
        final invoicesResponse =
            await _invoiceService.getIspInvoice(ispServices);

        print('ISP Invoices Response Status: ${invoicesResponse.status}');

        if (invoicesResponse.status == 200) {
          final List<Invoice> invoices = invoicesResponse.body;

          print('Facturas ISP encontradas: ${invoices.length}');

          List<FinancialItem> egresosTemp = [];

          for (Invoice invoice in invoices) {
            try {
              // Encontrar el service correspondiente
              final service = ispServices.firstWhereOrNull(
                (s) => s.id == invoice.serviceId,
              );

              if (service == null) {
                print('ISP Service not found for invoice ${invoice.id}');
                continue;
              }
              // Obtener información del ISP
              final ispResponse = await _ispService.getIspById(service.ispId);
              String ispName = '';
              String ispRuc = '';

              if (ispResponse?.status == 200) {
                final Isp isp = ispResponse!.body;
                ispName = isp.name;
                ispRuc = isp.ruc;
              }

              // Obtener información de la dependencia
              final dependencyResponse = await _dependencyService
                  .getDependencyById(service.providerId);

              String dependencyName = '';

              if (dependencyResponse?.status == 200) {
                final Dependency dependency = dependencyResponse!.body;
                dependencyName = dependency.name;
              }

              egresosTemp.add(FinancialItem(
                name: service.description,
                ruc: ispRuc,
                date: _formatDate(invoice.issueDate),
                dependency: dependencyName,
                amount: 'S/ ${service.cost.toStringAsFixed(2)}',
                ispName: ispName,
              ));

              print(
                  'Egreso agregado: ${service.description} - S/ ${service.cost}');
            } catch (e) {
              print('Error procesando factura ISP ${invoice.id}: $e');
            }
          }

          egresos.value = egresosTemp;
          print('Total egresos cargados: ${egresosTemp.length}');
        } else {
          print('Error obteniendo facturas ISP: ${invoicesResponse.status}');
        }
      } else {
        print('Error obteniendo ISP services: ${ispServicesResponse.status}');
      }
    } catch (e) {
      print('Error loading egresos: $e');
    }
  }

  void _calculateTotals() {
    // Calcular total de ingresos
    double totalIng = 0.0;
    for (var item in ingresos) {
      final amount = item.amount.replaceAll('S/ ', '').replaceAll(',', '');
      totalIng += double.tryParse(amount) ?? 0.0;
    }
    totalIngresos.value = totalIng;

    // Calcular total de egresos
    double totalEgr = 0.0;
    for (var item in egresos) {
      final amount = item.amount.replaceAll('S/ ', '').replaceAll(',', '');
      totalEgr += double.tryParse(amount) ?? 0.0;
    }
    totalEgresos.value = totalEgr;

    // Calcular saldo total
    saldoTotal.value = totalIngresos.value - totalEgresos.value;

    print('Totales calculados:');
    print('- Ingresos: S/ ${totalIngresos.value}');
    print('- Egresos: S/ ${totalEgresos.value}');
    print('- Saldo: S/ ${saldoTotal.value}');
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

Future exportToPdf() async {
  final pdf = pw.Document();
  
  // Cargar fuente Roboto
  final fontData = await rootBundle.load("assets/fonts/roboto.ttf");
  final roboto = pw.Font.ttf(fontData);

  // Cargar logo
  final ByteData logoData = await rootBundle.load('assets/images/logo_proveedify.png');
  final Uint8List logoBytes = logoData.buffer.asUint8List();
  final logoImage = pw.MemoryImage(logoBytes);

  // Preparar datos de ingresos para PDF
  List<List<String>> ingresosData = ingresos
      .map((item) => [
            item.name,
            item.ruc,
            item.date,
            item.dependency,
            item.amount,
          ])
      .toList();
  ingresosData.add([
    'Total ingresos',
    '',
    '',
    '',
    'S/ ${totalIngresos.value.toStringAsFixed(2)}'
  ]);

  // Preparar datos de egresos para PDF
  List<List<String>> egresosData = egresos
      .map((item) => [
            item.name,
            item.ruc,
            item.date,
            item.ispName ?? '',
            item.amount,
          ])
      .toList();
  egresosData.add([
    'Total egresos',
    '',
    '',
    '',
    'S/ ${totalEgresos.value.toStringAsFixed(2)}'
  ]);

  pdf.addPage(
    pw.MultiPage(
      build: (context) => [
        // Encabezado con logo y título
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Image(logoImage, width: 100),
            pw.Text(
              'Reporte Financiero',
              style: pw.TextStyle(
                font: roboto,
                fontSize: 20,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 20),
        // Sección Ingresos
        pw.Text('Ingresos', style: pw.TextStyle(font: roboto, fontSize: 16)),
        pw.TableHelper.fromTextArray(
          headers: ['Nombre', 'RUC', 'Fecha', 'Dep.', 'Monto'],
          data: ingresosData,
          headerStyle: pw.TextStyle(font: roboto, fontWeight: pw.FontWeight.bold),
          cellStyle: pw.TextStyle(font: roboto),
          border: pw.TableBorder.all(
            width: 0.5, 
            color: PdfColors.black,
            style: pw.BorderStyle.solid,
          ),
          columnWidths: {
            0: pw.FixedColumnWidth(85), // Ajustar el ancho de la columna
            1: pw.FixedColumnWidth(65),
            2: pw.FixedColumnWidth(50),
            3: pw.FixedColumnWidth(70),
            4: pw.FixedColumnWidth(60),
          },
        ),
        pw.SizedBox(height: 20),
        // Sección Egresos
        pw.Text('Egresos', style: pw.TextStyle(font: roboto, fontSize: 16)),
        pw.TableHelper.fromTextArray(
          headers: ['Nombre', 'RUC', 'Fecha', 'ISP', 'Monto'],
          data: egresosData,
          headerStyle: pw.TextStyle(font: roboto, fontWeight: pw.FontWeight.bold),
          cellStyle: pw.TextStyle(font: roboto),
          border: pw.TableBorder.all(
            width: 0.5, 
            color: PdfColors.black,
            style: pw.BorderStyle.solid,
          ),
          columnWidths: {
            0: pw.FixedColumnWidth(85), // Ajustar el ancho de la columna
            1: pw.FixedColumnWidth(65),
            2: pw.FixedColumnWidth(50),
            3: pw.FixedColumnWidth(70),
            4: pw.FixedColumnWidth(60),
          },
        ),
        pw.SizedBox(height: 20),
        // Sección Saldo
        pw.Text('Saldo actual', style: pw.TextStyle(font: roboto, fontSize: 16)),
        pw.TableHelper.fromTextArray(
          headers: ['Utilidad Total'],
          data: [
            ['S/ ${saldoTotal.value.toStringAsFixed(2)}']
          ],
          headerStyle: pw.TextStyle(font: roboto, fontWeight: pw.FontWeight.bold),
          cellStyle: pw.TextStyle(font: roboto),
        ),
      ],
    ),
  );
  
  // Guardar archivo
  final dir = await getTemporaryDirectory();
  final file = File('${dir.path}/estado_financiero.pdf');
  await file.writeAsBytes(await pdf.save());
  return file;
}


  Future exportToExcel() async {
    final excel = Excel.createExcel();
    final sheet =
        excel['Reporte']; // Aseguramos que la primera hoja sea la de "Reporte"

    // Aseguramos que las celdas sean más anchas para acomodar el contenido
    sheet.setColWidth(0, 35); // Nombre
    sheet.setColWidth(1, 15); // RUC
    sheet.setColWidth(2, 15); // Fecha
    sheet.setColWidth(3, 25); // Dependencia
    sheet.setColWidth(4, 15); // Monto

    // Cabeceras Ingresos
    sheet.appendRow(['Ingresos']);
    sheet.appendRow(['Nombre', 'RUC', 'Fecha', 'Dep.', 'Monto']);

    // Datos de ingresos
    for (var item in ingresos) {
      sheet.appendRow(
          [item.name, item.ruc, item.date, item.dependency, item.amount]);
    }
    sheet.appendRow([
      'Total ingresos',
      '',
      '',
      '',
      'S/ ${totalIngresos.value.toStringAsFixed(2)}'
    ]);

    sheet.appendRow([]);

    // Cabeceras Egresos
    sheet.appendRow(['Egresos']);
    sheet.appendRow(['Nombre', 'RUC', 'Fecha', 'ISP', 'Monto']);

    // Datos de egresos
    for (var item in egresos) {
      sheet.appendRow(
          [item.name, item.ruc, item.date, item.ispName ?? '', item.amount]);
    }
    sheet.appendRow([
      'Total egresos',
      '',
      '',
      '',
      'S/ ${totalEgresos.value.toStringAsFixed(2)}'
    ]);

    sheet.appendRow([]);
    sheet.appendRow(['Saldo']);
    sheet.appendRow([
      'Utilidad Total',
      '',
      '',
      '',
      'S/ ${saldoTotal.value.toStringAsFixed(2)}'
    ]);

    // Guardar archivo
    final directory = await getTemporaryDirectory();
    final path = '${directory.path}/estado_financiero.xlsx';
    final file = File(path);
    await file.writeAsBytes(excel.encode()!);
    return file;
  }
}
