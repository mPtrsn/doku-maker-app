import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AdaptiveProgressIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      print("isWeb");
      return CircularProgressIndicator();
    } else {
      return (Platform.isIOS)
          ? CupertinoActivityIndicator()
          : CircularProgressIndicator();
    }
  }
}
