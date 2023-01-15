

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Globals {
  Globals._();

  static init() async {
    documentPath = "${(await getApplicationDocumentsDirectory()).path}/";
  }
  static String documentPath = '';
  static List<String> files = [];

}