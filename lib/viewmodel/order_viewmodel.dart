import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/order_history_model.dart';
import '../services/api_service.dart';
import '../utils/snackbar.dart';

class OrderState {
  final bool isLoading;
  final bool isPaginationLoading;
  final List<Booking> orderList;
  final OrderData? orderData;
  final int currentPage;
  final int totalPages;

  OrderState({
    this.isLoading = false,
    this.isPaginationLoading = false,
    this.orderList = const [],
    this.orderData,
    this.currentPage = 1,
    this.totalPages = 1,
  });

  OrderState copyWith({
    bool? isLoading,
    bool? isPaginationLoading,
    List<Booking>? orderList,
    OrderData? Function()? orderData,
    int? currentPage,
    int? totalPages,
  }) {
    return OrderState(
      isLoading: isLoading ?? this.isLoading,
      isPaginationLoading: isPaginationLoading ?? this.isPaginationLoading,
      orderList: orderList ?? this.orderList,
      orderData: orderData != null ? orderData() : this.orderData,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
    );
  }
}

class OrderViewModel extends AutoDisposeNotifier<OrderState> {
  final ApiService apiService = ApiService();
  final ScrollController scrollController = ScrollController();

  @override
  OrderState build() {
    ref.onDispose(() {
      scrollController.dispose();
    });

    Future.microtask(() {
      getOrderHistory();
    });

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 200 &&
          !state.isPaginationLoading &&
          state.currentPage < state.totalPages) {
        getOrderHistory(isLoadMore: true);
      }
    });

    return OrderState();
  }

  Future<void> getOrderHistory({bool isLoadMore = false}) async {
    try {
      int page = state.currentPage;
      List<Booking> currentList = List.from(state.orderList);

      if (isLoadMore) {
        state = state.copyWith(isPaginationLoading: true);
        page++;
      } else {
        state = state.copyWith(isLoading: true);
        page = 1;
        currentList.clear();
      }

      final OrderHistoryModel response = await apiService.getOrderHistoryAPI(
        pageNumber: page,
        count: 10,
      );

      if (response.success == true) {
        currentList.addAll(response.data?.bookings ?? []);
        state = state.copyWith(
          orderData: () => response.data,
          totalPages: response.data?.totalPages ?? 1,
          orderList: currentList,
          currentPage: page,
        );
      }
    } catch (e) {
      AppToast.showError(e.toString());
    } finally {
      state = state.copyWith(isLoading: false, isPaginationLoading: false);
    }
  }

  Future<void> refreshOrders() async {
    await getOrderHistory();
  }

  Future<void> updateOrderStatus({
    required String orderId,
    required int status,
    PlatformFile? poDocument,
    PlatformFile? statusDocument,
    PlatformFile? voiceDocument,
    String? additionalNotes,
    String? closeLossReason,
  }) async {
    try {
      await apiService.updateOrderStatus(
        orderId: orderId,
        status: status,
        poDocument: poDocument,
        statusDocument: statusDocument,
        voiceDocument: voiceDocument,
        additionalNotes: additionalNotes,
        closeLossReason: closeLossReason,
      );

      AppToast.showSuccess("Status updated successfully");

      Future.microtask(() {
        getOrderHistory();
      });
    } catch (e) {
      AppToast.showError(e.toString());
    }
  }
}

final orderViewModelProvider =
    NotifierProvider.autoDispose<OrderViewModel, OrderState>(
      OrderViewModel.new,
    );
