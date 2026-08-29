import 'package:flutter/material.dart';

class CategoryMenu extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const CategoryMenu({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  final List<Map<String, dynamic>> categories = const [
    {'icon': Icons.apps, 'title': 'Semua'},
    {'icon': Icons.local_florist, 'title': 'Indoor'},
    {'icon': Icons.park, 'title': 'Outdoor'},
    {'icon': Icons.spa, 'title': 'Bunga'},
    {'icon': Icons.eco, 'title': 'Sukulen'},
    {'icon': Icons.grass, 'title': 'Bibit'},
    {'icon': Icons.science_outlined, 'title': 'Pupuk'},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final title = category['title'] as String;
          final isSelected = selectedCategory == title;

          return InkWell(
            onTap: () => onCategorySelected(title),
            borderRadius: BorderRadius.circular(18),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.green
                          : Colors.green.withValues(alpha: 0.10),
                      shape: BoxShape.circle,
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: Colors.green.withValues(alpha: 0.35),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ]
                          : null,
                    ),
                    child: Icon(
                      category['icon'] as IconData,
                      color: isSelected ? Colors.white : Colors.green.shade800,
                      size: 22,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected
                          ? Colors.green.shade800
                          : Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
