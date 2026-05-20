import 'package:flutter/cupertino.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import '../controller/apartment_controller.dart';
import 'apartment_screen_content.dart';

class ApartmentScreen extends StatelessWidget {
  ApartmentScreen({super.key});

  final ApartmentController controller = Get.find<ApartmentController>();

  @override
  Widget build(BuildContext context) {
    return ApartmentScreenContent(controller: controller);
  }
}
