import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/entities/quiz.dart';
import '../../models/service_http_response.dart';
import '../../services/quiz_service.dart';

class HomeController extends GetxController {
  QuizService service = QuizService();
  var quizzes = <Quiz>[].obs;

  void initialFetch(BuildContext context) async {
    Future<ServiceHttpResponse?> response = service.fetchAll();
    ServiceHttpResponse? result = await response;
    if(result == null){
      print('no hay respuesta del servidor');
    }else{
      if(result.status == 200){
        quizzes.value = result.body; // estoy sacando la lista de quizzes
      }else{
        print('error en la respuesta de servidor');
      }
    }
  }
}
