import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_test/models/transaction_model.dart';

import '../utils/format.dart';

class TransactionCard extends StatelessWidget {
  final TransactionModel tx;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const TransactionCard({
    required this.tx,
    this.onEdit,
    this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Format format = Format();
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: tx.imagePath != null && tx.imagePath!.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.file(
                  File(tx.imagePath!),
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.receipt_long),
                ),
              )
            : const Icon(Icons.receipt_long, size: 48),
        title: Text(tx.description),
        subtitle: Text(tx.date.toLocal().toString().split(' ')[0]),
        trailing: SizedBox(
          width: 120,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Text(
                  format.formatRupiah(tx.amount),
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: tx.isIncome ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              PopupMenuButton(
                onSelected: (v) {
                  if (v == 'edit') onEdit?.call();
                  if (v == 'delete') onDelete?.call();
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'edit', child: Text('Edit')),
                  PopupMenuItem(value: 'delete', child: Text('Hapus')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
