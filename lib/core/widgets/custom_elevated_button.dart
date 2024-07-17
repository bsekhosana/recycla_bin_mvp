import 'package:flutter/material.dart';
import 'package:recycla_bin/core/constants/strings.dart';
import 'package:recycla_bin/core/utilities/utils.dart';

class CustomElevatedButton extends StatelessWidget {

  final String text;
  final bool primaryButton;
  final VoidCallback onPressed;

  const CustomElevatedButton({super.key, required this.text, required this.onPressed, required this.primaryButton});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.067,
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        gradient:  !primaryButton
            ? null
            :  LinearGradient(
          colors: [Utils.hexToColor(AppStrings.kRBPrimaryColor), Utils.hexToColor(AppStrings.kRBSecondaryColor)], // Gradient colors
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(8), // Rounded corners
        border: Border.all(color: Utils.hexToColor(primaryButton ? AppStrings.kRBPrimaryColor : AppStrings.kRBSecondaryColor), width: 1), // Green border
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          minimumSize: Size(MediaQuery.of(context).size.width * 0.8, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(color: !primaryButton
               ?Colors.black : Colors.white,
          fontSize: MediaQuery.of(context).size.width * 0.04,
            fontWeight: FontWeight.bold,

          ) // Text color
        ),
      ),
    );
  }
}
