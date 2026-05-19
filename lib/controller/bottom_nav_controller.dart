import 'package:get/get.dart';

import 'apartment_controller.dart';

class BottomNavController extends GetxController {
  final currentIndex = 0.obs;
  final List<int> tabHistory = [0];

  Future<void> changeIndex(int index) async {
    if (currentIndex.value == index) return;
    currentIndex.value = index;
    if (index == 1) {
      final apartmentController = Get.find<ApartmentController>();
      apartmentController.clearSessionFilter();
      await apartmentController.getApartments();
    }
    tabHistory.remove(index);
    tabHistory.add(index);
  }

  bool handleBack() {
    if (tabHistory.length > 1) {
      tabHistory.removeLast();
      currentIndex.value = tabHistory.last;
      return false;
    }
    return true;
  }

  void goToPreviousTab() {
    if (tabHistory.length > 1) {
      tabHistory.removeLast();
      currentIndex.value = tabHistory.last;
    }
  }
}
