import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../screens/upload_apartment_screen.dart';
import '../screens/upload_screen.dart';
import '../screens/upload_summary.dart';

/*
class UploadNavigator extends StatelessWidget {
  const UploadNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        Widget page;

        switch (settings.name) {
          case '/uploadSummaryScreen':
            page = const UploadSummary();
            break;

          case '/apartmentScreen':
            page = const UploadApartmentScreen();
            break;

          default:
            page = const UploadScreen();
        }

        return MaterialPageRoute(builder: (_) => page);
      },
    );
  }
}*/
