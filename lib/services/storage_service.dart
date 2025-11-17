import 'dart:io';
import 'dart:convert';
import 'package:flutter_application_test/models/transaction_model.dart';
import 'package:path_provider/path_provider.dart';

class StorageService {
  static Future<File> _localFile() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/transactions.json');
    // pastikan file ada
    if (!(await file.exists())) {
      await file.create(recursive: true);
      // tulis list kosong awal
      await file.writeAsString('[]');
    }
    return file;
  }

  static Future<List<TransactionModel>> readAll() async {
    try {
      final file = await _localFile();
      final content = await file.readAsString();
      if (content.trim().isEmpty) return [];
      final List<dynamic> list = json.decode(content);
      return list
          .map((e) => TransactionModel.fromMap(Map<String, dynamic>.from(e)))
          .toList();
    } catch (e) {
      return [];
    }
  }

  static Future<void> writeAll(List<TransactionModel> items) async {
    try {
      final file = await _localFile();
      final list = items.map((e) => e.toMap()).toList();
      await file.writeAsString(json.encode(list));
    } catch (e) {
      rethrow;
    }
  }
}
