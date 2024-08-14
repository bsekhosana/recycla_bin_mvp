import 'package:flutter/material.dart';
class RBTransactionModel {

  final IconData icon;
  final String title;
  final String details;
  final double amount;

  RBTransactionModel({
    required this.icon,
    required this.title,
    required this.details,
    required this.amount,
  });
}