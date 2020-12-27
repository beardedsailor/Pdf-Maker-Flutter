import 'package:flutter/material.dart';
import 'package:photo_editor_app/routes/routes.dart';
import 'package:photo_editor_app/utils/elements.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Elements.appTheme(),
      routes: SetupRoutes.routes,
      initialRoute: SetupRoutes.initialRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}