import 'dart:convert';

import 'package:hive/hive.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 0)
class TransactionModel extends HiveObject {
  @HiveField(0)
  String id; // optional, HiveObject memiliki key juga
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
    // parse amount: terima int, double, atau string
    int parseAmount(dynamic a) {
      try {
        if (a == null) return 0;
        if (a is int) return a;
        if (a is double) return a.toInt();
        if (a is String) {
          final cleaned = a
              .replaceAll('.', '')
              .replaceAll(',', '')
              .replaceAll(' ', '');
          return int.tryParse(cleaned) ?? 0;
        }
        return 0;
      } catch (_) {
        return 0;
      }
    }

    // parse isIncome: terima int(1/0), bool, atau string
    bool parseIsIncome(dynamic v) {
      if (v == null) return false;
      if (v is bool) return v;
      if (v is int) return v == 1;
      if (v is String) {
        final low = v.toLowerCase();
        if (low == '1' || low == 'true' || low == 'yes') return true;
        return false;
      }
      return false;
    }

    return TransactionModel(
      id:
          map['id']?.toString() ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      description: map['description']?.toString() ?? '',
      amount: parseAmount(map['amount']),
      isIncome: parseIsIncome(map['isIncome']),
      imagePath: map['imagePath']?.toString(),
      date: DateTime.tryParse(map['date']?.toString() ?? '') ?? DateTime.now(),
    );
  }
  String toJson() => json.encode(toMap());
  factory TransactionModel.fromJson(String source) =>
      TransactionModel.fromMap(json.decode(source));
}
