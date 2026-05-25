import 'dart:io';
import 'package:apartment_project/utils/snackbar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../model/get_list_model.dart';
import '../model/recent_upload_model.dart';
import '../model/upload_file_model.dart';
import '../screens/upload_summary.dart';
import '../services/api_service.dart';
import 'apartment_controller.dart';

class UploadController extends GetxController {
  final ApiService apiService = ApiService();

  Rx<File?> selectedFile = Rx<File?>(null);

  RxBool isLoading = false.obs;

  RxBool isRecentLoading = false.obs;
  RxBool isPaginationLoading = false.obs;

  int currentPage = 1;
  int totalPages = 1;
  final ScrollController scrollController = ScrollController();
  RxBool isSummaryLoading = false.obs;
  RxList<Session> recentUploads = <Session>[].obs;

  @override
  void onInit() {
    super.onInit();
    getRecentUploads();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 200 &&
          !isPaginationLoading.value &&
          currentPage < totalPages) {
        getRecentUploads(isLoadMore: true);
      }
    });
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
        final apartmentController = Get.find<ApartmentController>();

        await apartmentController.getApartments(
          sessionId: response.data?.sessionId ?? "",
        );

        await Get.toNamed(
          '/uploadSummaryScreen',
          arguments: {"isNewUpload": true, "uploadData": response.data},
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

  Future<void> getRecentUploads({bool isLoadMore = false}) async {
    try {
      if (isLoadMore) {
        isPaginationLoading.value = true;
        currentPage++;
      } else {
        isRecentLoading.value = true;
        currentPage = 1;
        recentUploads.clear();
      }

      final RecentUploadModel response = await apiService.recentUploadAPI(
        pageNumber: currentPage,
        count: 10,
      );

      if (response.success == true) {
        totalPages = response.data?.totalPages ?? 1;

        final List<Session> newData = response.data?.sessions ?? [];

        recentUploads.addAll(newData);
      }
    } catch (e) {
      AppToast.showError(e.toString());
    } finally {
      isRecentLoading.value = false;
      isPaginationLoading.value = false;
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
