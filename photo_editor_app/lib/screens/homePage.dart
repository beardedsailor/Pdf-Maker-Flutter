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
import 'package:pdf/widgets.dart' as pw;

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
  var imageList;
  var tempOutput;
  bool value;
  // Key _key = new Key("listOfItems");
  int lengthOfSelectedList = 0;
  // List<File> _files = [];
  final pdf = pw.Document();

  @override
  void initState() {
    loadImageList();
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;

    return Scaffold(
      appBar: getAppBar(),
      body: GridView.builder(
          itemCount: tempOutput.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: (itemWidth / itemHeight),
              crossAxisSpacing: 2,
              mainAxisSpacing: 2),
          itemBuilder: (context, index) {
            return GridItem(
                item: File(tempOutput[index]),
                isSelected: (value) {
                  setState(() {
                    if (value) {
                      selectedList.add(tempOutput[index]);
                    } else {
                      selectedList.remove(tempOutput[index]);
                    }
                  });
                  // print("$selectedList");
                },
                key: Key(tempOutput[index].toString()));
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
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 60,
          color: Colors.lightBlue,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              new IconButton(
                  icon: new Icon(
                    Icons.camera_alt,
                    semanticLabel: "Camera",
                  ),
                  onPressed: () {
                    getCameraImageDetails();
                  }),
              new IconButton(
                  icon: new Icon(Icons.photo_library),
                  onPressed: () {
                    getgalleryImageDetails();
                  }),
              new IconButton(
                  icon: new Icon(Icons.picture_as_pdf),
                  onPressed: () async {
                    // createPdf();
                    // final pdf = await createPdf();
                    // await savePdf(pdf);
                  }),
            ],
          ),
        ),

        
      ),
    );
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

  getAppBar() {
    lengthOfSelectedList = selectedList.length;
    print(lengthOfSelectedList);
    return AppBar(
      title: Text(selectedList.length < 1
          ? "Photo Editor"
          : "${selectedList.length} item selected"),
      actions: <Widget>[
        selectedList.length < 1
            ? Container()
            : InkWell(
                onTap: () {
                  while (lengthOfSelectedList > 0) {
                    new File(selectedList[0]).delete();
                    // print(tempOutput);
                    tempOutput.remove(selectedList[0]);
                    // print(tempOutput);
                    // print("list1== + $selectedList");
                    selectedList.removeAt(0);
                    // print("list2== + $selectedList");
                    // print(lengthOfSelectedList);
                    lengthOfSelectedList--;
                  }
                  setState(() {});
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.delete),
                ))
      ],
    );
  }

  loadImageList() {
    imageList = _photoDir
        .listSync()
        .map((item1) => item1.path)
        .where((item1) => item1.endsWith(".jpg"))
        .toList();
    tempOutput = imageList.toList();
  }

  // createPdf() {
  //   for (var i = 0; i < selectedList.length; i++) {
  //     var image = PdfImage.file(
  //       pdf.document,
  //       bytes: File(selectedList[i]).readAsBytesSync(),
  //     );

  //     pdf.addPage(pw.Page(
  //         pageFormat: PdfPageFormat.a4,
  //         build: (pw.Context context) {
  //           // ignore: deprecated_member_use
  //           return pw.Center(child: pw.Image(image));
  //         }));
  //   }
  // }

  // Future savePdf(pdf) async {
  //   print(pdf);
  //   Directory tempDir = await getTemporaryDirectory();
  //   String tempPath = tempDir.path;
  //   File file = File('$tempPath/1234.pdf');
  //   file.writeAsBytesSync(pdf);
  //   print(tempDir.listSync());
  // }
}

class Item {
  File imageUrl;
  int rank;
  Item(this.imageUrl, this.rank);
}
