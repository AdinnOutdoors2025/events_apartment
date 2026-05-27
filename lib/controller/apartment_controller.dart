import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/get_list_model.dart';
import '../services/api_service.dart';
import '../utils/snackbar.dart';

class ApartmentController extends GetxController {
  ApartmentController({this.initialSessionId});

  final String? initialSessionId;
  final ApiService apiService = ApiService();
  Rxn<Datas> apartmentData = Rxn<Datas>();
  RxList<Apartment> apartments = <Apartment>[].obs;
  RxBool isLoading = false.obs;
  RxBool isPaginationLoading = false.obs;
  int page = 1;
  int totalPages = 1;
  final RxnString currentSessionId = RxnString();
  final ScrollController scrollController = ScrollController();
  final isFilterApplied = false.obs;
  final selectedLocation = RxnString();
  final selectedCity = RxnString();

  final locations = <String>[].obs;
  final cities = <String>[].obs;

  final minCampaignRent = 0.0.obs;
  final maxCampaignRent = 0.0.obs;
  final campaignPriceRange = const RangeValues(0, 0).obs;

  final minTG = 0.0.obs;
  final maxTG = 0.0.obs;
  final tgValueRange = const RangeValues(0, 0).obs;
  final appliedLocation = RxnString();
  final appliedCity = RxnString();

  final appliedCampaignRange = const RangeValues(0, 0).obs;
  final appliedTGRange = const RangeValues(0, 0).obs;
  final openedDropdown = RxnString();

  @override
  void onInit() {
    super.onInit();
    currentSessionId.value = initialSessionId;
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 200 &&
          !isPaginationLoading.value &&
          page < totalPages) {
        getApartments(isLoadMore: true);
      }
    });

    getApartments(sessionId: initialSessionId);
  }

  bool get isSessionBasedData {
    return currentSessionId.value?.isNotEmpty ?? false;
  }

  bool get hasAnyFilterSelected {
    final rent = campaignPriceRange.value;
    final tg = tgValueRange.value;

    final isRentDefault =
        rent.start.round() == minCampaignRent.value.round() &&
        rent.end.round() == maxCampaignRent.value.round();

    final isTGDefault =
        tg.start.round() == minTG.value.round() &&
        tg.end.round() == maxTG.value.round();

    return selectedLocation.value != null ||
        selectedCity.value != null ||
        !isRentDefault ||
        !isTGDefault;
  }

  Future<void> refreshApartments() async {
    await getApartments(
      sessionId: currentSessionId.value,
      updateFilterData: true,
    );
  }

  Future<void> getApartments({
    bool isLoadMore = false,
    bool updateFilterData = true,
    String? sessionId,
    String? search,
    String? location,
    String? city,
    int? minRent,
    int? maxRent,
    int? minTG,
    int? maxTG,
  }) async {
    try {
      if (sessionId != null && sessionId.isNotEmpty) {
        currentSessionId.value = sessionId;
      }
      final selectedSessionId = currentSessionId;
      final bool useCurrentFilters =
          isFilterApplied.value;
      if (kDebugMode) {
        print("usecurrentfilters: $useCurrentFilters");
      }
      final requestLocation =
          location ?? (useCurrentFilters ? selectedLocation.value : null);
      if (kDebugMode) {
        print("requestLocation: $requestLocation");
      }
      final requestCity =
          city ?? (useCurrentFilters ? selectedCity.value : null);

      final requestMinRent =
          minRent ??
          (useCurrentFilters ? campaignPriceRange.value.start.round() : null);

      final requestMaxRent =
          maxRent ??
          (useCurrentFilters ? campaignPriceRange.value.end.round() : null);

      final requestMinTG =
          minTG ??
          (useCurrentFilters ? tgValueRange.value.start.round() : null);

      final requestMaxTG =
          maxTG ?? (useCurrentFilters ? tgValueRange.value.end.round() : null);

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
        sessionId: selectedSessionId.value,
        search: search,
        location: requestLocation,
        city: requestCity,
        minRent: requestMinRent,
        maxRent: requestMaxRent,
        minTG: requestMinTG,
        maxTG: requestMaxTG,
      );

      if (response.success == true) {
        apartmentData.value = response.data;
        totalPages = response.data?.totalPages ?? 1;

        apartments.addAll(response.data?.apartments ?? []);

        if (!isLoadMore && updateFilterData && !isFilterApplied.value) {
          setFilterDataFromApi(response.data);
        }
      }
    } catch (e) {
      AppToast.showError(e.toString());
    } finally {
      isLoading.value = false;
      isPaginationLoading.value = false;
    }
  }

  void toggleDropdown(String key) {
    if (openedDropdown.value == key) {
      openedDropdown.value = null;
    } else {
      openedDropdown.value = key;
    }
  }

  void closeDropdown() {
    openedDropdown.value = null;
  }

  void clearSessionFilter() {
    currentSessionId.value = null;
  }

  void resetFilters() {
    selectedLocation.value = null;
    selectedCity.value = null;

    campaignPriceRange.value = RangeValues(
      minCampaignRent.value,
      maxCampaignRent.value,
    );

    tgValueRange.value = RangeValues(minTG.value, maxTG.value);
    appliedLocation.value = null;
    appliedCity.value = null;

    appliedCampaignRange.value = campaignPriceRange.value;
    appliedTGRange.value = tgValueRange.value;
    closeDropdown();
  }

  void setFilterDataFromApi(Datas? data) {
    locations.assignAll(data?.locationFilter ?? []);
    cities.assignAll(data?.cityFilter ?? []);

    final priceRange = data?.priceRange;

    if (priceRange == null) return;

    final apiMinRent = priceRange.minRent ?? 0;
    final apiMaxRent = priceRange.maxRent ?? 0;
    final apiMinTG = priceRange.minTG ?? 0;
    final apiMaxTG = priceRange.maxTG ?? 0;

    if (apiMaxRent > apiMinRent) {
      minCampaignRent.value = apiMinRent.toDouble();
      maxCampaignRent.value = apiMaxRent.toDouble();

      campaignPriceRange.value = RangeValues(
        minCampaignRent.value,
        maxCampaignRent.value,
      );
      appliedCampaignRange.value = RangeValues(
        minCampaignRent.value,
        maxCampaignRent.value,
      );
    }

    if (apiMaxTG > apiMinTG) {
      minTG.value = apiMinTG.toDouble();
      maxTG.value = apiMaxTG.toDouble();

      tgValueRange.value = RangeValues(minTG.value, maxTG.value);
      appliedTGRange.value = RangeValues(minTG.value, maxTG.value);
    }
  }

  void applyFilterFromSheet() {
    isFilterApplied.value = hasAnyFilterSelected;

    if (!isFilterApplied.value) {
      getApartments(updateFilterData: true);
      return;
    }

    final rentRange = campaignPriceRange.value;
    final tgRange = tgValueRange.value;

    appliedLocation.value = selectedLocation.value;
    appliedCity.value = selectedCity.value;

    appliedCampaignRange.value = campaignPriceRange.value;
    appliedTGRange.value = tgValueRange.value;
    getApartments(
      updateFilterData: false,
      location: selectedLocation.value,
      city: selectedCity.value,
      minRent: rentRange.start.round(),
      maxRent: rentRange.end.round(),
      minTG: tgRange.start.round(),
      maxTG: tgRange.end.round(),
    );
    closeDropdown();
  }

  void clearFiltersAndFetch() {
    resetFilters();
    isFilterApplied.value = false;
    getApartments(updateFilterData: true);
  }

  int get appliedFilterCount {
    int count = 0;
    if (kDebugMode) {
      print("count: $count");
    }

    if (appliedLocation.value != null) {
      count++;
    }

    if (appliedCity.value != null) {
      count++;
    }

    final rent = appliedCampaignRange.value;

    final isRentDefault =
        rent.start.round() == minCampaignRent.value.round() &&
        rent.end.round() == maxCampaignRent.value.round();

    if (!isRentDefault) {
      count++;
    }

    final tg = appliedTGRange.value;

    final isTGDefault =
        tg.start.round() == minTG.value.round() &&
        tg.end.round() == maxTG.value.round();

    if (!isTGDefault) {
      count++;
    }
    return count;
  }

  Future<void> removeSessionFilter() async {
    currentSessionId.value = null;

    resetFilters();

    isFilterApplied.value = false;

    await getApartments(updateFilterData: true);
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
