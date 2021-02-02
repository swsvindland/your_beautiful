import 'package:http/http.dart' as http;
import '../config.dart';

class Api {
  static Future<String> getMessage() async {
    try {
      final response = await http.get('$apiUrl/getMessageOfTheDayHttp');

      return response.body;
    } catch (error) {
      throw Error();
    }
  }
}
