import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive.dart';
import '../../domain/entities/product.dart';
import '../../../favorites/presentation/bloc/favorite_bloc.dart';
import '../../../favorites/presentation/bloc/favorite_event.dart';
import '../../../favorites/presentation/bloc/favorite_state.dart';

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
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.all(context.rw(16)),
                    decoration: BoxDecoration(
                      color: AppColors.grey50,
                      borderRadius: BorderRadius.vertical(
                          top: Radius.circular(context.rw(20))),
                    ),
                    child: Center(
                      child: Hero(
                        tag: heroTag,
                        child: Image.network(
                          product.image,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: context.rh(8),
                    right: context.rw(8),
                    child: BlocBuilder<FavoriteBloc, FavoriteState>(
                      builder: (context, state) {
                        bool isFavorite = false;
                        if (state is FavoriteLoaded) {
                          isFavorite =
                              state.favorites.any((p) => p.id == product.id);
                        }
                        return GestureDetector(
                          onTap: () {
                            context
                                .read<FavoriteBloc>()
                                .add(ToggleFavoriteEvent(product));
                          },
                          child: Container(
                            padding: EdgeInsets.all(context.rw(6)),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color:
                                  isFavorite ? Colors.red : AppColors.grey400,
                              size: context.sp(18),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Product Info
            Padding(
              padding: EdgeInsets.all(context.rw(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.category.toUpperCase(),
                    style: TextStyle(
                      color: AppColors.grey500,
                      fontSize: context.sp(10),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  SizedBox(height: context.rh(4)),
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: context.sp(14),
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: context.rh(8)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${product.price}',
                        style: TextStyle(
                          fontSize: context.sp(16),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
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
                                color: AppColors.ratingStar,
                                size: context.sp(12)),
                            SizedBox(width: context.rw(2)),
                            Text(
                              product.rating.rate.toString(),
                              style: TextStyle(
                                  fontSize: context.sp(10),
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
