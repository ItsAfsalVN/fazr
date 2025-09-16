import 'package:flutter/material.dart';

class CategorySelect extends StatefulWidget {
  const CategorySelect({super.key});

  @override
  State<CategorySelect> createState() => _CategorySelectState();
}

class _CategorySelectState extends State<CategorySelect> {
  final List<String> _categories = ['All', 'Completed', 'Incomplete'];
  int _selectedItem = 0;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final bool isSelected = index == _selectedItem;

          final Color containerColor = isSelected
              ? colors.primary
              : Colors.white;
          final Color textColor = isSelected ? Colors.white : colors.primary;

          return GestureDetector(

            onTap: () {
              setState(() {
                _selectedItem = index;
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: containerColor,
                border: Border.all(color: colors.primary),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  _categories[index].toUpperCase(),
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
