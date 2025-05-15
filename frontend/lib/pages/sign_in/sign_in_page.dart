import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'sign_in_controller.dart';

class SignInPage extends StatelessWidget {
  SignInController control = Get.put(SignInController());

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
                  controller: control.txtUser,
                  decoration: InputDecoration(
                    labelText: 'Usuario',
                    hintText: 'Usuario',
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    prefixIcon: Icon(Icons.person), // Aquí agregamos el ícono d
                    //border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextField(
                  obscureText: true,
                  controller:
                      control.txtPassword, // Esto oculta el texto ingresado
                  decoration: InputDecoration(
                    hintText: 'Contraseña',
                    prefixIcon: Icon(Icons.lock), // Ícono de candado
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  onPressed: () {
                    // Acción del botón
                    print(':)');
                    control.signIn(context);
                  },
                  child: Text('INGRESAR'),
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
          SizedBox(
            height: 15,
          ),
          Obx(() => control.message.value != ""
              ? Column(
                  children: [
                    Text(
                      control.message.value,
                      style: TextStyle(
                        color: control.messageColor
                            .value, // Aquí puedes poner el color que desees
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    )
                  ],
                )
              : SizedBox.shrink()),
          /**
               * if (control.message.value != "")
               *   Text()
               * else: 
               *    SizedBox
               */
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('No tienes una cuenta, '),
              GestureDetector(
                onTap: () {
                  control.goToSignUp(context);
                },
                child: Text(
                  'creala aquí',
                  style: TextStyle(
                    fontWeight: FontWeight
                        .bold, // Esto hace que el texto sea en negrita
                  ),
                ),
              )
            ],
          )
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
          bottom: 40, // Coloca el widget a 40 píxeles del fondo
          left: 0, // Alinea al inicio del eje horizontal
          right: 0, // Alinea al final del eje horizontal
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center, // Centra el contenido
            children: [
              Text('Olvidaste tu contraseña?, '),
              GestureDetector(
                onTap: () {
                  // Aquí pones la acción que quieres ejecutar cuando el texto sea tocado
                  control.goToResetPassword(context);
                },
                child: Text(
                  'recupérala aquí',
                  style: TextStyle(
                    fontWeight:
                        FontWeight.bold, // Hace que el texto sea en negrita
                  ),
                ),
              ),
            ],
          ),
        ),
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
