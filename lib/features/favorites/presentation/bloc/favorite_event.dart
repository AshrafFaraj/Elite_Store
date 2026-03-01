import 'package:equatable/equatable.dart';

import '../../../home/domain/entities/product.dart';

abstract class FavoriteEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadFavoritesEvent extends FavoriteEvent {}

class ToggleFavoriteEvent extends FavoriteEvent {
  final Product product;
  ToggleFavoriteEvent(this.product);

  @override
  List<Object?> get props => [product];
}
