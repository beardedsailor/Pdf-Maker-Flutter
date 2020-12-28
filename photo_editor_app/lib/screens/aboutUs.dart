import 'package:flutter/material.dart';
import 'package:photo_editor_app/screens/homePage.dart';
import 'package:photo_editor_app/utils/elements.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Elements.appBar("About Us", Icons.arrow_back, () {
        Navigator.push(
            context, new MaterialPageRoute(builder: (context) => HomePage()));
      }),
      body: Container(
        child: new Center(
          child: new Text("Welcome to Photo editor app. This app helps you to make pdf from photo"),
        ),
      ),
    );
  }
}
