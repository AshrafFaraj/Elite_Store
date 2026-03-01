import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/cart_item.dart';
import '../repositories/cart_repository.dart';

class GetCartItemsUseCase implements UseCase<List<CartItem>, NoParams> {
  final CartRepository repository;

  GetCartItemsUseCase(this.repository);

  @override
  Future<Either<Failure, List<CartItem>>> call(NoParams params) async {
    return await repository.getCartItems();
  }
}

class AddToCartUseCase implements UseCase<void, CartItem> {
  final CartRepository repository;

  AddToCartUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(CartItem item) async {
    return await repository.addToCart(item);
  }
}

class RemoveFromCartUseCase implements UseCase<void, int> {
  final CartRepository repository;

  RemoveFromCartUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(int productId) async {
    return await repository.removeFromCart(productId);
  }
}
