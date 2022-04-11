import 'package:abieris/admin_panel.dart';
import 'package:abieris/search_store.dart';

import 'admin_login.dart';

import 'login.dart';
import 'package:flutter/material.dart';
import 'image_banner.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    var submitTextStyle = GoogleFonts.nunito(
        fontSize: 14,
        letterSpacing: 5,
        color: Colors.white,
        fontWeight: FontWeight.w300);
    return Scaffold(
        body: Stack(
      children: [
        const ImageBanner("assets/images/main.png"),
        PositionedDirectional(
          bottom: 20,
          start: 20,
          child: AnimatedButton(
            onPress: () {
              Future.delayed(const Duration(milliseconds: 460), () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              });
            },
            height: 70,
            width: width / 2.5,
            text: 'VENDEUR',
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
        PositionedDirectional(
          bottom: 20,
          end: 20,
          child: AnimatedButton(
            onPress: () {
              Future.delayed(const Duration(milliseconds: 460), () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => AdminPanel(0, 0)));
              });
            },
            height: 70,
            width: width / 2.5,
            text: 'GESTION',
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
      ],
    ));
  }
}
