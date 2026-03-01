import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

import '../../../home/data/models/product_model.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_local_data_source.dart';
import '../models/cart_item_model.dart';

class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource localDataSource;

  CartRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<CartItem>>> getCartItems() async {
    try {
      final items = await localDataSource.getCartItems();
      return Right(items);
    } catch (e) {
      return const Left(CacheFailure('فشل جلب بيانات السلة'));
    }
  }

  @override
  Future<Either<Failure, void>> addToCart(CartItem item) async {
    try {
      final items = await localDataSource.getCartItems();
      final index = items.indexWhere((i) => i.product.id == item.product.id);

      if (index != -1) {
        items[index] = CartItemModel(
          product: items[index].product as ProductModel,
          quantity: items[index].quantity + item.quantity,
        );
      } else {
        items.add(CartItemModel(
          product: item.product as ProductModel,
          quantity: item.quantity,
        ));
      }

      await localDataSource.saveCartItems(items);
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure('فشل إضافة المنتج للسلة'));
    }
  }

  @override
  Future<Either<Failure, void>> removeFromCart(int productId) async {
    try {
      final items = await localDataSource.getCartItems();
      items.removeWhere((i) => i.product.id == productId);
      await localDataSource.saveCartItems(items);
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure('فشل حذف المنتج من السلة'));
    }
  }

  @override
  Future<Either<Failure, void>> updateQuantity(
      int productId, int quantity) async {
    try {
      final items = await localDataSource.getCartItems();
      final index = items.indexWhere((i) => i.product.id == productId);
      if (index != -1) {
        if (quantity <= 0) {
          items.removeAt(index);
        } else {
          items[index] = CartItemModel(
            product: items[index].product as ProductModel,
            quantity: quantity,
          );
        }
        await localDataSource.saveCartItems(items);
      }
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure('فشل تحديث الكمية'));
    }
  }

  @override
  Future<Either<Failure, void>> clearCart() async {
    try {
      await localDataSource.saveCartItems([]);
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure('فشل إفراغ السلة'));
    }
  }
}
