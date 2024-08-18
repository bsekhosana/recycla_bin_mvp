import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum RBTransactionStatus { Pending, Paid, Declined, Cancelled }
enum RBTransactionType { TopUp, PaidOut, PaidIn, Refund }

class RBTransactionModel {
  final String? id;
  final IconData icon;
  final String title;
  final String details;
  final double amount;
  final double oldAmount;
  final double newAmount;
  final String userId;
  final RBTransactionType type;
  final RBTransactionStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? collectionId;

  RBTransactionModel({
    this.id,
    this.collectionId,
    required this.icon,
    required this.title,
    required this.details,
    required this.amount,
    required this.oldAmount,
    required this.newAmount,
    required this.userId,
    required this.type,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RBTransactionModel.fromJson(Map<String, dynamic> json) {
    return RBTransactionModel(
      id: json['id'],
      icon: IconData(json['icon'], fontFamily: 'MaterialIcons'),
      title: json['title'],
      details: json['details'],
      amount: json['amount'],
      oldAmount: json['oldAmount'],
      newAmount: json['newAmount'],
      userId: json['userId'],
      collectionId: json['collectionId'],
      type: RBTransactionType.values[json['type']],
      status: RBTransactionStatus.values[json['status']],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'icon': icon.codePoint,
      'title': title,
      'details': details,
      'amount': amount,
      'oldAmount': oldAmount,
      'newAmount': newAmount,
      'userId': userId,
      'collectionId': collectionId,
      'type': type.index,
      'status': status.index,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  RBTransactionModel copyWith({
    String? id,
    IconData? icon,
    String? title,
    String? details,
    double? amount,
    double? oldAmount,
    double? newAmount,
    String? userId,
    String? collectionId,
    RBTransactionType? type,
    RBTransactionStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RBTransactionModel(
      id: id ?? this.id,
      icon: icon ?? this.icon,
      title: title ?? this.title,
      details: details ?? this.details,
      amount: amount ?? this.amount,
      oldAmount: oldAmount ?? this.oldAmount,
      newAmount: newAmount ?? this.newAmount,
      userId: userId ?? this.userId,
      collectionId: collectionId ?? this.collectionId,
      type: type ?? this.type,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
