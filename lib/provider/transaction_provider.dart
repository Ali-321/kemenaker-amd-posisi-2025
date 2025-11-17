import 'package:flutter/material.dart';
import 'package:flutter_application_test/models/transaction_model.dart';

import '../services/storage_service.dart';

class TransactionProvider extends ChangeNotifier {
  List<TransactionModel> _items = [];
  List<TransactionModel> get items => _items;

  Future<void> loadTransactions() async {
    _items = await StorageService.readAll();
    // sort by date desc
    _items.sort((a, b) => b.date.compareTo(a.date));
    notifyListeners();
  }

  Future<void> add(TransactionModel tx) async {
    _items.insert(0, tx);
    await StorageService.writeAll(_items);
    notifyListeners();
  }

  Future<void> update(String id, TransactionModel updated) async {
    final idx = _items.indexWhere((e) => e.id == id);
    if (idx != -1) {
      _items[idx] = updated;
      // resort after update if date changed
      _items.sort((a, b) => b.date.compareTo(a.date));
      await StorageService.writeAll(_items);
      notifyListeners();
    }
  }

  Future<void> delete(String id) async {
    _items.removeWhere((e) => e.id == id);
    await StorageService.writeAll(_items);
    notifyListeners();
  }

  int get totalIncome => _items.where((t) => t.isIncome).fold(0, (s, t) => s + t.amount);
  int get totalExpense => _items.where((t) => !t.isIncome).fold(0, (s, t) => s + t.amount);
  int get balance => totalIncome - totalExpense;
}
