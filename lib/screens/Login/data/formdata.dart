import 'package:flutter/material.dart';

class FlowaFormField extends StatelessWidget {
  final String label;
  final bool isPassword;
  final TextEditingController controller ;
  final Function(String) onchanged;

  const FlowaFormField({super.key, required this.label, required this.isPassword,   required  this.controller , required this.onchanged});

  @override
  Widget build(BuildContext context) {
    return TextFormField(controller: controller,
      decoration: InputDecoration(
        labelText: '$label',
        
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onChanged: onchanged,
      obscureText: isPassword,
    );
  }
}