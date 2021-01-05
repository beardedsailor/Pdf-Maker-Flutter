import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:photo_editor_app/utils/griditem.dart';

class PdfHistory extends StatefulWidget {
  final List<Future<String>> documents;
  PdfHistory(this.documents);
  @override
  _PdfHistoryState createState() => _PdfHistoryState();
}

class _PdfHistoryState extends State<PdfHistory> {

  List<Widget> _pdfWidgets;
  List<Widget> get document => _pdfWidgets;
  @override
  Widget build(BuildContext context) {
    List<Future<String>> historyOfDocuments = widget.documents;
    return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
                  child: GridView.builder(
            itemCount: historyOfDocuments.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                // childAspectRatio: (itemWidth / itemHeight),
                crossAxisSpacing: 2,
                mainAxisSpacing: 2),
            itemBuilder: (context, index) {
              return GestureDetector(
                              child: GridItem(
                    item: File(historyOfDocuments[index].toString()),
                    
                    ),
                    onTap: () => OpenFile.open(historyOfDocuments[index].toString()),
              );
            }),
        ),
        );
  }
}
