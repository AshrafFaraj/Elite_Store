import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/favorite_grid.dart';
import '../widgets/empty_favorites.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive.dart';
import '../bloc/favorite_bloc.dart';
import '../bloc/favorite_state.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'المفضلات',
          style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: context.sp(20)),
        ),
        iconTheme: IconThemeData(color: AppColors.primary, size: context.sp(24)),
      ),
      body: BlocBuilder<FavoriteBloc, FavoriteState>(
        builder: (context, state) {
          if (state is FavoriteLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          } else if (state is FavoriteLoaded) {
            if (state.favorites.isEmpty) {
              return const EmptyFavorites();
            }
            return FavoriteGrid(favorites: state.favorites);
          } else if (state is FavoriteError) {
            return Center(child: Text(state.message, style: TextStyle(fontSize: context.sp(16))));
          }
          return const SizedBox();
        },
      ),
    );
  }
}
