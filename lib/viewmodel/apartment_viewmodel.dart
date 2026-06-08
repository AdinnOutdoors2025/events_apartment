import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/get_list_model.dart';
import '../services/api_service.dart';
import '../utils/snackbar.dart';

class ApartmentState {
  final Datas? apartmentData;
  final List<Apartment> apartments;
  final bool isLoading;
  final bool isPaginationLoading;
  final int page;
  final int totalPages;
  final String? currentSessionId;
  final bool isFilterApplied;
  final String? selectedLocation;
  final String? selectedCity;
  final String? selectedGroupedName;
  final List<String> locations;
  final List<String> cities;
  final List<String> apartmentGroupName;
  final double minCampaignRent;
  final double maxCampaignRent;
  final RangeValues campaignPriceRange;
  final double minTG;
  final double maxTG;
  final RangeValues tgValueRange;
  final String? appliedLocation;
  final String? appliedCity;
  final String? appliedGroupedName;
  final RangeValues appliedCampaignRange;
  final RangeValues appliedTGRange;
  final String? openedDropdown;
  final List<Apartment> allApartments;

  ApartmentState({
    this.apartmentData,
    this.apartments = const [],
    this.isLoading = false,
    this.isPaginationLoading = false,
    this.page = 1,
    this.totalPages = 1,
    this.currentSessionId,
    this.isFilterApplied = false,
    this.selectedLocation,
    this.selectedCity,
    this.selectedGroupedName,
    this.locations = const [],
    this.cities = const [],
    this.apartmentGroupName = const [],
    this.minCampaignRent = 0.0,
    this.maxCampaignRent = 0.0,
    this.campaignPriceRange = const RangeValues(0, 0),
    this.minTG = 0.0,
    this.maxTG = 0.0,
    this.tgValueRange = const RangeValues(0, 0),
    this.appliedLocation,
    this.appliedCity,
    this.appliedGroupedName,
    this.appliedCampaignRange = const RangeValues(0, 0),
    this.appliedTGRange = const RangeValues(0, 0),
    this.openedDropdown,
    this.allApartments = const [],
  });

  ApartmentState copyWith({
    Datas? Function()? apartmentData,
    List<Apartment>? apartments,
    bool? isLoading,
    bool? isPaginationLoading,
    int? page,
    int? totalPages,
    String? Function()? currentSessionId,
    bool? isFilterApplied,
    String? Function()? selectedLocation,
    String? Function()? selectedCity,
    String? Function()? selectedGroupedName,
    List<String>? locations,
    List<String>? cities,
    List<String>? apartmentGroupName,
    double? minCampaignRent,
    double? maxCampaignRent,
    RangeValues? campaignPriceRange,
    double? minTG,
    double? maxTG,
    RangeValues? tgValueRange,
    String? Function()? appliedLocation,
    String? Function()? appliedCity,
    String? Function()? appliedGroupName,
    RangeValues? appliedCampaignRange,
    RangeValues? appliedTGRange,
    String? Function()? openedDropdown,
    List<Apartment>? allApartments,
  }) {
    return ApartmentState(
      apartmentData: apartmentData != null
          ? apartmentData()
          : this.apartmentData,
      apartments: apartments ?? this.apartments,
      isLoading: isLoading ?? this.isLoading,
      isPaginationLoading: isPaginationLoading ?? this.isPaginationLoading,
      page: page ?? this.page,
      totalPages: totalPages ?? this.totalPages,
      currentSessionId: currentSessionId != null
          ? currentSessionId()
          : this.currentSessionId,
      isFilterApplied: isFilterApplied ?? this.isFilterApplied,
      selectedLocation: selectedLocation != null
          ? selectedLocation()
          : this.selectedLocation,
      selectedCity: selectedCity != null ? selectedCity() : this.selectedCity,
      selectedGroupedName: selectedGroupedName != null
          ? selectedGroupedName()
          : this.selectedGroupedName,
      locations: locations ?? this.locations,
      cities: cities ?? this.cities,
      apartmentGroupName: apartmentGroupName ?? this.apartmentGroupName,
      minCampaignRent: minCampaignRent ?? this.minCampaignRent,
      maxCampaignRent: maxCampaignRent ?? this.maxCampaignRent,
      campaignPriceRange: campaignPriceRange ?? this.campaignPriceRange,
      minTG: minTG ?? this.minTG,
      maxTG: maxTG ?? this.maxTG,
      tgValueRange: tgValueRange ?? this.tgValueRange,
      appliedLocation: appliedLocation != null
          ? appliedLocation()
          : this.appliedLocation,
      appliedCity: appliedCity != null ? appliedCity() : this.appliedCity,
      appliedGroupedName: appliedGroupName != null
          ? appliedGroupName()
          : appliedGroupedName,
      appliedCampaignRange: appliedCampaignRange ?? this.appliedCampaignRange,
      appliedTGRange: appliedTGRange ?? this.appliedTGRange,
      openedDropdown: openedDropdown != null
          ? openedDropdown()
          : this.openedDropdown,
      allApartments: allApartments ?? this.allApartments,
    );
  }
}

class ApartmentViewModel
    extends AutoDisposeFamilyNotifier<ApartmentState, String?> {
  final ApiService apiService = ApiService();
  final ScrollController scrollController = ScrollController();
  Timer? _searchDebounce;
  String _currentSearch = '';
  final TextEditingController searchController = TextEditingController();
  bool _isLocalSearch = false;

  @override
  ApartmentState build(String? arg) {
    ref.onDispose(() {
      scrollController.dispose();
    });

    Future.microtask(() {
      getApartments(sessionId: arg);
    });

    scrollController.addListener(() {
      if (_currentSearch.isNotEmpty) {
        return;
      }

      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 200 &&
          !state.isPaginationLoading &&
          state.page < state.totalPages) {
        getApartments(isLoadMore: true);
      }
    });

    return ApartmentState(currentSessionId: arg);
  }

  bool get isSessionBasedData {
    return state.currentSessionId?.isNotEmpty ?? false;
  }

  void searchApartments(String query) {
    print("Searching in ${state.allApartments.length} apartments");

    for (final apartment in state.allApartments) {
      print(apartment.apartmentName);
    }
    _searchDebounce?.cancel();

    _currentSearch = query;
    if (query.trim().isEmpty) {
      state = state.copyWith(apartments: List.from(state.allApartments));
      return;
    }

    final searchText = query.toLowerCase();

    final localResults = state.allApartments.where((apartment) {
      return (apartment.apartmentName ?? '').toLowerCase().contains(
            searchText,
          ) ||
          (apartment.location ?? '').toLowerCase().contains(searchText) ||
          (apartment.city ?? '').toLowerCase().contains(searchText) ||
          (apartment.residencyCount ?? 0).toString().contains(searchText) ||
          (apartment.perDayRent ?? 0).toString().contains(searchText) ||
          (apartment.fromTGValues ?? 0).toString().contains(searchText) ||
          (apartment.toTGValues ?? 0).toString().contains(searchText);
    }).toList();

    if (localResults.isNotEmpty) {
      _isLocalSearch = true;
      state = state.copyWith(apartments: localResults);
      return;
    }
    _isLocalSearch = false;

    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      getApartments(search: query, isSearch: true);
    });
  }

  Future<void> clearSearch() async {
    _currentSearch = '';

    searchController.clear();

    state = state.copyWith(apartments: List.from(state.allApartments));
  }

  bool get hasAnyFilterSelected {
    final rent = state.campaignPriceRange;
    final tg = state.tgValueRange;

    final isRentDefault =
        rent.start.round() == state.minCampaignRent.round() &&
        rent.end.round() == state.maxCampaignRent.round();

    final isTGDefault =
        tg.start.round() == state.minTG.round() &&
        tg.end.round() == state.maxTG.round();

    return state.selectedLocation != null ||
        state.selectedCity != null ||
        state.selectedGroupedName != null ||
        !isRentDefault ||
        !isTGDefault;
  }

  Future<void> refreshApartments() async {
    if (_currentSearch.isNotEmpty) {
      if (_isLocalSearch) {
        await Future.delayed(const Duration(seconds: 1));
        searchApartments(_currentSearch);
        return;
      }

      await getApartments(
        search: _currentSearch,
        isSearch: true,
      );
      return;
    }
    final rentChanged =
        state.appliedCampaignRange.start.round() !=
            state.minCampaignRent.round() ||
        state.appliedCampaignRange.end.round() != state.maxCampaignRent.round();

    final tgChanged =
        state.appliedTGRange.start.round() != state.minTG.round() ||
        state.appliedTGRange.end.round() != state.maxTG.round();

    await getApartments(
      sessionId: state.currentSessionId,
      updateFilterData: false,
      location: state.appliedLocation,
      city: state.appliedCity,
      apartmentGroupName: state.appliedGroupedName,
      minRent: rentChanged ? state.appliedCampaignRange.start.round() : null,
      maxRent: rentChanged ? state.appliedCampaignRange.end.round() : null,
      minTG: tgChanged ? state.appliedTGRange.start.round() : null,
      maxTG: tgChanged ? state.appliedTGRange.end.round() : null,
    );
  }

  /*
  Future<void> getApartments({
    bool isLoadMore = false,
    bool updateFilterData = true,
    String? sessionId,
    String? search,
    String? location,
    String? city,
    String? apartmentGroupName,
    int? minRent,
    int? maxRent,
    int? minTG,
    int? maxTG,
  }) async {
    try {
      String? activeSessionId = state.currentSessionId;
      if (sessionId != null && sessionId.isNotEmpty) {
        activeSessionId = sessionId;
        state = state.copyWith(currentSessionId: () => sessionId);
      }

      final bool useCurrentFilters = state.isFilterApplied;

      final bool appliedRentChanged =
          state.appliedCampaignRange.start.round() !=
              state.minCampaignRent.round() ||
          state.appliedCampaignRange.end.round() !=
              state.maxCampaignRent.round();

      final bool appliedTGChanged =
          state.appliedTGRange.start.round() != state.minTG.round() ||
          state.appliedTGRange.end.round() != state.maxTG.round();

      final requestLocation =
          location ?? (useCurrentFilters ? state.appliedLocation : null);

      final requestCity =
          city ?? (useCurrentFilters ? state.appliedCity : null);

      final requestApartmentGroupName =
          apartmentGroupName ??
          (useCurrentFilters ? state.appliedGroupedName : null);

      final requestMinRent =
          minRent ??
          (useCurrentFilters && appliedRentChanged
              ? state.appliedCampaignRange.start.round()
              : null);

      final requestMaxRent =
          maxRent ??
          (useCurrentFilters && appliedRentChanged
              ? state.appliedCampaignRange.end.round()
              : null);

      final requestMinTG =
          minTG ??
          (useCurrentFilters && appliedTGChanged
              ? state.appliedTGRange.start.round()
              : null);

      final requestMaxTG =
          maxTG ??
          (useCurrentFilters && appliedTGChanged
              ? state.appliedTGRange.end.round()
              : null);
      int nextPage = state.page;
      List<Apartment> currentList = List.from(state.apartments);

      if (kDebugMode) {
        print(
          "FILTER API PARAMS => "
          "sessionId: $activeSessionId, "
          "location: $requestLocation, "
          "city: $requestCity, "
          "apartmentGroupName: $requestApartmentGroupName, "
          "minRent: $requestMinRent, "
          "maxRent: $requestMaxRent, "
          "minTG: $requestMinTG, "
          "maxTG: $requestMaxTG",
        );
      }

      if (isLoadMore) {
        state = state.copyWith(isPaginationLoading: true);
        nextPage++;
      } else {
        state = state.copyWith(isLoading: true);
        nextPage = 1;
        currentList.clear();
      }

      final response = await apiService.getApartmentSummary(
        pageNumber: nextPage,
        count: 10,
        sessionId: activeSessionId,
        search: search,
        location: requestLocation,
        city: requestCity,
        apartmentGroupName: requestApartmentGroupName,
        minRent: requestMinRent,
        maxRent: requestMaxRent,
        minTG: requestMinTG,
        maxTG: requestMaxTG,
      );

      if (response.success == true) {
        currentList.addAll(response.data?.apartments ?? []);
        state = state.copyWith(
          apartmentData: () => response.data,
          totalPages: response.data?.totalPages ?? 1,
          apartments: currentList,
          allApartments: currentList,
          page: nextPage,
        );

        if (!isLoadMore && updateFilterData && !state.isFilterApplied) {
          setFilterDataFromApi(response.data);
        }
      }
    } catch (e) {
      AppToast.showError(e.toString());
      print("$e");
    } finally {
      state = state.copyWith(isLoading: false, isPaginationLoading: false);
    }
  }
*/
  Future<void> getApartments({
    bool isLoadMore = false,
    bool updateFilterData = true,
    bool isSearch = false,
    String? sessionId,
    String? search,
    String? location,
    String? city,
    String? apartmentGroupName,
    int? minRent,
    int? maxRent,
    int? minTG,
    int? maxTG,
  }) async {
    try {
      String? activeSessionId = state.currentSessionId;

      if (sessionId != null && sessionId.isNotEmpty) {
        activeSessionId = sessionId;
        state = state.copyWith(currentSessionId: () => sessionId);
      }

      final bool useCurrentFilters = state.isFilterApplied;

      final bool appliedRentChanged =
          state.appliedCampaignRange.start.round() !=
              state.minCampaignRent.round() ||
          state.appliedCampaignRange.end.round() !=
              state.maxCampaignRent.round();

      final bool appliedTGChanged =
          state.appliedTGRange.start.round() != state.minTG.round() ||
          state.appliedTGRange.end.round() != state.maxTG.round();

      final requestLocation =
          location ?? (useCurrentFilters ? state.appliedLocation : null);

      final requestCity =
          city ?? (useCurrentFilters ? state.appliedCity : null);

      final requestApartmentGroupName =
          apartmentGroupName ??
          (useCurrentFilters ? state.appliedGroupedName : null);

      final requestMinRent =
          minRent ??
          (useCurrentFilters && appliedRentChanged
              ? state.appliedCampaignRange.start.round()
              : null);

      final requestMaxRent =
          maxRent ??
          (useCurrentFilters && appliedRentChanged
              ? state.appliedCampaignRange.end.round()
              : null);

      final requestMinTG =
          minTG ??
          (useCurrentFilters && appliedTGChanged
              ? state.appliedTGRange.start.round()
              : null);

      final requestMaxTG =
          maxTG ??
          (useCurrentFilters && appliedTGChanged
              ? state.appliedTGRange.end.round()
              : null);

      int nextPage = state.page;
      List<Apartment> currentList = List.from(state.apartments);

      if (!isSearch) {
        if (isLoadMore) {
          state = state.copyWith(isPaginationLoading: true);
          nextPage++;
        } else {
          state = state.copyWith(isLoading: true);
          nextPage = 1;
          currentList.clear();
        }
      } else {
        state = state.copyWith(isLoading: true);
      }

      if (kDebugMode) {
        print(
          "FILTER API PARAMS => "
          "search: $search, "
          "isSearch: $isSearch, "
          "page: ${isSearch ? null : nextPage}, "
          "count: ${isSearch ? null : 10}",
        );
      }

      final response = await apiService.getApartmentSummary(
        pageNumber: isSearch ? null : nextPage,
        count: isSearch ? null : 10,
        sessionId: activeSessionId,
        search: search,
        location: requestLocation,
        city: requestCity,
        apartmentGroupName: requestApartmentGroupName,
        minRent: requestMinRent,
        maxRent: requestMaxRent,
        minTG: requestMinTG,
        maxTG: requestMaxTG,
      );

      if (response.success == true) {
        // SEARCH RESPONSE
        if (isSearch) {
          state = state.copyWith(apartments: response.data?.apartments ?? []);
          return;
        }

        // NORMAL LIST RESPONSE
        currentList.addAll(response.data?.apartments ?? []);

        state = state.copyWith(
          apartmentData: () => response.data,
          totalPages: response.data?.totalPages ?? 1,
          apartments: currentList,
          allApartments: currentList,
          page: nextPage,
        );
        if (kDebugMode) {
          print("========== ALL APARTMENTS ==========");
          print("Total Stored: ${state.allApartments.length}");

          for (final apartment in state.allApartments) {
            print(
              "Name: ${apartment.apartmentName}, "
              "City: ${apartment.city}, "
              "Location: ${apartment.location}",
            );
          }

          print("====================================");
        }

        if (!isLoadMore && updateFilterData && !state.isFilterApplied) {
          setFilterDataFromApi(response.data);
        }
      }
    } catch (e) {
      AppToast.showError(e.toString());

      if (kDebugMode) {
        print(e);
      }
    } finally {
      state = state.copyWith(isLoading: false, isPaginationLoading: false);
    }
  }

  Future<void> removeCityFilter() async {
    state = state.copyWith(selectedCity: () => null, appliedCity: () => null);

    await applyFilterFromSheet();
  }

  Future<void> removeLocationFilter() async {
    state = state.copyWith(
      selectedLocation: () => null,
      appliedLocation: () => null,
    );

    await applyFilterFromSheet();
  }

  Future<void> removeGroupFilter() async {
    state = state.copyWith(
      selectedGroupedName: () => null,
      appliedGroupName: () => null,
    );

    await applyFilterFromSheet();
  }

  Future<void> removeRentFilter() async {
    state = state.copyWith(
      campaignPriceRange: RangeValues(
        state.minCampaignRent,
        state.maxCampaignRent,
      ),
      appliedCampaignRange: RangeValues(
        state.minCampaignRent,
        state.maxCampaignRent,
      ),
    );

    await applyFilterFromSheet();
  }

  Future<void> removeTGFilter() async {
    state = state.copyWith(
      tgValueRange: RangeValues(state.minTG, state.maxTG),
      appliedTGRange: RangeValues(state.minTG, state.maxTG),
    );

    await applyFilterFromSheet();
  }

  void toggleDropdown(String key) {
    if (state.openedDropdown == key) {
      state = state.copyWith(openedDropdown: () => null);
    } else {
      state = state.copyWith(openedDropdown: () => key);
    }
  }

  void closeDropdown() {
    state = state.copyWith(openedDropdown: () => null);
  }

  void clearSessionFilter() {
    state = state.copyWith(currentSessionId: () => null);
  }

  void resetFilters() {
    state = state.copyWith(
      selectedLocation: () => null,
      selectedCity: () => null,
      selectedGroupedName: () => null,
      campaignPriceRange: RangeValues(
        state.minCampaignRent,
        state.maxCampaignRent,
      ),
      tgValueRange: RangeValues(state.minTG, state.maxTG),
      appliedLocation: () => null,
      appliedCity: () => null,
      appliedGroupName: () => null,
      appliedCampaignRange: RangeValues(
        state.minCampaignRent,
        state.maxCampaignRent,
      ),
      appliedTGRange: RangeValues(state.minTG, state.maxTG),
      openedDropdown: () => null,
    );
  }

  void setFilterDataFromApi(Datas? data) {
    final priceRange = data?.priceRange;
    if (priceRange == null) {
      state = state.copyWith(
        locations: data?.locationFilter ?? [],
        cities: data?.cityFilter ?? [],
        apartmentGroupName: data?.apartmentGroupNameFilter ?? [],
      );
      return;
    }

    final apiMinRent = priceRange.minRent ?? 0;
    final apiMaxRent = priceRange.maxRent ?? 0;
    final apiMinTG = priceRange.minTG ?? 0;
    final apiMaxTG = priceRange.maxTG ?? 0;

    double minRentVal = state.minCampaignRent;
    double maxRentVal = state.maxCampaignRent;
    RangeValues rentRange = state.campaignPriceRange;
    RangeValues appliedRentRange = state.appliedCampaignRange;

    if (apiMaxRent > apiMinRent) {
      minRentVal = apiMinRent.toDouble();
      maxRentVal = apiMaxRent.toDouble();
      rentRange = RangeValues(minRentVal, maxRentVal);
      appliedRentRange = RangeValues(minRentVal, maxRentVal);
    }

    double minTGVal = state.minTG;
    double maxTGVal = state.maxTG;
    RangeValues tgRange = state.tgValueRange;
    RangeValues appliedTGRangeVal = state.appliedTGRange;

    if (apiMaxTG > apiMinTG) {
      minTGVal = apiMinTG.toDouble();
      maxTGVal = apiMaxTG.toDouble();
      tgRange = RangeValues(minTGVal, maxTGVal);
      appliedTGRangeVal = RangeValues(minTGVal, maxTGVal);
    }

    state = state.copyWith(
      locations: data?.locationFilter ?? [],
      cities: data?.cityFilter ?? [],
      apartmentGroupName: data?.apartmentGroupNameFilter ?? [],
      minCampaignRent: minRentVal,
      maxCampaignRent: maxRentVal,
      campaignPriceRange: rentRange,
      appliedCampaignRange: appliedRentRange,
      minTG: minTGVal,
      maxTG: maxTGVal,
      tgValueRange: tgRange,
      appliedTGRange: appliedTGRangeVal,
    );
  }

  Future<void> applyFilterFromSheet() async {
    final rentRange = state.campaignPriceRange;
    final tgRange = state.tgValueRange;

    final bool isRentChanged =
        rentRange.start.round() != state.minCampaignRent.round() ||
        rentRange.end.round() != state.maxCampaignRent.round();

    final bool isTGChanged =
        tgRange.start.round() != state.minTG.round() ||
        tgRange.end.round() != state.maxTG.round();

    final bool isApplied =
        state.selectedLocation != null ||
        state.selectedCity != null ||
        isRentChanged ||
        isTGChanged;
    final selectedLocation = state.selectedLocation;
    final selectedCity = state.selectedCity;
    final selectedApartmentGroupName = state.selectedGroupedName;
    final currentSessionId = state.currentSessionId;

    state = state.copyWith(
      isFilterApplied: isApplied,
      appliedLocation: () => selectedLocation,
      appliedCity: () => selectedCity,
      appliedGroupName: () => selectedApartmentGroupName,
      appliedCampaignRange: rentRange,
      appliedTGRange: tgRange,
      openedDropdown: () => null,
    );

    await getApartments(
      sessionId: currentSessionId,
      updateFilterData: false,
      location: selectedLocation,
      city: selectedCity,
      apartmentGroupName: selectedApartmentGroupName,
      minRent: isRentChanged ? rentRange.start.round() : null,
      maxRent: isRentChanged ? rentRange.end.round() : null,
      minTG: isTGChanged ? tgRange.start.round() : null,
      maxTG: isTGChanged ? tgRange.end.round() : null,
    );
  }

  Future<void> clearFiltersAndFetch() async {
    final sessionId = state.currentSessionId;

    resetFilters();

    state = state.copyWith(
      currentSessionId: () => sessionId,
      isFilterApplied: false,
    );

    await getApartments(sessionId: sessionId, updateFilterData: true);
  }

  int get appliedFilterCount {
    int count = 0;

    if (state.appliedLocation != null) {
      count++;
    }

    if (state.appliedCity != null) {
      count++;
    }
    if (state.appliedGroupedName != null) {
      count++;
    }

    final rent = state.appliedCampaignRange;
    final isRentDefault =
        rent.start.round() == state.minCampaignRent.round() &&
        rent.end.round() == state.maxCampaignRent.round();

    if (!isRentDefault) {
      count++;
    }

    final tg = state.appliedTGRange;
    final isTGDefault =
        tg.start.round() == state.minTG.round() &&
        tg.end.round() == state.maxTG.round();

    if (!isTGDefault) {
      count++;
    }
    return count;
  }

  Future<void> removeSessionFilter() async {
    state = state.copyWith(
      currentSessionId: () => null,
      isFilterApplied: false,
    );
    resetFilters();
    await getApartments(updateFilterData: true);
  }

  void setSelectedLocation(String? value) {
    state = state.copyWith(selectedLocation: () => value);
  }

  void setSelectedCity(String? value) {
    state = state.copyWith(selectedCity: () => value);
  }

  void setSelectedApartmentGroupName(String? value) {
    state = state.copyWith(selectedGroupedName: () => value);
  }

  void setCampaignPriceRange(RangeValues value) {
    state = state.copyWith(campaignPriceRange: value);
  }

  void setTGValueRange(RangeValues value) {
    state = state.copyWith(tgValueRange: value);
  }
}

final apartmentFamilyProvider = NotifierProvider.autoDispose
    .family<ApartmentViewModel, ApartmentState, String?>(
      ApartmentViewModel.new,
    );

final apartmentViewModelProvider = Provider.autoDispose<ApartmentViewModel>((
  ref,
) {
  return ref.watch(apartmentFamilyProvider(null).notifier);
});
