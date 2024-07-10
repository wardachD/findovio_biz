import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CustomTextField extends StatefulWidget {
  final Key? keyTextField;
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final TextInputAction? textInputAction;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextCapitalization? textCapitalization;
  final bool? showSuffix;
  final bool? enableSuggestions;
  final bool? expands;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final Function()? onTap;
  final bool? readOnly;
  final InputBorder? focusedBorder;
  final InputBorder? border;
  final int? maxLength;

  const CustomTextField(
      {super.key,
      this.keyTextField,
      this.labelText,
      this.controller,
      this.hintText,
      this.textInputAction,
      this.onChanged,
      this.validator,
      this.textCapitalization,
      this.enableSuggestions,
      this.showSuffix,
      this.expands,
      this.focusNode,
      this.keyboardType,
      this.onTap,
      this.readOnly,
      this.focusedBorder,
      this.border,
      this.maxLength});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.keyTextField,
      child: TextFormField(
        enableSuggestions: widget.enableSuggestions ?? true,
        onTap: widget.onTap,
        readOnly: widget.readOnly ?? false,
        keyboardType: widget.keyboardType,
        focusNode: widget.focusNode,
        textAlign: TextAlign.start,
        maxLength: widget.maxLength ?? null,
        expands: widget.expands ?? false,
        maxLines: null,
        minLines: null,
        textCapitalization:
            widget.textCapitalization ?? TextCapitalization.none,
        onChanged: widget.onChanged,
        validator: widget.validator,
        onTapOutside: (event) => {FocusScope.of(context).unfocus()},
        textInputAction: widget.textInputAction ?? TextInputAction.next,
        controller: widget.controller,
        decoration: InputDecoration(
          floatingLabelStyle: TextStyle(color: Color.fromARGB(255, 31, 31, 31)),
          labelStyle: TextStyle(
              fontWeight: FontWeight.w200,
              fontSize: 13,
              color: Color.fromARGB(255, 31, 31, 31)),
          hintStyle: TextStyle(
              fontWeight: FontWeight.w200,
              color: Color.fromARGB(255, 143, 143, 143)),
          suffixIcon: widget.showSuffix != null
              ? widget.showSuffix == true
                  ? Focus(
                      canRequestFocus: false,
                      descendantsAreFocusable: false,
                      child: Padding(
                        padding: const EdgeInsetsDirectional.only(end: 12.0),
                        child: InkWell(
                            onTap: widget.controller != null &&
                                    widget.controller!.text.length > 1
                                ? () {
                                    widget.controller?.clear();
                                    setState(() {});
                                  }
                                : null,
                            child: Icon(MdiIcons
                                .close)), // myIcon is a 48px-wide widget.
                      ),
                    )
                  : null
              : null,
          labelText: widget.labelText ?? widget.hintText,
          hintText: widget.hintText,
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
          enabledBorder: widget.border ??
              OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400]!, width: 0.9),
                borderRadius: BorderRadius.circular(12),
              ),
          focusedBorder: widget.focusedBorder ??
              OutlineInputBorder(
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
      ),
    );
  }
}
