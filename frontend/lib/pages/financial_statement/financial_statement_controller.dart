import 'package:get/get.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';

class FinancialStatementController extends GetxController {
  Future<File> exportToPdf() async {
    final pdf = pw.Document();

    // Cargar fuente Roboto
    final fontData = await rootBundle.load("assets/fonts/roboto.ttf");
    final roboto = pw.Font.ttf(fontData);

    // Cargar logo
    final ByteData logoData =
        await rootBundle.load('assets/images/logo_proveedify.png');
    final Uint8List logoBytes = logoData.buffer.asUint8List();
    final logoImage = pw.MemoryImage(logoBytes);

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
            data: [
              ['Ganancia 1', '', '', '', 'S/ 54243'],
              ['Ganancia 3', '', '', '', 'S/ 54243'],
              ['Total ingresos', '', '', '', 'S/ 108486'],
            ],
            headerStyle:
                pw.TextStyle(font: roboto, fontWeight: pw.FontWeight.bold),
            cellStyle: pw.TextStyle(font: roboto),
          ),

          pw.SizedBox(height: 20),

          // Sección Egresos
          pw.Text('Egresos', style: pw.TextStyle(font: roboto, fontSize: 16)),
          pw.TableHelper.fromTextArray(
            headers: ['Nombre', 'RUC', 'Fecha', 'ISP', 'Monto'],
            data: [
              ['Egreso 2', '', '', '', 'S/ 54243'],
              ['Egreso 3', '', '', '', 'S/ 54243'],
              ['Total egresos', '', '', '', 'S/ 108486'],
            ],
            headerStyle:
                pw.TextStyle(font: roboto, fontWeight: pw.FontWeight.bold),
            cellStyle: pw.TextStyle(font: roboto),
          ),

          pw.SizedBox(height: 20),

          // Sección Saldo
          pw.Text('Saldo actual',
              style: pw.TextStyle(font: roboto, fontSize: 16)),
          pw.TableHelper.fromTextArray(
            headers: ['Utilidad Total'],
            data: [
              ['S/ 0']
            ],
            headerStyle:
                pw.TextStyle(font: roboto, fontWeight: pw.FontWeight.bold),
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

  Future<File> exportToExcel() async {
    final excel = Excel.createExcel();
    final sheet = excel['Reporte'];

    // Cabeceras
    sheet.appendRow(['Ingresos']);
    sheet.appendRow(['Nombre', 'RUC', 'Fecha', 'Dep.', 'Monto']);
    sheet.appendRow(['Ganancia 1', '', '', '', 'S/ 54243']);
    sheet.appendRow(['Ganancia 3', '', '', '', 'S/ 54243']);
    sheet.appendRow(['Total ingresos', '', '', '', 'S/ 108486']);
    sheet.appendRow([]);

    sheet.appendRow(['Egresos']);
    sheet.appendRow(['Nombre', 'RUC', 'Fecha', 'ISP', 'Monto']);
    sheet.appendRow(['Egreso 2', '', '', '', 'S/ 54243']);
    sheet.appendRow(['Egreso 3', '', '', '', 'S/ 54243']);
    sheet.appendRow(['Total egresos', '', '', '', 'S/ 108486']);
    sheet.appendRow([]);

    sheet.appendRow(['Saldo']);
    sheet.appendRow(['Utilidad Total', '', '', '', 'S/ 0']);

    // Guardar archivo
    final directory = await getTemporaryDirectory();
    final path = '${directory.path}/estado_financiero.xlsx';
    final file = File(path);
    await file.writeAsBytes(excel.encode()!);

    return file;
  }
}
