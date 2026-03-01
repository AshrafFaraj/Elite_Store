import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../home/domain/entities/product.dart';
import '../repositories/favorite_repository.dart';

class GetFavoritesUseCase implements UseCase<List<Product>, NoParams> {
  final FavoriteRepository repository;

  GetFavoritesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(NoParams params) async {
    return await repository.getFavorites();
  }
}

class ToggleFavoriteUseCase implements UseCase<bool, Product> {
  final FavoriteRepository repository;

  ToggleFavoriteUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(Product product) async {
    return await repository.toggleFavorite(product);
  }
}
