import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../controller/upload_controller.dart';
import '../model/upload_file_model.dart';
import '../theme/app_colors.dart';

class UploadScreen extends StatelessWidget {
  UploadScreen({super.key});

  final UploadController controller = Get.put(UploadController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
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
                    height: 90,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Upload apartment\nExcel file",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    ".xlsx files up to 10MB",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
                  ),
                  const SizedBox(height: 25),
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
            const SizedBox(height: 24),
            const Text(
              "Recent Upload",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),

            const SizedBox(height: 14),

            Obx(
              () => ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.recentUploads.length,
                itemBuilder: (context, index) {
                  final item = controller.recentUploads[index];

                  return GestureDetector(
                    onTap: () async {
                      /*Get.toNamed(
                        '/uploadSummaryScreen',
                        arguments: {
                          "isNewUpload": false,
                          "sessionId": item.sessionId,
                        },
                      );*/
                      print("sessionID : ${item.sessionId}");
                      await controller.getUploadSummary(
                        sessionId: item.sessionId ?? "",
                      );

                      Get.toNamed(
                        '/uploadSummaryScreen',
                        arguments: {
                          "isNewUpload": false,
                          "summaryData": UploadSummaryData(
                            fileName: controller.summaryData.value?.fileName,
                            totalRows: controller.summaryData.value?.totalRows,
                            insertedCount:
                                controller.summaryData.value?.insertedCount,
                            updatedCount:
                                controller.summaryData.value?.updatedCount,
                            skippedCount:
                                controller.summaryData.value?.skippedCount,
                            uploadedAt:
                                controller.summaryData.value?.uploadedAt,
                          ),
                        },
                      );
                    },
                    /* child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.fileName ?? ""),
                          Text(item.updatedAt ?? ""),
                          Text("${item.totalRows ?? 0} rows"),
                        ],
                      ),
                    ),*/
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  //"Chennai_Apartments_May.xlsx",
                                  item.fileName ?? "",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  //   "26 May 2026, 10:35 AM",
                                  item.updatedAt ?? "",
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  /* "1,020 rows",*/
                                  "${item.totalRows ?? 0} rows",
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          /*Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Text(
                        "Completed",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),*/
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
