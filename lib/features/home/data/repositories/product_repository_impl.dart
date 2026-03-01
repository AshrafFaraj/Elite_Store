import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteProducts = await remoteDataSource.getProducts();
        return Right(remoteProducts);
      } catch (e) {
        return const Left(ServerFailure('حدث خطأ أثناء جلب المنتجات'));
      }
    } else {
      return const Left(NetworkFailure('لا يوجد اتصال بالإنترنت'));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getProductsByCategory(
      String category) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteProducts =
            await remoteDataSource.getProductsByCategory(category);
        return Right(remoteProducts);
      } catch (e) {
        return const Left(ServerFailure('حدث خطأ أثناء جلب منتجات التصنيف'));
      }
    } else {
      return const Left(NetworkFailure('لا يوجد اتصال بالإنترنت'));
    }
  }

  @override
  Future<Either<Failure, Product>> getProductDetails(int id) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteProduct = await remoteDataSource.getProductDetails(id);
        return Right(remoteProduct);
      } catch (e) {
        return const Left(ServerFailure('حدث خطأ أثناء جلب تفاصيل المنتج'));
      }
    } else {
      return const Left(NetworkFailure('لا يوجد اتصال بالإنترنت'));
    }
  }
}
