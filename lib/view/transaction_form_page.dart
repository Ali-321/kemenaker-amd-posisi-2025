import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_test/models/transaction_model.dart';
import 'package:flutter_application_test/provider/transaction_provider.dart';
import 'package:provider/provider.dart';

import '../services/image_service.dart';
import '../utils/format.dart';

class TransactionFormPage extends StatefulWidget {
  final TransactionModel? editTx;
  const TransactionFormPage({super.key, this.editTx});

  @override
  State<TransactionFormPage> createState() => _TransactionFormPageState();
}

class _TransactionFormPageState extends State<TransactionFormPage> {
  final _formKey = GlobalKey<FormState>();
  late bool isIncome;
  final _descCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  String? imagePath;
  DateTime date = DateTime.now();
  Format format = Format();

  @override
  void initState() {
    super.initState();
    if (widget.editTx != null) {
      final t = widget.editTx!;
      isIncome = t.isIncome;
      _descCtrl.text = t.description;
      _amountCtrl.text = t.amount.toString();
      imagePath = t.imagePath;
      date = t.date;
    } else {
      isIncome = false;
    }
  }

  @override
  void dispose() {
    _descCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final path = await ImageService.pickAndSaveImage();
    if (path != null) {
      setState(() => imagePath = path);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Gagal mengambil gambar')));
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final desc = _descCtrl.text.trim();
    final amount =
        int.tryParse(
          _amountCtrl.text.replaceAll('.', '').replaceAll(',', ''),
        ) ??
        0;
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nominal harus lebih dari 0')),
      );
      return;
    }

    final prov = Provider.of<TransactionProvider>(context, listen: false);

    if (widget.editTx != null) {
      final updated = TransactionModel(
        id: widget.editTx!.id,
        description: desc,
        amount: amount,
        isIncome: isIncome,
        imagePath: imagePath,
        date: date,
      );
      await prov.update(widget.editTx!.id as String, updated);
    } else {
      final id = DateTime.now().millisecondsSinceEpoch.toString();
      final newTx = TransactionModel(
        id: id as int,
        description: desc,
        amount: amount,
        isIncome: isIncome,
        imagePath: imagePath,
        date: date,
      );
      await prov.add(newTx);
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.editTx != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Transaksi' : 'Tambah Transaksi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              ToggleButtons(
                isSelected: [isIncome, !isIncome],
                onPressed: (i) {
                  setState(() {
                    isIncome = i == 0;
                  });
                },
                children: const [
                  Padding(padding: EdgeInsets.all(8), child: Text('Pemasukan')),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text('Pengeluaran'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descCtrl,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v == null || v.trim().isEmpty
                    ? 'Deskripsi wajib diisi'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _amountCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Nominal (angka)',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v == null || v.trim().isEmpty
                    ? 'Nominal wajib diisi'
                    : null,
              ),
              const SizedBox(height: 8),
              Builder(
                builder: (context) {
                  final txt = _amountCtrl.text.isEmpty
                      ? ''
                      : 'Preview: ${format.formatRupiah(int.tryParse(_amountCtrl.text.replaceAll('.', '').replaceAll(',', '')) ?? 0)}';
                  return Text(txt);
                },
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Pilih Gambar'),
                  ),
                  const SizedBox(width: 12),
                  if (imagePath != null)
                    GestureDetector(
                      onTap: () {
                        // preview
                        showDialog(
                          context: context,
                          builder: (_) =>
                              Dialog(child: Image.file(File(imagePath!))),
                        );
                      },
                      child: Image.file(
                        File(imagePath!),
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.calendar_today),
                title: Text(
                  'Tanggal: ${date.toLocal().toString().split(' ')[0]}',
                ),
                trailing: TextButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: date,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) setState(() => date = picked);
                  },
                  child: const Text('Ubah'),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submit,
                child: Text(isEdit ? 'Simpan Perubahan' : 'Tambah'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
