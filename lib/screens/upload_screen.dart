import 'package:apartment_project/controller/apartment_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../controller/upload_controller.dart';
import '../theme/app_colors.dart';

class UploadScreen extends StatelessWidget {
  UploadScreen({super.key});

  final controller = Get.find<UploadController>();
  final apartmentController = Get.find<ApartmentController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: const Text(
          "Excel Upload",
          style: TextStyle(color: AppColors.red, fontWeight: FontWeight.w500),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.getRecentUploads();
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 28,
                ),
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
                      "Upload apartment\nExcel file",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      ".xlsx files up to 10MB",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Obx(
                      () => SizedBox(
                        width: 150,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : controller.pickExcelFile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: controller.isLoading.value
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  "Choose File",
                                  style: TextStyle(color: Colors.white),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Recent Upload",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),

              const SizedBox(height: 14),

              Expanded(
                child: Obx(() {
                  if (controller.isRecentLoading.value/* &&
                      controller.recentUploads.isEmpty*/) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(30),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (controller.recentUploads.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(30),
                        child: Text(
                          "No Recent Uploads",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    controller: controller.scrollController,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount:
                        controller.recentUploads.length +
                        (controller.isPaginationLoading.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == controller.recentUploads.length) {
                        return const Padding(
                          padding: EdgeInsets.all(20),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      final item = controller.recentUploads[index];

                      return GestureDetector(
                        onTap: () async {
                          if (kDebugMode) {
                            print("sessionID : ${item.sessionId}");
                          }
                          await apartmentController.getApartments(
                            sessionId: item.sessionId ?? "",
                          );

                          Get.toNamed(
                            '/uploadSummaryScreen',
                            arguments: {
                              "isNewUpload": false,
                              "listData":
                                  apartmentController.apartmentData.value,
                            },
                          );
                        },

                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: Colors.grey.shade200,
                                width: 1,
                                style: BorderStyle.solid,
                              ),
                            ),
                            child: Row(
                              children: [
                                Image.network(
                                  'https://cdn-icons-png.flaticon.com/512/732/732220.png',
                                  height: 40,
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.fileName ?? "",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        item.updatedAt ?? "",
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "${item.totalRows ?? 0} rows",
                                        style: TextStyle(
                                          color: Colors.grey.shade700,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
