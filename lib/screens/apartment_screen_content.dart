import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/apartment_controller.dart';
import '../model/get_list_model.dart';
import '../theme/app_colors.dart';

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
                      right: 4,
                      top: 4,
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
          const SizedBox(width: 6),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 0),

        child: Column(
          children: [
            _SearchBox(controller: controller),

            const SizedBox(height: 14),
            Obx(() {
              if (!controller.isSessionBasedData) {
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

            //    const SizedBox(height: 14),
            Expanded(
              child: Obx(() {
                final items = controller.apartments;

                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (items.isEmpty) {
                  return const Center(child: Text("No apartments found"));
                }

                return ListView.separated(
                  controller: controller.scrollController,
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
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
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
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.back(),
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
              () => FilterDropdown(
                title: 'Location',
                hint: 'Select location',
                value: controller.selectedLocation.value,
                items: controller.locations,
                onChanged: (value) {
                  controller.selectedLocation.value = value;
                },
              ),
            ),

            const SizedBox(height: 22),

            Obx(
              () => FilterDropdown(
                title: 'City',
                hint: 'Select city',
                value: controller.selectedCity.value,
                items: controller.cities,
                onChanged: (value) {
                  controller.selectedCity.value = value;
                },
              ),
            ),

            const SizedBox(height: 26),

            Obx(
              () => RangeFilterTile(
                title: 'Campaign Price Range (₹ / Day)',
                values: controller.campaignPriceRange.value,
                min: controller.minCampaignRent.value,
                max: controller.maxCampaignRent.value,
                step: 1000,
                startText:
                    '₹${controller.campaignPriceRange.value.start.round()}',
                endText: '₹${controller.campaignPriceRange.value.end.round()}',
                minText: '₹${controller.minCampaignRent.value.round()}',
                maxText: '₹${controller.maxCampaignRent.value.round()}',
                onChanged: (value) {
                  controller.campaignPriceRange.value = value;
                },
              ),
            ),

            const SizedBox(height: 22),

            Obx(
              () => RangeFilterTile(
                title: 'TG Value Range',
                values: controller.tgValueRange.value,
                min: controller.minTG.value,
                max: controller.maxTG.value,
                step: 5,
                startText: '₹${controller.tgValueRange.value.start.round()}',
                endText: '₹${controller.tgValueRange.value.end.round()}',
                minText: '₹${controller.minTG.value.round()}',
                maxText: '₹${controller.maxTG.value.round()}',
                onChanged: (value) {
                  controller.tgValueRange.value = value;
                },
              ),
            ),
            const SizedBox(height: 30),

            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: OutlinedButton(
                      onPressed: () {
                        controller.clearFiltersAndFetch();
                        Get.back();
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
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: SizedBox(
                    height: 56,
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
                          fontSize: 17,
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

class FilterDropdown extends StatelessWidget {
  final String title;
  final String hint;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const FilterDropdown({
    super.key,
    required this.title,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FilterTitle(title: title),

        const SizedBox(height: 10),

        Container(
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: const Color(0xFFE1E1E8), width: 1.3),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField<String>(
              value: items.contains(value) ? value : null,
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Color(0xFF6B7280),
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(
                  color: Color(0xFF9CA3AF),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 15,
                ),
              ),
              items: items.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                      color: Color(0xFF111827),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

/*
class RangeFilterTile extends StatelessWidget {
  final String title;
  final RangeValues values;
  final double min;
  final double max;
  final int divisions;
  final String startText;
  final String endText;
  final String minText;
  final String maxText;
  final ValueChanged<RangeValues> onChanged;

  const RangeFilterTile({
    super.key,
    required this.title,
    required this.values,
    required this.min,
    required this.max,
    required this.divisions,
    required this.startText,
    required this.endText,
    required this.minText,
    required this.maxText,
    required this.onChanged,
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

        const SizedBox(height: 4),

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
            divisions: ((max - min) ~/ 5),
            labels: RangeLabels(startText, endText),
            onChanged: onChanged,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              startText,
              style: const TextStyle(
                color: Color(0xFF8A8F9E),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              endText,
              style: const TextStyle(
                color: Color(0xFF8A8F9E),
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
*/
class RangeFilterTile extends StatelessWidget {
  final String title;
  final RangeValues values;
  final double min;
  final double max;

  // NEW
  final double step;

  final String startText;
  final String endText;
  final String minText;
  final String maxText;
  final ValueChanged<RangeValues> onChanged;

  const RangeFilterTile({
    super.key,
    required this.title,
    required this.values,
    required this.min,
    required this.max,
    required this.step, // NEW
    required this.startText,
    required this.endText,
    required this.minText,
    required this.maxText,
    required this.onChanged,
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
              style: const TextStyle(
                color: Color(0xFF8A8F9E),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              endText,
              style: const TextStyle(
                color: Color(0xFF8A8F9E),
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
                    Text(
                      "₹${apartment.perDayRent ?? 0}/day",
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 3),

                Text(
                  "${apartment.location ?? ""}, ${apartment.city ?? ""}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w300,
                  ),
                ),

                const SizedBox(height: 11),

                RateInfoRow(
                  label: 'TG Value',
                  value: "${apartment.startingTgValues ?? 0}",
                ),

                const SizedBox(height: 7),

                RateInfoRow(
                  label: 'Total Residences',
                  value: "${apartment.residencyCount ?? 0}",
                ),

                const SizedBox(height: 7),

                const SizedBox(height: 9),
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
        height: 139,
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
