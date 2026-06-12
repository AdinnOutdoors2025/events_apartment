import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class Helpers {
  String formatIndianAmount(int? value) {
    if (value == null) return '-';

    if (value == 0) return '0';

    if (value >= 10000000) {
      final crore = value / 10000000;
      return '${crore % 1 == 0 ? crore.toInt() : crore.toStringAsFixed(1)}Cr';
    }

    if (value >= 100000) {
      final lakh = value / 100000;
      return '${lakh % 1 == 0 ? lakh.toInt() : lakh.toStringAsFixed(1)}L';
    }
    if (value >= 1000) {
      final thousand = value / 1000;
      return '${thousand % 1 == 0 ? thousand.toInt() : thousand.toStringAsFixed(1)}K';
    }

    return Helpers().numberFormatter.format(value);
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

      if (start.month == end.month && start.year == end.year) {
        return "${start.day} - ${end.day} ${DateFormat('MMM yyyy').format(end)}";
      }

      return "${DateFormat('dd MMM yyyy').format(start)} - "
          "${DateFormat('dd MMM yyyy').format(end)}";
    } catch (e) {
      return "";
    }
  }

  final numberFormatter = NumberFormat('#,##,##0', 'en_IN');

  Future<void> makePhoneCall(String phoneNumber) async {
    final uri = Uri.parse('tel:$phoneNumber');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> sendSms(String phoneNumber) async {
    final uri = Uri.parse('sms:$phoneNumber');

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      debugPrint("SMS launched: $launched");
    } catch (e) {
      debugPrint("SMS error: $e");
    }
  }
  String formatTGRange(int? from, int? to) {
    final fromText = formatIndianAmount(from);
    final toText = formatIndianAmount(to);

    // Both null
    if (from == null && to == null) return '-';

    // Both zero
    if (from == 0 && to == 0) return '0';

    // One side missing
    if (from == null) return toText;
    if (to == null) return fromText;

    // Same value
    if (from == to) return fromText;

    return '$fromText - $toText';
  }
}

class IndianCurrencyInputFormatter extends TextInputFormatter {
  final NumberFormat formatter = NumberFormat('#,##,##0', 'en_IN');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final cleanText = newValue.text.replaceAll(',', '');

    final number = int.tryParse(cleanText);
    if (number == null) {
      return oldValue;
    }

    final formatted = formatter.format(number);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}


