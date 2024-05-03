// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class IconTextFieldForm extends StatelessWidget {
  final String hintText;
  final String labelText;
  TextEditingController? controller;
  TextInputType? keyboardType;
  FormFieldValidator<String>? validator;
  bool obscureText;
  double px;
  double py;
  IconData? prefixIcon;
  IconData? suffixIcon;
  IconTextFieldForm({
    super.key,
    required this.hintText,
    required this.labelText,
    this.obscureText = false,
    this.px = 8,
    this.py = 18,
    this.prefixIcon,
    this.suffixIcon,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        fillColor: Colors.white,
        filled: true,
        contentPadding: EdgeInsets.symmetric(
          vertical: py,
          horizontal: px,
        ),
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
      ),
      style: const TextStyle(
        color: Colors.black,
        fontSize: 14,
      ),
    );
  }
}

class PasswordTextForm extends StatefulWidget {
  final String hintText;
  final String labelText;
  TextEditingController? controller;
  TextInputType? keyboardType;
  FormFieldValidator<String>? validator;
  bool obscureText;
  double px;
  double py;
  IconData? prefixIcon;
  IconData? suffixIcon;
  PasswordTextForm({
    super.key,
    required this.hintText,
    required this.labelText,
    this.obscureText = false,
    this.px = 8,
    this.py = 18,
    this.prefixIcon,
    this.suffixIcon,
    this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
  });

  @override
  State<PasswordTextForm> createState() => _PasswordTextFormState();
}

class _PasswordTextFormState extends State<PasswordTextForm> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: widget.obscureText,
      validator: widget.validator,
      decoration: InputDecoration(
        hintText: widget.hintText,
        labelText: widget.labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        fillColor: Colors.white,
        filled: true,
        contentPadding: EdgeInsets.symmetric(
          vertical: widget.py,
          horizontal: widget.px,
        ),
        prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
        suffixIcon: widget.suffixIcon != null
            ? IconButton(
                onPressed: () {
                  setState(
                    () {
                      widget.obscureText = !widget.obscureText;
                    },
                  );
                },
                icon: Icon(
                  widget.obscureText ? widget.suffixIcon : Icons.visibility_off,
                ),
              )
            : null,
      ),
      style: const TextStyle(
        color: Colors.black,
        fontSize: 14,
      ),
    );
  }
}
