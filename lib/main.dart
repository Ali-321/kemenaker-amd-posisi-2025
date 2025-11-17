import 'package:flutter/material.dart';
import 'package:flutter_application_test/provider/transaction_provider.dart';
import 'package:flutter_application_test/view/dashboard.page.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TransactionProvider()..loadTransactions(),
      child: MaterialApp(
        title: 'Keuangan Offline',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: const DashboardPage(),
      ),
    );
  }
}
