import 'package:flutter/material.dart';

import '../widgets/loading_indicator.dart';

void showLoadingDialog(BuildContext context) {
  // Remove focus from all text fields and close the keyboard
  FocusScope.of(context).unfocus();

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: LoadingIndicator(),
      );
    },
  );
}

void hideLoadingDialog(BuildContext context) {
  Navigator.of(context).pop();
}
