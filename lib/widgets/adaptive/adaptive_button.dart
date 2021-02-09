import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveButton extends StatelessWidget {
  final Widget child;
  final Function onPressed;

  const AdaptiveButton(
      {Key key, @required this.onPressed, @required this.child})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return null;
  }
}

class AdaptiveTextButton extends AdaptiveButton {
  const AdaptiveTextButton(
      {Key key, @required Function onPressed, @required Widget child})
      : super(key: key, onPressed: onPressed, child: child);
  @override
  Widget build(BuildContext context) {
    return (Platform.isIOS)
        ? CupertinoButton(child: child, onPressed: onPressed)
        : TextButton(onPressed: onPressed, child: child);
  }
}

class AdaptiveElevatedButton extends AdaptiveButton {
  const AdaptiveElevatedButton(
      {Key key, @required Function onPressed, @required Widget child})
      : super(key: key, onPressed: onPressed, child: child);
  @override
  Widget build(BuildContext context) {
    return (Platform.isIOS)
        ? CupertinoButton(child: child, onPressed: onPressed)
        : ElevatedButton(onPressed: onPressed, child: child);
  }
}
