import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_test/provider/transaction_provider.dart';
import 'package:provider/provider.dart';

import '../widgets/transaction_card.dart';
import 'transaction_form_page.dart';

class TransactionListPage extends StatelessWidget {
  const TransactionListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transaksi')),
      body: Consumer<TransactionProvider>(
        builder: (context, prov, _) {
          final items = prov.items;
          if (items.isEmpty) {
            return const Center(child: Text('Belum ada transaksi.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: items.length,
            itemBuilder: (context, i) {
              final tx = items[i];
              return TransactionCard(
                tx: tx,
                onEdit: () async {
                  // Buka form pre-filled; pass id untuk update
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TransactionFormPage(editTx: tx),
                    ),
                  );
                },
                onDelete: () async {
                  final ok = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Hapus'),
                      content: const Text(
                        'Yakin ingin menghapus transaksi ini?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Batal'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Hapus'),
                        ),
                      ],
                    ),
                  );
                  if (ok == true) {
                    await prov.delete(tx.id as String);
                    // coba hapus image file kalau ada
                    if (tx.imagePath != null) {
                      try {
                        final f = File(tx.imagePath!);
                        if (await f.exists()) await f.delete();
                      } catch (_) {}
                    }
                  }
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TransactionFormPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
