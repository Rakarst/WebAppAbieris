import 'dart:convert';
import 'package:abieris/screen_bothStockPanel.dart';

import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'const_var.dart';
import 'main.dart';

var itemsTextStyle = GoogleFonts.nunito(
    fontSize: 20,
    letterSpacing: 5,
    color: Colors.white,
    fontWeight: FontWeight.w300);

// ignore: must_be_immutable
class MagasinView extends StatelessWidget {
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

  Future<List> getHistorique(String magasinName) async {
    String domaine = "le-petit-palais.com";
    String linkToPhp = "PHP/getHistorique.php";
    var data = {
      "magasin": magasinName,
    };
    var response = await http.post(
      Uri.https(domaine, linkToPhp),
      body: data,
    );

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        var result = jsonDecode(response.body);

        return result;
      }
      return [];
    } else {
      throw Exception('Erreur connection serveur.');
    }
  }

  Future<List> getIdMagasin(String magasinName) async {
    var data = {
      "nom": magasinName,
    };
    var response = await http.post(
      Uri.https(site, "PHP/getId.php"),
      body: data,
    );
    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        var result = jsonDecode(response.body);
        return result;
      }
      return [];
    } else {
      throw Exception('Erreur connection serveur.');
    }
  }

  Widget _buildHistoriqueView(BuildContext context, String magasinName) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        title: const Text('Historique'),
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
                        future: getHistorique(magasinName),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data?.length,
                              controller: ScrollController(),
                              itemBuilder: (context, index) {
                                var color = Colors.black38;

                                if (snapshot.data?[index][1] == "0001-00-00" ||
                                    snapshot.data?[index][1] == "0002-00-00" ||
                                    snapshot.data?[index][1] == "0000-00-00") {
                                  return const SizedBox.shrink();
                                }
                                return AnimatedButton(
                                  onPress: () {
                                    Future.delayed(
                                        const Duration(milliseconds: 460), () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context)
                                          .pushReplacement(MaterialPageRoute(
                                              builder: (context) => StockScreen(
                                                  0,
                                                  int.parse(
                                                    snapshot.data?[index][0],
                                                  ),
                                                  snapshot.data?[index][1],
                                                  true)));
                                    });
                                  },
                                  height: 40,
                                  width: width,
                                  text: snapshot.data?[index][1],
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

  Widget _buildMenu(BuildContext context, String magasinName) {
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
              child: FutureBuilder<List>(
                future: getIdMagasin(magasinName),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        AnimatedButton(
                          onPress: () {
                            Future.delayed(const Duration(milliseconds: 460),
                                () {
                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                      builder: (context) => StockScreen(
                                          0,
                                          int.parse(
                                            snapshot.data?[0],
                                          ),
                                          "0004-00-00",
                                          true)));
                            });
                          },
                          height: 40,
                          width: width,
                          text: 'VOIR STOCK ACTUEL',
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
                            Future.delayed(const Duration(milliseconds: 460),
                                () {
                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                      builder: (context) => StockScreen(
                                          0,
                                          int.parse(
                                            snapshot.data?[0],
                                          ),
                                          "0000-00-00",
                                          true)));
                            });
                          },
                          height: 40,
                          width: width,
                          text: 'MODIFIER STOCK DEPART',
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
                            Future.delayed(const Duration(milliseconds: 460),
                                () {
                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                      builder: (context) => StockScreen(
                                          0,
                                          int.parse(
                                            snapshot.data?[0],
                                          ),
                                          "0001-00-00",
                                          true)));
                            });
                          },
                          height: 40,
                          width: width,
                          text: 'AJOUTER CHANGEMENT STOCK',
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
                            Future.delayed(const Duration(milliseconds: 460),
                                () {
                              Navigator.of(context).pop();
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      _buildHistoriqueView(
                                        context,
                                        magasinName,
                                      ));
                            });
                          },
                          height: 40,
                          width: width,
                          text: 'HISTORIQUE DES VENTES',
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
                    );
                  } else {
                    return const Padding(
                      padding: EdgeInsets.only(bottom: 50),
                      child: SizedBox(
                          height: 64,
                          width: 64,
                          child: Center(child: CircularProgressIndicator())),
                    );
                  }
                },
              ),
            )
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
        Align(
          alignment: Alignment.bottomCenter,
          child: IconButton(
            iconSize: 50,
            icon: const Icon(Icons.close),
            color: Colors.red,
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const MyApp(),
              ));
            },
          ),
        ),
      ],
    );
  }
}
