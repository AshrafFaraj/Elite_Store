import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive.dart';
import '../../domain/entities/product.dart';
import '../../../favorites/presentation/bloc/favorite_bloc.dart';
import '../../../favorites/presentation/bloc/favorite_event.dart';
import '../../../favorites/presentation/bloc/favorite_state.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../cart/presentation/bloc/cart_state.dart';
import '../../../cart/presentation/pages/cart_page.dart';

class ProductImageHeader extends StatelessWidget {
  final Product product;
  final String heroTag;

  const ProductImageHeader({
    super.key,
    required this.product,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: context.rh(400),
      pinned: true,
      backgroundColor: AppColors.surface,
      elevation: 0,
      leading: Padding(
        padding: EdgeInsets.all(context.rw(8)),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface.withOpacity(0.9),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(LucideIcons.arrowRight, color: AppColors.primary, size: context.sp(20)),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.all(context.rw(8)),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface.withOpacity(0.9),
              shape: BoxShape.circle,
            ),
            child: BlocBuilder<CartBloc, CartState>(
              builder: (context, state) {
                int count = 0;
                if (state is CartLoaded) {
                  count = state.items.length;
                }
                return IconButton(
                  icon: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(LucideIcons.shoppingCart, color: AppColors.primary, size: context.sp(20)),
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
              },
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              color: Colors.white,
              padding: EdgeInsets.only(
                top: context.rh(80),
                bottom: context.rh(40),
                left: context.rw(32),
                right: context.rw(32),
              ),
              child: Hero(
                tag: heroTag,
                child: Image.network(
                  product.image,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned(
              bottom: context.rh(20),
              left: context.rw(20),
              child: BlocBuilder<FavoriteBloc, FavoriteState>(
                builder: (context, state) {
                  bool isFavorite = false;
                  if (state is FavoriteLoaded) {
                    isFavorite = state.favorites.any((p) => p.id == product.id);
                  }
                  return GestureDetector(
                    onTap: () {
                      context.read<FavoriteBloc>().add(ToggleFavoriteEvent(product));
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: EdgeInsets.all(context.rw(12)),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? AppColors.error : AppColors.grey400,
                        size: context.sp(24),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
