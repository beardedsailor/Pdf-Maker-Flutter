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






//  Container(
//           child: widget.userImgFile != null
//               ? Padding(
//                   padding: const EdgeInsets.all(18.0),
//                   child: Container(
//                     child: Image.file(
//                       imageFile,
//                       width: screenWidth,
//                       height: screenHeight * 0.8,
//                       fit: BoxFit.fitWidth,
//                     ),
//                   ),
//                 )
//               : Container()),
//       bottomNavigationBar: BottomAppBar(
//         child: Container(
//           height: 65,
//           decoration: BoxDecoration(color: Colors.lightBlue),
//           child: new Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               SizedBox(
//                 child: new IconButton(
//                     icon: new Icon(
//                       Icons.crop,
//                       color: Colors.white,
//                       size: 30,
//                     ),
//                     onPressed: () {
//                       _cropImage();
//                     }),
//               ),
//               // SizedBox(
//               //   child: new IconButton(
//               //       icon: new Icon(Icons.crop_free_sharp,
//               //       color: Colors.white,size: 30), onPressed: null),
//               // ),
//               SizedBox(
//                 child: new IconButton(
//                     icon: new Icon(Icons.rotate_left_sharp,
//                         color: Colors.white, size: 30),
//                     onPressed: null),
//               ),
//               SizedBox(
//                 child: new IconButton(
//                     icon: new Icon(Icons.rotate_right_sharp,
//                         color: Colors.white, size: 30),
//                     onPressed: null),
//               ),
//               SizedBox(
//                 child: new IconButton(
//                     icon: new Icon(Icons.check_sharp,
//                         color: Colors.white, size: 30),
//                     onPressed: null),
//               )
//             ],
//           ),
//         ),
//       ),
  