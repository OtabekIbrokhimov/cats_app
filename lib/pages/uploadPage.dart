import 'dart:io';

import 'package:cats_app/pages/direct.page.dart';
import 'package:cats_app/pages/myCat.dart';
import 'package:cats_app/servise/http_servise.dart';
import 'package:cats_app/servise/utils_servise.dart';
import 'package:flutter/material.dart';

class UploadPage extends StatefulWidget {
  static const String id = "/UploadPage";
  File? file;
  UploadPage({this.file, Key? key}) : super(key: key);

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  void upload() async {
    HttpServise.MULTIPART(HttpServise.API_UPLOAD, widget.file!.path, HttpServise.bodyUpload(widget.file!.hashCode.toString())).then((value) {
      if(value != null) {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MyCat()), (route) => route.isFirst);
      } else {
        UtilsServise.fireSnackBar("Something error", context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              image: FileImage(widget.file!),
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height * 0.7,
            ),
            MaterialButton(
              onPressed: upload,
              child: Text("Upload"),
              textColor: Colors.white,
              shape: StadiumBorder(),
              height: 55,
              minWidth: MediaQuery.of(context).size.width * 0.7,
              color: Colors.blueAccent,
            )
          ],
        ),
      ),
    );
  }
}