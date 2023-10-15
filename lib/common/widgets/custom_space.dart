import 'package:flutter/material.dart';

class CustomSpace extends StatelessWidget {
  double width = 0;
  double height = 10;

  CustomSpace({super.key, this.width = 10, this.height = 10});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
    );
  }
}
