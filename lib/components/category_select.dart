import 'package:flutter/material.dart';

class CategorySelect extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const CategorySelect({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  final List<String> _categories = const ['All', 'Completed', 'Incomplete'];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final bool isSelected = category == selectedCategory;

          final Color containerColor = isSelected
              ? colors.primary
              : Colors.white;
          final Color textColor = isSelected ? Colors.white : colors.primary;

          return GestureDetector(
            onTap: () => onCategorySelected(category), // Reports the tap
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
                  category.toUpperCase(),
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
