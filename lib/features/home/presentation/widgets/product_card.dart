import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive.dart';
import '../../domain/entities/product.dart';
import 'product_image.dart';
import 'product_card_info.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final String heroTag;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(context.rw(20)),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.05),
              blurRadius: context.rw(10),
              offset: Offset(0, context.rh(5)),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              child: ProductImage(heroTag: heroTag, product: product),
            ),

            // Product Info
            Padding(
              padding: EdgeInsets.all(context.rw(12)),
              child: ProductCardInfo(product: product),
            ),
          ],
        ),
      ),
    );
  }
}
