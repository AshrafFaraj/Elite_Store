import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive.dart';

class CategoryFilter extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategorySelected;

  CategoryFilter({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  final List<Map<String, dynamic>> _categories = [
    {'label': 'الكل', 'value': 'all', 'icon': LucideIcons.layoutGrid},
    {'label': 'إلكترونيات', 'value': 'electronics', 'icon': LucideIcons.laptop},
    {'label': 'مجوهرات', 'value': 'jewelery', 'icon': LucideIcons.gem},
    {'label': 'رجالي', 'value': "men's clothing", 'icon': LucideIcons.shirt},
    {'label': 'نسائي', 'value': "women's clothing", 'icon': LucideIcons.shoppingBag},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.rh(60),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: context.rw(16)),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final isActive = selectedCategory == cat['value'];
          return Padding(
            padding: EdgeInsets.only(left: context.rw(8)),
            child: FilterChip(
              label: Text(cat['label'], style: TextStyle(fontSize: context.sp(14))),
              avatar: Icon(cat['icon'], size: context.sp(16), color: isActive ? AppColors.surface : AppColors.grey500),
              selected: isActive,
              onSelected: (selected) {
                onCategorySelected(cat['value']);
              },
              selectedColor: AppColors.primary,
              labelStyle: TextStyle(color: isActive ? AppColors.surface : AppColors.primary),
              backgroundColor: AppColors.surface,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(context.rw(12))),
            ),
          );
        },
      ),
    );
  }
}
