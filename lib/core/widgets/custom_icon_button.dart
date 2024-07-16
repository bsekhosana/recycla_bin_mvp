import 'package:flutter/material.dart';

import '../constants/strings.dart';
import '../utilities/utils.dart';

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const CustomIconButton({super.key, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        // padding: EdgeInsets.all(16.0), // Adjust padding as needed
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Utils.hexToColor(AppStrings.kRBPrimaryColor), Utils.hexToColor(AppStrings.kRBSecondaryColor)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: MediaQuery.of(context).size.width*0.056,
        ),
      ),
    );
  }
}