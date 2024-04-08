import 'package:flutter/cupertino.dart';

const double screenWidth = 390;
const double screenHeight = 844;

const double defaultScreenWidth = 390;
const double defaultScreenHeight = 844;

const double tittleWidth = 205.18;
const double tittleHeight = 22.9;

const double defaultRatio = screenWidth / screenHeight;

double currentRatio(BuildContext context) {
  return MediaQuery.of(context).size.width / MediaQuery.of(context).size.height;
}

double coefficient(BuildContext context) {
  return currentRatio(context) / defaultRatio;
}

double calculatedHeight(double dimension, BuildContext context) {
  return dimension / defaultScreenHeight * MediaQuery.of(context).size.height;
}

double calculatedWidth(double dimension, BuildContext context) {
  return dimension / defaultScreenWidth * MediaQuery.of(context).size.width;
}

double calculatedFontSize(double dimension, BuildContext context) {
  //return dimension / defaultScreenHeight * MediaQuery.of(context).size.height;
  return dimension * coefficient(context);
}
