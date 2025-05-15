import 'dart:convert';

import 'package:flutter/services.dart';
import '../models/service_http_response.dart';
import '../models/entities/quiz.dart';

class QuizService {
  Future<ServiceHttpResponse?> fetchAll() async {
    List<Quiz> quizzes = [];
    ServiceHttpResponse serviceResponse = ServiceHttpResponse();
    final String body =
        await rootBundle.loadString('assets/jsons/quizzes.json');
    final List<dynamic> data = jsonDecode(body);
    quizzes =
        data.map((map) => Quiz.fromJson(map as Map<String, dynamic>)).toList();
    serviceResponse.status = 200;
    serviceResponse.body = quizzes;
    return serviceResponse;
  }
}
