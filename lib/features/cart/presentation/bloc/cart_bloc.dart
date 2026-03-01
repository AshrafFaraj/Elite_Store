import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/repositories/cart_repository.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository repository;

  CartBloc({required this.repository}) : super(CartInitial()) {
    
    on<LoadCartEvent>((event, emit) async {
      emit(CartLoading());
      final result = await repository.getCartItems();
      result.fold(
        (failure) => emit(CartError(failure.message)),
        (items) => emit(CartLoaded(items)),
      );
    });

    on<AddToCartEvent>((event, emit) async {
      await repository.addToCart(event.item);
      add(LoadCartEvent());
    });

    on<RemoveFromCartEvent>((event, emit) async {
      await repository.removeFromCart(event.productId);
      add(LoadCartEvent());
    });

    on<UpdateQuantityEvent>((event, emit) async {
      await repository.updateQuantity(event.productId, event.quantity);
      add(LoadCartEvent());
    });

    on<ClearCartEvent>((event, emit) async {
      await repository.clearCart();
      add(LoadCartEvent());
    });
  }
}
