import 'package:apartment_project/utils/helpers.dart';
import 'package:apartment_project/widgets/custom_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodel/apartment_viewmodel.dart';
import '../model/get_list_model.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_dropdown.dart';
import 'add_apartment_screen.dart';
import 'apartment_details_screen.dart';

class ApartmentScreenContent extends ConsumerWidget {
  final ApartmentState state;
  final ApartmentViewModel viewModel;
  final String? sessionId;
  final String? filename;

  const ApartmentScreenContent({
    super.key,
    required this.state,
    required this.viewModel,
    this.sessionId,
    this.filename,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSearching = viewModel.searchController.text.trim().isNotEmpty;
    final resultCount = state.apartments.length;
    final totalCount = state.apartmentData?.totalCount ?? resultCount;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.white,
          centerTitle: true,
          title: const Text(
            'Apartment Rate Card',
            style: TextStyle(
              color: AppColors.red,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: SizedBox(
                width: 48,
                height: 48,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    IconButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        showModalBottomSheet(
                          context: context,
                          useRootNavigator: true,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          builder: (_) =>
                              FilterBottomSheet(sessionId: sessionId),
                        );
                      },
                      icon: const Icon(
                        Icons.filter_alt_outlined,
                        color: Colors.black,
                        size: 25,
                      ),
                    ),
                    if (viewModel.appliedFilterCount > 0)
                      Positioned(
                        right: 2,
                        top: -2,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 20,
                            minHeight: 20,
                          ),
                          child: Center(
                            child: Text(
                              viewModel.appliedFilterCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
          child: Column(
            children: [
              _SearchBox(viewModel: viewModel),

              const SizedBox(height: 14),
              if (viewModel.appliedFilterCount > 0)
                AppliedFilterChips(state: state, viewModel: viewModel),

              if (viewModel.appliedFilterCount > 0) const SizedBox(height: 15),
              const SizedBox(height: 1),
              if (!state.isLoading && resultCount > 0)
                Padding(
                  padding: const EdgeInsets.only(top: 2, bottom: 2),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      isSearching
                          ? 'Showing $totalCount matching Apartment${totalCount == 1 ? '' : 's'} for "${viewModel.searchController.text.trim()}"'
                          : 'Showing $totalCount Apartments',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 12),
              if (viewModel.isSessionBasedData && state.apartments.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.red.withOpacity(.08),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.red.withOpacity(.25)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: /*Text(
                          "Showing uploaded excel data only",
                          style: TextStyle(
                            color: AppColors.red,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),*/ Text(
                          "Showing uploaded $filename data only",
                          style: const TextStyle(
                            color: AppColors.red,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          await viewModel.removeSessionFilter();
                        },
                        child: const Icon(
                          Icons.close,
                          size: 20,
                          color: AppColors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: Builder(
                  builder: (context) {
                    final items = state.apartments;

                    if (state.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (items.isEmpty) {
                      return const Center(child: Text("No Apartments found"));
                    }

                    return RefreshIndicator(
                      onRefresh: () async {
                        await viewModel.refreshApartments();
                      },
                      child: ListView.separated(
                        controller: viewModel.scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount:
                            items.length + (state.isPaginationLoading ? 1 : 0),
                        separatorBuilder: (_, __) => const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          if (index == items.length) {
                            return const Padding(
                              padding: EdgeInsets.all(20),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }

                          return GestureDetector(
                            onTap: () async {
                              /* Navigator.of(
                                context,
                                rootNavigator: true,
                              ).pushNamed(
                                '/apartmentDetails',
                                arguments: items[index],
                              );*/

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return ApartmentDetailsScreen(
                                      apartment: items[index],
                                    );
                                  },
                                ),
                              );
                            },
                            child: ApartmentRateCard(
                              apartment: items[index],
                              viewModel: viewModel,
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FilterBottomSheet extends ConsumerWidget {
  final String? sessionId;

  const FilterBottomSheet({super.key, this.sessionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final normalizedSessionId =
        sessionId != null && sessionId!.trim().isNotEmpty ? sessionId : null;

    final state = ref.watch(apartmentFamilyProvider(normalizedSessionId));
    final viewModel = ref.read(
      apartmentFamilyProvider(normalizedSessionId).notifier,
    );
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.80,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Column(
                children: [
                  Container(
                    width: 54,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD8D8D8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Expanded(
                        child: Center(
                          child: Text(
                            'Filter Apartments',
                            style: TextStyle(
                              color: AppColors.red,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.close_rounded, size: 28),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    CustomDropdown(
                      title: 'Apartment Group Name',
                      hint: 'Select Group',
                      value: state.selectedGroupedName,
                      items: state.apartmentGroupName,
                      onChanged: (value) {
                        viewModel.setSelectedApartmentGroupName(value);
                      },
                      openedDropdown: state.openedDropdown,
                      dropdownKey: 'apartmentGroup',
                      toggleDropdown: viewModel.toggleDropdown,
                    ),

                    const SizedBox(height: 15),

                    CustomDropdown(
                      title: 'City',
                      hint: 'Select City',
                      value: state.selectedCity,
                      items: state.cities,
                      onChanged: viewModel.setSelectedCity,
                      openedDropdown: state.openedDropdown,
                      dropdownKey: 'City',
                      toggleDropdown: viewModel.toggleDropdown,
                    ),

                    const SizedBox(height: 15),

                    CustomDropdown(
                      title: 'Location',
                      hint: 'Select Location',
                      value: state.selectedLocation,
                      items: state.locations,
                      onChanged: viewModel.setSelectedLocation,
                      openedDropdown: state.openedDropdown,
                      dropdownKey: 'Location',
                      toggleDropdown: viewModel.toggleDropdown,
                    ),

                    const SizedBox(height: 15),

                    Builder(
                      builder: (context) {
                        final range = state.campaignPriceRange;
                        final isChanged =
                            range.start.round() !=
                                state.minCampaignRent.round() ||
                            range.end.round() != state.maxCampaignRent.round();

                        return RangeFilterTile(
                          title: 'Campaign Price Range (₹ / Day)',
                          values: range,
                          min: state.minCampaignRent,
                          max: state.maxCampaignRent,
                          step: 1000,
                          isChanged: isChanged,

                          startText: Helpers().formatIndianAmount(
                            range.start.round(),
                          ),
                          endText: Helpers().formatIndianAmount(
                            range.end.round(),
                          ),
                          minText: Helpers().formatIndianAmount(
                            state.minCampaignRent.round(),
                          ),
                          maxText: Helpers().formatIndianAmount(
                            state.maxCampaignRent.round(),
                          ),
                          onChanged: (value) {
                            viewModel.setCampaignPriceRange(value);
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 15),
                    Builder(
                      builder: (context) {
                        final range = state.tgValueRange;
                        final isChanged =
                            range.start.round() != state.minTG.round() ||
                            range.end.round() != state.maxTG.round();

                        return RangeFilterTile(
                          title: 'TG Value Range (₹ / Day)',
                          values: range,
                          min: state.minTG,
                          max: state.maxTG,
                          step: 50,
                          isChanged: isChanged,
                          startText: Helpers().formatIndianAmount(
                            range.start.round(),
                          ),
                          endText: Helpers().formatIndianAmount(
                            range.end.round(),
                          ),
                          minText: Helpers().formatIndianAmount(
                            state.minTG.round(),
                          ),
                          maxText: Helpers().formatIndianAmount(
                            state.maxTG.round(),
                          ),
                          onChanged: (value) {
                            viewModel.setTGValueRange(value);
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
                top: 10,
                bottom: 4,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 45,
                      child: OutlinedButton(
                        onPressed: () async {
                          await viewModel.clearFiltersAndFetch();
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.red,
                          side: const BorderSide(
                            color: AppColors.red,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Reset',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: SizedBox(
                      height: 45,
                      child: OutlinedButton(
                        onPressed: () async {
                          await viewModel.applyFilterFromSheet();

                          if (context.mounted) {
                            Navigator.maybePop(context);
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: AppColors.red,
                          side: const BorderSide(
                            color: AppColors.red,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Apply Filters',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RangeFilterTile extends StatelessWidget {
  final String title;
  final RangeValues values;
  final double min;
  final double max;
  final double step;
  final String startText;
  final String endText;
  final String minText;
  final String maxText;
  final bool isChanged;
  final ValueChanged<RangeValues> onChanged;

  const RangeFilterTile({
    super.key,
    required this.title,
    required this.values,
    required this.min,
    required this.max,
    required this.step,
    required this.startText,
    required this.endText,
    required this.minText,
    required this.maxText,
    required this.onChanged,
    required this.isChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (max <= min) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FilterTitle(title: title),
        const SizedBox(height: 12),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppColors.red,
            inactiveTrackColor: const Color(0xFFFFD6D6),
            thumbColor: AppColors.red,
            overlayColor: AppColors.red.withOpacity(0.15),
            rangeThumbShape: const RoundRangeSliderThumbShape(
              enabledThumbRadius: 10,
            ),
            rangeTrackShape: const RoundedRectRangeSliderTrackShape(),
            trackHeight: 5,
          ),
          child: RangeSlider(
            values: values,
            min: min,
            max: max,
            divisions: ((max - min) ~/ step).toInt(),
            labels: RangeLabels(startText, endText),
            onChanged: (value) {
              final start = (value.start / step).round() * step;
              final end = (value.end / step).round() * step;
              onChanged(RangeValues(start.toDouble(), end.toDouble()));
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              startText,
              style: TextStyle(
                color: isChanged ? AppColors.red : const Color(0xFF8A8F9E),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              endText,
              style: TextStyle(
                color: isChanged ? AppColors.red : const Color(0xFF8A8F9E),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class FilterTitle extends StatelessWidget {
  final String title;

  const FilterTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFF1F2937),
        fontSize: 15.5,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _SearchBox extends StatelessWidget {
  final ApartmentViewModel viewModel;

  const _SearchBox({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: TextField(
        controller: viewModel.searchController,
        cursorColor: AppColors.red,
        onChanged: (value) {
          viewModel.searchApartments(value);
        },
        style: const TextStyle(
          fontSize: 14,
          color: AppColors.textGrey,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          hintText: 'Search Apartments...',
          hintStyle: const TextStyle(
            color: Color(0xFF8A8FA3),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: Color(0xFF7C8196),
            size: 23,
          ),
          /*suffixIcon: viewModel.searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    viewModel.clearSearch();
                  },
                )
              : null,*/
          suffixIcon: ValueListenableBuilder(
            valueListenable: viewModel.searchController,
            builder: (_, value, __) {
              if (value.text.isEmpty) {
                return const SizedBox.shrink();
              }

              return IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  viewModel.clearSearch();
                },
              );
            },
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}

class ApartmentRateCard extends ConsumerWidget {
  final Apartment apartment;
  final ApartmentViewModel viewModel;

  const ApartmentRateCard({
    super.key,
    required this.apartment,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rent = apartment.perDayRent ?? 0;

    return Container(
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.045),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ApartmentImage(imagePath: apartment.photo ?? ""),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: /*Text(
                        apartment.apartmentName ?? "",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),*/ Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: HighlightText(
                          text: apartment.apartmentName ?? '-',
                          searchText: viewModel.searchController.text,
                          maxLines: 2,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            height: 1.25,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddApartmentScreen(
                              apartment: apartment,
                              showAppBar: true,
                            ),
                          ),
                        );

                        if (result == true) {
                          ref
                              .read(apartmentFamilyProvider(null).notifier)
                              .getApartments();
                        }
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xffD9E3F0),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.edit_outlined,
                          size: 16,
                          color: AppColors.red,
                        ),
                      ),
                    ),
                  ],
                ),
                //  const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: Colors.grey,
                      size: 14,
                    ),
                    const SizedBox(width: 1),
                    /*Text(
                      "${apartment.location ?? ""}, ${apartment.city ?? ""}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w300,
                      ),
                    ),*/
                    HighlightText(
                      text:
                          "${apartment.location ?? ""}, ${apartment.city ?? ""}",
                      searchText: viewModel.searchController.text,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 11),

                /*RateInfoRow(
                  label: 'TG Value',
                  value:
                      (apartment.fromTGValues == 0 && apartment.toTGValues == 0)
                      ? '-'
                      : "${Helpers().formatIndianAmount(apartment.fromTGValues)} - "
                            "${Helpers().formatIndianAmount(apartment.toTGValues)}",
                ),*/
                RateInfoRow(
                  label: 'TG Value',
                  value:
                      (apartment.fromTGValues == 0 && apartment.toTGValues == 0)
                      ? '-'
                      : "${Helpers().formatIndianAmount(apartment.fromTGValues)} - "
                            "${Helpers().formatIndianAmount(apartment.toTGValues)}",
                  searchText: viewModel.searchController.text,
                ),
                const SizedBox(height: 7),
                /* RateInfoRow(
                  label: 'Total Residences',
                  value: Helpers().numberFormatter.format(
                    apartment.residencyCount ?? 0,
                  ),
                ),*/
                RateInfoRow(
                  label: 'Total Residences',
                  value: Helpers().numberFormatter.format(
                    apartment.residencyCount ?? 0,
                  ),
                  searchText: viewModel.searchController.text,
                ),
                const SizedBox(height: 7),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Per Day Rent",
                      style: TextStyle(
                        color: AppColors.textGrey,
                        fontSize: 12.2,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    Flexible(
                      child: HighlightText(
                        /*   text:
                            "₹${Helpers().numberFormatter.format(apartment.perDayRent ?? 0)}/day",
                        searchText: viewModel.searchController.text,*/
                        text: "₹${Helpers().numberFormatter.format(rent)}/day",
                        searchText: _normalizeSearch(
                          viewModel.searchController.text,
                          rent,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 9),
                CustomButton(
                  text: 'Book Order',
                  radius: 10,
                  height: 40,
                  textFontSize: 14,
                  textColor: Colors.white,
                  onPressed: () {},
                  borderColor: Colors.red,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _normalizeSearch(String search, int rent) {
    if (search == rent.toString()) {
      return Helpers().numberFormatter.format(rent);
    }
    return search;
  }
}

class _ApartmentImage extends StatelessWidget {
  final String imagePath;

  const _ApartmentImage({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(13),
      child: Image.network(
        imagePath,
        width: 94,
        height: 185,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 94,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13),
              gradient: const LinearGradient(
                colors: [Color(0xFFFFFFFF), Color(0xFFFFFFFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Icon(
              Icons.apartment_rounded,
              color: AppColors.red,
              size: 42,
            ),
          );
        },
      ),
    );
  }
}

class RateInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final String searchText;

  const RateInfoRow({
    super.key,
    required this.label,
    required this.value,
    this.searchText = '',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textGrey,
              fontSize: 12.2,
              fontWeight: FontWeight.w800,
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: HighlightText(
                text: value,
                searchText: searchText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textGrey,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AppliedFilterChips extends StatelessWidget {
  final ApartmentState state;
  final ApartmentViewModel viewModel;

  const AppliedFilterChips({
    super.key,
    required this.state,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    final rentChanged =
        state.appliedCampaignRange.start.round() !=
            state.minCampaignRent.round() ||
        state.appliedCampaignRange.end.round() != state.maxCampaignRent.round();

    final tgChanged =
        state.appliedTGRange.start.round() != state.minTG.round() ||
        state.appliedTGRange.end.round() != state.maxTG.round();

    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _clearAllChip(),
          if (state.appliedCity != null)
            _chip(
              context,
              "City: ${state.appliedCity?.toLowerCase()}",
              viewModel.removeCityFilter,
            ),
          if (state.appliedLocation != null)
            _chip(
              context,
              "Location: ${state.appliedLocation?.toLowerCase()}",
              viewModel.removeLocationFilter,
            ),

          if (state.appliedGroupedName != null)
            _chip(
              context,
              "Group: ${state.appliedGroupedName?.toLowerCase()}",
              viewModel.removeGroupFilter,
            ),

          if (rentChanged)
            _chip(
              context,
              "Rent: ${Helpers().formatIndianAmount(state.appliedCampaignRange.start.round())} - ${Helpers().formatIndianAmount(state.appliedCampaignRange.end.round())}",

              viewModel.removeRentFilter,
            ),

          if (tgChanged)
            _chip(
              context,
              "TG: ${Helpers().formatIndianAmount(state.appliedTGRange.start.round())} - ${Helpers().formatIndianAmount(state.appliedTGRange.end.round())}",
              viewModel.removeTGFilter,
            ),
        ],
      ),
    );
  }

  Widget _chip(BuildContext context, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 4.0),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            Icon(Icons.close, color: Color(0xFFE5212A), size: 13),
            SizedBox(width: 5),
            Text(label, style: TextStyle(fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _clearAllChip() {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () {
          viewModel.clearFiltersAndFetch();
        },
        child: Container(
          margin: const EdgeInsets.only(top: 4.0, bottom: 4.0),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF0EF),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFFBBFBC)),
          ),
          child: const Icon(Icons.close, color: Color(0xFFE5212A), size: 16),
        ),
      ),
    );
  }
}

class HighlightText extends StatelessWidget {
  final String text;
  final String searchText;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign textAlign;

  const HighlightText({
    super.key,
    required this.text,
    required this.searchText,
    this.style,
    this.maxLines,
    this.overflow,
    this.textAlign = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    if (searchText.trim().isEmpty) {
      return RichText(
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow ?? TextOverflow.clip,
        text: TextSpan(text: text, style: style),
      );
    }

    final lowerText = text.toLowerCase();
    final lowerSearch = searchText.toLowerCase();
    String formattedSearch = lowerSearch;

    final number = int.tryParse(
      lowerSearch.replaceAll(',', '').replaceAll('₹', ''),
    );

    if (number != null) {
      formattedSearch = Helpers().numberFormatter.format(number).toLowerCase();
    }

    final spans = <TextSpan>[];
    int start = 0;

    while (true) {
      //  final index = lowerText.indexOf(lowerSearch, start);
      final index = lowerText.indexOf(formattedSearch, start);

      if (index < 0) {
        spans.add(TextSpan(text: text.substring(start), style: style));
        break;
      }

      if (index > start) {
        spans.add(TextSpan(text: text.substring(start, index), style: style));
      }

      spans.add(
        TextSpan(
          text: text.substring(index, index + formattedSearch.length),
          style:
              /*style?.copyWith( fontWeight: FontWeight.bold, backgroundColor: Colors.yellow, ),*/
              style?.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.red,
                backgroundColor: const Color(0xFFFFF1F1),
              ),
        ),
      );

      start = index + formattedSearch.length;
    }

    return RichText(
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.clip,
      text: TextSpan(children: spans),
    );
  }
}
