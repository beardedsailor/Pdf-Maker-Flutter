import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'custom_colors.dart';

/// Class Elements Contains all the elements that can be reused throughout the Application
class Elements {
  /// Theme Data: This function contains all the basic settings for the theme of the app
  static ThemeData appTheme() => new ThemeData(
        brightness: Brightness.light,
        primaryColor: CustomColors.themeBlue,
        primaryColorDark: CustomColors.themeBlue,
        inputDecorationTheme: new InputDecorationTheme(
          labelStyle: new TextStyle(color: Colors.white, fontSize: 25.0),
        ),
        fontFamily: 'ProductSans',
      );

  /// Heading Text Style: This function contains the stying of headings in the app
  static TextStyle headingTextStyle() => TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20.0,
      color: Colors.black,
      fontFamily: 'ProductSans');

  /// this function is called for setting the border side
  static BorderSide borderSide(inputColor, inputWidth) =>
      new BorderSide(color: inputColor, width: inputWidth);

  /// this function is called to set the textStyle
  static TextStyle textStyle(fontsize, fontcolor, {fontWeight}) =>
      new TextStyle(
          color: fontcolor,
          fontSize: fontsize,
          fontFamily: 'ProductSans',
          fontWeight: fontWeight);

  static TextStyle labelStyle() =>
      TextStyle(color: Colors.black, fontFamily: 'ProductSans');

  /// This function is called for creating a text field into a form

  static TextFormField inputField(
          controller, hintText, labelText, icon, validator,
          {keyboardType,
          obscureText,
          suffixIcon,
          errorText,
          focusNode,
          int maxLength,
          bool maxLengthEnforced,
          Key key,
          maxLines,
          minLines}) =>
      TextFormField(
        controller: controller,
        style: TextStyle(color: CustomColors.themeBlue),
        keyboardType: keyboardType,
        decoration: new InputDecoration(
          counterText: '',
          focusedBorder: OutlineInputBorder(
            borderSide: Elements.borderSide(CustomColors.themeOrange, 2.0),
            borderRadius: BorderRadius.circular(15.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: Elements.borderSide(Colors.grey[300], 2.0),
            borderRadius: BorderRadius.circular(15.0),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: Elements.borderSide(Colors.red, 2.0),
            borderRadius: BorderRadius.circular(15.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
              borderSide: Elements.borderSide(Colors.red, 2.0),
              borderRadius: BorderRadius.circular(15.0)),
          hintText: hintText,
          labelText: labelText,
          fillColor: Colors.black,
          errorText: errorText,
          prefixIcon: Icon(
            icon,
            color: CustomColors.themeOrange,
          ),
          suffixIcon: suffixIcon,
          labelStyle: Elements.textStyle(15.0, Colors.black),
        ),
        validator: validator,
        focusNode: focusNode,
        obscureText: obscureText != null ? obscureText : false,
        maxLength: maxLength,
        maxLengthEnforced: maxLengthEnforced != null ? maxLengthEnforced : true,
        key: (key != null) ? key : Key(""),
        maxLines: (maxLines != null) ? maxLines : 1,
        minLines: (minLines != null) ? minLines : 1,
      );

  /// Function for creating button with Theme
  static ButtonTheme buttonTheme(
      minWidth, height, text, bgColor, textColor, onPressed,
      {Key key, value}) {
    return ButtonTheme(
      minWidth: minWidth,
      height: height,
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(8.0)),
      child: RaisedButton(
          onPressed: onPressed,
          child: Text(
            text,
            style: Elements.textStyle(15.0, textColor),
          ),
          color: bgColor),
      key: key,
    );
  }

  /// App Bar on top of the page.
  static AppBar appBar(text, icon, onPressed) {
    return AppBar(
      title: new Text(
        text,
        style: Elements.textStyle(20.0, Colors.white),
      ),
      backgroundColor: CustomColors.themeBlue,
      //Back arrow present in AppBar
      leading: IconButton(
        icon: new Icon(icon),
        onPressed: onPressed,
      ),
    );
  }

  ///This Function Displays the image picker Window for getting the image from gallery or camera
  static imagePickerWindow(context, onTap,
      {gallery: false, camera: true, key}) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              key: key,
              child: new Wrap(
                children: <Widget>[
                  gallery
                      ? new ListTile(
                          leading: new Icon(Icons.photo_library),
                          title: new Text(
                              'Photo Library'), // for selecting images from gallery
                          onTap: () {
                            onTap(ImageSource.gallery);
                            Navigator.of(context).pop();
                          })
                      : Container(),
                  camera
                      ? new ListTile(
                          leading: new Icon(Icons.photo_camera),
                          title: new Text(
                              'Camera'), //for selecting images from camera
                          onTap: () {
                            onTap(ImageSource.camera);
                            Navigator.of(context).pop();
                          },
                        )
                      : Container(),
                ],
              ),
            ),
          );
        });
  }

  // static loadImageAsset(String imagePath, String placeholderPath) {
  //   File file = File('${globals.dir.path}$imagePath');
  //   if (file.existsSync()) {
  //     return FileImage(file);
  //   } else {
  //     if (placeholderPath != null && placeholderPath != "") {
  //       return AssetImage(placeholderPath);
  //     }
  //     return AssetImage("assets/images/itinker_logo.png");
  //   }
  // }
}
