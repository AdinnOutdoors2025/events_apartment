import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:lottie/lottie.dart';
import '../controller/apartment_controller.dart';
import '../controller/upload_summary_controller.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_button.dart';

class UploadSummary extends StatelessWidget {
  UploadSummary({super.key});

  final controller = Get.find<UploadSummaryController>();

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
            if (controller.isNewUpload) ...[
              Center(
                child: SizedBox(
                  height: 150,
                  width: 150,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Lottie.asset(
                        'assets/lottie/completed.json',
                        repeat: false,
                        fit: BoxFit.contain,
                      ),
                      Container(
                        width: 70,
                        height: 70,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

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

              const SizedBox(height: 15),
            ],
            if (!controller.isNewUpload) ...[
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
                            controller.fileName,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            controller.uploadedAt,
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${controller.totalRows} rows',
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
              const SizedBox(height: 15),
            ],

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.summaryList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 1.20,
              ),
              padding: EdgeInsets.all(5),
              itemBuilder: (context, index) {
                final item = controller.summaryList[index];
                return SummaryBox(
                  title: item["title"],
                  value: item["value"],
                  valueColor: item["color"],
                );
              },
            ),
            SizedBox(height: 15),
            CustomButton(
              text: 'View Added Data',
              color: Colors.white,
              textColor: AppColors.red,
              radius: 12,
              borderColor: AppColors.red,
              /*onPressed: () async {
                //  Get.toNamed('/apartmentScreen');
                final apartmentController = Get.find<ApartmentController>();
                apartmentController.resetFilters();
                apartmentController.isFilterApplied.value = false;
                // keep session data
                await apartmentController.getApartments(
                  sessionId: controller.sessionId,
                  updateFilterData: true,
                );

                Get.toNamed('/apartmentScreen');
              },*/
              onPressed: () async {
                Get.toNamed(
                  '/uploadApartmentScreen',
                  arguments: {
                    "sessionId": controller.sessionId,
                  },
                );
              },

            ),
            SizedBox(height: 10),
            CustomButton(
              text: 'View Failed / Duplicate Data',
              onPressed: () {},
              color: Colors.white,
              textColor: AppColors.red,
              radius: 12,
              borderColor: AppColors.red,
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

          const SizedBox(height: 10),

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
