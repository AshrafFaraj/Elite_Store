import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginParams {
  final String email;
  final String password;
  LoginParams({required this.email, required this.password});
}

class LoginWithEmailUseCase implements UseCase<User, LoginParams> {
  final AuthRepository repository;

  LoginWithEmailUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(LoginParams params) async {
    return await repository.loginWithEmail(params.email, params.password);
  }
}

class LoginPhoneParams {
  final String phone;
  LoginPhoneParams({required this.phone});
}

class LoginWithPhoneUseCase implements UseCase<User, LoginPhoneParams> {
  final AuthRepository repository;

  LoginWithPhoneUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(LoginPhoneParams params) async {
    return await repository.loginWithPhone(params.phone);
  }
}
