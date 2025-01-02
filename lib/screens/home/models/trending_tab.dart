import 'package:flutter/material.dart';
import 'package:movie_app/utilities/constants/text_constants.dart';

enum TrendingTab {
  today,
  thisWeek,
}

extension TrendingTabExtension on TrendingTab {
  String getLabel(BuildContext context) {
    switch (this) {
      case TrendingTab.today:
        return TextConstants.today;
      case TrendingTab.thisWeek:
        return TextConstants.thisWeek;
    }
  }
}
