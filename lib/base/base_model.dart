import 'package:http/http.dart';

class BaseModel {
  static Client client = Client();

  getClient() {
    return client;
  }

  dispose() {
    client.close();
  }
}
