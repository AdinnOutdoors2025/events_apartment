import 'package:intl/intl.dart';

class Helpers {
  String formatTGValue(double value) {
    if (value >= 10000000) {
      final crore = value / 10000000;

      if (crore % 1 == 0) {
        return '₹${crore.toInt()}Cr';
      }

      return '₹${crore.toStringAsFixed(2)}Cr';
    }

    final lakh = value / 100000;

    if (lakh % 1 == 0) {
      return '₹${lakh.toInt()}L';
    }

    return '₹${lakh.toStringAsFixed(1)}L';
  }

  String formatDateTime(String? date) {
    if (date == null || date.isEmpty) {
      return "";
    }

    try {
      final parsedDate = DateTime.parse(date).toLocal();

      return DateFormat('dd MMM yyyy, h:mm a').format(parsedDate);
    } catch (e) {
      return "";
    }
  }

  /*String formatDate(String? date) {
    if (date == null || date.isEmpty) {
      return "";
    }

    try {
      final parsedDate = DateTime.parse(date).toLocal();

      return DateFormat('dd MMM yyyy').format(parsedDate);
    } catch (e) {
      return "";
    }
  }*/
  String formatDateRange(String? fromDate, String? toDate) {
    if (fromDate == null ||
        toDate == null ||
        fromDate.isEmpty ||
        toDate.isEmpty) {
      return "";
    }

    try {
      final start = DateTime.parse(fromDate).toLocal();
      final end = DateTime.parse(toDate).toLocal();

      /// SAME MONTH & YEAR
      if (start.month == end.month && start.year == end.year) {
        return "${start.day} - ${end.day} ${DateFormat('MMM yyyy').format(end)}";
      }

      /// DIFFERENT MONTH/YEAR
      return "${DateFormat('dd MMM yyyy').format(start)} - "
          "${DateFormat('dd MMM yyyy').format(end)}";
    } catch (e) {
      return "";
    }
  }
}
