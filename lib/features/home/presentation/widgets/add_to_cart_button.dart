import 'package:elite_store/core/theme/app_colors.dart';
import 'package:elite_store/core/utils/responsive.dart';
import 'package:elite_store/features/cart/domain/entities/cart_item.dart';
import 'package:elite_store/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:elite_store/features/cart/presentation/bloc/cart_event.dart';
import 'package:elite_store/features/home/domain/entities/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AddToCartButton extends StatelessWidget {
  const AddToCartButton({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.read<CartBloc>().add(
              AddToCartEvent(CartItem(product: product, quantity: 1)),
            );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('تمت إضافة المنتج إلى السلة بنجاح'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: context.rh(16)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.rw(16)),
        ),
        elevation: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.shoppingBag, size: context.sp(20)),
          SizedBox(width: context.rw(8)),
          Text(
            'أضف إلى السلة',
            style: TextStyle(
              fontSize: context.sp(16),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
