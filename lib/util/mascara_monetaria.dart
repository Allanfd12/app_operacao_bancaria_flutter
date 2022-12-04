import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class MacaraMonetaria extends TextInputFormatter {
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    String numero = newValue.text.replaceAll(new RegExp(r'[^0-9]+'), '');

    final double? value = double.tryParse(numero);

    if (value != null) {
      numero = NumberFormat.currency(locale: 'pt_BR', symbol: '')
          .format(value / 100);
    } else {
      numero = '0.00';
    }
    return TextEditingValue(
      text: numero,
      selection: TextSelection.collapsed(offset: numero.length),
    );
  }
}
