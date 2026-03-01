import 'package:elite_store/core/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../favorites/presentation/bloc/favorite_bloc.dart';
import '../../../favorites/presentation/bloc/favorite_event.dart';
import '../../../favorites/presentation/bloc/favorite_state.dart';
import '../../domain/entities/product.dart';

class ProductImage extends StatelessWidget {
  const ProductImage({
    super.key,
    required this.heroTag,
    required this.product,
  });

  final String heroTag;
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(context.rw(16)),
          decoration: BoxDecoration(
            color: AppColors.grey50,
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(context.rw(20))),
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
                isFavorite = state.favorites.any((p) => p.id == product.id);
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
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : AppColors.grey400,
                    size: context.sp(18),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
