import 'dart:io';
import 'dart:typed_data';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path1;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_editor_app/screens/homePage.dart';
import 'package:photo_editor_app/utils/custom_colors.dart';
import 'package:photo_editor_app/utils/elements.dart';
import 'package:photofilters/photofilters.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;

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
  Uint8List bytes1;
  List<double> blackwhitematrix = [
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
  ];
  List<double> original = [
    1,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
  ];

  @override
  void initState() {
    _requestPermission();
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
                      _saveScreen();
                    })
              ]),
          backgroundColor: Colors.cyanAccent[700],
          //Back arrow present in AppBar
          leading: IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          width: screenWidth,
          height: screenHeight * 0.8,
          child: currentIndex == 0
              ? filteredImage(original)
              : filteredImage(blackwhitematrix),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTappedBar,
        currentIndex: currentIndex,
        backgroundColor: Colors.cyanAccent[700],
        selectedItemColor: CustomColors.themeBlue,
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
        filteredImage(original);
        setState(() {});
      } else if (currentIndex == 1) {
        filteredImage(blackwhitematrix);
        setState(() {});
      }
    });
  }

  Widget filteredImage(List<double> colorScheme) {
    return RepaintBoundary(
      key: _globalKey,
      child: ColorFiltered(
          colorFilter: ColorFilter.matrix(colorScheme),
          child: Image.file(
            imageFile,
            fit: BoxFit.fitWidth,
          )),
    );
  }

  _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    final info = statuses[Permission.storage].toString();
    print(info);
    // _toastInfo(info);
  }

  _saveScreen() async {
    RenderRepaintBoundary boundary =
        _globalKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage();
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final result =
        await ImageGallerySaver.saveImage(byteData.buffer.asUint8List());
        // ImageGallerySaver.saveFile(file)

    // print(result);
    // var sourceFile = result['filePath'];
    // String x = sourceFile.toString();
    // x = x.substring(7);
    // File file1 = new File(x);
    // final Directory ab = await getExternalStorageDirectory();
    // print(ab);
    // print(file1);
    // // print(sourceFile.toString());
    // var basNameWithExtension = path1.basename(file1.path);
    // print(basNameWithExtension);
    // final Directory check = await getApplicationDocumentsDirectory();
    // // String folderName = "/AllFiles";
    // String a = "${check.path}";
    // // a=a.substring(11);
    // final Directory _appDocDirFolder = Directory(ab.path);
    // // final Directory _appDocDirFolder = Directory('${check.path}/AllFiles');
    // File newImage = await file1.copy('$_appDocDirFolder');
    // print(newImage);
    // print(_appDocDirFolder);
    // var file =
    // await moveFile(
    //     file1, _appDocDirFolder.path + "/" + basNameWithExtension);
    // print(file);
    // var appDocDir = await getTemporaryDirectory();
    // print(appDocDir);
    // final Directory check = await getApplicationDocumentsDirectory();

    // print(result);
    // _toastInfo(result.toString());

    setState(() {
      Navigator.push(
          context, new MaterialPageRoute(builder: (context) => HomePage()));
    });
  }

  // _toastInfo(String info) {
  //   Fluttertoast.showToast(msg: info, toastLength: Toast.LENGTH_LONG);
  // }

  Future<File> moveFile(File sourceFile, String newPath) async {
    print("hello");
    // try {
    //   return await sourceFile.rename(newPath);
    // } catch (e) {
    final newFile = await sourceFile.copy(newPath);
    print(newFile);
    return newFile;
  }
}
