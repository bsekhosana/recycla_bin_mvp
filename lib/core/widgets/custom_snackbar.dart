import 'package:flutter/material.dart';

void showCustomSnackbar(BuildContext context, String message, {Color backgroundColor = Colors.black, int duration = 5}) {
  final snackBar = SnackBar(
    content: Text(message),
    backgroundColor: backgroundColor,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    duration: Duration(seconds: duration),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
