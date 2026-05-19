import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screens/upload_screen.dart';

class UploadNavigator extends StatelessWidget {
  const UploadNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (_) => UploadScreen(),
        );
      },
    );
  }
}