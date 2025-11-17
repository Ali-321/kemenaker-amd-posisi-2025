import 'dart:io';
import 'dart:convert';
import 'package:flutter_application_test/models/transaction_model.dart';
import 'package:path_provider/path_provider.dart';

class StorageService {
  static Future<File> _localFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/transactions.json');
  }

  static Future<List<TransactionModel>> readAll() async {
    try {
      final file = await _localFile();
      if (!(await file.exists())) return [];
      final content = await file.readAsString();
      if (content.trim().isEmpty) return [];
      final List<dynamic> list = json.decode(content);
      return list.map((e) => TransactionModel.fromMap(Map<String, dynamic>.from(e))).toList();
    } catch (e) {
      // kalau error, kembalikan list kosong
      return [];
    }
  }

  static Future<void> writeAll(List<TransactionModel> items) async {
    final file = await _localFile();
    final list = items.map((e) => e.toMap()).toList();
    await file.writeAsString(json.encode(list));
  }
}
