import 'package:flutter/material.dart';
import 'package:flutter_application_test/provider/transaction_provider.dart';
import 'package:provider/provider.dart';

import 'transaction_list_page.dart';
import 'transaction_form_page.dart';
import '../utils/format.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    Format format = Format();
    final provider = Provider.of<TransactionProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: RefreshIndicator(
        onRefresh: () async => provider.loadTransactions(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  _summaryCard(
                    'Pemasukan',
                    format.formatRupiah(provider.totalIncome),
                    Colors.green,
                  ),
                  const SizedBox(width: 12),
                  _summaryCard(
                    'Pengeluaran',
                    format.formatRupiah(provider.totalExpense),
                    Colors.red,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _summaryCard(
                'Saldo',
                format.formatRupiah(provider.balance),
                Colors.indigo,
                fullWidth: true,
              ),
              const SizedBox(height: 20),
              ListTile(
                title: const Text('Daftar Transaksi'),
                trailing: IconButton(
                  icon: const Icon(Icons.list),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const TransactionListPage(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              const Text('Tarik ke daftar transaksi untuk lihat semua.'),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TransactionFormPage()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Tambah Transaksi'),
      ),
    );
  }

  Widget _summaryCard(
    String title,
    String value,
    Color color, {
    bool fullWidth = false,
  }) {
    final card = Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );

    if (fullWidth) {
      return SizedBox(width: double.infinity, child: card);
    } else {
      return Expanded(child: card);
    }
  }
}
