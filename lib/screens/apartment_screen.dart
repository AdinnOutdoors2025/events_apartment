import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import '../controller/apartment_controller.dart';
import '../model/get_list_model.dart';
import '../theme/app_colors.dart';

/*
class ApartmentScreen extends StatelessWidget {
  const ApartmentScreen({super.key});

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
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: const Text(
          "Apartments",
          style: TextStyle(color: AppColors.red, fontWeight: FontWeight.w500),
        ),
      ),
      body: Center(child: Text("data")),
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/custom_button.dart';

class ApartmentScreen extends StatelessWidget {
  ApartmentScreen({super.key});

  final controller = Get.find<ApartmentController>();

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
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: Get.context!,
                isScrollControlled: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (_) => FilterBottomSheet(),
              );
            },
            icon: const Icon(
              Icons.filter_alt_outlined,
              color: Colors.black,
              size: 25,
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

            Expanded(
              child: Obx(() {
                final items = controller.apartments;

                if (controller.isLoading.value) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                if (items.isEmpty) {
                  return Center(
                    child: Text(
                      'No apartments found',
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.textGrey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  // physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 20),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
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
  FilterBottomSheet({super.key});

  final controller = Get.find<ApartmentController>();

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
                min: 1000,
                max: 50000,
                divisions: 49,
                startText:
                    '₹${controller.campaignPriceRange.value.start.round()}',
                endText: '₹${controller.campaignPriceRange.value.end.round()}',
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
                min: 10,
                max: 200,
                divisions: 19,
                startText: '₹${controller.tgValueRange.value.start.round()}L',
                endText: '₹${controller.tgValueRange.value.end.round()}L',
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
                        controller.resetFilters();
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
              value: value,
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

class RangeFilterTile extends StatelessWidget {
  final String title;
  final RangeValues values;
  final double min;
  final double max;
  final int divisions;
  final String startText;
  final String endText;
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
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FilterTitle(title: title),

        const SizedBox(height: 12),

        const SizedBox(height: 8),

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
            divisions: divisions,
            labels: RangeLabels(startText, endText),
            onChanged: onChanged,
          ),
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
        //   controller: controller.searchController,
        cursorColor: AppColors.red,
        onChanged: (value) {
          //   controller.searchText.value = value;
        },
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

                /* CustomButton(
                  text: 'Edit Apartments',
                  color: Colors.white,
                  textColor: AppColors.red,
                  radius: 5,
                  height: 30,
                  borderColor: AppColors.red,
                  onPressed: () {
                    Get.toNamed('/apartmentScreen');
                  },
                ),*/
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
          // const Spacer(),
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
