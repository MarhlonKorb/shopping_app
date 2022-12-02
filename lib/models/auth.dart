import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shop/exceptions/auth_exception.dart';

class Auth with ChangeNotifier {

  Future<void> _authenticate(
      String email, String password, String urlFragment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlFragment?key=AIzaSyA4bTcMtGMsRHseKePo2iLM4u-LSN7cYW0';
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode(
          {'email': email, 'password': password, 'returnSecureToken': true}),
    );

    final body = jsonDecode(response.body);
    // Valida se ocorreu uma excessão
    if (body['error'] != null) {
      // Pega a mensagem do objeto de erro retornado
      throw AuthException(body['error']['message']);
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }
}
