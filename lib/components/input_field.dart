import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  String label;
  String hint;
  final int? maxlines;
  InputField({
    super.key,
    required this.label,
    this.maxlines,
    required this.hint,
  });
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: colors.primary,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        TextFormField(
          maxLines: maxlines,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hint: Text(hint, style: TextStyle(color: colors.primary)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colors.primary),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colors.primary),
            ),
          ),
        ),
      ],
    );
  }
}
