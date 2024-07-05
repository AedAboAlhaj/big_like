import 'package:big_like/features/orders/domain/models/product_api_model.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/models/products_api_model.dart';

class CartCubit extends Cubit<List<ProductApiModel>> {
  CartCubit() : super([]);

  bool addToCart(ProductApiModel product) {
    if (product.quantity > 0) {
      emit([...state, product]);
      return true;
    } else {
      addError('لا يوجد كمية كافية');
      return false;
    }
  }

  void increaseQuantity(ProductApiModel product) {
    ++state
        .firstWhere(
          (element) => element.id == product.id,
        )
        .userSelectedQuantity;
    emit([
      ...state
    ]); /* if (product.quantity > 0) {
      emit([...state, product]);
      return true;
    } else {
      addError('لا يوجد كمية كافية');
      return false;
    }*/
  }

  void decreaseQuantity(ProductApiModel product) {
    --state
        .firstWhere(
          (element) => element.id == product.id,
        )
        .userSelectedQuantity;
    emit([...state]);
  }

  void deleteFromCart(ProductApiModel product) {
    state.removeWhere(
      (element) => element.id == product.id,
    );
    emit([...state]);

    return;
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    // TODO: implement onError
    super.onError(error, stackTrace);
    debugPrint(error.toString());
  }
}
