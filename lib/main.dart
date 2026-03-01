import 'package:elite_store/features/cart/presentation/bloc/cart_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/cart/presentation/bloc/cart_bloc.dart';
import 'features/home/presentation/bloc/product_bloc.dart';
import 'injection_container.dart' as di;
import 'main_page.dart';
// import 'features/products/presentation/bloc/product_bloc.dart';
// import 'features/cart/presentation/bloc/cart_bloc.dart';
// import 'features/cart/presentation/bloc/cart_event.dart';
// import 'features/favorites/presentation/bloc/favorite_bloc.dart';
// import 'features/favorites/presentation/bloc/favorite_event.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/auth/presentation/pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => di.sl<AuthBloc>()..add(CheckAuthStatusEvent())),
        BlocProvider(create: (_) => di.sl<ProductBloc>()),
        BlocProvider(create: (_) => di.sl<CartBloc>()..add(LoadCartEvent())),
        // BlocProvider(create: (_) => di.sl<FavoriteBloc>()..add(LoadFavoritesEvent())),
      ],
      child: MaterialApp(
        title: 'Elite Store',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily:
              'Cairo', // تأكد من إضافة الخط في pubspec.yaml إذا أردت استخدامه
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        ),
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading || state is AuthInitial) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(color: Colors.black),
                ),
              );
            } else if (state is Authenticated) {
              return const MainPage();
            } else {
              return const LoginPage();
            }
          },
        ),
      ),
    );
  }
}
