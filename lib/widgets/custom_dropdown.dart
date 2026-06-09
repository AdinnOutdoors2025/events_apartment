import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CustomDropdown extends StatelessWidget {
  final String? openedDropdown;
  final String dropdownKey;
  final String title;
  final String hint;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final Function(String) toggleDropdown;

  const CustomDropdown({
    super.key,
    required this.openedDropdown,
    required this.dropdownKey,
    required this.title,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.toggleDropdown,
  });

  @override
  Widget build(BuildContext context) {
    final bool isOpen = openedDropdown == dropdownKey;
    final String? selectedValue = items.contains(value) ? value : null;
    final bool hasSelectedValue = selectedValue != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF1F2937),
            fontSize: 15.5,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            toggleDropdown(dropdownKey);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            height: 45,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(9),
              border: Border.all(
                color: isOpen || hasSelectedValue
                    ? AppColors.red
                    : const Color(0xFFE1E1E8),
                width: isOpen || hasSelectedValue ? 1.6 : 1.3,
              ),
              boxShadow: isOpen
                  ? [
                      BoxShadow(
                        color: AppColors.red.withOpacity(0.10),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedValue ?? hint,
                    style: TextStyle(
                      color: hasSelectedValue
                          ? const Color(0xFF111827)
                          : const Color(0xFF9CA3AF),
                      fontSize: 16,
                      fontWeight: hasSelectedValue
                          ? FontWeight.w600
                          : FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                  isOpen
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: hasSelectedValue
                      ? AppColors.red
                      : const Color(0xFF111827),
                  size: 28,
                ),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOut,
          child: isOpen
              ? Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(9),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: items.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          child: Text(
                            'No options available',
                            style: TextStyle(
                              color: Color(0xFF9CA3AF),
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      : /*Column(
                          children: items.map((item) {
                            final bool isSelected = item == selectedValue;

                            return InkWell(
                              onTap: () {
                                onChanged(item);
                                toggleDropdown(dropdownKey);
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 15,
                                ),
                                color: isSelected
                                    ? const Color(0xFFF5F5F5)
                                    : Colors.white,
                                child: Text(
                                  item,
                                  style: TextStyle(
                                    color: isSelected
                                        ? const Color(0xFF111827)
                                        : const Color(0xFF6B7280),
                                    fontSize: 16,
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        )*/ ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxHeight: 250, // fixed dropdown height
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              children: items.map((item) {
                                final bool isSelected = item == selectedValue;

                                return InkWell(
                                  onTap: () {
                                    onChanged(item);
                                    toggleDropdown(dropdownKey);
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 15,
                                    ),
                                    color: isSelected
                                        ? const Color(0xFFF5F5F5)
                                        : Colors.white,
                                    child: Text(
                                      item,
                                      style: TextStyle(
                                        color: isSelected
                                            ? const Color(0xFF111827)
                                            : const Color(0xFF6B7280),
                                        fontSize: 16,
                                        fontWeight: isSelected
                                            ? FontWeight.w700
                                            : FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
