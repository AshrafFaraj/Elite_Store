import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../home/domain/entities/product.dart';

abstract class FavoriteRepository {
  Future<Either<Failure, List<Product>>> getFavorites();
  Future<Either<Failure, bool>> toggleFavorite(Product product);
  Future<Either<Failure, bool>> isFavorite(int productId);
}
