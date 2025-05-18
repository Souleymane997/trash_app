// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class CustomText extends Text {
  // ignore: use_key_in_widget_constructors
  CustomText(String? data,
      {color = Colors.white,
      textAlign = TextAlign.center,
      tex = 1.0,
      fontWeight = FontWeight.normal,
      family = "Poppins"})
      : super(
          data!,
          textAlign: textAlign,
          textScaleFactor:tex ,
          style: TextStyle(
            color: color,
            fontSize: 15.0,
            fontFamily: family,
            fontWeight: fontWeight,
            
          ),
          maxLines: 10,
          
        );
}

class TailleText {
  late double titre;
  late double soustitre;
  late double contenu;
  late double mini;

  TailleText(BuildContext context) {
    if (MediaQuery.of(context).size.width <= 350) {
      titre = 0.9;
      soustitre = 0.8;
      contenu = 0.45;
      mini = 0.25;
    } else {
      if (MediaQuery.of(context).size.width > 350 &&
          MediaQuery.of(context).size.width <= 450) {
        titre = 1.20;
        soustitre = 1.05;
        contenu = 0.75;
        mini = 0.5;
      } else {
        titre = 1.6;
        soustitre = 1.35;
        contenu = 1.1;
        mini = 0.85;
      }
    }
  }
}




