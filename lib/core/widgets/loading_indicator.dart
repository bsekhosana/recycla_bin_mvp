import 'package:flutter/material.dart';
import 'package:recycla_bin/core/utilities/utils.dart';
import '../constants/strings.dart';

class LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: Colors.white,
      ),
    );
  }
}