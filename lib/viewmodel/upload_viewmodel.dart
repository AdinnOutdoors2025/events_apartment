import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/recent_upload_model.dart';
import '../model/upload_file_model.dart';
import '../services/api_service.dart';
import '../utils/snackbar.dart';
import 'apartment_viewmodel.dart';

class UploadState {
  final File? selectedFile;
  final String? fileName;
  final bool isLoading;
  final bool isRecentLoading;
  final bool isPaginationLoading;
  final int currentPage;
  final int totalPages;
  final List<Session> recentUploads;
  final bool isSummaryLoading;

  UploadState({
    this.selectedFile,
    this.fileName,
    this.isLoading = false,
    this.isRecentLoading = false,
    this.isPaginationLoading = false,
    this.currentPage = 1,
    this.totalPages = 1,
    this.recentUploads = const [],
    this.isSummaryLoading = false,
  });

  UploadState copyWith({
    File? Function()? selectedFile,
    String? fileName,
    bool? isLoading,
    bool? isRecentLoading,
    bool? isPaginationLoading,
    int? currentPage,
    int? totalPages,
    List<Session>? recentUploads,
    bool? isSummaryLoading,
  }) {
    return UploadState(
      selectedFile: selectedFile != null ? selectedFile() : this.selectedFile,
      fileName: fileName ?? this.fileName,
      isLoading: isLoading ?? this.isLoading,
      isRecentLoading: isRecentLoading ?? this.isRecentLoading,
      isPaginationLoading: isPaginationLoading ?? this.isPaginationLoading,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      recentUploads: recentUploads ?? this.recentUploads,
      isSummaryLoading: isSummaryLoading ?? this.isSummaryLoading,
    );
  }
}

class UploadViewModel extends Notifier<UploadState> {
  final ApiService apiService = ApiService();
  final ScrollController scrollController = ScrollController();

  @override
  UploadState build() {
    ref.onDispose(() {
      scrollController.dispose();
    });

    Future.microtask(() {
      getRecentUploads();
    });

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 200 &&
          !state.isPaginationLoading &&
          state.currentPage < state.totalPages) {
        getRecentUploads(isLoadMore: true);
      }
    });

    return UploadState();
  }

  Future<File?> pickExcelFile() async {
    try {
      FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
      );

      if (result != null && result.files.single.path != null) {

        final file = File(result.files.single.path!);
        state = state.copyWith(selectedFile: () => file, fileName: result.files.single.name,);
        return file;
      }
    } catch (e) {
      AppToast.showError(e.toString());
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return null;
  }

  Future<UploadFileModel?> uploadExcel() async {
    try {
      if (state.selectedFile == null) {
        AppToast.showError("Please select excel file");
        return null;
      }

      state = state.copyWith(isLoading: true);

      final UploadFileModel response = await apiService.uploadExcelAPI(
        file: state.selectedFile!,
      );

      if (response.success == true) {
        final sessionId = response.data?.sessionId ?? "";
        ref
            .read(apartmentFamilyProvider(sessionId).notifier)
            .getApartments(sessionId: sessionId);

        await getRecentUploads();
        return response;
      } else {
        AppToast.showError(response.message ?? "Upload failed");
      }
    } catch (e) {
      AppToast.showError(e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
    return null;
  }

  Future<void> getRecentUploads({bool isLoadMore = false}) async {
    try {
      int page = state.currentPage;
      List<Session> uploadsList = List.from(state.recentUploads);

      if (isLoadMore) {
        state = state.copyWith(isPaginationLoading: true);
        page++;
      } else {
        state = state.copyWith(isRecentLoading: true);
        page = 1;
        uploadsList.clear();
      }

      final RecentUploadModel response = await apiService.recentUploadAPI(
        pageNumber: page,
        count: 10,
      );

      if (response.success == true) {
        uploadsList.addAll(response.data?.sessions ?? []);
        state = state.copyWith(
          totalPages: response.data?.totalPages ?? 1,
          recentUploads: uploadsList,
          currentPage: page,
        );
      }
    } catch (e) {
      AppToast.showError(e.toString());
    } finally {
      state = state.copyWith(
        isRecentLoading: false,
        isPaginationLoading: false,
      );
    }
  }

  Future<void> downloadExcelTemplate() async {
    try {
      final ByteData data = await rootBundle.load(
        'assets/templates/apartment_template.xlsx',
      );

      final Uint8List bytes = data.buffer.asUint8List();

      if (kDebugMode) {
        print('Template bytes length: ${bytes.length}');
      }

      final String? savedPath = await FileSaver.instance.saveAs(
        name: 'apartment_template',
        bytes: bytes,
        fileExtension: 'xlsx',
        mimeType: MimeType.microsoftExcel,
      );

      if (savedPath == null || savedPath.isEmpty) {
        AppToast.showError('Download cancelled');
        return;
      }

      AppToast.showSuccess('Excel template downloaded successfully');
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('Download template error: $e');
        print(stackTrace);
      }

      AppToast.showError('Unable to download Excel template');
    }
  }
}

final uploadViewModelProvider = NotifierProvider<UploadViewModel, UploadState>(
  UploadViewModel.new,
);
