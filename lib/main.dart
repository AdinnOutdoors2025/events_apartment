import 'package:apartment_project/screens/apartment_details_screen.dart';
import 'package:apartment_project/screens/apartment_screen.dart';
import 'package:apartment_project/screens/add_apartment_screen.dart';
import 'package:apartment_project/screens/bottom_nav_screen.dart';
import 'package:apartment_project/screens/orders_screen.dart';
import 'package:apartment_project/screens/upload_apartment_screen.dart';
import 'package:apartment_project/screens/upload_screen.dart';
import 'package:apartment_project/screens/upload_summary.dart';
import 'package:apartment_project/services/storage_service.dart';
import 'package:apartment_project/theme/app_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'login_page.dart';
import 'model/get_list_model.dart';

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
    ProviderScope(
      child: MyApp(
        initialRoute: token != null && token.isNotEmpty ? '/bottomNav' : '/',
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Apartments',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.red),
      ),
      initialRoute: initialRoute,
      onGenerateRoute: (settings) {
        print("settings.name: ${settings.name.toString()}");
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              builder: (_) => LoginPage(),
              settings: settings,
            );
          case '/bottomNav':
            return MaterialPageRoute(
              builder: (_) => BottomNavScreen(),
              settings: settings,
            );
          case '/uploadScreen':
            return MaterialPageRoute(
              builder: (_) => UploadScreen(),
              settings: settings,
            );
          /* case '/uploadSummaryScreen':
            return MaterialPageRoute(
              builder: (_) => UploadSummary(),
              settings: settings,
            );*/
          case '/apartmentScreen':
            return MaterialPageRoute(
              builder: (_) => ApartmentScreen(),
              settings: settings,
            );
          case '/addApartment':
            return MaterialPageRoute(
              builder: (_) => const AddApartmentScreen(),
              settings: settings,
            );
          case '/apartmentDetails':
            final apartment = settings.arguments as Apartment;

            return MaterialPageRoute(
              builder: (_) => ApartmentDetailsScreen(apartment: apartment),
            );
          /* case '/uploadApartmentScreen':
            return MaterialPageRoute(
              builder: (_) => UploadApartmentScreen(),
              settings: settings,
            );*/
          /* case '/orderHistory':
            return MaterialPageRoute(
              builder: (_) => OrdersScreen(),
              settings: settings,
            );*/
          default:
            return MaterialPageRoute(
              builder: (_) => LoginPage(),
              settings: settings,
            );
        }
      },
    );
  }
}
