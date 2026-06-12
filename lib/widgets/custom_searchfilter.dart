import 'package:flutter/material.dart';

class CustomSearchFilter extends StatelessWidget {
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onDateTap;
  final ValueChanged<String?>? onFilterChanged;

  final bool showSearch;
  final bool showCalendar;
  final bool showFilter;

  final String? hintText;
  final String? selectedValue;
  final List<String>? filterItems;

  const CustomSearchFilter({
    super.key,
    this.onSearchChanged,
    this.onDateTap,
    this.onFilterChanged,
    this.showSearch = true,
    this.showCalendar = false,
    this.showFilter = false,
    this.hintText,
    this.selectedValue,
    this.filterItems,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        children: [
          if (showSearch)
            Expanded(
              child: TextField(
                onChanged: onSearchChanged,
                decoration: InputDecoration(
                  hintText: hintText ?? "Search...",
                  hintStyle: const TextStyle(fontSize: 14),
                  prefixIcon: const Icon(Icons.search, size: 18),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 1.4,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

          if (showSearch && (showCalendar || showFilter))
            const SizedBox(width: 8),

          if (showCalendar)
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: IconButton(
                icon: const Icon(Icons.calendar_today, size: 20),
                onPressed: onDateTap,
              ),
            ),


          if (showCalendar && showFilter) const SizedBox(width: 8),

          if (showFilter)
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE0E0E0)),
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: PopupMenuButton<String>(
                color: Colors.white,
                surfaceTintColor: Colors.white,
                position: PopupMenuPosition.under,
                elevation: 8,
                shadowColor: Colors.black.withOpacity(0.12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(color: Color(0xFFEEEEEE)),
                ),
                constraints: const BoxConstraints(minWidth: 80),
                icon: const Icon(
                  Icons.filter_list_rounded,
                  size: 24,
                  color: Colors.black87,
                ),
                onSelected: onFilterChanged,
                itemBuilder: (context) {
                  return (filterItems ?? []).map((item) {
                    return PopupMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    );
                  }).toList();
                },
              ),
            ),
        ],
      ),
    );
  }
}
