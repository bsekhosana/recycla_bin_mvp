import 'dart:convert';
import 'dart:ui';

import 'package:flutter/foundation.dart';

import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';

class Utils{

  static String extractSubstring(String fullString, String startDelimiter, String endDelimiter) {
    final startIndex = fullString.indexOf(startDelimiter);
    if (startIndex == -1) {
      return ''; // Start delimiter not found
    }
    final endIndex = fullString.indexOf(endDelimiter, startIndex + startDelimiter.length);
    if (endIndex == -1) {
      return ''; // End delimiter not found
    }
    return fullString.substring(
      startIndex + startDelimiter.length,
      endIndex,
    );
  }

  static Color hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  static bool isMobileDevice() {
    if (kIsWeb) {
      return false; // Web is not considered mobile
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
        return true; // Mobile platforms
      case TargetPlatform.fuchsia:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
        return false; // Desktop platforms
      default:
        return false;
    }
  }

  static String hashString(String stringToHash) {
    final bytes = utf8.encode(stringToHash);
    return sha256.convert(bytes).toString();
  }

  static String getInitials(String name) {
    List<String> names = name.split(' ');
    String initials = '';
    for (var n in names) {
      if (n.isNotEmpty) {
        initials += n[0].toUpperCase();
      }
    }
    return initials;
  }

  static String formatDateString(String dateString, {bool dateOnly = false}) {
    DateTime dateTime = DateTime.parse(dateString);
    DateFormat formatter = DateFormat('EEEE, MMMM d, yyyy');
    if(dateOnly){
      formatter = DateFormat('yyyy/MM/d');
    }

    return formatter.format(dateTime);
  }

}