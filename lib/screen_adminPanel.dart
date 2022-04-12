import 'package:abieris/screen_adminShopManagePanel.dart';
import 'package:abieris/screen_adminShopDetailsPanel.dart';
import 'package:abieris/screen_adminSellerManagePanel.dart';
import 'package:abieris/screen_adminAllStockMain.dart';
import 'package:flutter/material.dart';
import 'package:scroll_navigation/scroll_navigation.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class AdminPanel extends StatelessWidget {
  final int id;
  final int currentPages;
  final ScrollController controller = ScrollController();
  final TextEditingController _controller = TextEditingController();

  AdminPanel(this.currentPages, this.id, {Key? key}) : super(key: key);

  Future<void> createStore(String name) async {
    String domaine = "le-petit-palais.com";
    String linkToPhp = "PHP/createMagasin.php";
    var data = {
      "name": name,
    };
    await http.post(
      Uri.https(domaine, linkToPhp),
      body: data,
    );
  }

  @override
  Widget build(BuildContext context) {
    Future openDialogue() => showDialog(
        context: context,
        builder: (context) => const AlertDialog(
              title: Text(""),
              content: Text("Magasin Ajouté"),
            ));
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Screen(
          controllerToHideAppBar: controller,
          body: TitleScrollNavigation(
            showIdentifier: false,
            identiferStyle:
                const NavigationIdentiferStyle(color: Colors.black38),
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
              "STOCK PAR MAGASIN",
              "STOCK PAR TYPE",
              "GESTION MAGASIN",
              "GESTION VENDEUR",
            ],
            pages: [
              MagasinView(),
              ByTypeController(0, 0, true),
              MagasinList(),
              VnedeurList(),
            ],
          ),
        ),
      ),
    );
  }
}
