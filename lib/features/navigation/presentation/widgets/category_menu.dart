import 'package:flutter/material.dart';

class CategoryMenu extends StatelessWidget {
  const CategoryMenu({super.key});

  final List<Map<String, dynamic>> categories = const [
    {'icon': Icons.local_florist, 'title': 'Indoor'},
    {'icon': Icons.park, 'title': 'Outdoor'},
    {'icon': Icons.grass, 'title': 'Bibit'},
    {'icon': Icons.spa, 'title': 'Pupuk'},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: categories.map((category) {
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),

                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  shape: BoxShape.circle,
                ),

                child: Icon(category['icon'], color: Colors.green),
              ),

              const SizedBox(height: 8),

              Text(category['title']),
            ],
          );
        }).toList(),
      ),
    );
  }
}
