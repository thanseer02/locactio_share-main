import 'package:flutter/services.dart';

///[DebitCardNumberFormatter] which helps format text in
///textformfield in "xxxx xxxx xxxx xxxx" format
class DebitCardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final formattedValue = _formatCardNumber(newValue.text);
    return TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );
  }

  String _formatCardNumber(String val) {
    final value = val.replaceAll(RegExp(r'\s+\b|\b\s'), '');
    final chunks = <String>[];

    var index = 0;
    while (index < value.length) {
      final endIndex = index + 4;
      final chunk = value.substring(
        index,
        endIndex < value.length ? endIndex : value.length,
      );
      chunks.add(chunk);
      index += 4;
    }

    return chunks.join(' ');
  }
}
