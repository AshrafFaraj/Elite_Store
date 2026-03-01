import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/product.dart';
import '../widgets/product_image_header.dart';
import '../widgets/product_info_section.dart';
import '../widgets/product_bottom_bar.dart';

class ProductDetailsPage extends StatelessWidget {
  final Product product;
  final String heroTag;

  const ProductDetailsPage(
      {super.key, required this.product, required this.heroTag});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              ProductImageHeader(
                product: product,
                heroTag: heroTag,
              ),
              SliverToBoxAdapter(
                child: ProductInfoSection(
                  product: product,
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ProductBottomBar(
              product: product,
            ),
          ),
        ],
      ),
    );
  }
}
