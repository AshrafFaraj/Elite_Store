import 'package:elite_store/core/utils/responsive.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/product.dart';

class ProductCardInfo extends StatelessWidget {
  const ProductCardInfo({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CategoryType(product: product),
        SizedBox(height: context.rh(4)),
        ProductTitle(product: product),
        SizedBox(height: context.rh(8)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ProductPrice(product: product),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: context.rw(6), vertical: context.rh(2)),
              decoration: BoxDecoration(
                color: AppColors.ratingBackground,
                borderRadius: BorderRadius.circular(context.rw(8)),
              ),
              child: Row(
                children: [
                  Icon(Icons.star,
                      color: AppColors.ratingStar, size: context.sp(12)),
                  SizedBox(width: context.rw(2)),
                  Text(
                    product.rating.rate.toString(),
                    style: TextStyle(
                        fontSize: context.sp(12), fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ProductPrice extends StatelessWidget {
  const ProductPrice({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Text(
      '\$${product.price}',
      style: TextStyle(
        fontSize: context.sp(16),
        fontWeight: FontWeight.w900,
      ),
    );
  }
}

class ProductTitle extends StatelessWidget {
  const ProductTitle({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Text(
      product.title,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: context.sp(14),
        fontWeight: FontWeight.bold,
        height: 1.2,
      ),
    );
  }
}

class CategoryType extends StatelessWidget {
  const CategoryType({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Text(
      product.category.toUpperCase(),
      style: TextStyle(
        color: AppColors.grey500,
        fontSize: context.sp(12),
        fontWeight: FontWeight.bold,
        letterSpacing: 1,
      ),
    );
  }
}
