import 'dart:convert';
import 'screen_sellerPanel.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'screen_adminPanel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'const_var.dart';

// ignore: must_be_immutable
class ByType extends StatelessWidget {
  final List<String> nom;
  final int currentPage;
  final int nombreItem;
  final String whichStock;
  final int magasinNumber;
  final List<String> label;
  final List<TextEditingController> allController;
  String magasinName = "ERROR";
  bool isAdmin;
  // ignore: use_key_in_widget_constructors
  ByType(this.nom, this.currentPage, this.nombreItem, this.allController,
      this.whichStock, this.magasinNumber, this.label,
      [this.isAdmin = false]);

  var tranformToPHP = [
    'categorie1',
    'categorie2',
    'categorie3',
    'categorie4',
    'categorie5',
    'categorie6',
    'categorie7',
    'categorie8',
    'categorie9',
    'categorie10',
    'invendable',
  ];

  getStock() {
    switch (whichStock) {
      case 'Epicea':
        {
          return getItems("/PHP/getEpicea.php");
        }
      case 'Nordmann':
        {
          return getItems("/PHP/getNordmann.php");
        }
      case 'Nobilis':
        {
          return getItems("/PHP/getNobilis.php");
        }
      case 'Fraseri':
        {
          return getItems("/PHP/getFraseri.php");
        }
      case 'Pots':
        {
          return getItems("/PHP/getPots.php");
        }
      case 'Floques':
        {
          return getItems("/PHP/getFloques.php");
        }
      case 'Buche':
        {
          return getItems("/PHP/getBuche.php");
        }
    }
  }

  resetController() {
    for (int i = 0; i <= 11; i++) {
      allController[i].text = '0';
    }
  }

  setController(int value, dynamic result) {
    for (int i = 0; i <= value; i++) {
      allController[i].text = result[(i + 1).toString()];
    }
  }

  Future<List> getItems(String path) async {
    String domaine = "le-petit-palais.com";
    String linkToPhp = path;
    var data = {
      "id": magasinNumber.toString(),
    };
    var response = await http.post(
      Uri.https(domaine, linkToPhp),
      body: data,
    );

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        var result = jsonDecode(response.body);
        if (result == false) {
          resetController();
          return ['ERROR'];
        }
        setController(nom.length - 1, result);
        return ['GOOD'];
      }
      return [];
    } else {
      throw Exception('Erreur connection serveur.');
    }
  }

  Future<List> getMagasin() async {
    String domaine = "le-petit-palais.com";
    String linkToPhp = "PHP/getMagasin.php";
    var data = {
      "id": magasinNumber.toString(),
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
        magasinName = result[magasinNumber][0];
        return ["GOOD"];
      }
      return [];
    } else {
      throw Exception('Erreur connection serveur.');
    }
  }

  Future<List> getListMagasin() async {
    String domaine = "le-petit-palais.com";
    String linkToPhp = "PHP/getMagasin.php";
    var data = {
      "id": magasinNumber.toString(),
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

  Future<List> getTotal(String cat, String table) async {
    String domaine = "le-petit-palais.com";
    String linkToPhp = "PHP/getTotal.php";
    var data = {
      "cat": cat,
      "table": table,
    };
    var response = await http.post(
      Uri.https(domaine, linkToPhp),
      body: data,
    );

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        var result = jsonDecode(response.body);
        var debug = "REsult + $result";
        debugPrint(debug);
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

  Future<List> getNumber(String cat, String table) async {
    String domaine = "le-petit-palais.com";
    String linkToPhp = "PHP/getNumber.php";
    var data = {
      "cat": cat,
      "table": table,
    };
    var response = await http.post(
      Uri.https(domaine, linkToPhp),
      body: data,
    );

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        var result = jsonDecode(response.body);
        var debug = "REsult + $result";
        debugPrint(debug);
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

  Widget _buildPopupDialog(BuildContext context, String label, String nom) {
    return AlertDialog(
      title: const Text('Nombre / Magasin'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FutureBuilder<List>(
              future: getListMagasin(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SizedBox(
                    width: 300,
                    height: 300,
                    child: ListView.builder(
                      itemCount: snapshot.data?.length,
                      controller: ScrollController(),
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            Text(snapshot.data?[index][0]),
                            FutureBuilder<List>(
                                future: getNumber(label, nom),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Align(
                                        alignment: Alignment.topRight,
                                        child:
                                            Text(snapshot.data?[index]['0']));
                                  } else {
                                    return const Padding(
                                      padding: EdgeInsets.only(bottom: 50),
                                      child: SizedBox(
                                          height: 64,
                                          width: 64,
                                          child: Center(
                                              child:
                                                  CircularProgressIndicator())),
                                    );
                                  }
                                })
                          ],
                        );
                      },
                    ),
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
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Fermer'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double widht = MediaQuery.of(context).size.width;
    return Column(
      children: <Widget>[
        Expanded(
          key: UniqueKey(),
          child: FutureBuilder<List>(
              future: getStock(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Stack(
                    children: [
                      FutureBuilder<List>(
                          future: getMagasin(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Align(
                                alignment: const Alignment(0, -0.95),
                                child: Text(
                                  "TOTAL",
                                  style: magasinTextStyle,
                                ),
                              );
                            }
                            return const Padding(
                              padding: EdgeInsets.only(bottom: 50),
                              child: SizedBox(
                                  height: 64,
                                  width: 64,
                                  child: Center(
                                      child: CircularProgressIndicator())),
                            );
                          }),
                      ListView.builder(
                          itemCount: nombreItem,
                          controller: ScrollController(),
                          padding: const EdgeInsets.only(top: 60),
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Container(
                                    child: Stack(
                                      children: [
                                        Align(
                                          alignment: const Alignment(5, -0.65),
                                          child: ConstrainedBox(
                                            constraints:
                                                BoxConstraints.tightFor(
                                                    width: widht - 100),
                                            child: Text(
                                              "Qty",
                                              style: itemsTextStyle,
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: const Alignment(-1, -0.6),
                                          child: ConstrainedBox(
                                            constraints:
                                                BoxConstraints.tightFor(
                                                    width: widht - 100),
                                            child: Text(
                                              label[index],
                                              style: itemsTextStyle,
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: const Alignment(0, 0.6),
                                          child: ConstrainedBox(
                                            constraints:
                                                BoxConstraints.tightFor(
                                                    width: widht - 100),
                                            child: Text(
                                              nom[index],
                                              style: itemsTextStyle,
                                            ),
                                          ),
                                        ),
                                        FutureBuilder<List>(
                                            future: getTotal(
                                                tranformToPHP[index],
                                                whichStock.toLowerCase()),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                return Align(
                                                  alignment: const Alignment(
                                                      0.95, 0.60),
                                                  child: AnimatedButton(
                                                    onPress: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                                context) =>
                                                            _buildPopupDialog(
                                                                context,
                                                                tranformToPHP[
                                                                    index],
                                                                whichStock
                                                                    .toLowerCase()),
                                                      );
                                                    },
                                                    height: 70,
                                                    width: 100,
                                                    text: snapshot.data?[0]
                                                        ['0'],
                                                    isReverse: true,
                                                    selectedTextColor:
                                                        Colors.white,
                                                    transitionType:
                                                        TransitionType
                                                            .LEFT_TOP_ROUNDER,
                                                    textStyle: submitTextStyle,
                                                    backgroundColor:
                                                        Colors.black38,
                                                    selectedBackgroundColor:
                                                        Colors.black38,
                                                    borderColor: Colors.white,
                                                    borderWidth: 1,
                                                  ),
                                                );
                                              } else {
                                                return const Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 50),
                                                  child: SizedBox(
                                                      height: 64,
                                                      width: 64,
                                                      child: Center(
                                                          child:
                                                              CircularProgressIndicator())),
                                                );
                                              }
                                            }),
                                      ],
                                    ),
                                    height: 150,
                                    color: const Color(0xff171717),
                                  ),
                                )
                              ],
                            );
                          }),
                      PositionedDirectional(
                          top: 10,
                          start: 10,
                          child: BackButton(
                            color: Colors.white,
                            onPressed: () {
                              if (isAdmin) {
                                Navigator.of(context)
                                    .pushReplacement(MaterialPageRoute(
                                  builder: (context) => AdminPanel(0, 0),
                                ));
                              } else {
                                Navigator.of(context)
                                    .pushReplacement(MaterialPageRoute(
                                  builder: (context) => const SelectScreen(0),
                                ));
                              }
                            },
                          )),
                    ],
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
      ],
    );
  }
}
