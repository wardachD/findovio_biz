import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomNumberTextField extends StatefulWidget {
  final TextEditingController salonCityController;
  final Function(String)? onChanged;
  const CustomNumberTextField({
    super.key,
    required this.salonCityController,
    required this.onChanged,
  });

  @override
  _CustomNumberTextFieldState createState() => _CustomNumberTextFieldState();
}

class _CustomNumberTextFieldState extends State<CustomNumberTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: widget.onChanged,
      controller: widget.salonCityController,
      keyboardType: TextInputType.text,
      maxLength: 6, // 2 digits, one hyphen, and 3 digits
      decoration: InputDecoration(
        labelText: 'Kod pocztowy',
        hintText: '12-345',
        contentPadding: const EdgeInsets.all(16.0),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 255, 82, 82),
            width: 0.9,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 255, 82, 82),
            width: 0.9,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[400]!, width: 0.9),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 44, 44, 44),
            width: 0.9,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[400]!, width: 0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[400]!, width: 0.3),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      inputFormatters: [
        LengthLimitingTextInputFormatter(6),
      ],
    );
  }
}

class _NumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = _formatInputText(newValue.text);
    return TextEditingValue(
      text: newText,
      selection: _updateCursorPosition(newValue, newText),
    );
  }

  String _formatInputText(String inputText) {
    if (inputText.isEmpty) {
      return inputText;
    }
    return inputText;
  }

  TextSelection _updateCursorPosition(
      TextEditingValue newValue, String formattedText) {
    final cursorPosition = newValue.selection.baseOffset +
        formattedText.length -
        newValue.text.length;
    return TextSelection.collapsed(offset: cursorPosition);
  }
}
