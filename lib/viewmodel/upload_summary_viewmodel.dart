import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/get_list_model.dart';
import '../model/recent_upload_model.dart';
import '../model/upload_file_model.dart';
import '../utils/helpers.dart';

class UploadSummaryState {
  final String fileName;
  final int totalRows;
  final int insertedCount;
  final int updatedCount;
  final int skippedCount;
  final String uploadedAt;
  final String sessionId;
  final bool isNewUpload;
  final List<Map<String, dynamic>> summaryList;

  UploadSummaryState({
    this.fileName = "",
    this.totalRows = 0,
    this.insertedCount = 0,
    this.updatedCount = 0,
    this.skippedCount = 0,
    this.uploadedAt = "",
    this.sessionId = "",
    this.isNewUpload = false,
    this.summaryList = const [],
  });
}

/*
class UploadSummaryViewModel
    extends FamilyNotifier<UploadSummaryState,
Map<String, dynamic>> {
  @override
  UploadSummaryState build(Map<String, dynamic> arg) {
    final bool isNewUpload = arg["isNewUpload"] ?? false;
    final UploadData? uploadData = arg["uploadData"];
    final Datas? listData = arg["listData"];

    String fileName = "";
    int totalRows = 0;
    int insertedCount = 0;
    int updatedCount = 0;
    int skippedCount = 0;
    String uploadedAt = "";
    String sessionId = "";

    if (isNewUpload) {
      fileName = uploadData?.fileName ?? "";
      if (kDebugMode) {
        print(fileName);
      }
      totalRows = uploadData?.totalRows ?? 0;
      insertedCount = uploadData?.insertedCount ?? 0;
      updatedCount = uploadData?.updatedCount ?? 0;
      skippedCount = uploadData?.skippedCount ?? 0;
      uploadedAt = "";
      sessionId = uploadData?.sessionId ?? "";
    } else {
      fileName = listData?.file?.fileName ?? "";
      if (kDebugMode) {
        print("recentUplaods: $fileName");
      }
      totalRows = listData?.file?.totalRows ?? 0;
      if (kDebugMode) {
        print("totalrows: $totalRows");
      }
      insertedCount = listData?.file?.insertedCount ?? 0;
      updatedCount = listData?.file?.updatedCount ?? 0;
      skippedCount = listData?.file?.skippedCount ?? 0;
      uploadedAt = Helpers().formatDateTime(
        listData?.file?.uploadedAt.toString(),
      );
      sessionId = listData?.file?.sessionId ?? "";
    }

    final summaryList = [
      {
        "title": "Total Rows",
        "value": "$totalRows",
        "color": Colors.deepPurple,
      },
      {"title": "Added", "value": "$insertedCount", "color": Colors.green},
      {"title": "Updated", "value": "$updatedCount", "color": Colors.blue},
      {"title": "Duplicate", "value": "$skippedCount", "color": Colors.orange},
    ];

    return UploadSummaryState(
      fileName: fileName,
      totalRows: totalRows,
      insertedCount: insertedCount,
      updatedCount: updatedCount,
      skippedCount: skippedCount,
      uploadedAt: uploadedAt,
      sessionId: sessionId,
      isNewUpload: isNewUpload,
      summaryList: summaryList,
    );
  }
}
*/
class UploadSummaryViewModel
    extends FamilyNotifier<UploadSummaryState, UploadSummaryArgs> {
  @override
  UploadSummaryState build(UploadSummaryArgs arg) {
    String fileName = "";
    int totalRows = 0;
    int insertedCount = 0;
    int updatedCount = 0;
    int skippedCount = 0;
    String uploadedAt = "";
    String sessionId = "";

    if (arg.isNewUpload) {
      final uploadData = arg.uploadData;

      fileName = uploadData?.fileName ?? "";
      totalRows = uploadData?.totalRows ?? 0;
      insertedCount = uploadData?.insertedCount ?? 0;
      updatedCount = uploadData?.updatedCount ?? 0;
      skippedCount = uploadData?.skippedCount ?? 0;
      uploadedAt = "";
      sessionId = uploadData?.sessionId ?? "";
    } else {
      final recent = arg.recentUpload;

      fileName = recent?.fileName ?? "";
      totalRows = recent?.totalRows ?? 0;
      insertedCount = recent?.insertedCount ?? 0;
      updatedCount = recent?.updatedCount ?? 0;
      skippedCount = recent?.skippedCount ?? 0;
      uploadedAt = recent?.updatedAt ?? '';
      sessionId = recent?.sessionId ?? "";
    }

    final summaryList = [
      {
        "title": "Total Rows",
        "value": "$totalRows",
        "color": Colors.deepPurple,
      },
      {
        "title": "Added",
        "value": "$insertedCount",
        "color": Colors.green,
      },
      {
        "title": "Updated",
        "value": "$updatedCount",
        "color": Colors.blue,
      },
      {
        "title": "Duplicate",
        "value": "$skippedCount",
        "color": Colors.orange,
      },
    ];

    return UploadSummaryState(
      fileName: fileName,
      totalRows: totalRows,
      insertedCount: insertedCount,
      updatedCount: updatedCount,
      skippedCount: skippedCount,
      uploadedAt: uploadedAt,
      sessionId: sessionId,
      isNewUpload: arg.isNewUpload,
      summaryList: summaryList,
    );
  }
}
class UploadSummaryArgs {
  final bool isNewUpload;
  final UploadData? uploadData;
  final Session? recentUpload;

  const UploadSummaryArgs({
    required this.isNewUpload,
    this.uploadData,
    this.recentUpload,
  });

  @override
  bool operator ==(Object other) {
    return other is UploadSummaryArgs &&
        other.isNewUpload == isNewUpload &&
        other.uploadData?.sessionId == uploadData?.sessionId &&
        other.recentUpload?.sessionId == recentUpload?.sessionId;
  }

  @override
  int get hashCode {
    return Object.hash(
      isNewUpload,
      uploadData?.sessionId,
      recentUpload?.sessionId,
    );
  }
}

/*final uploadSummaryFamilyProvider =
    NotifierProvider.family<
      UploadSummaryViewModel,
      UploadSummaryState,
      Map<String, dynamic>
    >(UploadSummaryViewModel.new);*/
final uploadSummaryFamilyProvider =
NotifierProvider.family<
    UploadSummaryViewModel,
    UploadSummaryState,
    UploadSummaryArgs
>(UploadSummaryViewModel.new);
