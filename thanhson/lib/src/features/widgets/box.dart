import 'package:flutter/material.dart';

class Box extends StatelessWidget {
  final String titleString;
  final VoidCallback? onPressedCallback;

  const Box({
    super.key,
    required this.titleString,
    this.onPressedCallback,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double boxWidth = screenWidth * 0.9;
    return Center(
        child: SizedBox(
      width: boxWidth,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressedCallback,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: Colors.white,
        ),
        child: Text(
          titleString,
          style: const TextStyle(
            color: Colors.black,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ));
  }
}
