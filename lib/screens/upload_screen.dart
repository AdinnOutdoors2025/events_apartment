import 'package:apartment_project/screens/upload_screen.dart';
import 'package:apartment_project/screens/upload_summary.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_colors.dart';
import '../utils/snackbar.dart';
import '../viewmodel/add_apartment_viewmodel.dart';
import '../viewmodel/upload_viewmodel.dart';
import 'add_apartment_screen.dart';

class UploadScreen extends ConsumerWidget {
  const UploadScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.white,
          centerTitle: true,
          title: Text(
            "Apartments",
            style: TextStyle(color: AppColors.red, fontWeight: FontWeight.w500),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              const _UploadTopTabs(),

              Expanded(
                child: TabBarView(
                  children: [
                    ProviderScope(
                      overrides: [
                        apartmentFormProvider.overrideWith((ref) {
                          return ApartmentFormNotifier(
                            ref.read(apiServiceProvider),
                          );
                        }),
                      ],
                      child: const AddApartmentScreen(showAppBar: false),
                    ),
                    const _UploadFileTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UploadTopTabs extends StatelessWidget {
  const _UploadTopTabs();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: const TabBar(
        indicatorColor: AppColors.red,
        indicatorWeight: 3,
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: AppColors.red,
        /*  unselectedLabelColor: AppColors.textGrey,*/
        labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
        unselectedLabelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        tabs: [
          Tab(text: 'Add Apartment'),
          Tab(text: 'Bulk Upload'),
        ],
      ),
    );
  }
}

class _UploadFileTab extends ConsumerWidget {
  const _UploadFileTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(uploadViewModelProvider);
    final viewModel = ref.read(uploadViewModelProvider.notifier);

    return RefreshIndicator(
      onRefresh: () async {
        await viewModel.getRecentUploads();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DownloadTemplateCard(
                onTap: () async {
                  await viewModel.downloadExcelTemplate();
                },
              ),

              const SizedBox(height: 10),

              _UploadExcelCard(
                isLoading: state.isLoading,
                onChooseFile: () async {
                  final file = await viewModel.pickExcelFile();

                  if (file != null && context.mounted) {
                    final response = await viewModel.uploadExcel();

                    if (response != null &&
                        response.success == true &&
                        context.mounted) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => UploadSummary(
                            isNewUpload: true,
                            uploadData: response.data,
                          ),
                        ),
                      );
                    }
                  }
                },
              ),

              const SizedBox(height: 15),

              const Text(
                "Recent Uploads",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),

              const SizedBox(height: 10),

              Builder(
                builder: (context) {
                  if (state.isRecentLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.recentUploads.isEmpty) {
                    return ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: const [
                        SizedBox(height: 45),
                        Center(
                          child: Text(
                            "No Recent Uploads",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount:
                        state.recentUploads.length +
                        (state.isPaginationLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == state.recentUploads.length) {
                        return const Padding(
                          padding: EdgeInsets.all(20),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final item = state.recentUploads[index];

                      return _RecentUploadTile(
                        fileName: item.fileName ?? '',
                        updatedAt: item.updatedAt ?? '',
                        rows: item.totalRows ?? 0,
                        onTap: () {
                          final sessionId = item.sessionId ?? "";

                          if (kDebugMode) {
                            print("sessionID : $sessionId");
                          }

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => UploadSummary(
                                isNewUpload: false,
                                // sessionId: sessionId,
                                recentUpload: item,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DownloadTemplateCard extends StatelessWidget {
  final VoidCallback onTap;

  const _DownloadTemplateCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.grey.shade800, width: 0.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.045),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: AppColors.red.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Center(
                  child: Image.network(
                    'https://cdn-icons-png.flaticon.com/512/732/732220.png',
                    height: 25,
                  ),
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Download Excel Template',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.textGrey,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),

                    SizedBox(height: 5),

                    Text(
                      'Use the sample format for easy bulk upload',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                  color: AppColors.red,
                  borderRadius: BorderRadius.circular(10),
                  /*boxShadow: [
                    BoxShadow(
                      color: AppColors.red.withOpacity(0.25),
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                  ],*/
                ),
                child: const Icon(
                  Icons.file_download_outlined,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UploadExcelCard extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onChooseFile;

  const _UploadExcelCard({required this.isLoading, required this.onChooseFile});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.red,
          width: 1,
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          Image.network(
            'https://cdn-icons-png.flaticon.com/512/732/732220.png',
            height: 80,
          ),

          const SizedBox(height: 20),

          const Text(
            "Upload Apartment\nExcel file",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              height: 1.35,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            "Excel file upto 5MB",
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 15),

          SizedBox(
            width: 150,
            height: 55,
            child: ElevatedButton.icon(
              onPressed: isLoading ? null : onChooseFile,
              icon: isLoading
                  ? const SizedBox.shrink()
                  : const Icon(
                      Icons.cloud_upload_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
              label: isLoading
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.4,
                      ),
                    )
                  : const Text(
                      "Choose File",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.red,
                elevation: 3,
                shadowColor: AppColors.red.withOpacity(0.25),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentUploadTile extends StatelessWidget {
  final String fileName;
  final String updatedAt;
  final int rows;
  final VoidCallback onTap;

  const _RecentUploadTile({
    required this.fileName,
    required this.updatedAt,
    required this.rows,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.grey.shade200, width: 1),
            ),
            child: Row(
              children: [
                Image.network(
                  'https://cdn-icons-png.flaticon.com/512/732/732220.png',
                  height: 42,
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fileName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        updatedAt,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        "$rows rows",
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textGrey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
