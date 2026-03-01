import 'package:elite_store/core/theme/app_colors.dart';
import 'package:elite_store/core/utils/responsive.dart';
import 'package:elite_store/features/cart/presentation/pages/cart_page.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class CartButton extends StatelessWidget {
  const CartButton({
    super.key,
    required this.count,
  });

  final int count;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(LucideIcons.shoppingCart,
              color: AppColors.primary, size: context.sp(24)),
          if (count > 0)
            Positioned(
              right: -4,
              top: -4,
              child: Container(
                padding: EdgeInsets.all(context.rw(4)),
                decoration: const BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                ),
                constraints: BoxConstraints(
                  minWidth: context.rw(16),
                  minHeight: context.rw(16),
                ),
                child: Text(
                  count.toString(),
                  style: TextStyle(
                    color: AppColors.surface,
                    fontSize: context.sp(10),
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CartPage()),
        );
      },
    );
  }
}
