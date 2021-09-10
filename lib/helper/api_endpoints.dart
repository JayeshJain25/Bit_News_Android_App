import 'dart:convert';

class ApiEndpoints{
  static const basUrl = "http://1690-49-36-101-249.ngrok.io/";
  static const username = 'W\$dbkezShQTa%X0h';
  static const password = 'rEUh68d*5d?a%ALB';
   String basicAuth =
      'Basic ${base64Encode(utf8.encode('$username:$password'))}';
}