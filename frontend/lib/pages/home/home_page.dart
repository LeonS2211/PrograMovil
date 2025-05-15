import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../components/resume_card.dart';
import '../../models/entities/quiz.dart';
import 'home_controller.dart';

class HomePage extends StatelessWidget {
  HomeController control = Get.put(HomeController());

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      //backgroundColor: const Color(0xFF3A2E28),
      title: const Text('Quiz ULima'),
      actions: const [Icon(Icons.more_vert)],
    );
  }

  Widget _buttonNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Theme.of(context).colorScheme.onSecondary,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white60,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Mi Record',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.play_arrow),
          label: 'Nuevo Quiz',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.leaderboard),
          label: 'Ranking',
        ),
      ],
    );
  }

  Widget _myRercod(BuildContext context) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text(
                '22',
                style: TextStyle(
                    fontSize: 24,
                    color: Theme.of(context).colorScheme.onSecondary),
              ),
              Text(
                'Cuestionarios\nRealizados',
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onSecondary),
              ),
            ],
          ),
          Column(
            children: [
              Text(
                '4%',
                style: TextStyle(
                    fontSize: 24,
                    color: Theme.of(context).colorScheme.onSecondary),
              ),
              Text(
                'Porcentaje\nde Aciertos',
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onSecondary),
              ),
            ],
          ),
        ],
      ),
      SizedBox(
        height: 15,
      ),
      Divider(
        color: Theme.of(context).colorScheme.onSecondary, // Color de la línea
        thickness: 1.0, // Grosor de la línea
        indent: 20.0, // Espacio desde el inicio (margen izquierdo)
        endIndent: 20.0, // Espacio desde el final (margen derecho)
      )
    ]);
  }

  Widget _buildBody(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryFixed,
      appBar: _appBar(context),
      bottomNavigationBar: _buttonNavigationBar(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _myRercod(context),
            const SizedBox(height: 24),
           Obx(() {
            return Expanded(
              child: control.quizzes == null || control.quizzes.isEmpty
                  ? Center(
                    child: Text(
                      'No hay quizzes disponibles', 
                      style: TextStyle(fontSize: 18, color: Colors.red))
                    )
                  : ListView.builder(
                      itemCount: control.quizzes.length,
                      itemBuilder: (context, index) {
                        Quiz quiz = control.quizzes[index];
                        return ResumeCard(
                          success: quiz.points,
                          created: quiz.created,
                          description: quiz.statement,
                        );
                      },
                    ),
            );
           }),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.zero, // Esto elimina el radio del borde
                  ),
                ),
                onPressed: () {},
                child: const Text('FILTROS'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    control.initialFetch(context);
    return MaterialApp(
        home: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: null,
            body: _buildBody(context)));
  }
}
