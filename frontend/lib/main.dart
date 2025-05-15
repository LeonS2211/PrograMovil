import 'package:flutter/material.dart';
import 'package:helloworld/configs/theme_1.dart';
import 'package:helloworld/configs/util.dart';
import 'package:helloworld/pages/create_account/create_account_page.dart';
import 'package:helloworld/pages/recover_password/recover_password_page.dart';
import './pages/sign_in/sign_in_page.dart';
import 'pages/home/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme =
        createTextTheme(context, 'Abril Fatface', 'Allerta');
    final MaterialTheme materialTheme = MaterialTheme(textTheme);

    return MaterialApp(
        title: 'Flutter Hello World',
        theme: materialTheme.light(),
        darkTheme: materialTheme.dark(),
        themeMode: ThemeMode.system,
        initialRoute: '/sign-in',
        routes: {
          '/sign-in': (context) => SignInPage(),
          '/create-account': (context) => CreateAccountPage(),
          '/recover-password': (context) => RecoverPasswordPage(),
          '/home': (context) => HomePage(),
        });
  }
}
