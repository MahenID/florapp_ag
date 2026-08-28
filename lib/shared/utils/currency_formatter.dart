import 'package:intl/intl.dart';

String formatRupiah(dynamic value) {
  final number = value is num ? value : num.tryParse(value.toString()) ?? 0;

  return NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  ).format(number);
}
