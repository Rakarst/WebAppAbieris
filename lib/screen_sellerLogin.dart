import 'package:abieris/screen_sellerPanel.dart';

import 'main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  int id = -1;
  Duration get loginTime => const Duration(milliseconds: 2250);

  Future<String?> _authUser(LoginData data) async {
    var email = data.name;
    var pass = data.password;
    String domaine = "le-petit-palais.com";
    String linkToPhp = "/PHP/auth.php";

    final response = await http.post(Uri.https(domaine, linkToPhp),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: jsonEncode(<String, String>{
          'email': email,
          'pass': pass,
        }),
        encoding: Encoding.getByName("utf-8"));

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        var go = jsonDecode(response.body);
        id = int.parse(go['id']);
        return Future.delayed(loginTime).then((_) {
          return null;
        });
      }
      return "Erreur vérifiez vos identifiants";
    } else {
      throw Exception('Erreur connection serveur.');
    }
  }

  static String? defaultUserValidator(value) {
    if (value!.isEmpty) {
      return 'Erreur';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: '',
      userValidator: defaultUserValidator,
      logo: const AssetImage('assets/images/logo.png'),
      onLogin: _authUser,
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => SelectScreen(id),
        ));
      },
      theme: LoginTheme(
          footerBackgroundColor: Colors.black38,
          primaryColor: const Color(0xff171717)),
      messages: LoginMessages(
        userHint: 'Prenom NOM',
        passwordHint: 'Mots de passe',
        loginButton: 'Connection',
      ),
      onRecoverPassword: (S) {},
      hideForgotPasswordButton: true,
      children: [
        PositionedDirectional(
          top: 10,
          start: 10,
          child: BackButton(
            color: Colors.white,
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const MyApp(),
              ));
            },
          ),
        )
      ],
    );
  }
}
