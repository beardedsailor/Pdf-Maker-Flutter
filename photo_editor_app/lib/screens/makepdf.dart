import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:photo_editor_app/screens/homePage.dart';
import 'package:photo_editor_app/utils/elements.dart';
import 'package:photo_editor_app/utils/griditem.dart';

class PdfHistory extends StatefulWidget {
  // final List<String> documents;
  // PdfHistory(this.documents);
  @override
  _PdfHistoryState createState() => _PdfHistoryState();
}

class _PdfHistoryState extends State<PdfHistory> {
  List<Widget> _pdfWidgets;
  List<Widget> get document => _pdfWidgets;
  Directory _photoDir = new Directory('/storage/emulated/0/photo_edito_app');
  var documentList;
  bool isLoading = true;
  
  @override
  void initState() {
    loadDocumentList();
    setState(() {
      print(documentList[0]);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Elements.appBar("About Us", Icons.arrow_back, () {
        Navigator.push(
            context, new MaterialPageRoute(builder: (context) => HomePage()));
      }),
        backgroundColor: Colors.white,
        body: SafeArea(
            child: Column(children: [
          isLoading?Container(child: Text("Nothing to show"),):
          Expanded(
            child: ListView.builder(
                itemCount: documentList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: new Icon(Icons.picture_as_pdf_rounded),
                    title:
                        new Text("Document " + basename(documentList[index])),
                    focusColor: Colors.grey[300],
                    tileColor: Colors.grey[100],
                  );
                }),
          )
        ]
                //   height: 500,
                //   child: Expanded(

                //     child:

                //   ),
                // ),
                // child: GridView.builder(
                //     itemCount: historyOfDocuments.length,
                //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //         crossAxisCount: 2,
                //         // childAspectRatio: (itemWidth / itemHeight),
                //         crossAxisSpacing: 2,
                //         mainAxisSpacing: 2),
                //     itemBuilder: (context, index) {
                //       return GridItem(
                //           item: File(historyOfDocuments[index]),
                //           isSelected: (value) {
                //             setState(() {
                //               // if (value) {
                //               //   selectedList.add(tempOutput[index]);
                //               // } else {
                //               //   selectedList.remove(tempOutput[index]);
                //               // }
                //             });
                //           },
                //           key: Key(historyOfDocuments[index].toString()));
                //     }),
                // child: GridView.builder(
                //     itemCount: historyOfDocuments.length,
                //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //         crossAxisCount: 2,
                //         childAspectRatio: (3 / 4),
                //         crossAxisSpacing: 2,
                //         mainAxisSpacing: 2),
                //     itemBuilder: (context, index) {
                //       return GridItem(
                //           item: File("/storage/emulated/0/photo_edito_app/8665.pdf"),

                //         // onTap: () => OpenFile.open(historyOfDocuments[index].toString()),
                //       );
                //     }),

                )));
  }

  loadDocumentList() async {
    documentList = _photoDir
        .listSync()
        .map((item1) => item1.path)
        .where((item1) => item1.endsWith(".pdf"))
        .toList();
    setState(() {
      isLoading = false;
      print(documentList);
    });
    // tempOutput = imageList.toList();
  }
}
