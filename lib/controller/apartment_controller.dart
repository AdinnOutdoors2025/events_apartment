import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/get_list_model.dart';
import '../services/api_service.dart';
import '../utils/snackbar.dart';

class ApartmentController extends GetxController {
  final ApiService apiService = ApiService();
  Rxn<Datas> apartmentData = Rxn<Datas>();
  RxList<Apartment> apartments = <Apartment>[].obs;
  RxBool isLoading = false.obs;
  RxBool isPaginationLoading = false.obs;
  int page = 1;
  int totalPages = 1;
  String? currentSessionId;
  final ScrollController scrollController = ScrollController();
  final selectedLocation = RxnString();
  final selectedCity = RxnString();
  final campaignPriceRange = const RangeValues(5000, 15000).obs;
  final tgValueRange = const RangeValues(40, 120).obs;

  @override
  void onInit() {
    super.onInit();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 200 &&
          !isPaginationLoading.value &&
          page < totalPages) {
        getApartments(isLoadMore: true);
      }
    });

    getApartments();
  }

  final locations = [
    'Anna Nagar',
    'T. Nagar',
    'Velachery',
    'Porur',
    'OMR',
    'ECR',
  ];

  final cities = ['Chennai', 'Coimbatore', 'Madurai', 'Trichy', 'Salem'];

  Future<void> getApartments({
    bool isLoadMore = false,
    String? sessionId,
    String? search,
    String? location,
    int? minRent,
    int? maxRent,
    int? minTG,
    int? maxTG,
  }) async {
    try {
      if (sessionId != null && sessionId.isNotEmpty) {
        currentSessionId = sessionId;
      }
      final selectedSessionId = currentSessionId;

      if (isLoadMore) {
        isPaginationLoading.value = true;
        page++;
      } else {
        isLoading.value = true;
        page = 1;
        apartments.clear();
      }

      final response = await apiService.getApartmentSummary(
        pageNumber: page,
        count: 10,
        sessionId: selectedSessionId,
        search: search,
        location: location,
        minRent: minRent,
        maxRent: maxRent,
        minTG: minTG,
        maxTG: maxTG,
      );

      if (response.success == true) {
        apartmentData.value = response.data;
        totalPages = response.data?.totalPages ?? 1;

        apartments.addAll(response.data?.apartments ?? []);
      }
    } catch (e) {
      AppToast.showError(e.toString());
    } finally {
      isLoading.value = false;
      isPaginationLoading.value = false;
    }
  }

  void clearSessionFilter() {
    currentSessionId = null;
  }

  void resetFilters() {
    selectedLocation.value = null;
    selectedCity.value = null;
    campaignPriceRange.value = const RangeValues(5000, 15000);
    tgValueRange.value = const RangeValues(40, 120);
  }

  void applyFilterFromSheet() {
    // Here you can filter your apartment list
    // based on selectedLocation, selectedCity, price range, and TG value range.
  }
}
