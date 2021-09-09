import 'dart:convert';

class ApiEndpoints{
  static const basUrl = "https://909f-49-36-97-105.ngrok.io/";
  static const username = 'user';
  static const password = '8abab8ac-965e-4a4b-a50c-e10582f29bcd';
   String basicAuth =
      'Basic ${base64Encode(utf8.encode('$username:$password'))}';
}