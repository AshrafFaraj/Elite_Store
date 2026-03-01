import '../../../../core/services/api_service.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> loginWithEmail(String email, String password);
  Future<UserModel> loginWithPhone(String phone);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiService apiService;

  AuthRemoteDataSourceImpl({required this.apiService});

  @override
  Future<UserModel> loginWithEmail(String email, String password) async {
    // محاكاة تسجيل الدخول بالإيميل
    await Future.delayed(const Duration(seconds: 1));
    if (email == 'test@test.com' && password == '123456') {
      return const UserModel(
        id: '1',
        name: 'مستخدم تجريبي',
        email: 'test@test.com',
      );
    }

    // في حال استخدام API حقيقي:
    // final response = await apiService.post('/auth/login', {
    //   'email': email,
    //   'password': password,
    // });
    // return UserModel.fromJson(response);

    return const UserModel(
      id: '1',
      name: 'مستخدم تجريبي',
      email: 'test@test.com',
    );
  }

  @override
  Future<UserModel> loginWithPhone(String phone) async {
    // محاكاة تسجيل الدخول برقم الجوال
    await Future.delayed(const Duration(seconds: 1));
    return UserModel(
      id: '2',
      name: 'مستخدم جوال',
      phone: phone,
    );
  }
}
