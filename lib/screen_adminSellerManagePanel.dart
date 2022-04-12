import 'dart:convert';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'screen_adminPanel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'const_var.dart';

// ignore: must_be_immutable
class VnedeurList extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controllerPass = TextEditingController();
  var name;
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

  Future<String> getMagasinByVendeur(String vendeurname) async {
    String domaine = "le-petit-palais.com";
    String linkToPhp = "PHP/getMagasinByVendeur.php";
    var data = {
      "email": vendeurname,
    };
    var response = await http.post(
      Uri.https(domaine, linkToPhp),
      body: data,
    );

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        var result = jsonDecode(response.body);
        debugPrint(result.toString());
        return result['nom'];
      }
      return "Aucun Magasin";
    } else {
      throw Exception('Erreur connection serveur.');
    }
  }

  Future<void> changeMagasinVendeur(
      String vendeurname, String newMagasin) async {
    String domaine = "le-petit-palais.com";
    String linkToPhp = "PHP/changeMagasin.php";
    var data = {
      "email": vendeurname,
      "magasin": newMagasin,
    };
    await http.post(
      Uri.https(domaine, linkToPhp),
      body: data,
    );
  }

  Future<void> changePassVendeur(String vendeurname, String pass) async {
    String domaine = "le-petit-palais.com";
    String linkToPhp = "PHP/changePassUsers.php";
    var data = {
      "email": vendeurname,
      "pass": pass,
    };
    await http.post(
      Uri.https(domaine, linkToPhp),
      body: data,
    );
  }

  Future<List> getLIstVendeur() async {
    String domaine = "le-petit-palais.com";
    String linkToPhp = "PHP/getVendeur.php";
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

  Future<void> createVendeur(String name, String pass) async {
    String domaine = "le-petit-palais.com";
    String linkToPhp = "PHP/createVendeur.php";
    var data = {
      "email": name,
      "pass": pass,
      "id": (-1).toString(),
    };
    await http.post(
      Uri.https(domaine, linkToPhp),
      body: data,
    );
  }

  Future<void> deleteMagasin(String vendeurEmail) async {
    String domaine = "le-petit-palais.com";
    String linkToPhp = "PHP/deleteVendeur.php";
    var data = {
      "email": vendeurEmail,
    };
    await http.post(
      Uri.https(domaine, linkToPhp),
      body: data,
    );
  }

  Widget _buildMagasinButton(BuildContext context, String vendeurEmail) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        title: const Text('Menu'),
        actions: <Widget>[
          TextButton(
            child: const Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
                height: height - 200,
                width: width,
                child: Column(
                  children: [
                    FutureBuilder<String>(
                      future: getMagasinByVendeur(vendeurEmail),
                      builder: (context, snapshot) {
                        Future.delayed(
                            const Duration(milliseconds: 1000), () {});
                        // ARRETER
                        if (snapshot.hasData) {
                          name = snapshot.data!;
                          return const Text("");
                        } else {
                          name = "";
                          return const Text("Aucun magasin");
                        }
                      },
                    ),
                    FutureBuilder<List>(
                        future: getListMagasin(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data?.length,
                              controller: ScrollController(),
                              itemBuilder: (context, index) {
                                var color = Colors.black38;
                                if (snapshot.data?[index][0] == name) {
                                  color = Colors.blue;
                                }
                                return AnimatedButton(
                                  onPress: () {
                                    debugPrint(snapshot.data?[index][0]);
                                    debugPrint(vendeurEmail);
                                    changeMagasinVendeur(
                                        vendeurEmail, snapshot.data?[index][0]);
                                    Future.delayed(
                                        const Duration(milliseconds: 460), () {
                                      Navigator.of(context).pop();
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              _buildMagasinButton(
                                                context,
                                                vendeurEmail,
                                              ));
                                    });
                                  },
                                  height: 40,
                                  width: width,
                                  text: snapshot.data?[index][0],
                                  isReverse: true,
                                  selectedTextColor: Colors.black,
                                  transitionType:
                                      TransitionType.LEFT_TOP_ROUNDER,
                                  textStyle: submitTextStyle,
                                  backgroundColor: color,
                                  selectedBackgroundColor: Colors.white,
                                  borderColor: Colors.white,
                                  borderWidth: 1,
                                );
                              },
                            );
                          }
                          return const Padding(
                            padding: EdgeInsets.only(bottom: 50),
                            child: SizedBox(
                                height: 64,
                                width: 64,
                                child:
                                    Center(child: CircularProgressIndicator())),
                          );
                        })
                  ],
                ))
          ],
        ));
  }

  Widget _buildAreUSure(BuildContext context, String vendeurEmail) {
    return AlertDialog(
        title: const Text('Validation'),
        actions: <Widget>[
          TextButton(
            child: const Text('Oui'),
            onPressed: () {
              deleteMagasin(vendeurEmail);
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
            Text("Voulez-vous supprimer le vendeur ?"),
          ],
        ));
  }

  Widget _buildChangePass(BuildContext context, String vendeurEmail) {
    return AlertDialog(
        title: const Text('Modification Vendeur'),
        actions: <Widget>[
          TextButton(
            child: const Text('Valider'),
            onPressed: () {
              changePassVendeur(vendeurEmail, _controllerPass.text);
              Navigator.of(context).pop();
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
            const SizedBox(height: 10),
            TextField(
              controller: _controllerPass,
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
                hintText: "Nouveau pass",
                hintStyle: TextStyle(color: Colors.black),
                filled: true,
              ),
            ),
          ],
        ));
  }

  Widget _buildaddVendeur(BuildContext context) {
    return AlertDialog(
        title: const Text('Création Vendeur'),
        actions: <Widget>[
          TextButton(
            child: const Text('Valider'),
            onPressed: () {
              createVendeur(_controller.text, _controllerPass.text);
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
                hintText: "Nom Vendeur",
                hintStyle: TextStyle(color: Colors.black),
                filled: true,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _controllerPass,
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
                hintText: "Mots de passe",
                hintStyle: TextStyle(color: Colors.black),
                filled: true,
              ),
            ),
          ],
        ));
  }

  Widget _buildMenu(BuildContext context, String vendeurEmail) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        title: const Text('Menu'),
        actions: <Widget>[
          TextButton(
            child: const Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                height: height - 200,
                width: width,
                child: Column(
                  children: [
                    AnimatedButton(
                      onPress: () {
                        Future.delayed(const Duration(milliseconds: 460), () {
                          Navigator.of(context).pop();
                          showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  _buildChangePass(
                                    context,
                                    vendeurEmail,
                                  ));
                        });
                      },
                      height: 40,
                      width: width,
                      text: 'MODIFIER PASS',
                      isReverse: true,
                      selectedTextColor: Colors.black,
                      transitionType: TransitionType.LEFT_TOP_ROUNDER,
                      textStyle: submitTextStyle,
                      backgroundColor: Colors.black38,
                      selectedBackgroundColor: Colors.white,
                      borderColor: Colors.white,
                      borderWidth: 1,
                    ),
                    AnimatedButton(
                      onPress: () {
                        Future.delayed(const Duration(milliseconds: 460), () {
                          Navigator.of(context).pop();
                          showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  _buildMagasinButton(
                                    context,
                                    vendeurEmail,
                                  ));
                        });
                      },
                      height: 40,
                      width: width,
                      text: 'MAGASIN ASSIGNE',
                      isReverse: true,
                      selectedTextColor: Colors.black,
                      transitionType: TransitionType.LEFT_TOP_ROUNDER,
                      textStyle: submitTextStyle,
                      backgroundColor: Colors.black38,
                      selectedBackgroundColor: Colors.white,
                      borderColor: Colors.white,
                      borderWidth: 1,
                    ),
                  ],
                ))
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
              future: getLIstVendeur(),
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
                                  Align(
                                      alignment: const Alignment(0.75, 0),
                                      child: IconButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  _buildMenu(
                                                    context,
                                                    snapshot.data?[index][0],
                                                  ));
                                        },
                                        icon: const Icon(
                                          Icons.menu,
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
                builder: (BuildContext context) => _buildaddVendeur(
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
