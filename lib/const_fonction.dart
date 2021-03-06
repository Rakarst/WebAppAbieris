import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List> getData(var data) async {
  String domaine = "le-petit-palais.com";
  String linkToPhp = "PHP/AllPHP.php";
  var response = await http.post(
    Uri.https(domaine, linkToPhp),
    body: data,
  );
  if (response.statusCode == 200) {
    if (response.body.isNotEmpty) {
      var result = jsonDecode(response.body);
      debugPrint(result.toString());
      return result;
    }
    return [];
  } else {
    throw Exception('Erreur connection serveur.');
  }
}

Future<void> setData(String sql,
    {String id = "",
    String email = "",
    String pass = "",
    String magasin = "",
    String objectif = "",
    var data}) async {
  String domaine = "le-petit-palais.com";
  String linkToPhp = "PHP/AllPHP.php";
  var data = {
    "id": id,
    "email": email,
    "pass": pass,
    "objectif": objectif,
    "magasin": magasin,
    "SQL": sql,
  };
  await http.post(
    Uri.https(domaine, linkToPhp),
    body: data,
  );
}
