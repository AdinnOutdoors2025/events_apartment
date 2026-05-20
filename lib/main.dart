import 'package:apartment_project/screens/apartment_screen.dart';
import 'package:apartment_project/screens/bottom_nav_screen.dart';
import 'package:apartment_project/screens/upload_apartment_screen.dart';
import 'package:apartment_project/screens/upload_screen.dart';
import 'package:apartment_project/screens/upload_summary.dart';
import 'package:apartment_project/services/storage_service.dart';
import 'package:apartment_project/theme/app_colors.dart';
import 'package:apartment_project/utils/bindings/bottom_nav_binding.dart';
import 'package:apartment_project/utils/bindings/login_binding.dart';
import 'package:apartment_project/utils/bindings/upload_screen_binding.dart';
import 'package:apartment_project/utils/bindings/upload_summary_binding.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  final token = await StorageService.getToken();

  runApp(
    MyApp(initialRoute: token != null && token.isNotEmpty ? '/bottomNav' : '/'),
  );
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Apartments',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.red),
      ),
      initialRoute: initialRoute,
      getPages: [
        GetPage(name: '/', page: () => LoginPage(), binding: LoginBinding()),
        GetPage(
          name: '/bottomNav',
          page: () => BottomNavScreen(),
          binding: BottomNavBinding(),
        ),
        GetPage(
          name: '/uploadScreen',
          page: () => UploadScreen(),
        ),
        GetPage(
          name: '/uploadSummaryScreen',
          page: () => UploadSummary(),
          binding: UploadSummaryBinding(),
        ),
        GetPage(name: '/apartmentScreen', page: () => ApartmentScreen()),
        GetPage(
          name: '/uploadApartmentScreen',
          page: () => UploadApartmentScreen(),
        ),
      ],
    );
  }
}
