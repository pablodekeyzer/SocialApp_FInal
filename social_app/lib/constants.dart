import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color darkBlu = Color(0xFF4C5273);
const Color lightGrey = Color(0xFFDCE4F2);
const Color skyBlu = Color(0xFF0487D9);
const Color skyBluLight = Color(0xFF049DD9);
const Color darkYello = Color(0xFFF2AA52);
const Color greyGrey = Color.fromARGB(255, 185, 190, 199);
const Color wit = Color(0xFFFEFAF9);

String? mainFont = GoogleFonts.inter().fontFamily;

TextStyle mainText = TextStyle(
  color: darkBlu,
  fontSize: 18,
  fontFamily: mainFont,
);
TextStyle userText = TextStyle(
    color: darkBlu,
    fontSize: 18,
    fontFamily: mainFont,
    fontWeight: FontWeight.w700);

TextStyle bigUserText = TextStyle(
    color: darkBlu,
    fontSize: 25,
    fontFamily: mainFont,
    fontWeight: FontWeight.w700);
TextStyle descText = TextStyle(
  color: greyGrey,
  fontSize: 12,
  fontFamily: mainFont,
);
