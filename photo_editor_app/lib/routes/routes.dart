import 'package:flutter/material.dart';
import 'package:photo_editor_app/routes/route_names.dart';
import 'package:photo_editor_app/screens/homePage.dart';

class SetupRoutes {
  // Set initial route here
  static String initialRoute = Routes.HOME_PAGE;

  /// Add entry for new route here
  static Map<String, WidgetBuilder> get routes {
    return {
      Routes.HOME_PAGE: (context) => HomePage(),
    };
  }
}
