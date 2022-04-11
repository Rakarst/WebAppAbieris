import 'dart:convert';
import 'search_store.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'admin_panel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

var itemsTextStyle = GoogleFonts.nunito(
    fontSize: 20,
    letterSpacing: 5,
    color: Colors.white,
    fontWeight: FontWeight.w300);

// ignore: must_be_immutable
class MagasinList extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  Future<List> getListMagasin() async {
    String domaine = "le-petit-palais.com";
    String linkToPhp = "PHP/getMagasin.php";
    var data = {
      "id": 0.toString(),
    };
    var response = await http.post(
      Uri.https(domaine, linkToPhp),
      body: data,
    );

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        var result = jsonDecode(response.body);

        if (result == false) {
          return ["EROOR"];
        }

        return result;
      }
      return [];
    } else {
      throw Exception('Erreur connection serveur.');
    }
  }

  Future<void> createStore(String name) async {
    String domaine = "le-petit-palais.com";
    String linkToPhp = "PHP/createMagasin.php";
    var data = {
      "name": name,
    };
    await http.post(
      Uri.https(domaine, linkToPhp),
      body: data,
    );
  }

  Future<void> deleteMagasin(String magasinName) async {
    String domaine = "le-petit-palais.com";
    String linkToPhp = "PHP/deleteMagasin.php";
    var data = {
      "nom": magasinName,
    };
    await http.post(
      Uri.https(domaine, linkToPhp),
      body: data,
    );
  }

  Widget _buildAreUSure(BuildContext context, String magasinName) {
    return AlertDialog(
        title: const Text('Validation'),
        actions: <Widget>[
          TextButton(
            child: const Text('Oui'),
            onPressed: () {
              deleteMagasin(magasinName);
              Navigator.of(context).pop();
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => AdminPanel(2, 0)));
            },
          ),
          TextButton(
            child: const Text('Annuler'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const <Widget>[
            Text("Voulez-vous supprimer le magasin ?"),
          ],
        ));
  }

  Widget _buildaddMagasin(BuildContext context) {
    return AlertDialog(
        title: const Text('Création Magasin'),
        actions: <Widget>[
          TextButton(
            child: const Text('Valider'),
            onPressed: () {
              createStore(_controller.text);
              Navigator.of(context).pop();
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => AdminPanel(2, 0)));
            },
          ),
          TextButton(
            child: const Text('Annuler'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.black),
              cursorColor: Colors.black,
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                helperStyle: TextStyle(color: Colors.black),
                focusColor: Colors.black,
                hintText: "Nom Magasin",
                hintStyle: TextStyle(color: Colors.black),
                filled: true,
              ),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    double widht = MediaQuery.of(context).size.width;

    return Column(
      children: <Widget>[
        Expanded(
          key: UniqueKey(),
          child: FutureBuilder<List>(
              future: getListMagasin(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data?.length,
                    controller: ScrollController(),
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Container(
                              child: Stack(
                                children: [
                                  Align(
                                      alignment: const Alignment(0.95, 0),
                                      child: IconButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  _buildAreUSure(
                                                    context,
                                                    snapshot.data?[index][0],
                                                  ));
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 1),
                                    child: SizedBox(
                                      height: 100,
                                      child: Align(
                                        alignment: const Alignment(-1, 0.1),
                                        child: Text(
                                          snapshot.data?[index][0],
                                          style: itemsTextStyle,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              height: 100,
                              color: const Color(0xff171717),
                            ),
                          )
                        ],
                      );
                    },
                  );
                }
                return const Padding(
                  padding: EdgeInsets.only(bottom: 50),
                  child: SizedBox(
                      height: 64,
                      width: 64,
                      child: Center(child: CircularProgressIndicator())),
                );
              }),
        ),
        AnimatedButton(
          onPress: () {
            showDialog(
                context: context,
                builder: (BuildContext context) => _buildaddMagasin(
                      context,
                    ));
          },
          height: 70,
          width: 150,
          text: 'AJOUTER',
          isReverse: true,
          selectedTextColor: Colors.white,
          transitionType: TransitionType.LEFT_TOP_ROUNDER,
          textStyle: submitTextStyle,
          backgroundColor: Colors.black38,
          selectedBackgroundColor: Colors.black38,
          borderColor: Colors.white,
          borderWidth: 1,
        ),
      ],
    );
  }
}
