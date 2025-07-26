import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final int maxLines;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator; 

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.maxLines = 1,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField( 
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator, 
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.black26,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.red,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}