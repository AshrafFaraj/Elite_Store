import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive.dart';
import '../../domain/entities/product.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../cart/presentation/bloc/cart_event.dart';
import '../../../cart/domain/entities/cart_item.dart';

class ProductBottomBar extends StatelessWidget {
  final Product product;

  const ProductBottomBar({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.rw(24),
        vertical: context.rh(20),
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(context.rw(32)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Price Column
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'السعر',
                  style: TextStyle(
                    fontSize: context.sp(14),
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: context.rh(4)),
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: context.sp(28),
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
            SizedBox(width: context.rw(32)),
            
            // Add to Cart Button
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  context.read<CartBloc>().add(
                    AddToCartEvent(CartItem(product: product, quantity: 1)),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          Icon(LucideIcons.checkCircle, color: AppColors.surface),
                          SizedBox(width: context.rw(12)),
                          const Text('تمت إضافة المنتج إلى السلة بنجاح'),
                        ],
                      ),
                      backgroundColor: AppColors.success,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(context.rw(16)),
                      ),
                      margin: EdgeInsets.all(context.rw(16)),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.surface,
                  padding: EdgeInsets.symmetric(vertical: context.rh(18)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(context.rw(20)),
                  ),
                  elevation: 8,
                  shadowColor: AppColors.primary.withOpacity(0.4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(LucideIcons.shoppingBag, size: context.sp(22)),
                    SizedBox(width: context.rw(12)),
                    Text(
                      'أضف إلى السلة',
                      style: TextStyle(
                        fontSize: context.sp(16),
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
