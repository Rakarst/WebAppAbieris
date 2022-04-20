import 'dart:convert';
import 'package:abieris/const_fonction.dart';

import 'screen_bothStockPanel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'const_var.dart';
import 'screen_sellerLogin.dart';

List<String> magasinList = [];

class SelectScreen extends StatefulWidget {
  final int id;
  const SelectScreen(this.id);

  @override
  _SelectScreenState createState() => _SelectScreenState();
}

class _SelectScreenState extends State<SelectScreen> {
  List<String>? selectedMagasinList = [];
  bool isSelected = false;
  bool isSet = false;
  String name = "";
  late final Future<List> magasin = getMagasin();
  Future<List> getMagasin() async {
    String domaine = "le-petit-palais.com";
    String linkToPhp = "PHP/getMagasinById.php";
    var data = {
      "id": widget.id.toString(),
    };
    var response = await http.post(
      Uri.https(domaine, linkToPhp),
      body: data,
    );

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        var result = jsonDecode(response.body);
        debugPrint(result.toString());
        if (result == false) {
          return ["EROOR"];
        }
        name = result['nom'];
        return [name];
      }
      return [];
    } else {
      throw Exception('Erreur connection serveur.');
    }
  }

  Future<void> createReview(String date, String magasin) async {
    String domaine = "le-petit-palais.com";
    String linkToPhp = "PHP/createReview.php";
    debugPrint(date);
    var data = {"date": date, "magasin": magasin};
    await http.post(
      Uri.https(domaine, linkToPhp),
      body: data,
    );
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
            FutureBuilder(
                future: getMagasin(),
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    return SizedBox(
                        height: height - 200,
                        width: width,
                        child: Column(
                          children: [
                            FutureBuilder<List>(
                                future: getHistorique(name),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: snapshot.data?.length,
                                      controller: ScrollController(),
                                      itemBuilder: (context, index) {
                                        var color = Colors.black38;

                                        if (snapshot.data?[index]
                                                    [1] ==
                                                "0000-00-00" ||
                                            snapshot.data?[index][1] ==
                                                "0002-00-00" ||
                                            snapshot.data?[index][1] ==
                                                "0001-00-00") {
                                          return const SizedBox.shrink();
                                        }
                                        return AnimatedButton(
                                          onPress: () {
                                            debugPrint(
                                                snapshot.data?[index][0]);

                                            Future.delayed(
                                                const Duration(
                                                    milliseconds: 460), () {
                                              Navigator.of(context).pop();
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              StockScreen(
                                                                  0,
                                                                  int.parse(
                                                                    snapshot.data?[
                                                                        index][0],
                                                                  ),
                                                                  snapshot.data?[
                                                                          index]
                                                                      [1])));
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
                                        child: Center(
                                            child:
                                                CircularProgressIndicator())),
                                  );
                                })
                          ],
                        ));
                  } else {
                    return const Text("Erreur");
                  }
                })),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xff171717),
      body: Align(
          child: Container(
              height: height / 1.3,
              width: width / 1.3,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0),
                    bottomLeft: Radius.circular(40.0),
                    bottomRight: Radius.circular(40.0),
                  )),
              child: Stack(
                children: [
                  FutureBuilder<List>(
                      future: getData(widget.id.toString(), "infoVendeur"),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Stack(
                            children: <Widget>[
                              Align(
                                alignment: const Alignment(0, -0.85),
                                child: Text(
                                  snapshot.data![0].toString(),
                                  style: NomPrenom,
                                ),
                              ),
                              Align(
                                alignment: const Alignment(0, -0.70),
                                child: Text(
                                  snapshot.data![1].toString(),
                                  style: Objectif,
                                ),
                              ),
                              Align(
                                alignment: const Alignment(0, -0.45),
                                child: Text(
                                  "Objectif de Vente",
                                  style: Objectif,
                                ),
                              ),
                              Align(
                                child: Container(
                                  height: height / 17,
                                  width: width / 1.5,
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(40.0),
                                        topRight: Radius.circular(40.0),
                                        bottomLeft: Radius.circular(40.0),
                                        bottomRight: Radius.circular(40.0),
                                      ),
                                      border: Border.all(
                                          width: 1.5, color: Colors.black)),
                                ),
                                alignment: const Alignment(0, -0.3),
                              ),
                              Align(
                                child: Container(
                                    height: height / 18,
                                    width: (width / 1.51) /
                                        (int.parse(
                                                snapshot.data![2].toString()) /
                                            int.parse(
                                                snapshot.data![3].toString())),
                                    decoration: const BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(40.0),
                                        topRight: Radius.circular(40.0),
                                        bottomLeft: Radius.circular(40.0),
                                        bottomRight: Radius.circular(40.0),
                                      ),
                                    )),
                                alignment: const Alignment(0, -0.298),
                              ),
                              Align(
                                child: Text(snapshot.data![3].toString() +
                                    " / " +
                                    snapshot.data![2].toString()),
                                alignment: const Alignment(0, -0.285),
                              ),
                              Align(
                                alignment: const Alignment(0, 0.25),
                                child: AnimatedButton(
                                  isSelected: isSelected,
                                  onPress: () {
                                    Future.delayed(Duration(milliseconds: 460),
                                        () {
                                      if (widget.id != -1) {
                                        DateTime now = DateTime.now();
                                        String formattedDate =
                                            DateFormat('yyyy-MM-dd')
                                                .format(now);
                                        createReview(formattedDate, name);
                                        Navigator.of(context)
                                            .pushReplacement(MaterialPageRoute(
                                          builder: (context) => StockScreen(
                                              0, widget.id, formattedDate),
                                        ));
                                      }
                                    });
                                  },
                                  borderRadius: 15,
                                  height: height / 8,
                                  width: width / 2,
                                  text: 'CREER VENTE',
                                  isReverse: true,
                                  selectedTextColor: Colors.black,
                                  transitionType:
                                      TransitionType.LEFT_TOP_ROUNDER,
                                  textStyle: submitTextStyle,
                                  backgroundColor: Colors.black87,
                                  selectedBackgroundColor: Colors.white,
                                  borderColor: Colors.black,
                                  borderWidth: 1,
                                ),
                              ),
                              Align(
                                alignment: const Alignment(0, 0.75),
                                child: AnimatedButton(
                                  isSelected: isSelected,
                                  onPress: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            _buildHistoriqueView(
                                                context, name));
                                  },
                                  height: height / 8,
                                  width: width / 2,
                                  text: 'HISTORIQUE',
                                  isReverse: true,
                                  borderRadius: 15,
                                  selectedTextColor: Colors.black,
                                  transitionType:
                                      TransitionType.LEFT_TOP_ROUNDER,
                                  textStyle: submitTextStyle,
                                  backgroundColor: Colors.black87,
                                  selectedBackgroundColor: Colors.white,
                                  borderColor: Colors.black,
                                  borderWidth: 1,
                                ),
                              ),
                            ],
                          );
                        }
                        return const Align(
                          alignment: Alignment(0, -0.5),
                          child: CircularProgressIndicator(),
                        );
                      }),
                  Align(
                    alignment: const Alignment(-0.95, -0.95),
                    child: BackButton(
                      color: Colors.black,
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ));
                      },
                    ),
                  )
                ],
              ))),
    );
  }
}
