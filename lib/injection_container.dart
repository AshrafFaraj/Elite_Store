import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import 'core/network/network_info.dart';
import 'core/services/api_service.dart';
import 'features/auth/data/datasources/auth_local_data_source.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/logout_usecase.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

import 'features/home/data/datasources/product_remote_data_source.dart';
import 'features/home/data/repositories/product_repository_impl.dart';
import 'features/home/domain/repositories/product_repository.dart';
import 'features/home/domain/usecases/get_products_usecase.dart';
import 'features/home/domain/usecases/get_products_by_category_usecase.dart';
import 'features/home/presentation/bloc/product_bloc.dart';

import 'features/cart/data/datasources/cart_local_data_source.dart';
import 'features/cart/data/repositories/cart_repository_impl.dart';
import 'features/cart/domain/repositories/cart_repository.dart';
import 'features/cart/presentation/bloc/cart_bloc.dart';

import 'features/favorites/data/datasources/favorite_local_data_source.dart';
import 'features/favorites/data/repositories/favorite_repository_impl.dart';
import 'features/favorites/domain/repositories/favorite_repository.dart';
import 'features/favorites/presentation/bloc/favorite_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Auth
  sl.registerFactory(() => AuthBloc(
        loginWithEmailUseCase: sl(),
        loginWithPhoneUseCase: sl(),
        logoutUseCase: sl(),
        repository: sl(),
      ));
  sl.registerLazySingleton(() => LoginWithEmailUseCase(sl()));
  sl.registerLazySingleton(() => LoginWithPhoneUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
        remoteDataSource: sl(),
        localDataSource: sl(),
      ));
  sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(apiService: sl()));
  sl.registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(sl()));

  //! Features - Products
  sl.registerFactory(() => ProductBloc(
      getProductsUseCase: sl(), getProductsByCategoryUseCase: sl()));
  sl.registerLazySingleton(() => GetProductsUseCase(sl()));
  sl.registerLazySingleton(() => GetProductsByCategoryUseCase(sl()));
  sl.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl(
        remoteDataSource: sl(),
        networkInfo: sl(),
      ));
  sl.registerLazySingleton<ProductRemoteDataSource>(
      () => ProductRemoteDataSourceImpl(apiService: sl()));

  //! Features - Cart
  sl.registerFactory(() => CartBloc(repository: sl()));
  sl.registerLazySingleton<CartRepository>(
      () => CartRepositoryImpl(localDataSource: sl()));
  sl.registerLazySingleton<CartLocalDataSource>(
      () => CartLocalDataSourceImpl(sharedPreferences: sl()));

  //! Features - Favorites
  sl.registerFactory(() => FavoriteBloc(repository: sl()));
  sl.registerLazySingleton<FavoriteRepository>(
      () => FavoriteRepositoryImpl(localDataSource: sl()));
  sl.registerLazySingleton<FavoriteLocalDataSource>(
      () => FavoriteLocalDataSourceImpl(sharedPreferences: sl()));

  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton(() => ApiService(client: sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnection());
}
