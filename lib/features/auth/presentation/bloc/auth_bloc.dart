import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginWithEmailUseCase loginWithEmailUseCase;
  final LogoutUseCase logoutUseCase;
  final AuthRepository repository; // لجلب حالة المستخدم الحالية

  AuthBloc({
    required this.loginWithEmailUseCase,
    required this.logoutUseCase,
    required this.repository,
  }) : super(AuthInitial()) {
    
    on<CheckAuthStatusEvent>((event, emit) async {
      emit(AuthLoading());
      final result = await repository.getAuthenticatedUser();
      result.fold(
        (failure) => emit(Unauthenticated()),
        (user) {
          if (user != null) {
            emit(Authenticated(user));
          } else {
            emit(Unauthenticated());
          }
        },
      );
    });

    on<LoginWithEmailEvent>((event, emit) async {
      emit(AuthLoading());
      final result = await loginWithEmailUseCase(
        LoginParams(email: event.email, password: event.password),
      );
      result.fold(
        (failure) => emit(AuthError(failure.message)),
        (user) => emit(Authenticated(user)),
      );
    });

    on<LogoutEvent>((event, emit) async {
      emit(AuthLoading());
      await logoutUseCase(NoParams());
      emit(Unauthenticated());
    });
  }
}
