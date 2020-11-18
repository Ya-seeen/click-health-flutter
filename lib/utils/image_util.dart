

import 'package:flutter/material.dart';

class ImageUtil {
  bool isDarkMode;

  static ImageUtil of(BuildContext context) {
    final isDark = false;
    ImageUtil colorUtil = ImageUtil();
    colorUtil.isDarkMode = isDark;

    return colorUtil;
  }

  String get drugDeliverySvgIcon {
    return "assets/images/ic_drug_delivery.svg";
  }

  String get clickHealthJpgIcon {
    return "assets/images/ic_click_health.jpg";
  }
}