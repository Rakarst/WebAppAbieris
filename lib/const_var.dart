import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

String site = "le-petit-palais.com";

var NomPrenom = GoogleFonts.nunito(
    fontSize: 30,
    letterSpacing: 5,
    color: Colors.black,
    fontWeight: FontWeight.w300);

var Objectif = GoogleFonts.nunito(
    fontSize: 15,
    letterSpacing: 5,
    color: Colors.black,
    fontWeight: FontWeight.w300);

var submitTextStyle = GoogleFonts.nunito(
    fontSize: 14,
    letterSpacing: 5,
    color: Colors.white,
    fontWeight: FontWeight.w300);

var itemsTextStyle = GoogleFonts.nunito(
    fontSize: 20,
    letterSpacing: 5,
    color: Colors.white,
    fontWeight: FontWeight.w300);

var magasinTextStyle = GoogleFonts.nunito(
    fontSize: 30,
    letterSpacing: 5,
    color: Colors.white,
    fontWeight: FontWeight.w300);

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

var tranformToPHP = [
  'categorie1',
  'categorie2',
  'categorie3',
  'categorie4',
  'categorie5',
  'categorie6',
  'categorie7',
  'categorie8',
  'categorie9',
  'categorie10',
  'invendable',
];
