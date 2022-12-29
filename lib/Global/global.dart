

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Globals {
  Globals._();

  static init() async {
    documentPath = "${(await getApplicationDocumentsDirectory()).path}/";
  }

  static const double borderRadius = 15;
  static const double defaultPadding = 8;
  static String documentPath = '';
  static GlobalKey<AnimatedListState> audioListKey =
  GlobalKey<AnimatedListState>();
}