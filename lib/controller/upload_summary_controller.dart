import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/get_list_model.dart';
import '../model/upload_file_model.dart';

class UploadSummaryController extends GetxController {
  late String fileName;
  late int totalRows;
  late int insertedCount;
  late int updatedCount;
  late int skippedCount;
  late String uploadedAt;
  late String sessionId;
  late bool isNewUpload;

  late List<Map<String, dynamic>> summaryList;

  @override
  void onInit() {
    super.onInit();
    getArgumentsData();
  }

  void getArgumentsData() {
    isNewUpload = Get.arguments["isNewUpload"] ?? false;

    final Data? uploadData = Get.arguments["uploadData"];

    final Datas? listData = Get.arguments["listData"];

    if (isNewUpload) {
      fileName = uploadData?.fileName ?? "";
      totalRows = uploadData?.totalRows ?? 0;
      insertedCount = uploadData?.insertedCount ?? 0;
      updatedCount = uploadData?.updatedCount ?? 0;
      skippedCount = uploadData?.skippedCount ?? 0;
      uploadedAt = "";
      sessionId = uploadData?.sessionId ?? "";
    } else {
      fileName = listData?.file?.fileName ?? "";
      totalRows = listData?.file?.totalRows ?? 0;
      insertedCount = listData?.file?.insertedCount ?? 0;
      updatedCount = listData?.file?.updatedCount ?? 0;
      skippedCount = listData?.file?.skippedCount ?? 0;
      uploadedAt = listData?.file?.uploadedAt?.toString() ?? "";
      sessionId = listData?.file?.sessionId ?? "";
    }

    summaryList = [
      {
        "title": "Total Rows",
        "value": "$totalRows",
        "color": Colors.deepPurple,
      },
      {"title": "Added", "value": "$insertedCount", "color": Colors.green},
      {"title": "Updated", "value": "$updatedCount", "color": Colors.blue},
      {"title": "Duplicate", "value": "$skippedCount", "color": Colors.orange},
    ];
  }
}
