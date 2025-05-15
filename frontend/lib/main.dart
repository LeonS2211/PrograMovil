import 'package:flutter/material.dart';
import 'package:helloworld/configs/theme_1.dart';
import 'package:helloworld/configs/util.dart';
import 'package:helloworld/pages/add_service/add_service_page.dart';
import 'package:helloworld/pages/financial_statement/financial_statement_page.dart';
import 'package:helloworld/pages/invoices/invoices_page.dart';
import 'package:helloworld/pages/register_service/register_service_page.dart';
import 'package:helloworld/pages/select_company/select_company_page.dart';
import 'package:helloworld/pages/view_companies/view_companies_page.dart';
import 'package:helloworld/pages/view_contacts/view_contacts_page.dart';
import 'package:helloworld/pages/view_dependencies/view_dependencies_page.dart';
import './pages/sign_in/sign_in_page.dart';

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
          '/select-company': (context) => SelectCompanyPage(),
          '/financial-statement': (context) => FinancialStatementPage(),
          '/invoices': (context) => InvoicesPage(),
          '/add-service': (context) => AddServicePage(),
          '/register-service': (context) => RegisterServicePage(),
          '/view-companies': (context) => ViewCompaniesPage(),
          '/view-dependencies': (context) => ViewDependenciesPage(),
          '/view-contacts': (context) => ViewContactsPage(),
        });
  }
}
