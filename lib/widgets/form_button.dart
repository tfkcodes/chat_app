// ignore_for_file: must_be_immutable

import 'package:chat_app/utils/colors.dart';
import 'package:flutter/material.dart';

class FormButton extends StatelessWidget {
  final String buttonText;
  void Function()? onPressed;
  double width;

  FormButton({
    super.key,
    required this.buttonText,
    this.width = 300,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          12,
        ),
        gradient: LinearGradient(
          colors: [
            AppColors.primaryColor700.withOpacity(
              0.6,
            ),
            AppColors.primaryColor500,
            AppColors.primaryColor600
          ], // List of gradient colors

          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              12,
            ),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          buttonText,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
