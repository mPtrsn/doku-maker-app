import 'package:doku_maker/widgets/adaptive/adaptive_progress_indicator.dart';
import 'package:flutter/material.dart';

class DokuImage extends StatelessWidget {
  final String src;
  final double width;
  final double height;
  final BoxFit fit;

  const DokuImage(this.src, {Key key, this.width, this.height, this.fit})
      : super(key: key);

  factory DokuImage.network(
    String src, {
    double width,
    double height,
    BoxFit fit,
  }) {
    return DokuImage(
      src,
      width: width,
      height: height,
      fit: fit,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Image.network(
      this.src,
      width: this.width,
      height: this.height,
      fit: this.fit,
      errorBuilder: (context, error, stackTrace) =>
          Center(child: Text('Failed to load Image')),
    );
  }
}
