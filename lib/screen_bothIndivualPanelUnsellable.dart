import 'dart:convert';
import 'package:abieris/const_fonction.dart';
import 'package:abieris/screen_bothStockPanelUnsellable.dart';

import 'screen_adminPanel.dart';
import 'screen_sellerPanel.dart';
import 'screen_bothStockPanel.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'const_var.dart';

class UnsellableStock extends StatefulWidget {
  final List<String> nom;
  final int currentPage;
  final int nombreItem;
  final String whichStock;
  final int magasinNumber;
  final List<String> label;
  final List<TextEditingController> allController;
  late String date;
  final String previousDate;
  String magasinName = "ERROR";
  bool isAdmin;
  // ignore: use_key_in_widget_constructors
  UnsellableStock(
      this.nom,
      this.currentPage,
      this.nombreItem,
      this.allController,
      this.whichStock,
      this.magasinNumber,
      this.label,
      this.date,
      this.previousDate,
      [this.isAdmin = false]);

  @override
  State<StatefulWidget> createState() => _UnsellableStock();
}

// ignore: must_be_immutable
class _UnsellableStock extends State<UnsellableStock> {
  bool isEnable = true;
  late final Future<List> items = getStock();
  late final Future<List> magasin =
      getData({"id": widget.magasinNumber.toString(), "SQL": "getMagasinName"});
  late final String stock_date;
  @override
  void initState() {
    super.initState();
  }

  getStock() {
    if (widget.date == '0000-00-00') {
      stock_date = "Stock Depart";
    } else if (widget.date == '0004-00-00') {
      stock_date = "Stock Actuel";
      switch (widget.whichStock) {
        case 'Epicea':
          {
            return getItems("/PHP/getEpiceaActuel.php", "Actuel");
          }
        case 'Nordmann':
          {
            return getItems("/PHP/getNordmannActuel.php", "Actuel");
          }
        case 'Nobilis':
          {
            return getItems("/PHP/getNobilisActuel.php", "Actuel");
          }
        case 'Fraseri':
          {
            return getItems("/PHP/getFraseriActuel.php", "Actuel");
          }
        case 'Pots':
          {
            return getItems("/PHP/getPotsActuel.php", "Actuel");
          }
        case 'Floques':
          {
            return getItems("/PHP/getFloquesActuel.php", "Actuel");
          }
        case 'Buche':
          {
            return getItems("/PHP/getBucheActuel.php", "Actuel");
          }
      }
    } else if (widget.date == '0001-00-00') {
      stock_date = "Changement Stock";
    } else if (widget.date == '0002-00-00') {
      stock_date = "Invendable";
    } else {
      isEnable = false;
      stock_date = widget.date;
    }
    switch (widget.whichStock) {
      case 'Epicea':
        {
          return getItems("/PHP/getItems.php", "epicea");
        }
      case 'Nordmann':
        {
          return getItems("/PHP/getItems.php", "nordmann");
        }
      case 'Nobilis':
        {
          return getItems("/PHP/getItems.php", "nobilis");
        }
      case 'Fraseri':
        {
          return getItems("/PHP/getItems.php", "fraseri");
        }
      case 'Pots':
        {
          return getItems("/PHP/getItems.php", "pots");
        }
      case 'Floques':
        {
          return getItems("/PHP/getItems.php", "floques");
        }
      case 'Buche':
        {
          return getItems("/PHP/getItems.php", "buche");
        }
    }
  }

  getSet() {
    switch (widget.whichStock) {
      case 'Epicea':
        {
          return "/PHP/setEpicea.php";
        }
      case 'Nordmann':
        {
          return "/PHP/setNordmann.php";
        }
      case 'Nobilis':
        {
          return "/PHP/setNobilis.php";
        }
      case 'Fraseri':
        {
          return "/PHP/setFraseri.php";
        }
      case 'Pots':
        {
          return "/PHP/setPots.php";
        }
      case 'Floques':
        {
          return "/PHP/setFloques.php";
        }
      case 'Buche':
        {
          return "/PHP/setBuches.php";
        }
    }
  }

  resetController() {
    for (int i = 0; i <= 11; i++) {
      widget.allController[i].text = '0';
    }
  }

  setController(int value, dynamic result) {
    for (int i = 0; i <= value; i++) {
      widget.allController[i].text = result[(i + 1).toString()];
    }
  }

  setControllerbis(int value, dynamic result) {
    for (int i = 0; i <= value; i++) {
      widget.allController[i].text = result[(i).toString()];
    }
  }

  Future<List> getItems(String path, String cat) async {
    String domaine = "le-petit-palais.com";
    String linkToPhp = path;
    var data = {
      "cat": cat,
      "id": widget.magasinNumber.toString(),
      "date": widget.date,
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
        if (cat == "Actuel") {
          isEnable = false;
          setControllerbis(widget.nom.length - 1, result);
        } else {
          setController(widget.nom.length - 1, result);
        }
        return ['GOOD'];
      }
      return [];
    } else {
      throw Exception('Erreur connection serveur.');
    }
  }

  Future<void> setItems() async {
    String domaine = "le-petit-palais.com";
    String linkToPhp = getSet();
    var data = {
      "date": widget.date,
      "id": widget.magasinNumber.toString(),
      "categorie1": widget.allController[0].text,
      "categorie2": widget.allController[1].text,
      "categorie3": widget.allController[2].text,
      "categorie4": widget.allController[3].text,
      "categorie5": widget.allController[4].text,
      "categorie6": widget.allController[5].text,
      "categorie7": widget.allController[6].text,
      "categorie8": widget.allController[7].text,
      "categorie9": widget.allController[8].text,
      "categorie10": widget.allController[9].text,
      "categorie11": widget.allController[10].text,
    };
    var response = await http.post(
      Uri.https(domaine, linkToPhp),
      body: data,
    );
  }

  @override
  Widget build(BuildContext context) {
    double widht = MediaQuery.of(context).size.width;

    return Column(
      children: <Widget>[
        Expanded(
          child: FutureBuilder<List>(
              future: items,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Stack(
                    children: [
                      FutureBuilder<List>(
                          future: magasin,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Column(
                                children: [
                                  Align(
                                    alignment: const Alignment(0, -0.95),
                                    child: Text(
                                      snapshot.data![0],
                                      style: magasinTextStyle,
                                    ),
                                  ),
                                  Align(
                                      alignment: const Alignment(0, -0.95),
                                      child: Text(
                                        stock_date,
                                        style: magasinTextStyle,
                                      )),
                                ],
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
                          itemCount: widget.nombreItem,
                          controller: ScrollController(),
                          padding: const EdgeInsets.only(top: 100),
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Container(
                                    child: Stack(
                                      children: [
                                        if (index != widget.nom.length - 1) ...[
                                          Align(
                                            alignment:
                                                const Alignment(5, -0.65),
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
                                            alignment:
                                                const Alignment(-1, -0.6),
                                            child: ConstrainedBox(
                                              constraints:
                                                  BoxConstraints.tightFor(
                                                      width: widht - 100),
                                              child: Text(
                                                widget.label[index],
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
                                                widget.nom[index],
                                                style: itemsTextStyle,
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment:
                                                const Alignment(0.95, 0.60),
                                            child: ConstrainedBox(
                                                child: TextField(
                                                  textAlign: TextAlign.center,
                                                  style: itemsTextStyle,
                                                  cursorColor: Colors.white,
                                                  decoration: InputDecoration(
                                                    enabled: isEnable,
                                                    enabledBorder:
                                                        const UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.white),
                                                    ),
                                                    focusedBorder:
                                                        const UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                  controller: widget
                                                      .allController[index],
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .allow(RegExp(
                                                            r'^-?(?:-?(?:[0-9]+))?(?:.[0-9]*)?(?:[eE][+-]?(?:[0-9]+))?')),
                                                  ],
                                                ),
                                                constraints:
                                                    const BoxConstraints
                                                        .tightFor(width: 80)),
                                          )
                                        ] else
                                          ...[]
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
                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                builder: (context) => StockScreen(
                                    getPages(),
                                    widget.magasinNumber,
                                    widget.previousDate,
                                    widget.isAdmin),
                              ));
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
        if (widget.date != '0004-00-00')
          AnimatedButton(
            onPress: () {
              setItems();
              Future.delayed(const Duration(milliseconds: 460), () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => UnsellableScreen(
                        0,
                        widget.magasinNumber,
                        widget.date,
                        widget.previousDate,
                        widget.nom,
                        widget.whichStock,
                        widget.label,
                        widget.isAdmin)));
              });
            },
            height: 70,
            width: 200,
            text: 'VALIDER',
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
  }

  int getPages() {
    switch (widget.whichStock) {
      case 'Epicea':
        {
          return 0;
        }
      case 'Nordmann':
        {
          return 1;
        }
      case 'Nobilis':
        {
          return 2;
        }
      case 'Fraseri':
        {
          return 3;
        }
      case 'Pots':
        {
          return 4;
        }
      case 'Floques':
        {
          return 5;
        }
      case 'Buche':
        {
          return 6;
        }
    }
    return 0;
  }
}
