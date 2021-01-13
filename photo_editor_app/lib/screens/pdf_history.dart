import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_editor_app/screens/homePage.dart';
import 'package:photo_editor_app/utils/elements.dart';

class PdfHistory extends StatefulWidget {
  @override
  _PdfHistoryState createState() => _PdfHistoryState();
}

class _PdfHistoryState extends State<PdfHistory> {
  List<Widget> _pdfWidgets;
  List<Widget> get document => _pdfWidgets;
  Directory _photoDir = new Directory('/storage/emulated/0/Pdf Maker');
  var documentList;
  bool isLoading = true;

  @override
  void initState() {
    loadDocumentList();

    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Elements.appBar("History", Icons.arrow_back, () {
          Navigator.push(
              context, new MaterialPageRoute(builder: (context) => HomePage()));
        }),
        backgroundColor: Colors.white,
        body: SafeArea(
            child: isLoading
                ? Center(
                    child: Text(
                      "Nothing to show",
                      style: Elements.textStyle(15.0, Colors.grey),
                    ),
                  )
                : Column(children: [
                    Expanded(
                      child: ListView.builder(
                          itemCount: documentList.length,
                          itemBuilder: (context, index) {
                            return Card(
                              elevation: 5,
                                                          child: ListTile(
                                leading: new Icon(Icons.picture_as_pdf_rounded),
                                title: new Text(basename(documentList[index])),
                                // focusColor: Colors.grey[300],
                                tileColor: Colors.grey[50],
                                onTap: () {
                                  OpenFile.open(documentList[index]);
                                },
                              ),
                            );
                          }),
                    )
                  ])));
  }

  loadDocumentList() async {
    documentList = _photoDir
        .listSync()
        .map((item1) => item1.path)
        .where((item1) => item1.endsWith(".pdf"))
        .toList();
    setState(() {
      if (documentList.isEmpty) {
        isLoading = true;
        print(documentList);
      } else {
        isLoading = false;
      }
    });
    setState(() {});
  }

}
