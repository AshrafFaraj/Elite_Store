import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

import '../../../home/data/models/product_model.dart';
import '../../../home/domain/entities/product.dart';
import '../../domain/repositories/favorite_repository.dart';
import '../datasources/favorite_local_data_source.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  final FavoriteLocalDataSource localDataSource;

  FavoriteRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Product>>> getFavorites() async {
    try {
      final favorites = await localDataSource.getFavorites();
      return Right(favorites);
    } catch (e) {
      return const Left(CacheFailure('فشل جلب المفضلات'));
    }
  }

  @override
  Future<Either<Failure, bool>> toggleFavorite(Product product) async {
    try {
      final favorites = await localDataSource.getFavorites();
      final index = favorites.indexWhere((p) => p.id == product.id);

      bool isNowFavorite;
      if (index != -1) {
        favorites.removeAt(index);
        isNowFavorite = false;
      } else {
        favorites.add(ProductModel(
          id: product.id,
          title: product.title,
          price: product.price,
          description: product.description,
          category: product.category,
          image: product.image,
          rating: product.rating,
        ));
        isNowFavorite = true;
      }

      await localDataSource.saveFavorites(favorites);
      return Right(isNowFavorite);
    } catch (e) {
      return const Left(CacheFailure('فشل تحديث المفضلات'));
    }
  }

  @override
  Future<Either<Failure, bool>> isFavorite(int productId) async {
    try {
      final favorites = await localDataSource.getFavorites();
      return Right(favorites.any((p) => p.id == productId));
    } catch (e) {
      return const Left(CacheFailure('فشل التحقق من المفضلة'));
    }
  }
}
