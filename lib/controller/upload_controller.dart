import 'dart:io';
import 'package:apartment_project/utils/snackbar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../model/get_list_model.dart';
import '../model/recent_upload_model.dart';
import '../model/upload_file_model.dart';
import '../services/api_service.dart';

class UploadController extends GetxController {
  final ApiService apiService = ApiService();

  Rx<File?> selectedFile = Rx<File?>(null);

  RxBool isLoading = false.obs;
  RxBool isRecentLoading = false.obs;
  RxBool isSummaryLoading = false.obs;
  RxList<Session> recentUploads = <Session>[].obs;
  Rx<Datas?> summaryData = Rx<Datas?>(null);

  @override
  void onInit() {
    super.onInit();

    getRecentUploads();
  }

  Future<void> pickExcelFile() async {
    try {
      FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
      );

      if (result != null) {
        selectedFile.value = File(result.files.single.path!);
        await uploadExcel();
      }
    } catch (e) {
      AppToast.showError(e.toString());
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<void> uploadExcel() async {
    try {
      if (selectedFile.value == null) {
        AppSnackBar.showError("Please select excel file");
        return;
      }

      isLoading.value = true;

      final UploadFileModel response = await apiService.uploadExcelAPI(
        file: selectedFile.value!,
      );

      if (response.success == true) {
        if (kDebugMode) {
          print(response.message);
        }
        await Get.toNamed(
          '/uploadSummaryScreen',
          arguments: {
            "isNewUpload": true,
            "summaryData": UploadSummaryData(
              fileName: response.data?.fileName,
              totalRows: response.data?.totalRows,
              insertedCount: response.data?.insertedCount,
              updatedCount: response.data?.updatedCount,
              skippedCount: response.data?.skippedCount,
            ),
          },
        );
        await getRecentUploads();
      } else {
        AppToast.showError(response.message ?? "Upload failed");
      }
    } catch (e) {
      AppToast.showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getRecentUploads() async {
    try {
      isRecentLoading.value = true;

      final RecentUploadModel response = await apiService.recentUploadAPI(
        pageNumber: 1,
        count: 10,
      );

      if (response.success == true) {
        recentUploads.value = response.data?.sessions ?? [];
      }
    } catch (e) {
      AppToast.showError(e.toString());
    } finally {
      isRecentLoading.value = false;
    }
  }

  Future<void> getUploadSummary({required String sessionId}) async {
    try {
      isSummaryLoading.value = true;

      final response = await apiService.getUploadSummaryAPI(
        sessionId: sessionId,
      );

      if (response.success == true) {
        summaryData.value = response.data;
      } else {
        AppToast.showError(response.message ?? "Failed");
        print("${response.message}");
      }
    } catch (e) {
      AppToast.showError(e.toString());
      print("${e.toString()}");
    } finally {
      isSummaryLoading.value = false;
    }
  }
}
