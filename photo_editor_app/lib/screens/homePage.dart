import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:path_provider_ex/path_provider_ex.dart';
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
// import 'package:simple_permissions/simple_permissions.dart';

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
  List imageList;
  List tempOutput;
  int lengthOfSelectedList = 0;
  final pdf = pw.Document();
  bool isLoading = true, next = false;
  String pdfFileName;
  TextEditingController _textFieldController = TextEditingController();
  int index = 1;
  List<bool> isSelected1 = [];
  var unique;

  @override
  void initState() {
    _requestPermission();
    setState(() {
      isLoading = true;
    });
    setState(() {
      loadImageList();
      _photoDir = new Directory('/storage/emulated/0/Pdf Maker/');
    });

    super.initState();
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _textFieldController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var size = MediaQuery.of(context).size;
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
              : new StaggeredGridView.countBuilder(
                  crossAxisCount: 4,
                  itemCount: tempOutput.length,
                  itemBuilder: (BuildContext context, int index) => InkWell(
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
                      fit: StackFit.passthrough,
                      children: <Widget>[
                        Image.file(
                          File(tempOutput[index]),
                          color: Colors.black
                              .withOpacity(isSelected1[index] ? 0.9 : 0),
                          colorBlendMode: BlendMode.color,
                          fit: BoxFit.fill,
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
                  ),
                  staggeredTileBuilder: (int index) =>
                      new StaggeredTile.count(2, index.isEven ? 2 : 2),
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                Container(
                  height: 220,
                  child: DrawerHeader(
                    child: Center(
                      child: Text(
                        "PDF MAKER",
                        style: Elements.textStyle(25.0, Colors.white,
                            fontWeight: FontWeight.bold, letterSpacing: 2.0),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.cyanAccent[700],
                    ),
                  ),
                ),
                ListTile(
                  leading: new Icon(
                    Icons.home_outlined,
                    color: Colors.cyanAccent[700],
                    size: 35,
                  ),
                  title: Text(
                    'Homepage',
                    style: Elements.textStyle(18.0, Colors.cyanAccent[700]),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => HomePage()));
                  },
                ),
                ListTile(
                  leading: new Icon(
                    Icons.file_present,
                    color: Colors.cyanAccent[700],
                    size: 35,
                  ),
                  title: Text(
                    'My Files',
                    style: Elements.textStyle(18.0, Colors.cyanAccent[700]),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => PdfHistory()));
                  },
                ),
                ListTile(
                  leading: new Icon(
                    Icons.person_outline_outlined,
                    color: Colors.cyanAccent[700],
                    size: 35,
                  ),
                  title: Text(
                    'About',
                    style: Elements.textStyle(18.0, Colors.cyanAccent[700]),
                  ),
                  onTap: () {
                    Navigator.push(context,
                        new MaterialPageRoute(builder: (context) => AboutUs()));
                  },
                  focusColor: Colors.grey,
                ),
                ListTile(
                  leading: new Icon(
                    Icons.new_releases_outlined,
                    color: Colors.cyanAccent[700],
                    size: 35,
                  ),
                  title: Text(
                    "What's New",
                    style: Elements.textStyle(18.0, Colors.cyanAccent[700]),
                  ),
                  onTap: () {
                    // Navigator.push(
                    //     context,
                    //     new MaterialPageRoute(
                    //         builder: (context) => HomePage()));
                  },
                ),
                ListTile(
                  leading: new Icon(
                    Icons.rate_review_outlined,
                    color: Colors.cyanAccent[700],
                    size: 35,
                  ),
                  title: Text(
                    'Rate Us',
                    style: Elements.textStyle(18.0, Colors.cyanAccent[700]),
                  ),
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
              color: Colors.cyanAccent[700],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  new IconButton(
                      icon: new Icon(
                        Icons.history_rounded,
                        semanticLabel: "History",
                        color: Colors.white,
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
                        color: Colors.white,
                      ),
                      onPressed: () {
                        getCameraImageDetails();
                      }),
                  new IconButton(
                      icon: new Icon(
                        Icons.photo_library,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        getgalleryImageDetails();
                      }),
                  new IconButton(
                      icon: new Icon(
                        Icons.picture_as_pdf,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        if (selectedList.isNotEmpty) {
                          await _displayTextInputDialog(context);

                          if (pdfFileName != "") {
                            next = true;
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
      backgroundColor: Colors.cyanAccent[700],
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
    var path = await savefile();
    _requestPermission();
    print(_photoDir);
    setState(() {
      imageList = _photoDir
          .listSync()
          .map((item1) => item1.path)
          .where((item1) => item1.endsWith(".jpg"))
          .toList(growable: true);
      tempOutput = imageList.toList();
      print(tempOutput);
      setState(() {
        if (tempOutput.isEmpty) {
          isLoading = true;
        } else {
          isLoading = false;
        }
      });
    });
    setState(() {
      if (isSelected1.length < tempOutput.length) {
        for (int i = 0; i <= tempOutput.length - isSelected1.length; i++) {
          isSelected1.add(false);
        }
      }
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

// Document pdf, String pdfFileName
  savefile() async {
    const pdfPathAndroid = "storage/emulated/0/Pdf Maker/";
    //this supports only android currently
    final bool permission = await permision.checkPermission();
    String pdfFileName = "hello";
    if (!permission) {
      await permision.requestPermission();
    } else {
      final Directory appDocDir = Directory(pdfPathAndroid);
      final bool hasExisted = await appDocDir.exists();
      if (!hasExisted) {
        appDocDir.create();
      }
      return appDocDir.path;
    }
    return "";
  }
}
