import 'package:apartment_project/screens/upload_screen.dart';
import 'package:apartment_project/screens/upload_summary.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../controller/bottom_nav_controller.dart';
import '../routes/upload_navigator.dart';
import '../services/storage_service.dart';
import '../theme/app_colors.dart';
import 'apartment_screen.dart';
import 'orders_screen.dart';

class BottomNavScreen extends StatelessWidget {
  BottomNavScreen({super.key});

  final controller = Get.find<BottomNavController>();

  final List<Widget> pages = [
    const DashboardScreen(),
    ApartmentScreen(),
     OrdersScreen(),
    UploadScreen(),
    const MoreScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          final shouldExit = controller.handleBack();

          if (shouldExit) {
            Get.back();
          }
        },
        child: Scaffold(
          body: IndexedStack(
            index: controller.currentIndex.value,
            children: pages,
          ),
          bottomNavigationBar: Theme(
            data: Theme.of(context).copyWith(
              splashFactory: NoSplash.splashFactory,
              highlightColor: Colors.transparent,
            ),
            child: BottomNavigationBar(
              currentIndex: controller.currentIndex.value,
              onTap: controller.changeIndex,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: AppColors.red,
              backgroundColor: Colors.white,

              unselectedItemColor: Colors.grey.shade700,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home),
                  label: "Dashboard",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.description_outlined),
                  activeIcon: Icon(Icons.description),
                  label: "Rate Card",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart_outlined),
                  activeIcon: Icon(Icons.shopping_cart),
                  label: "Orders",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.upload_outlined),
                  activeIcon: Icon(Icons.upload),
                  label: "Upload",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.more_horiz),
                  activeIcon: Icon(Icons.more_horiz),
                  label: "More",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: Text("DashBoard")),
    );
  }
}

class RateCardScreen extends StatelessWidget {
  const RateCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: Text("RateCard")),
    );
  }
}

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                await StorageService.clearToken();

                Get.offAllNamed('/');
              },
              child: Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}
