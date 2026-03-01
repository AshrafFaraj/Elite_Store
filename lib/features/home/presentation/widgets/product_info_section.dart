import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive.dart';
import '../../domain/entities/product.dart';

class ProductInfoSection extends StatelessWidget {
  final Product product;

  const ProductInfoSection({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.rw(24)),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(context.rw(32)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category & Rating
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.rw(16),
                  vertical: context.rh(8),
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(context.rw(24)),
                ),
                child: Text(
                  product.category.toUpperCase(),
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: context.sp(12),
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.rw(12),
                  vertical: context.rh(6),
                ),
                decoration: BoxDecoration(
                  color: AppColors.ratingBackground,
                  borderRadius: BorderRadius.circular(context.rw(16)),
                ),
                child: Row(
                  children: [
                    Icon(LucideIcons.star, color: AppColors.ratingStar, size: context.sp(16)),
                    SizedBox(width: context.rw(6)),
                    Text(
                      product.rating.rate.toString(),
                      style: TextStyle(
                        fontSize: context.sp(14),
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(width: context.rw(4)),
                    Text(
                      '(${product.rating.count})',
                      style: TextStyle(
                        fontSize: context.sp(12),
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: context.rh(24)),
          
          // Title
          Text(
            product.title,
            style: TextStyle(
              fontSize: context.sp(24),
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
              height: 1.3,
            ),
          ),
          SizedBox(height: context.rh(32)),
          
          // Description Header
          Row(
            children: [
              Container(
                width: context.rw(4),
                height: context.rh(24),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(context.rw(2)),
                ),
              ),
              SizedBox(width: context.rw(12)),
              Text(
                'وصف المنتج',
                style: TextStyle(
                  fontSize: context.sp(18),
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: context.rh(16)),
          
          // Description Text
          Text(
            product.description,
            style: TextStyle(
              fontSize: context.sp(15),
              color: AppColors.secondary,
              height: 1.8,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: context.rh(100)), // Space for bottom bar
        ],
      ),
    );
  }
}
