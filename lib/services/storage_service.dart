import 'dart:io';
import 'dart:convert';
import 'package:flutter_application_test/models/transaction_model.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:developer' as developer;

class StorageService {
  static Future<File> _localFile() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/transactions.json');
    if (!(await file.exists())) {
      await file.create(recursive: true);
      await file.writeAsString('[]');
    }
    return file;
  }

  static Future<List<TransactionModel>> readAll() async {
    try {
      final file = await _localFile();
      final content = await file.readAsString();
      developer.log('StorageService.readAll content: ${content.length} chars');
      if (content.trim().isEmpty) return [];
      final dynamic parsed = json.decode(content);
      if (parsed is! List) {
        developer.log('StorageService.readAll: JSON not a List, returning []');
        return [];
      }
      final List<TransactionModel> out = [];
      for (var i = 0; i < parsed.length; i++) {
        try {
          final map = Map<String, dynamic>.from(parsed[i]);
          final tx = TransactionModel.fromMap(map);
          out.add(tx);
        } catch (e, st) {
          developer.log('Failed to parse transaction at index $i: $e\n$st');
        }
      }
      developer.log('StorageService.readAll parsed items: ${out.length}');
      return out;
    } catch (e, st) {
      developer.log('StorageService.readAll error: $e\n$st');
      return [];
    }
  }

  static Future<void> writeAll(List<TransactionModel> items) async {
    final file = await _localFile();
    final list = items.map((e) => e.toMap()).toList();
    await file.writeAsString(json.encode(list));
  }
}
