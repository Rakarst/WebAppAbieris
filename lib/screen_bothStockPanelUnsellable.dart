import 'package:flutter/material.dart';
import 'package:scroll_navigation/scroll_navigation.dart';
import 'const_var.dart';
import 'screen_bothIndivualPanelUnsellable.dart';

class UnsellableScreen extends StatelessWidget {
  final int id;
  final int currentPages;
  final String stock_date;
  final String previous_date;

  final List<String> wich_type;
  final String wich_type_string;
  final List<String> annotation;
  final bool isAdmin;

  // ignore: use_key_in_widget_constructors
  UnsellableScreen(
      this.currentPages,
      this.id,
      this.stock_date,
      this.previous_date,
      this.wich_type,
      this.wich_type_string,
      this.annotation,
      [this.isAdmin = false]);

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
              "INVENDABLE",
            ],
            pages: [
              UnsellableStock(
                  wich_type,
                  0,
                  wich_type.length,
                  allController,
                  wich_type_string,
                  id,
                  annotation,
                  stock_date,
                  previous_date,
                  isAdmin),
            ],
          ),
        ),
      ),
    );
  }
}
