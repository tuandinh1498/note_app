import 'package:flutter/material.dart';

class SizeConfig {
  static const double sizeWidthDesign=375;
  static const double sizeHeightDesign=812;


  static Size displaySize(BuildContext context) {
    debugPrint('Size = ${MediaQuery.of(context).size}');
    return MediaQuery.of(context).size;
  }

  static double displayHeight(BuildContext context) {
    debugPrint('Height = ${displaySize(context).height}');
    return displaySize(context).height;
  }

  static double displayWidth(BuildContext context) {
    debugPrint('Width = ${displaySize(context).width}');
    return displaySize(context).width;
  }

  static double displaySizeByWidth(BuildContext context,double size) {
    debugPrint('Width = ${displaySize(context).width}');
    return displaySize(context).width*size/sizeWidthDesign;
  }

  static double displaySizeByHeight(BuildContext context,double size) {
    debugPrint('Width = ${displaySize(context).width}');
    return displaySize(context).height*size/sizeHeightDesign;
  }
}
