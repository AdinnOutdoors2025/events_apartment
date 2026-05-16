import 'package:apartment_project/screens/bottom_nav_screen.dart';
import 'package:apartment_project/screens/upload_screen.dart';
import 'package:apartment_project/screens/upload_summary.dart';
import 'package:apartment_project/services/storage_service.dart';
import 'package:apartment_project/theme/app_colors.dart';
import 'package:apartment_project/utils/bindings/login_binding.dart';
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

  // runApp(const MyApp());
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
        GetPage(name: '/bottomNav', page: () => BottomNavScreen()),
        GetPage(name: '/uploadScreen', page: () => UploadScreen()),
        GetPage(name: '/uploadSummaryScreen', page: () => UploadSummary()),
      ],
    );
  }
}
