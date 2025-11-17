import 'dart:convert';

import 'package:hive/hive.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 0)
class TransactionModel extends HiveObject {
  @HiveField(0)
  int id; // optional, HiveObject memiliki key juga
  @HiveField(1)
  String description;
  @HiveField(2)
  int amount; // simpan dalam integer rupiah (mis. 120000)
  @HiveField(3)
  bool isIncome; // true = pemasukan, false = pengeluaran
  @HiveField(4)
  String? imagePath; // path file lokal

  @HiveField(5)
  DateTime date;

  TransactionModel({
    required this.id,
    required this.description,
    required this.amount,
    required this.isIncome,
    this.imagePath,
    required this.date,
  });

  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'amount': amount,
      'isIncome': isIncome ? 1 : 0,
      'imagePath': imagePath,
      'date': date.toIso8601String(),
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] ?? '',
      description: map['description'] ?? '',
      amount: (map['amount'] is int) ? map['amount'] : int.tryParse('${map['amount']}') ?? 0,
      isIncome: (map['isIncome'] == 1 || map['isIncome'] == true),
      imagePath: map['imagePath'],
      date: DateTime.tryParse(map['date'] ?? '') ?? DateTime.now(),
    );
  }

  String toJson() => json.encode(toMap());
  factory TransactionModel.fromJson(String source) => TransactionModel.fromMap(json.decode(source));

}
