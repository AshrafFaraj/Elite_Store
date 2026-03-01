import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive.dart';

class EmptyFavorites extends StatelessWidget {
  const EmptyFavorites({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border_rounded, size: context.rw(80), color: AppColors.grey300),
          SizedBox(height: context.rh(16)),
          Text(
            'قائمة المفضلات فارغة',
            style: TextStyle(color: AppColors.grey500, fontSize: context.sp(18)),
          ),
          SizedBox(height: context.rh(8)),
          Text(
            'ابدأ بإضافة المنتجات التي تعجبك',
            style: TextStyle(color: AppColors.grey500, fontSize: context.sp(14)),
          ),
        ],
      ),
    );
  }
}
