import 'package:flutter/material.dart';

class Constants {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;
  static double borderSize = 4;
  static int mnistImageSize = 28;
  static double strokeWidth = 15;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth * 0.9;
    blockSizeVertical = screenHeight * 0.6;
  }
}