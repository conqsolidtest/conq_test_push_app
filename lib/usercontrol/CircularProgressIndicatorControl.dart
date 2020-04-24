import 'package:flutter/material.dart';

class CircularProgressIndicatorControl extends StatelessWidget {
  final double size;

  CircularProgressIndicatorControl({
    Key key,
    this.size,
  }) : super(key: key);

  @override
  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
            height: size,
            width: size,
            child: CircularProgressIndicator(
                backgroundColor: Colors.grey,
                strokeWidth: 0.7,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black87))));
  }
}
