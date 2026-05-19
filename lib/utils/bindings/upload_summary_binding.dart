import 'package:apartment_project/controller/upload_controller.dart';
import 'package:apartment_project/controller/upload_summary_controller.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';

class UploadSummaryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UploadController>(() => UploadController());
    Get.lazyPut<UploadSummaryController>(() => UploadSummaryController());
  }
}
