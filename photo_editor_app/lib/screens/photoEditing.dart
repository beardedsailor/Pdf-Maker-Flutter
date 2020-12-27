import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_editor_app/screens/makepdf.dart';
import 'package:photo_editor_app/utils/custom_colors.dart';
// import 'package:gallery_saver/gallery_saver.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:photo_editor_app/utils/elements.dart';
// import 'dart:async';
// import 'package:path/path.dart';
import 'package:photofilters/photofilters.dart';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:permission_handler/permission_handler.dart';

class PhotoEditing extends StatefulWidget {
  final File userImgFile;
  PhotoEditing(this.userImgFile);

  @override
  _PhotoEditingState createState() => _PhotoEditingState();
}

class _PhotoEditingState extends State<PhotoEditing> {
  GlobalKey _globalKey = GlobalKey();
  File imageFile;
  String fileName;
  List<Filter> filters = presetFiltersList;
  int currentIndex = 0;

  @override
  void initState() {
    imageFile = widget.userImgFile;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: Elements.appBar("Add Effects", Icons.arrow_back, () {
        Navigator.pop(context);
      }),
      body: Container(
          child: currentIndex==0
              ? Image.file(
            imageFile,
            width: screenWidth,
            height: screenHeight * 0.8,
            fit: BoxFit.fitWidth,
          )
              : filteredImage()),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTappedBar,
        currentIndex: currentIndex,
        backgroundColor: Colors.lightBlue,
        selectedItemColor: CustomColors.themeBlue,
        // unselectedItemColor: CustomColors.themeBlue,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.photo),
            label: 'Original',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.picture_as_pdf),
            label: 'Docs',
          ),
        ],
      ),
    );
  }

  void onTappedBar(int index) {
    setState(() {
      currentIndex = index;
      if (currentIndex == 0) {
        setState(() {});
      } else if (currentIndex == 1) {
        filteredImage();
        setState(() {
          print("object");
        });
      }
    });
  }

  Widget filteredImage() {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return RepaintBoundary(
      key: _globalKey,
      child: ColorFiltered(
          colorFilter: ColorFilter.matrix(<double>[
            -1,  0,  0, 0, 255,
   0, -1,  0, 0, 255,
   0,  0, -1, 0, 255,
   0,  0,  0, 1,   0,
          ]),
          child: Image.file(
            imageFile,
            width: screenWidth,
            height: screenHeight * 0.8,
            fit: BoxFit.fitWidth,
          )),
    );
  }

  void _saveScreen() async {
    RenderRepaintBoundary boundary =
        _globalKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage(pixelRatio: 1);
    // File image = imageFile;
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List uint8list = byteData.buffer.asUint8List();
    Navigator.of(_globalKey.currentContext)
        .push(MaterialPageRoute(builder: (context) => MakePdf(uint8list)));
    // print(result);
    // _toastInfo(result.toString());
  }
}

// void _takePhoto() async {
//   File recordedImage = imageFile;
//   if (recordedImage != null && recordedImage.path != null) {
//     setState(() {
//       // firstButtonText = 'saving in progress...';
//     });
//     GallerySaver.saveImage(recordedImage.path).then((path) {
//       setState(() {
//         // firstButtonText = 'image saved!';
//         print(path.toString());
//       });
//     });
//   }
// }

// _requestPermission() async {
//   Map<Permission, PermissionStatus> statuses = await [
//     Permission.storage,
//   ].request();

//   final info = statuses[Permission.storage].toString();
//   print(info);
// }

// }

/*
  Future getImage(context) async {
    
    fileName = basename(imageFile.path);
    var image = imageLib.decodeImage(imageFile.readAsBytesSync());
    image = imageLib.copyResize(image, width: 600);
     Map imagefile = await Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) => new PhotoFilterSelector(
              title: Text("Photo Filter Example"),
              image: image,
              filters: presetFiltersList,
              filename: fileName,
              loader: Center(child: CircularProgressIndicator()),
              fit: BoxFit.contain,
            ),
      ),
    );
    if (imagefile != null && imagefile.containsKey('image_filtered')) {
      setState(() {
        imageFile = imagefile['image_filtered'];
      });
      print(imageFile.path);
    }
  } 
  */
