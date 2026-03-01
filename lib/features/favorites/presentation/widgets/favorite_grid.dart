import 'package:flutter/material.dart';
import '../../../home/domain/entities/product.dart';
import '../../../home/presentation/pages/product_details_page.dart';
import '../../../home/presentation/widgets/product_card.dart';

import '../../../../core/utils/responsive.dart';

class FavoriteGrid extends StatelessWidget {
  final List<Product> favorites;

  const FavoriteGrid({super.key, required this.favorites});

  @override
  Widget build(BuildContext context) {
    final int crossAxisCount = Responsive.isDesktop(context)
        ? 4
        : Responsive.isTablet(context)
            ? 3
            : 2;

    return GridView.builder(
      padding: EdgeInsets.all(context.rw(16)),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 0.7,
        crossAxisSpacing: context.rw(16),
        mainAxisSpacing: context.rh(16),
      ),
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final product = favorites[index];
        return ProductCard(
          product: product,
          heroTag: 'fav_product_${product.id}',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailsPage(
                  product: product,
                  heroTag: 'fav_product_${product.id}',
                ),
              ),
            );
          },
        );
      },
    );
  }
}
