import 'package:elite_store/core/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';

class Search extends StatelessWidget {
  const Search({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(LucideIcons.search,
          color: AppColors.primary, size: context.sp(24)),
      onPressed: () {},
    );
  }
}
