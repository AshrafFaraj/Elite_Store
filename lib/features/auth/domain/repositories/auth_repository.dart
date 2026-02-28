import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> loginWithEmail(String email, String password);
  Future<Either<Failure, User>> loginWithPhone(String phone);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, User?>> getAuthenticatedUser();
}
