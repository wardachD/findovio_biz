import 'package:flutter/material.dart';

import 'custom_text_field.dart';

class CustomAutocompleteTextField extends StatefulWidget {
  final Key? keyTextField;
  final TextEditingController? controller;
  final String? hintText;
  final TextInputAction? textInputAction;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextCapitalization? textCapitalization;
  final bool? showSuffix;
  final bool? expands;
  final FocusNode? focusNode;
  final List<String> suggestions;

  const CustomAutocompleteTextField({
    Key? key,
    this.keyTextField,
    this.controller,
    this.hintText,
    this.textInputAction,
    this.onChanged,
    this.validator,
    this.textCapitalization,
    this.showSuffix,
    this.expands,
    this.focusNode,
    required this.suggestions,
  }) : super(key: key);

  @override
  State<CustomAutocompleteTextField> createState() =>
      _CustomAutocompleteTextFieldState();
}

class _CustomAutocompleteTextFieldState
    extends State<CustomAutocompleteTextField> {
  late TextEditingController _textEditingController;
  late List<String> _filteredSuggestions;
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _textEditingController = widget.controller ?? TextEditingController();
    _filteredSuggestions = [];
    _textEditingController.addListener(() {
      final inputText = _textEditingController.text.toLowerCase();
      setState(() {
        _filteredSuggestions = widget.suggestions
            .where((suggestion) => suggestion.toLowerCase().contains(inputText))
            .toList();
        _showSuggestions = _filteredSuggestions.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 60,
          child: CustomTextField(
            keyTextField: widget.keyTextField,
            controller: _textEditingController,
            hintText: widget.hintText,
            textInputAction: widget.textInputAction,
            onChanged: widget.onChanged,
            validator: widget.validator,
            textCapitalization: widget.textCapitalization,
            showSuffix: widget.showSuffix,
            expands: widget.expands,
            focusNode: widget.focusNode,
          ),
        ),
        if (_showSuggestions)
          Positioned(
            top: 50.0,
            left: 0.0,
            right: 0.0,
            child: Card(
              elevation: 4.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _filteredSuggestions
                    .map((suggestion) => ListTile(
                          title: Text(suggestion),
                          onTap: () {
                            _textEditingController.text = suggestion;
                            _textEditingController.selection =
                                TextSelection.fromPosition(TextPosition(
                                    offset:
                                        _textEditingController.text.length));
                            setState(() {
                              _showSuggestions = false;
                            });
                          },
                        ))
                    .toList(),
              ),
            ),
          ),
      ],
    );
  }
}
