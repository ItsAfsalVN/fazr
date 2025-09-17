import 'package:flutter/material.dart';

class RepeatSelector extends StatefulWidget {
  final Function(String)? onRepeatSelected;
  const RepeatSelector({super.key, this.onRepeatSelected});

  @override
  State<RepeatSelector> createState() => _RepeatSelectorState();
}

class _RepeatSelectorState extends State<RepeatSelector> {
  final List<String> _repeats = ["Once", "Daily", "Weekly", "Monthly"];
  String _selectedRepeat = "Once";

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: colors.primary),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _repeats.map((repeat) {
            final isSelected = _selectedRepeat == repeat;
            final backgroundColor = isSelected ? colors.primary : Colors.white;
            final textColor = isSelected ? Colors.white : colors.primary;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedRepeat = repeat;
                });
                if (widget.onRepeatSelected != null) {
                  widget.onRepeatSelected!(repeat.toLowerCase());
                }
              },
              child: Container(
                width: 80,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Center(
                    child: Text(repeat, style: TextStyle(color: textColor)),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
