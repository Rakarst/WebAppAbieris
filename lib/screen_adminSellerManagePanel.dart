import 'dart:convert';
import 'package:abieris/const_fonction.dart';
import 'package:flutter/services.dart';
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

  Widget _buildObjectifView(BuildContext context, String vendeurEmail) {
    return AlertDialog(
        title: const Text('Objectif Vendeur'),
        actions: <Widget>[
          TextButton(
            child: const Text('Valider'),
            onPressed: () {
              setData("changeObjectifVendeur",
                  email: vendeurEmail, objectif: _controllerPass.text);
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
            FutureBuilder<List>(
                future: getData("id", "getObjectif", email: vendeurEmail),
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                        "Objectif vente actuelle : " + snapshot.data?[0]);
                  } else {
                    return const Text("ERREUR");
                  }
                })),
            const SizedBox(height: 10),
            TextField(
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
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
                hintText: "Nouvel Objectif",
                hintStyle: TextStyle(color: Colors.black),
                filled: true,
              ),
            ),
          ],
        ));
  }

  Widget _buildMagasinButton(BuildContext context, String vendeurEmail) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var name;

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
                    FutureBuilder<List>(
                      future: getData("id", "getMagasinByVendeur",
                          email: vendeurEmail),
                      builder: (context, snapshot) {
                        Future.delayed(
                            const Duration(milliseconds: 1000), () {});
                        // ARRETER
                        if (snapshot.hasData) {
                          name = snapshot.data?[0];
                          return const SizedBox.shrink();
                        } else {
                          name = "";
                          return const Text("Aucun magasin");
                        }
                      },
                    ),
                    FutureBuilder<List>(
                        future: getData("id", "getListAllMagasin"),
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
                                    setData("changeMagasinVendeur",
                                        email: vendeurEmail,
                                        magasin: snapshot.data?[index][0]);
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
              setData("deleteVendeur", email: vendeurEmail);
              Navigator.of(context).pop();
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => AdminPanel(3, 0)));
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
              setData("changePassUsers",
                  email: vendeurEmail, pass: _controllerPass.text);
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
              setData("createVendeur",
                  email: _controller.text, pass: _controllerPass.text);
              Navigator.of(context).pop();
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => AdminPanel(3, 0)));
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
                hintText: "Prénom NOM",
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
                      text: 'MOTS DE PASSE',
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
                      text: 'ASSIGNATION',
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
                                  _buildObjectifView(
                                    context,
                                    vendeurEmail,
                                  ));
                        });
                      },
                      height: 40,
                      width: width,
                      text: 'OBJECTIF',
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
    return Column(
      children: <Widget>[
        Expanded(
          key: UniqueKey(),
          child: FutureBuilder<List>(
              future: getData("id", "getListVendeur"),
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
