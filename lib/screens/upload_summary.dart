import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:lottie/lottie.dart';
import '../model/upload_file_model.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_button.dart';

class UploadSummary extends StatelessWidget {
  UploadSummary({super.key});

  final bool isNewUpload = Get.arguments["isNewUpload"] ?? false;
  final UploadSummaryData summaryData = Get.arguments["summaryData"];

  late final List<Map<String, dynamic>> summaryList = [
    {
      "title": "Total Rows",
      "value": "${summaryData.totalRows ?? 0}",
      "color": Colors.deepPurple,
    },
    {
      "title": "Added",
      "value": "${summaryData.insertedCount ?? 0}",
      "color": Colors.green,
    },
    {
      "title": "Updated",
      "value": "${summaryData.updatedCount ?? 0}",
      "color": Colors.blue,
    },
    {
      "title": "Duplicate",
      "value": "${summaryData.skippedCount ?? 0}",
      "color": Colors.orange,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: Text(
          "Upload Summary",
          style: TextStyle(color: AppColors.red, fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isNewUpload) ...[
              const SizedBox(height: 20),

              /*  Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 40),
                ),
              ),*/
              Center(
                child: SizedBox(
                  height: 180,
                  width: 180,
                  child: Lottie.asset(
                    'assets/lottie/completed.json',
                    repeat: false,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Center(
                child: Text(
                  "Upload Completed Successfully!",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 5),

              const Center(
                child: Text(
                  "Your apartment data has been processed.",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),

              const SizedBox(height: 25),
            ],
            if (!isNewUpload) ...[
              Container(
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
                            "${summaryData.fileName}",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "${summaryData.uploadedAt}",
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${summaryData.totalRows ?? 0} rows",
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
            ],

            const SizedBox(height: 15),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: summaryList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 1.15,
              ),
              itemBuilder: (context, index) {
                final item = summaryList[index];
                return SummaryBox(
                  title: item["title"],
                  value: item["value"],
                  valueColor: item["color"],
                );
              },
            ),

            CustomButton(
              text: 'View Added Data',
              onPressed: () {},
              color: Colors.white,
              textColor: AppColors.red,
              radius: 12,
              borderColor: AppColors.red,
              //    isLoading: controller.isLoading.value,
              //     onPressed: controller.login,
            ),
            SizedBox(height: 10),
            CustomButton(
              text: 'View Failed / Duplicate Data',
              onPressed: () {},
              color: Colors.white,
              textColor: AppColors.red,
              radius: 12,

              borderColor: AppColors.red,
              //    isLoading: controller.isLoading.value,
              //     onPressed: controller.login,
            ),
          ],
        ),
      ),
    );
  }
}

class SummaryBox extends StatelessWidget {
  final String title;
  final String value;
  final Color valueColor;

  const SummaryBox({
    super.key,
    required this.title,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 14),

          Text(
            value,
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
