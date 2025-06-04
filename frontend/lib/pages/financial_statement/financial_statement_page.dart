import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'financial_statement_controller.dart';
import '../../components/custom_nav_bar.dart';

class FinancialStatementPage extends StatelessWidget {
  FinancialStatementPage({super.key});

  final FinancialStatementController control =
      Get.put(FinancialStatementController());

  /// Aquí va el contenido principal de la pantalla
  Widget _buildBody(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Aquí irán tus resultados financieros (placeholder por ahora)
            Expanded(
              child: Center(
                child: Text(
                  'financialStatement',
                  style: textTheme.titleLarge,
                ),
              ),
            ),

            // Botones EXPORTAR y COMPARTIR
            Center(
              child: ElevatedButton(
                onPressed: () => showExportDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primaryContainer,
                  foregroundColor: colorScheme.onPrimaryContainer,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  textStyle: textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('EXPORTAR Y COMPARTIR'),
              ),
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  void showExportDialog(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    String selected = 'excel';

    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: colorScheme.tertiaryContainer,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () => setState(() => selected = 'excel'),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: selected == 'excel'
                                      ? colorScheme.primaryContainer
                                      : Colors.transparent,
                                ),
                                child: Column(
                                  children: [
                                    Image.asset('assets/images/excel.png',
                                        width: 64),
                                    const SizedBox(height: 8),
                                    Text('Excel', style: textTheme.bodyMedium),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => setState(() => selected = 'pdf'),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: selected == 'pdf'
                                      ? colorScheme.primaryContainer
                                      : Colors.transparent,
                                ),
                                child: Column(
                                  children: [
                                    Image.asset('assets/images/pdf.png',
                                        width: 64),
                                    const SizedBox(height: 8),
                                    Text('PDF', style: textTheme.bodyMedium),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),

                  // Línea horizontal más visible
                  Container(
                    height: 1,
                    width: double.infinity,
                    color: colorScheme.outline,
                  ),

                  // Botones ocupan toda la parte inferior
                  SizedBox(
                    height: 48,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                ),
                              ),
                              foregroundColor: colorScheme.primary,
                            ),
                            child:
                                Text('Cancelar', style: textTheme.labelLarge),
                          ),
                        ),
                        Container(
                          width: 1,
                          height: double.infinity,
                          color: colorScheme.outline,
                        ),
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(context); // cerrar modal
                              Future.microtask(
                                  () => _exportWithLoader(context, selected));
                            },
                            style: TextButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(20)),
                              ),
                              foregroundColor: colorScheme.primary,
                            ),
                            child:
                                Text('Exportar', style: textTheme.labelLarge),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void _exportWithLoader(BuildContext context, String selected) async {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final navigator =
        Navigator.of(context, rootNavigator: true); // ✅ guardado válido
    final messenger = ScaffoldMessenger.of(context);

    // Mostrar loader
    navigator.push(
      DialogRoute(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: colorScheme.surface,
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 16),
              Text('Generando archivo...', style: textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );

    try {
      File file;

      if (selected == 'excel') {
        file = await control.exportToExcel();
      } else {
        file = await control.exportToPdf();
      }

      navigator.pop(); // ✅ cerrar loader con navigator seguro

      await Future.delayed(
          const Duration(milliseconds: 100)); // evitar conflicto visual
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Estado financiero generado con Proveedify',
      );
    } catch (e) {
      navigator.pop(); // cerrar loader
      messenger.showSnackBar(
        const SnackBar(content: Text('Error al exportar archivo')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (!didPop) {
          Navigator.pushReplacementNamed(context, '/select-company');
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: null,
        bottomNavigationBar: const CustomNavBar(selectedIndex: 0),
        body: _buildBody(context),
      ),
    );
  }
}
