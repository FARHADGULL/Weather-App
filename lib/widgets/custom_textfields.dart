import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../helper/common_functions.dart';

class CustomTextField extends StatelessWidget {
  final String? hint;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final int maxLines;
  final int? minLines;
  final int? maxLength;
  final GestureTapCallback? onTap;
  final FormFieldValidator<String>? validator;
  final AutovalidateMode? autoValidateMode;
  final ValueChanged<String>? onChanged;
  final onSubmitted;
  final Color fillColor;
  final Widget? suffixIcon;
  final IconData? prefixIcon;
  final double prefixIconSize;
  final double suffixIconSize;
  final EdgeInsetsGeometry contentPadding;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextField({
    super.key,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 10,
      vertical: 10,
    ),
    this.validator,
    this.onChanged,
    this.autoValidateMode,
    this.hint,
    this.controller,
    this.keyboardType,
    this.maxLines = 1,
    this.onTap,
    this.minLines,
    this.maxLength,
    this.suffixIcon,
    this.prefixIconSize = 18,
    this.suffixIconSize = 18,
    this.fillColor = Colors.white,
    this.prefixIcon,
    this.inputFormatters,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTapOutside: (event) {
        CommonFunctions.closeKeyboard();
      },
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      autovalidateMode: autoValidateMode,
      validator: validator,
      onTap: onTap,
      controller: controller,
      keyboardType: keyboardType,
      minLines: minLines,
      maxLines: maxLines,
      maxLength: maxLength,
      decoration: InputDecoration(
        errorMaxLines: 2,
        contentPadding: contentPadding,
        prefixIcon: (prefixIcon == null)
            ? null
            : Icon(
                prefixIcon,
                color: const Color(0xff3E515B),
                size: prefixIconSize,
              ),
        fillColor: fillColor,
        filled: true,
        hintText: hint,
        isDense: true,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(width: 0.8, color: Color(0xffE9E9E9)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(width: 1, color: Color(0xffE9E9E9)),
        ),
      ),
    );
  }
}
