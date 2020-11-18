

import 'package:flutter/material.dart';

class ColorUtil {
  bool isDarkMode;

  static ColorUtil of(BuildContext context) {
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    ColorUtil colorUtil = ColorUtil();
    colorUtil.isDarkMode = isDark;

    return colorUtil;
  }

  Color get circleAvatarBackColor {
    return isDarkMode ? Colors.grey[850] : Colors.grey[100];
  }

  Color get circleAvatarBackColorReverse {
    return isDarkMode ? Colors.grey[100] : Colors.grey[850];
  }

  Color get circleAvatarIconColor {
    return isDarkMode ? Colors.white : Colors.black;
  }

  Color get circleAvatarIconColorReverse {
    return isDarkMode ? Colors.black : Colors.white;
  }

  Color get circleAvatarBigBackColor {
    return isDarkMode ? Colors.grey[900] : Colors.grey[200];
  }

  Color get mPowerIconColor {
    return isDarkMode ? Colors.white : Color.fromARGB(255, 129, 13, 26);
  }
}