import 'package:barber_app/core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final defaultFontFamily = GoogleFonts.robotoCondensed();

var theme = ApplicationTheme();

class ApplicationTheme {
  Color get mainColor {
    return Get.theme.primaryColor;
  }

  Color get backgroundColor {
    return Get.theme.scaffoldBackgroundColor;
  }

  Color get textColor {
    return Get.theme.textTheme.bodyText1.color;
  }

  Color get inactiveColor {
    return Get.theme.textTheme.bodyText2.color;
  }

  Color get success {
    return Colors.green;
  }

  Color get danger {
    return Colors.red;
  }

  Color get warning {
    return Colors.orange;
  }

  Color get info {
    return Color(0xff49C3DE);
  }

  Color get primary {
    return Get.theme.primaryColor;
  }

  Color get secondary {
    return Get.theme.secondaryHeaderColor;
  }

  Color get disabled {
    return Color(0xff212121);
  }

  //Radius
  double smallCircularRadius = 8.0;
  double mediumCircularRadius = 16.0;
  double largeCircularRadius = 32.0;

  BorderRadiusGeometry get smallRadius {
    return BorderRadius.all(Radius.circular(smallCircularRadius));
  }

  BorderRadiusGeometry get mediumRadius {
    return BorderRadius.all(Radius.circular(mediumCircularRadius));
  }

  BorderRadiusGeometry get largeRadius {
    return BorderRadius.all(Radius.circular(largeCircularRadius));
  }

  //Height
  double get smallHeight {
    return 48;
  }

  double get mediumHeight {
    return 52;
  }

  double get largeHeight {
    return 56;
  }

  //Shadow
  normalShadow(Color color) {
    return [
      BoxShadow(
        color: color.withOpacity(0.4),
        blurRadius: 6.0,
        spreadRadius: 4,
      ),
    ];
  }

  //Padding
  EdgeInsetsGeometry get normalPadding {
    return EdgeInsets.all(10.0);
  }

  EdgeInsetsGeometry get mediumPadding {
    return EdgeInsets.all(16.0);
  }

  EdgeInsetsGeometry get largePadding {
    return EdgeInsets.all(20.0);
  }

  //Border
  BoxBorder get defaultBorder {
    return Border.all(
      width: 1.0,
      color: Colors.grey[300],
    );
  }

  TextStyle get fontFamily {
    return GoogleFonts.montserrat();
  }
}
