import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker_saver/image_picker_saver.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:flutter/material.dart';
import 'package:photo_editor_app/screens/homePage.dart';
import 'package:photo_editor_app/screens/makepdf.dart';
import 'package:photo_editor_app/utils/custom_colors.dart';
import 'package:photo_editor_app/utils/elements.dart';
import 'package:photofilters/photofilters.dart';
import 'package:flutter/rendering.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'dart:io' as Io;

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
  File _storedImage;
  Uint8List bytes1;

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
      appBar: new AppBar(
          title: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                new Text(
                  "Add Effects",
                  style: Elements.textStyle(20.0, Colors.white),
                ),
                new IconButton(
                    icon: new Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 32,
                    ),
                    onPressed: () async {
                      if (currentIndex == 0) {
                        _takePicture();
                      } else if (currentIndex == 1) {
                        // final bytes1 = await capture(_globalKey);
                        // setState(() {
                        //   this.bytes1 = bytes1;
                        // });
                        // _takePicture();
                        _capturePng();
                      }
                    })
              ]),
          backgroundColor: CustomColors.themeBlue,
          //Back arrow present in AppBar
          leading: IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          )),

      //  Elements.appBar("Add Effects", Icons.arrow_back, () {
      //   Navigator.pop(context);
      // }),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
            width: screenWidth,
            height: screenHeight * 0.8,
            key: _globalKey,
            child: currentIndex == 0
                ? Image.file(
                    imageFile,
                    width: screenWidth,
                    height: screenHeight * 0.8,
                    fit: BoxFit.fitWidth,
                  )
                :
                // : buildImage(bytes1)
                filteredImage()),
      ),
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
          // _storedImage=imageFile;
        });
      }
    });
  }

  Widget filteredImage() {
    return RepaintBoundary(
      key: _globalKey,
      child: ColorFiltered(
          colorFilter: ColorFilter.matrix(<double>[
            0,
            1,
            0,
            0,
            0,
            0,
            1,
            0,
            0,
            0,
            0,
            1,
            0,
            0,
            0,
            0,
            1,
            0,
            1.5,
            0
          ]),
          child: Image.file(
            imageFile,
            fit: BoxFit.fitWidth,
          )),
    );
  }

  Future<void> _takePicture() async {
    setState(() {
      _storedImage = imageFile;
    });

    final appDir = await syspaths.getApplicationDocumentsDirectory();
    print(appDir);
    final fileName = path.basename(imageFile.path);
    print(fileName);
    final savedImage = await imageFile.copy('${appDir.path}/$fileName');
    print(savedImage);
    Navigator.push(this.context,
        new MaterialPageRoute(builder: (context) => HomePage()));
    setState(() {});
  }

  // static Future capture(GlobalKey key) async {
  //   if (key == null) return null;

  //   RenderRepaintBoundary boundary = key.currentContext.findRenderObject();
  //   final image = await boundary.toImage(pixelRatio: 3);
  //   final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  //   final pngBytes = byteData.buffer.asUint8List();

  //   return pngBytes;
  // }

  Widget buildImage(Uint8List bytes) {
    return bytes != null ? Image.memory(bytes) : Container();
  }

  Future<void> _capturePng() async {
    try {
      print('inside');
      RenderRepaintBoundary boundary =
          _globalKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData.buffer.asUint8List();
      var filePath = await ImagePickerSaver.saveFile(fileData: pngBytes);
      print(filePath);
      var bs64 = base64Encode(pngBytes);
      // print(pngBytes);
      // print(bs64);
      // print(image);
      // Uint8List bytes = base64Decode(bs64);

      // File file = new File("outputimage.png");

      // var file = Io.File("output.png");
      // file.writeAsBytesSync(bytes);
      //      final appDir = await syspaths.getApplicationDocumentsDirectory();
      // final fileName = path.basename(imageFile.path);
      // final savedImage = await imageFile.copy('${appDir.path}/$fileName');
      // Widget outputimage = Image.memory(bytes);
      // Navigator.push(this.context,
      //     new MaterialPageRoute(builder: (context) => MakePdf(savedImage)));
      return pngBytes;
    } catch (e) {
      print(e);
    }
  }
}
