import 'package:apartment_project/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/apartment_controller.dart';
import '../model/get_list_model.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_dropdown.dart';

class ApartmentScreenContent extends StatelessWidget {
  final ApartmentController controller;

  const ApartmentScreenContent({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.white,
        centerTitle: true,

        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
            size: 21,
          ),
        ),

        title: const Text(
          'Apartment Rate Card',
          style: TextStyle(
            color: AppColors.red,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),

        actions: [
          Obx(
            () => Padding(
              padding: const EdgeInsets.only(right: 6),
              child: SizedBox(
                width: 48,
                height: 48,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: Get.context!,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          builder: (_) =>
                              FilterBottomSheet(controller: controller),
                        );
                      },
                      icon: const Icon(
                        Icons.filter_alt_outlined,
                        color: Colors.black,
                        size: 25,
                      ),
                    ),

                    if (controller.appliedFilterCount > 0)
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
                              controller.appliedFilterCount.toString(),
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
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 0),

        child: Column(
          children: [
            _SearchBox(controller: controller),
            const SizedBox(height: 14),
            Obx(() {
              if (!controller.isSessionBasedData ||
                  controller.apartments.isEmpty) {
                return const SizedBox();
              }

              return Container(
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
                    const Expanded(
                      child: Text(
                        "Showing uploaded excel data only",
                        style: TextStyle(
                          color: AppColors.red,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () async {
                        await controller.removeSessionFilter();
                      },
                      child: const Icon(
                        Icons.close,
                        size: 20,
                        color: AppColors.red,
                      ),
                    ),
                  ],
                ),
              );
            }),

            Expanded(
              child: Obx(() {
                final items = controller.apartments;

                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (items.isEmpty) {
                  return const Center(child: Text("No apartments found"));
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await controller.refreshApartments();
                  },
                  child: ListView.separated(
                    controller: controller.scrollController,
                    physics: AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount:
                        items.length +
                        (controller.isPaginationLoading.value ? 1 : 0),

                    separatorBuilder: (_, __) => const SizedBox(height: 14),

                    itemBuilder: (context, index) {
                      if (index == items.length) {
                        return const Padding(
                          padding: EdgeInsets.all(20),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      return ApartmentRateCard(apartment: items[index]);
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class FilterBottomSheet extends StatelessWidget {
  final ApartmentController controller;

  const FilterBottomSheet({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.82,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 10,
          bottom:
              MediaQuery.of(context).viewInsets.bottom +
              MediaQuery.of(context).padding.bottom +
              24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 54,
              height: 5,
              margin: const EdgeInsets.only(bottom: 22),
              decoration: BoxDecoration(
                color: const Color(0xFFD8D8D8),
                borderRadius: BorderRadius.circular(20),
              ),
            ),

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
                  onTap: () {
                    Get.back();
                  },
                  child: const Icon(
                    Icons.close_rounded,
                    size: 28,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 26),

            Obx(
              () => CustomDropdown(
                title: 'Location',
                hint: 'Select location',
                dropdownKey: 'Location',
                value: controller.selectedLocation.value,
                items: controller.locations,
                onChanged: (value) {
                  controller.selectedLocation.value = value;
                },
                openedDropdown: controller.openedDropdown,
              ),
            ),

            const SizedBox(height: 22),

            Obx(
              () => CustomDropdown(
                title: 'City',
                hint: 'Select city',
                value: controller.selectedCity.value,
                items: controller.cities,
                onChanged: (value) {
                  controller.selectedCity.value = value;
                },
                openedDropdown: controller.openedDropdown,
                dropdownKey: 'City',
              ),
            ),

            const SizedBox(height: 26),

            Obx(() {
              final range = controller.campaignPriceRange.value;

              final isChanged =
                  range.start.round() !=
                      controller.minCampaignRent.value.round() ||
                  range.end.round() != controller.maxCampaignRent.value.round();

              return RangeFilterTile(
                title: 'Campaign Price Range (₹ / Day)',
                values: range,
                min: controller.minCampaignRent.value,
                max: controller.maxCampaignRent.value,
                step: 1000,
                isChanged: isChanged,

                startText: '₹${range.start.round()}',
                endText: '₹${range.end.round()}',

                minText: '₹${controller.minCampaignRent.value.round()}',
                maxText: '₹${controller.maxCampaignRent.value.round()}',

                onChanged: (value) {
                  controller.campaignPriceRange.value = value;
                },
              );
            }),
            const SizedBox(height: 22),

            Obx(() {
              final range = controller.tgValueRange.value;

              final isChanged =
                  range.start.round() != controller.minTG.value.round() ||
                  range.end.round() != controller.maxTG.value.round();

              return RangeFilterTile(
                title: 'TG Value Range',
                values: range,
                min: controller.minTG.value,
                max: controller.maxTG.value,
                step: 50,
                isChanged: isChanged,

                startText: '₹${range.start.round()}',
                endText: '₹${range.end.round()}',

                minText: '₹${controller.minTG.value.round()}',
                maxText: '₹${controller.maxTG.value.round()}',

                onChanged: (value) {
                  controller.tgValueRange.value = value;
                },
              );
            }),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 45,
                    child: OutlinedButton(
                      onPressed: () {
                        controller.clearFiltersAndFetch();
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
                    child: ElevatedButton(
                      onPressed: () {
                        controller.applyFilterFromSheet();
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.red,
                        foregroundColor: Colors.white,
                        elevation: 0,
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
  final ApartmentController controller;

  const _SearchBox({required this.controller});

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
        cursorColor: AppColors.red,
        onChanged: (value) {},
        style: const TextStyle(
          fontSize: 14,
          color: AppColors.textGrey,
          fontWeight: FontWeight.w600,
        ),
        decoration: const InputDecoration(
          hintText: 'Search apartments...',
          hintStyle: TextStyle(
            color: Color(0xFF8A8FA3),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: Color(0xFF7C8196),
            size: 23,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}

class ApartmentRateCard extends StatelessWidget {
  final Apartment apartment;

  const ApartmentRateCard({super.key, required this.apartment});

  @override
  Widget build(BuildContext context) {
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
                      child: Text(
                        apartment.apartmentName ?? "",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    InkWell(
                      onTap: () {},
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

                //    const SizedBox(height: 3),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: Colors.grey,
                      size: 14,
                    ),
                    SizedBox(width: 1),
                    Text(
                      "${apartment.location ?? ""}, ${apartment.city ?? ""}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 11),

                RateInfoRow(
                  label: 'TG Value',
                  value:
                      "${apartment.fromTGValues ?? 0} - ${apartment.toTGValues ?? 0}",
                ),

                const SizedBox(height: 7),

                RateInfoRow(
                  label: 'Total Residences',
                  value: "${apartment.residencyCount ?? 0}",
                ),

                const SizedBox(height: 7),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Per Day Rent",
                      style: const TextStyle(
                        color: AppColors.textGrey,
                        fontSize: 12.2,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "₹${apartment.perDayRent ?? 0}/day",
                        maxLines: 1,
                        textAlign: TextAlign.right,
                        overflow: TextOverflow.ellipsis,
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

  const RateInfoRow({super.key, required this.label, required this.value});

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
            child: Text(
              value,
              maxLines: 1,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textGrey,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
