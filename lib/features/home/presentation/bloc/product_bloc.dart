import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../domain/usecases/get_products_by_category_usecase.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductsUseCase getProductsUseCase;
  final GetProductsByCategoryUseCase getProductsByCategoryUseCase;

  ProductBloc({
    required this.getProductsUseCase,
    required this.getProductsByCategoryUseCase,
  }) : super(ProductInitial()) {
    on<FetchProductsEvent>((event, emit) async {
      emit(ProductLoading());
      final result = await getProductsUseCase(NoParams());
      result.fold(
        (failure) => emit(ProductError(failure.message)),
        (products) => emit(ProductLoaded(products)),
      );
    });

    on<FetchProductsByCategoryEvent>((event, emit) async {
      emit(ProductLoading());
      final result = await getProductsByCategoryUseCase(event.category);
      result.fold(
        (failure) => emit(ProductError(failure.message)),
        (products) => emit(ProductLoaded(products)),
      );
    });
  }
}
