import '../models/service_http_response.dart';
import '../models/entities/user.dart';

class UserService {
  Future<ServiceHttpResponse?> signIn(User u) async {
    ServiceHttpResponse serviceResponse = ServiceHttpResponse();
    if (u.username == 'admin' && u.password == '123') {
      serviceResponse.status = 200;
      serviceResponse.body = 'ok';
    } else {
      serviceResponse.status = 401;
      serviceResponse.body = ':(';
    }
    return serviceResponse;
  }
}
