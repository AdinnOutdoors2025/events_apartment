import 'package:get/get.dart';
class BottomNavController extends GetxController {
  final currentIndex = 0.obs;
  final List<int> tabHistory = [0];

  void changeIndex(int index) {
    if (currentIndex.value == index) return;
    currentIndex.value = index;
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
