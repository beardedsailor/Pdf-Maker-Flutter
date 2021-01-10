import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_editor_app/screens/homePage.dart';
import 'package:photo_editor_app/utils/elements.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  bool permission=true;
  @override
  void initState() { 
    _requestPermission();
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Stack(
        children: [
          Container(
            color: Colors.cyan,
             height: double.infinity,
    width: double.infinity,
    alignment: Alignment.center,
          child: Center(child: 
          Text("PDF MAKER",
          style: Elements.textStyle(30.0, Colors.white,fontWeight: FontWeight.bold),
          )),
          ),
          
           
          Container(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom:20.0),
              child: permission?new CircularProgressIndicator():new Text("Accept permissions",
          style: Elements.textStyle(14.0, Colors.white),
          ),
            ),
          )
          
        ],
      )
      
      
    );
  }

  _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    final info = statuses[Permission.storage].toString();
    print(info);
    setState(() {
      if(info.toString().trim()=="PermissionStatus.granted"){
         Navigator.push(
            context, new MaterialPageRoute(builder: (context) => HomePage()));
      }
      else{
        permission=false;
      }

    });
    setState(() {
      
    });
  }
}