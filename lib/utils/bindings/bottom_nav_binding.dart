import 'package:apartment_project/controller/order_controller.dart';
import 'package:get/get.dart';
import '../../controller/apartment_controller.dart';
import '../../controller/bottom_nav_controller.dart';
import '../../controller/upload_controller.dart';

class BottomNavBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BottomNavController>(() => BottomNavController(), fenix: true);
    Get.lazyPut<ApartmentController>(() => ApartmentController(), fenix: true);
    Get.lazyPut<UploadController>(() => UploadController(), fenix: true);
    Get.lazyPut<OrderController>(() => OrderController(), fenix: true);
  }
}
