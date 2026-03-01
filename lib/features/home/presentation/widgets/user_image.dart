import 'package:elite_store/core/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';

class UserImage extends StatelessWidget {
  const UserImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: AppColors.primary.withOpacity(0.1),
      child: Icon(LucideIcons.user,
          color: AppColors.primary, size: context.sp(20)),
    );
  }
}
