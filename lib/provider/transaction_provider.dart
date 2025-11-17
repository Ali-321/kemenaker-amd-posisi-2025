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
    try {
      await StorageService.writeAll(_items);
      notifyListeners();
    } catch (e) {
      // rollback jika write gagal
      _items.removeWhere((t) => t.id == tx.id);
      rethrow;
    }
  }

  Future<void> update(String id, TransactionModel updated) async {
    final idx = _items.indexWhere((e) => e.id == id);
    if (idx == -1) throw Exception('Item tidak ditemukan');
    final old = _items[idx];
    _items[idx] = updated;
    _items.sort((a, b) => b.date.compareTo(a.date));
    try {
      await StorageService.writeAll(_items);
      notifyListeners();
    } catch (e) {
      // rollback jika gagal
      _items[idx] = old;
      _items.sort((a, b) => b.date.compareTo(a.date));
      rethrow;
    }
  }

  Future<void> delete(String id) async {
    final idx = _items.indexWhere((e) => e.id == id);
    if (idx == -1) return;
    final removed = _items.removeAt(idx);
    try {
      await StorageService.writeAll(_items);
      notifyListeners();
    } catch (e) {
      // rollback jika gagal
      _items.insert(idx, removed);
      rethrow;
    }
  }


  int get totalIncome => _items.where((t) => t.isIncome).fold(0, (s, t) => s + t.amount);
  int get totalExpense => _items.where((t) => !t.isIncome).fold(0, (s, t) => s + t.amount);
  int get balance => totalIncome - totalExpense;
}
