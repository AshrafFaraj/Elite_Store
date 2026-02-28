import '../../../../core/services/api_service.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String username, String password);
  Future<UserModel> loginWithPhone(String phone);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiService apiService;

  AuthRemoteDataSourceImpl({required this.apiService});

  @override
  Future<UserModel> login(String username, String password) async {
    final response = await apiService.post('/auth/login', {
      'username': username,
      'password': password,
    });
    return UserModel.fromJson(response);
  }

  @override
  Future<UserModel> loginWithPhone(String phone) async {
    final response = await apiService.post('/auth/login', {
      'phone': phone,
    });
    return UserModel.fromJson(response);
  }
}
