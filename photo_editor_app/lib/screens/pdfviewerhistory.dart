import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:permission_handler/permission_handler.dart';

Future<String> exportPdf(List<File> images) {
  final Document pdf = Document();
  final filesToImages = images
      // ignore: deprecated_member_use
      .map((image) => Image(
          PdfImage.file(
            pdf.document,
            bytes: image.readAsBytesSync(),
          ),
          height: 400))
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
  Future<String> a = savePdf(pdf);
  return a;
}

Future<String> savePdf(Document pdf) async {
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
    final now = DateTime.now().millisecondsSinceEpoch.toString();
    final File file = File('${appDocDir.path}/${now.substring(9)}.pdf');
    await file.create(recursive: true);
    final data = pdf.save();
    await file.writeAsBytes(data);
    return file.path;
  }
  return null;
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
