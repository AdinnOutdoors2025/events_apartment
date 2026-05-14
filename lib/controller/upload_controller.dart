import 'dart:io';
import 'package:apartment_project/utils/snackbar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';

class UploadController extends GetxController {
  final ApiService apiService = ApiService();

  Rx<File?> selectedFile = Rx<File?>(null);

  RxBool isLoading = false.obs;

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

      final response = await apiService.uploadExcelAPI(
        file: selectedFile.value!,
      );

      if (response["success"] == true) {
        AppSnackBar.showSuccess(response["message"] ?? "Upload successful");
      } else {
        AppSnackBar.showError(response["message"] ?? "Upload failed");
      }
    } catch (e) {
      AppSnackBar.showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
