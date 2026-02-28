import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> loginWithEmail(
      String email, String password) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteUser = await remoteDataSource.login(email, password);
        await localDataSource.cacheUser(remoteUser);
        return Right(remoteUser);
      } catch (e) {
        return const Left(
            ServerFailure('فشل تسجيل الدخول، يرجى المحاولة لاحقاً'));
      }
    } else {
      return const Left(NetworkFailure('لا يوجد اتصال بالإنترنت'));
    }
  }

  @override
  Future<Either<Failure, User>> loginWithPhone(String phone) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteUser = await remoteDataSource.loginWithPhone(
          phone,
        );
        await localDataSource.cacheUser(remoteUser);
        return Right(remoteUser);
      } catch (e) {
        return const Left(ServerFailure('فشل تسجيل الدخول عبر الجوال'));
      }
    } else {
      return const Left(NetworkFailure('لا يوجد اتصال بالإنترنت'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.clearCache();
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure('فشل تسجيل الخروج'));
    }
  }

  @override
  Future<Either<Failure, User?>> getAuthenticatedUser() async {
    try {
      final user = await localDataSource.getLastUser();
      return Right(user);
    } catch (e) {
      return const Left(CacheFailure('فشل جلب بيانات المستخدم'));
    }
  }
}
