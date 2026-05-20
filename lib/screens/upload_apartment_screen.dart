import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../controller/apartment_controller.dart';
import 'apartment_screen_content.dart';

class UploadApartmentScreen extends StatelessWidget {
  UploadApartmentScreen({super.key});

  final String sessionId = Get.arguments["sessionId"];

  late final ApartmentController controller = Get.put(
    ApartmentController(initialSessionId: sessionId),
    tag: sessionId,
  );

  @override
  Widget build(BuildContext context) {
    return ApartmentScreenContent(controller: controller);
  }
}
