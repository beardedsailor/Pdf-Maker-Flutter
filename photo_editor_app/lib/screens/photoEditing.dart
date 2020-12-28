import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:flutter/material.dart';
import 'package:photo_editor_app/screens/makepdf.dart';
import 'package:photo_editor_app/utils/custom_colors.dart';
import 'package:photo_editor_app/utils/elements.dart';
import 'package:photofilters/photofilters.dart';
import 'package:flutter/rendering.dart';

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
                    onPressed: () {
                      _takePicture();
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
                : filteredImage()),
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
          print("object");
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
    final fileName = path.basename(imageFile.path);
    final savedImage = await imageFile.copy('${appDir.path}/$fileName');
    Navigator.push(this.context, new MaterialPageRoute(builder: (context) => MakePdf(savedImage)));
    setState(() {
    });
  }
}
