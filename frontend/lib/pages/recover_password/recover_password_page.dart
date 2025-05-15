import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'recover_password_controller.dart';

class RecoverPasswordPage extends StatelessWidget {
  RecoverPasswordController control = Get.put(RecoverPasswordController());

  Widget _form(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryFixed,
          border: Border.all(
              color: Theme.of(context).colorScheme.onSecondaryFixedVariant,
              width: 2.0)),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
              top: 0, // Padding superior
              bottom: 0, // Padding inferior
              left: 25, // Padding izquierdo
              right: 25, // Padding derecho
            ),
            child: Column(
              children: [
                Text('Ingresa Esta Información'),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Correo',
                    hintText: 'Correo',
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    prefixIcon: Icon(Icons
                        .mail_outline), // Aquí agregamos el ícono de usuario
                    //border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  onPressed: () {
                    // Acción del botón
                  },
                  child: Text('RECUPERAR CONTRASEÑA'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 40), // 100% del ancho
                    backgroundColor:
                        Color(0xFFFF7F2A), // Color de fondo personalizado
                    foregroundColor: Colors.white, // Color del texto blanco
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.zero, // Sin redondeo en las esquinas
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _layer1(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [
        SizedBox(
          height: 50,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryFixed,
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Theme.of(context).colorScheme.primaryFixed,
                        width: 10.0)),
                child: ClipOval(
                  child:
                      Image.asset('assets/images/g23.png', fit: BoxFit.cover),
                )),
          ],
        ),
        SizedBox(
          height: 40,
        ),
        _form(context)
      ],
    ));
  }

  Widget _buildBody(BuildContext context) {
    return Stack(
      children: [
        Positioned(
            top: 0, // Coloca el widget en la parte inferior
            left: 0, // Alinea al inicio del eje horizontal
            right: 0, // Alinea al final del eje horizontal
            child: _layer1(context)),
        Positioned(
            top: 0, // Coloca el widget en la parte inferior
            left: 0, // Alinea al inicio del eje horizontal
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              iconSize: 30.0, // Tamaño del icono
              color: Theme.of(context)
                  .colorScheme
                  .onTertiaryContainer, // Color del icono
              onPressed: () {
                // Acción cuando se presiona el botón
                print('Botón con ícono "Agregar" presionado');
              },
            ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: null,
            body: _buildBody(context)));
  }
}
