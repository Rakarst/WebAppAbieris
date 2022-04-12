import 'dart:convert';
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

                                        if (snapshot.data?[index][1] ==
                                                "0000-00-00" ||
                                            snapshot.data?[index][1] ==
                                                "0000-00-02") {
                                          return const Text("");
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

  Widget _buildVerif(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);

    return AlertDialog(
        title: const Text('Vérifications Informations'),
        actions: <Widget>[
          TextButton(
            child: const Text('Correct'),
            onPressed: () {
              createReview(formattedDate, name);
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => StockScreen(0, widget.id, formattedDate),
              ));
            },
          ),
          TextButton(
            child: const Text('Erreur'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text("Nous sommes le : "),
            Text(formattedDate),
            const Text("Vous êtes rattaché à : "),
            FutureBuilder(
                future: getMagasin(),
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(name);
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
        body: Stack(
          children: [
            Align(
              alignment: const Alignment(0, -0.2),
              child: AnimatedButton(
                isSelected: isSelected,
                onPress: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => _buildVerif(
                            context,
                          ));
                },
                height: height / 8,
                width: width / 2,
                text: 'CREER HISTORIQUE',
                isReverse: true,
                selectedTextColor: Colors.black,
                transitionType: TransitionType.LEFT_TOP_ROUNDER,
                textStyle: submitTextStyle,
                backgroundColor: Colors.black38,
                selectedBackgroundColor: Colors.white,
                borderColor: Colors.white,
                borderWidth: 1,
              ),
            ),
            Align(
              alignment: const Alignment(0, 0.2),
              child: AnimatedButton(
                isSelected: isSelected,
                onPress: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          _buildHistoriqueView(context, name));
                },
                height: height / 8,
                width: width / 2,
                text: 'MODIFIER HISTORIQUE',
                isReverse: true,
                selectedTextColor: Colors.black,
                transitionType: TransitionType.LEFT_TOP_ROUNDER,
                textStyle: submitTextStyle,
                backgroundColor: Colors.black38,
                selectedBackgroundColor: Colors.white,
                borderColor: Colors.white,
                borderWidth: 1,
              ),
            ),
            Align(
              alignment: const Alignment(-0.98, -0.98),
              child: BackButton(
                color: Colors.white,
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ));
                },
              ),
            )
          ],
        ));
  }
}
