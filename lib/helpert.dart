
  import 'package:intl/intl.dart';

class Helper {

final _currency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

String formatRupiah(int amount) => _currency.format(amount);

  
}