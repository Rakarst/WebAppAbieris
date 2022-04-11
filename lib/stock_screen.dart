import 'image_banner.dart';
import 'package:flutter/material.dart';
import 'package:scroll_navigation/scroll_navigation.dart';

class StockScreen extends StatelessWidget {
  final int id;
  final int currentPages;
  final String stock_date;
  final bool isAdmin;

  // ignore: use_key_in_widget_constructors
  StockScreen(this.currentPages, this.id, this.stock_date,
      [this.isAdmin = false]);

  final epicea = [
    "0.8m - 1.0m",
    "1.0m - 1.5m",
    "1.5m - 2.0m",
    "2.0m - 2.5m",
    "2.5m - 3.0m",
    "3.0m - 4.0m",
    "INVENDABLE"
  ];

  final List<TextEditingController> allController = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  final nordmann = [
    "0.8m - 1.0m",
    "1.0m - 1.25m",
    "1.0m - 1.5m",
    "1.5m - 2.0m",
    "1.25m - 1.5m",
    "1.5m - 1.75m",
    "1.75m - 2.0m",
    "2.0m - 2.5m",
    "2.5m - 3.0m",
    "3.0m",
    "INVENDABLE",
  ];

  final nobilis = [
    "1.25m - 1.5m",
    "1.5m - 1.75m",
    "INVENDABLE",
  ];

  final fraseris = [
    "1.5m - 1.75m",
    "INVENDABLE",
  ];

  final pots = [
    "1.0m - 1.25m",
    "1.0m - 1.25m",
    "INVENDABLE",
  ];

  final floques = [
    "0.5m - 0.6m",
    "0.7m - 0.8m",
    "0.9m - 1.0m",
    "1.1m - 1.2m",
    "1.4m - 1.5m",
    "INVENDABLE",
  ];

  final buche = [
    "D40 D50",
    "D60",
    "40 x 40 cm",
    "INVENDABLE",
  ];

  final nomTop = [
    [
      "EPICEA",
      "EPICEA",
      "EPICEA",
      "EPICEA",
      "EPICEA",
      "EPICEA",
      "EPICEA",
    ],
    [
      "NORDMANN",
      "NORDMANN",
      "NORDMANN COURANT",
      "NORDMANN COURANT",
      "NORDMANN",
      "NORDMANN",
      "NORDMANN",
      "NORDMANN",
      "NORDMANN",
      "NORDMANN",
      "NORDMANN",
    ],
    [
      "NOBILIS",
      "NOBILIS",
      "NOBILIS",
    ],
    [
      "FRASERI",
      "FRASERI",
    ],
    [
      "EPICEA POTS",
      "NORDMANN POTS",
      "POTS",
    ],
    [
      "FLOQUES",
      "FLOQUES",
      "FLOQUES",
      "FLOQUES",
      "FLOQUES",
      "FLOQUES",
    ],
    ["BUCHE", "BUCHE", "CROISILLON", "BUCHE / CROISILLON"]
  ];

  @override
  Widget build(BuildContext context) {
    debugPrint(id.toString());
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Screen(
          controllerToHideAppBar: ScrollController(),
          body: TitleScrollNavigation(
            showIdentifier: false,
            identiferStyle: const NavigationIdentiferStyle(color: Colors.white),
            bodyStyle: const NavigationBodyStyle(background: Color(0xff171717)),
            initialPage: currentPages,
            barStyle: const TitleNavigationBarStyle(
              deactiveColor: Colors.white,
              background: Colors.black38,
              style: TextStyle(
                  fontSize: 14, letterSpacing: 5, fontWeight: FontWeight.w300),
              padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
              spaceBetween: 40,
            ),
            titles: const [
              "EPICEA",
              "NORDMANN",
              "NOBILIS",
              "FRASERI",
              "SAPIN POTS",
              "FLOQUES",
              "BUCHE",
            ],
            pages: [
              StatefullStock(epicea, 0, 7, allController, 'Epicea', id,
                  nomTop[0], stock_date, isAdmin),
              StatefullStock(nordmann, 1, 11, allController, 'Nordmann', id,
                  nomTop[1], stock_date, isAdmin),
              StatefullStock(nobilis, 2, nobilis.length, allController,
                  'Nobilis', id, nomTop[2], stock_date, isAdmin),
              StatefullStock(fraseris, 3, fraseris.length, allController,
                  'Fraseri', id, nomTop[3], stock_date, isAdmin),
              StatefullStock(pots, 4, pots.length, allController, 'Pots', id,
                  nomTop[4], stock_date, isAdmin),
              StatefullStock(floques, 5, floques.length, allController,
                  'Floques', id, nomTop[5], stock_date, isAdmin),
              StatefullStock(buche, 6, buche.length, allController, 'Buche', id,
                  nomTop[6], stock_date, isAdmin),
            ],
          ),
        ),
      ),
    );
  }
}
