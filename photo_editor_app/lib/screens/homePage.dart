import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_editor_app/screens/aboutUs.dart';
import 'package:photo_editor_app/screens/griditem.dart';
import 'package:photo_editor_app/screens/photoEditing.dart';
import 'package:photo_editor_app/utils/custom_colors.dart';
import 'package:photo_editor_app/utils/elements.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var selectedList = List();
  final Directory _photoDir =
      new Directory('/storage/emulated/0/photo_editor_app/'); 
  final picker = ImagePicker();
  int currentIndex = 0;
  File userImgFile, schoolIDImgFile;
  String userImgPath, schoolImgPath;
  int select = 0;
  
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;

    var imageList = _photoDir
        .listSync()
        .map((item1) => item1.path)
        .where((item1) => item1.endsWith(".jpg"))
        .toList(growable: false);
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Photo Editor"),
      ),
      body:GridView.builder(
          itemCount: imageList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: (itemWidth / itemHeight),
              crossAxisSpacing: 2,
              mainAxisSpacing: 2),
          itemBuilder: (context, index) {
            return GridItem(
                item: File(imageList[index]),
                isSelected: (bool value) {
                  setState(() {
                    if (value) {
                      selectedList.add(imageList[index]);
                    } else {
                      selectedList.remove(imageList[index]);
                    }
                  });
                  print("$selectedList");
                },
                );
          }),

     
          
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
                child: Stack(
              alignment: AlignmentDirectional.topStart,
              children: [
                Container(
                  decoration: new BoxDecoration(
                    color: Colors.lightBlue,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.elliptical(220, 50),
                        bottomRight: Radius.elliptical(220, 50)),
                  ),
                  height: 250,
                  child: Center(
                    child: Text(
                      'Welcome',
                      style: Elements.textStyle(20.0, Colors.white),
                    ),
                  ),
                ),
              ],
            )),
            ListTile(
              title: Text('Homepage'),
              onTap: () {
                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) => HomePage()));
              },
            ),
            ListTile(
              title: Text('About Us'),
              onTap: () {
                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) => AboutUs()));
              },
            ),
            ListTile(
              title: Text('Whats New'),
              onTap: () {
                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) => HomePage()));
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTappedBar,
        currentIndex: currentIndex,
        backgroundColor: Colors.lightBlue,

        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            label: 'Camera',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_a_photo),
            label: 'Add Photo',
          ),
        ],
      ),
    );
  }

  void onTappedBar(int index) {
    setState(() {
      currentIndex = index;
      if (currentIndex == 0) {
        getCameraImageDetails();
      } else if (currentIndex == 1) {
        getgalleryImageDetails();
      }
    });
  }

  void getCameraImageDetails() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        userImgPath = pickedFile.path;
        userImgFile = File(pickedFile.path);
        _cropImage();
      });
    } else {
      print('No image selected.');
    }
  }

  void getgalleryImageDetails() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        userImgPath = pickedFile.path;
        userImgFile = File(pickedFile.path);
        _cropImage();
      });
    } else {
      print('No image selected.');
    }
  }

  Future<Null> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: userImgFile.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: CustomColors.themeBlue,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Crop Image',
        ));
    if (croppedFile != null) {
      userImgFile = croppedFile;
      setState(() {
        Navigator.push(
            this.context,
            new MaterialPageRoute(
                builder: (context) => PhotoEditing(croppedFile)));
      });
    }
  }
}

class Item {
  File imageUrl; 

  Item(this.imageUrl);
}