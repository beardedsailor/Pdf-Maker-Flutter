import 'package:flutter/material.dart';
import 'package:photo_editor_app/routes/route_names.dart';
import 'package:photo_editor_app/screens/splashScreen.dart';

class SetupRoutes {
  // Set initial route here
  static String initialRoute = Routes.SPLASH_SCREEN;

  /// Add entry for new route here
  static Map<String, WidgetBuilder> get routes {
    return {
      Routes.SPLASH_SCREEN: (context) => SplashScreen(),
    };
  }
}
