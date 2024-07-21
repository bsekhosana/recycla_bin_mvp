import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  // Add any global state management here, like theme, localization, etc.

  // Example: Manage a simple counter
  int _counter = 0;

  int get counter => _counter;

  void incrementCounter() {
    _counter++;
    notifyListeners();
  }
}
