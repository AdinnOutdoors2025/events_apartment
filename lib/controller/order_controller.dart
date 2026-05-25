import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../model/order_history_model.dart';
import '../services/api_service.dart';
import '../utils/snackbar.dart';

class OrderController extends GetxController {
  final ApiService apiService = ApiService();

  RxBool isLoading = false.obs;
  RxBool isPaginationLoading = false.obs;

  RxList<Booking> orderList = <Booking>[].obs;

  Rxn<OrderData> orderData = Rxn<OrderData>();

  int currentPage = 1;
  int totalPages = 1;

  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();

    getOrderHistory();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 200 &&
          !isPaginationLoading.value &&
          currentPage < totalPages) {
        getOrderHistory(isLoadMore: true);
      }
    });
  }

  Future<void> getOrderHistory({bool isLoadMore = false}) async {
    try {
      if (isLoadMore) {
        isPaginationLoading.value = true;
        currentPage++;
      } else {
        isLoading.value = true;
        currentPage = 1;
        orderList.clear();
      }

      final OrderHistoryModel response = await apiService.getOrderHistoryAPI(
        pageNumber: currentPage,
        count: 10,
      );

      if (response.success == true) {
        orderData.value = response.data;

        totalPages = response.data?.totalPages ?? 1;

        final List<Booking> newData = response.data?.bookings ?? [];

        orderList.addAll(newData);
      }
    } catch (e) {
      AppToast.showError(e.toString());

      if (kDebugMode) {
        print(e.toString());
      }
    } finally {
      isLoading.value = false;
      isPaginationLoading.value = false;
    }
  }

  Future<void> refreshOrders() async {
    await getOrderHistory();
  }
}
