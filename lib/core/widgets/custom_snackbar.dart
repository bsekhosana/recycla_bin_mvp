import 'package:flutter/material.dart';

void showCustomSnackbar(BuildContext context, String message, {Color backgroundColor = Colors.black}) {
  final snackBar = SnackBar(
    content: Text(message),
    backgroundColor: backgroundColor,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    duration: const Duration(seconds: 3),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
