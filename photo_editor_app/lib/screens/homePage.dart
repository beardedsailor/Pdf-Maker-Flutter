import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_editor_app/screens/aboutUs.dart';
import 'package:photo_editor_app/screens/pdf_history.dart';
import 'package:photo_editor_app/screens/pdfviewerhistory.dart';
import 'package:photo_editor_app/screens/photoEditing.dart';
import 'package:photo_editor_app/utils/custom_colors.dart';
import 'package:photo_editor_app/utils/elements.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:photo_editor_app/utils/griditem.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var selectedList = List();
  List<File> images = [];
  Directory _photoDir =
      new Directory('data/user/0/com.example.photo_editor_app/app_flutter');
  final picker = ImagePicker();
  File userImgFile;
  String userImgPath;
  var imageList;
  var tempOutput;
  int lengthOfSelectedList = 0;
  final pdf = pw.Document();
  bool isLoading = true, next = false;
  String pdfFileName;
  TextEditingController _textFieldController = TextEditingController();
  int index = 1;
  // List<bool> isSelected1 = [false, false, false, false, false];
  List<bool> isSelected1 = [];
  var unique;

  @override
  void initState() {
    _requestPermission();
    setState(() {
      _photoDir = new Directory('/storage/emulated/0/photo_editor_app/');
      loadImageList();
    });
    setState(() {
      for (int i = 0; i < tempOutput.length; i++) {
        isSelected1.add(false);
      }
    });

    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return new WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: getAppBar(),
          body: (isLoading)
              ? Center(
                  child: Text(
                  "Add Images to Start",
                  style: Elements.textStyle(15.0, Colors.grey),
                ))
              : GridView.builder(
                  itemCount: tempOutput.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: (itemWidth / itemHeight),
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          isSelected1[index] = !isSelected1[index];

                          if (isSelected1[index]) {
                            selectedList.add(tempOutput[index]);
                          } else {
                            selectedList.remove(tempOutput[index]);
                          }
                        });
                      },
                      child: Stack(
                        children: <Widget>[
                          Image.file(
                            File(tempOutput[index]),
                            color: Colors.black
                                .withOpacity(isSelected1[index] ? 0.9 : 0),
                            colorBlendMode: BlendMode.color,
                          ),
                          isSelected1[index]
                              ? Align(
                                  alignment: Alignment.bottomRight,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.check_circle,
                                      color: Colors.blue,
                                    ),
                                  ),
                                )
                              : Container()
                        ],
                      ),
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
                        color: Colors.pinkAccent,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.elliptical(220, 50),
                          topRight: Radius.elliptical(220, 50),
                            bottomLeft: Radius.elliptical(220, 50),
                            bottomRight: Radius.elliptical(220, 50)),
                      ),
                      height: 250,
                      child: Center(
                        child: Text(
                          'PDF MAKER',
                          style: Elements.textStyle(20.0, Colors.white),
                        ),
                      ),
                    ),
                  ],
                )),
                ListTile(
                  leading: new Icon(Icons.home_outlined, color: Colors.lightBlue,size: 35,),
                  title: Text('Homepage', style: Elements.textStyle(18.0, Colors.pinkAccent),),
                  onTap: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => HomePage()));
                  },
                ),
                ListTile(
                  leading: new Icon(Icons.file_present, color: Colors.lightBlue,size: 35,),
                  title: Text('My Files', style: Elements.textStyle(18.0, Colors.pinkAccent),),
                  onTap: () {
                    Navigator.push(context,
                        new MaterialPageRoute(builder: (context) => PdfHistory()));
                  },
                ),
                ListTile(
                  leading: new Icon(Icons.person_outline_outlined,color: Colors.lightBlue,size: 35,),
                  title: Text('About', style: Elements.textStyle(18.0, Colors.pinkAccent),),
                  onTap: () {
                    Navigator.push(context,
                        new MaterialPageRoute(builder: (context) => AboutUs()));
                  },
                  focusColor: Colors.grey,
                ),
                ListTile(
                  leading: new Icon(Icons.new_releases_outlined, color: Colors.lightBlue,size: 35,),
                  title: Text("What's New", style: Elements.textStyle(18.0, Colors.pinkAccent),),
                  onTap: () {
                    // Navigator.push(
                    //     context,
                    //     new MaterialPageRoute(
                    //         builder: (context) => HomePage()));
                  },
                ),
                ListTile(
                  leading: new Icon(Icons.rate_review_outlined,color: Colors.lightBlue,size: 35,),
                  title: Text('Rate Us', style: Elements.textStyle(18.0, Colors.pinkAccent),),
                  onTap: () {
                    // Navigator.push(context,
                    //     new MaterialPageRoute(builder: (context) => ));
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
                        Icons.history_rounded,
                        semanticLabel: "History",
                      ),
                      onPressed: () {
                        selectedList.clear();
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => PdfHistory()));
                      }),
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
                        if (selectedList.isNotEmpty) {
                          await _displayTextInputDialog(context);

                          if (pdfFileName != "") {
                            // pdfFileName = "Document " + index.toString();
                            next = true;
                            // index += 1;
                          }
                        } else {
                          await _displayMessageDialog(context);
                          setState(() {
                            next = false;
                          });
                        }
                        if (next) {
                          for (var i in selectedList) {
                            images.add(File(i));
                          }

                          if (images.isNotEmpty) {
                            print(pdfFileName);
                            await exportPdf(images, pdfFileName, height, width);
                            setState(() {
                              pdfFileName = "";
                              for (int i = 0; i < tempOutput.length; i++) {
                                isSelected1[i] = false;
                              }
                              selectedList.clear();

                              images.clear();
                            });
                          }
                          setState(() {
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => PdfHistory()));
                          });
                        }
                      }),
                ],
              ),
            ),
          ),
        ));
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
                    tempOutput.remove(selectedList[0]);
                    selectedList.removeAt(0);
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

  _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    final info = statuses[Permission.storage].toString();
    print(info);
  }

  loadImageList() async {
    imageList = _photoDir
        .listSync()
        .map((item1) => item1.path)
        .where((item1) => item1.endsWith(".jpg"))
        .toList();
    tempOutput = imageList.toList();
    setState(() {
      if (tempOutput.isEmpty) {
        isLoading = true;
      } else {
        isLoading = false;
      }
    });
    setState(() {});
  }

  photodirValue() async {
    new Timer(const Duration(milliseconds: 1000), () {
      _photoDir = new Directory('/storage/emulated/0/photo_editor_app/');
    });
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    String valueText;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Document Name'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "Enter Value"),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.orange,
                textColor: Colors.white,
                child: Text('OK'),
                onPressed: () {
                  setState(() {
                    pdfFileName = valueText;
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  Future<void> _displayMessageDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Select images to make pdf'),
            actions: <Widget>[
              FlatButton(
                color: Colors.orange,
                textColor: Colors.white,
                child: Text('OK'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }
}

class Item {
  File imageUrl;
  int rank;
  Item(this.imageUrl, this.rank);
}
