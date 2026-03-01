import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/favorite_repository.dart';
import 'favorite_event.dart';
import 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final FavoriteRepository repository;

  FavoriteBloc({required this.repository}) : super(FavoriteInitial()) {
    on<LoadFavoritesEvent>((event, emit) async {
      emit(FavoriteLoading());
      final result = await repository.getFavorites();
      result.fold(
        (failure) => emit(FavoriteError(failure.message)),
        (favorites) => emit(FavoriteLoaded(favorites)),
      );
    });

    on<ToggleFavoriteEvent>((event, emit) async {
      final result = await repository.toggleFavorite(event.product);
      result.fold(
        (failure) => emit(FavoriteError(failure.message)),
        (_) => add(LoadFavoritesEvent()),
      );
    });
  }
}
