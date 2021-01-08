import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:permission_handler/permission_handler.dart';

var file1;
File file;
exportPdf(List<File> images, String pdfFileName,double height,double width) async {
  final Document pdf = Document();
  final filesToImages = images
      // ignore: deprecated_member_use
      .map((image) => Image(
          PdfImage.file(
            pdf.document,
            bytes: image.readAsBytesSync(),
          ),
          height: height,
          width: width
          ))
      .toList();
  //TODO:make better ui
  pdf.addPage(MultiPage(
      pageFormat: PdfPageFormat.a4.copyWith(
        marginBottom: 1 * PdfPageFormat.cm,
        marginLeft: 1 * PdfPageFormat.cm,
        marginTop: 1 * PdfPageFormat.cm,
        marginRight: 1 * PdfPageFormat.cm,
      ),
      footer: (Context context) {
        return Container(
          alignment: Alignment.centerRight,
          child: Text(
            'Page ${context.pageNumber}',
            style: Theme.of(context)
                .defaultTextStyle
                .copyWith(color: PdfColors.grey),
          ),
        );
      },
      build: (Context context) => <Widget>[...filesToImages]));
  String a = await savePdf(pdf,pdfFileName);
  return a;
  // return file.path.toString();

  // Future<String> a = savePdf(pdf);
  // return a;
}

savePdf(Document pdf, String pdfFileName) async {
  const pdfPathAndroid = "storage/emulated/0/photo_edito_app";
  //this supports only android currently
  final bool permission = await permision.checkPermission();
  if (!permission) {
    await permision.requestPermission();
  } else {
    final Directory appDocDir = Directory(pdfPathAndroid);
    final bool hasExisted = await appDocDir.exists();
    if (!hasExisted) {
      appDocDir.create();
    }
    // final now = DateTime.now().millisecondsSinceEpoch.toString();
    print(appDocDir.path);
    file = File('${appDocDir.path}/$pdfFileName.pdf');
    await file.create(recursive: true);
    final data = pdf.save();
    await file.writeAsBytes(data);

    return file.path;
  }

  return "";
}

class PermissionChecker {
  PermissionStatus permissionStatus = PermissionStatus.undetermined;
  Permission permission = Permission.storage;

  Future listenForPermissionStatus() async {
    final status = await permission.status;
    permissionStatus = status;
  }

  Future<void> requestPermission() async {
    final status = await permission.request();
    permissionStatus = status;
  }

  Future<bool> checkPermission() async {
    await listenForPermissionStatus();

    if (permissionStatus == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }
}

final permision = PermissionChecker();
