import 'package:elite_store/core/utils/responsive.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class StoreTitle extends StatelessWidget {
  const StoreTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      'متجر النخبة',
      style: TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
          fontSize: context.sp(16)),
    );
  }
}
