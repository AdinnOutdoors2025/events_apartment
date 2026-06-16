import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/order_details_model.dart';
import '../services/api_service.dart';

class OrderDetailsState {
  final bool isLoading;
  final OrderDetails? details;

  const OrderDetailsState({
    this.isLoading = false,
    this.details,
  });

  OrderDetailsState copyWith({
    bool? isLoading,
    OrderDetails? details,
  }) {
    return OrderDetailsState(
      isLoading: isLoading ?? this.isLoading,
      details: details ?? this.details,
    );
  }

}
class OrderDetailsViewModel
    extends AutoDisposeFamilyNotifier<
        OrderDetailsState,
        String> {

  final ApiService api = ApiService();

  @override
  OrderDetailsState build(String orderId) {
    Future.microtask(() {
      getOrderDetails(orderId);
    });

    return const OrderDetailsState(
      isLoading: true,
    );
  }

  Future<void> getOrderDetails(String orderId) async {
    try {
      state = state.copyWith(
        isLoading: true,
      );

      final response =
      await api.getOrderDetails(
        orderId: orderId,
      );

      state = state.copyWith(
        details: response.data,
      );
    } finally {
      state = state.copyWith(
        isLoading: false,
      );
    }
  }

}
final orderDetailsProvider =
NotifierProvider.autoDispose.family<
    OrderDetailsViewModel,
    OrderDetailsState,
    String>(
  OrderDetailsViewModel.new,
);

