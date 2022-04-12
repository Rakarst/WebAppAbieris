import 'screen_adminAllStock.dart';
import 'package:flutter/material.dart';
import 'package:scroll_navigation/scroll_navigation.dart';
import 'const_var.dart';

class ByTypeController extends StatelessWidget {
  final int id;
  final int currentPages;

  final bool isAdmin;

  // ignore: use_key_in_widget_constructors
  const ByTypeController(this.currentPages, this.id, [this.isAdmin = false]);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Screen(
          controllerToHideAppBar: ScrollController(),
          body: TitleScrollNavigation(
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
              ByType(epicea, 0, 7, allController, 'Epicea', id, nomTop[0],
                  isAdmin),
              ByType(nordmann, 1, 11, allController, 'Nordmann', id, nomTop[1],
                  isAdmin),
              ByType(nobilis, 2, nobilis.length, allController, 'Nobilis', id,
                  nomTop[2], isAdmin),
              ByType(fraseris, 3, fraseris.length, allController, 'Fraseri', id,
                  nomTop[3], isAdmin),
              ByType(pots, 4, pots.length, allController, 'Pots', id, nomTop[4],
                  isAdmin),
              ByType(floques, 5, floques.length, allController, 'Floques', id,
                  nomTop[5], isAdmin),
              ByType(buche, 2, buche.length, allController, 'Buche', id,
                  nomTop[6], isAdmin),
            ],
          ),
        ),
      ),
    );
  }
}
