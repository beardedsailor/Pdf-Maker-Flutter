import 'dart:typed_data';
import 'package:flutter/material.dart';

class MakePdf extends StatefulWidget {
  final Uint8List imageData;
  MakePdf(this.imageData);
  @override
  _MakePdfState createState() => _MakePdfState();
}

class _MakePdfState extends State<MakePdf> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Image.memory(
        widget.imageData,
        width: 200,
        height: 200,
      ),
    );
  }
}
