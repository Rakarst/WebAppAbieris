import 'screen_sellerPanel.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'screen_adminPanel.dart';
import 'package:flutter/material.dart';

import 'const_var.dart';
import 'const_fonction.dart';

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

  getStockByCat(String cat, String label, String id) {
    switch (label) {
      case 'epicea':
        {
          return getData({"id": id, "SQL": "getEpiceaActuel", "cat": cat});
        }
      case 'nordmann':
        {
          return getData({"id": id, "SQL": "getNordmannActuel", "cat": cat});
        }
      case 'nobilis':
        {
          return getData({"id": id, "SQL": "getNobilisActuel", "cat": cat});
        }
      case 'fraseri':
        {
          return getData({"id": id, "SQL": "getFraseriActuel", "cat": cat});
        }
      case 'pots':
        {
          return getData({"id": id, "SQL": "getPotsActuel", "cat": cat});
        }
      case 'floques':
        {
          return getData({"id": id, "SQL": "getFloquesActuel", "cat": cat});
        }
      case 'buche':
        {
          return getData({"id": id, "SQL": "getBucheActuel", "cat": cat});
        }
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
              future: getData(
                  {"id": magasinNumber.toString(), "SQL": "getListAllMagasin"}),
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
                                future: getStockByCat(
                                    label, nom, snapshot.data?[index][1]),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    debugPrint(snapshot.data?[0]);
                                    return Align(
                                        alignment: Alignment.topRight,
                                        child: Text(snapshot.data?[0]));
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
          child: Stack(
            children: [
              Align(
                alignment: const Alignment(0, -0.95),
                child: Text(
                  "TOTAL",
                  style: magasinTextStyle,
                ),
              ),
              ListView.builder(
                  itemCount: nombreItem - 1,
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
                                    constraints: BoxConstraints.tightFor(
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
                                    constraints: BoxConstraints.tightFor(
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
                                    constraints: BoxConstraints.tightFor(
                                        width: widht - 100),
                                    child: Text(
                                      nom[index],
                                      style: itemsTextStyle,
                                    ),
                                  ),
                                ),
                                FutureBuilder<List>(
                                    future: getData({
                                      "SQL": "getTotalByCat",
                                      "table": whichStock.toLowerCase(),
                                      "cat": tranformToPHP[index]
                                    }),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Align(
                                          alignment:
                                              const Alignment(0.95, 0.60),
                                          child: AnimatedButton(
                                            onPress: () {
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext
                                                        context) =>
                                                    _buildPopupDialog(
                                                        context,
                                                        tranformToPHP[index],
                                                        whichStock
                                                            .toLowerCase()),
                                              );
                                            },
                                            height: 70,
                                            width: 100,
                                            text: snapshot.data?[0]['0'],
                                            isReverse: true,
                                            selectedTextColor: Colors.white,
                                            transitionType:
                                                TransitionType.LEFT_TOP_ROUNDER,
                                            textStyle: submitTextStyle,
                                            backgroundColor: Colors.black38,
                                            selectedBackgroundColor:
                                                Colors.black38,
                                            borderColor: Colors.white,
                                            borderWidth: 1,
                                          ),
                                        );
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
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => AdminPanel(0, 0),
                        ));
                      } else {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const SelectScreen(0),
                        ));
                      }
                    },
                  )),
            ],
          ),
        ),
      ],
    );
  }
}
