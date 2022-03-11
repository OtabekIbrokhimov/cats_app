import 'dart:io';

import 'package:cats_app/pages/uploadPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'SearchPage.dart';
import 'homePage.dart';

class DirectPage extends StatefulWidget {
  const DirectPage({Key? key}) : super(key: key);

  @override
  State<DirectPage> createState() => _DirectPageState();
}

class _DirectPageState extends State<DirectPage> {
  PageController controller = PageController();
  File? file;
   void  getimage()async{
     var result = await ImagePicker().pickImage(source: ImageSource.gallery);
     if(result != null){
       setState(() {
         file = File(result.path);
       });
       Navigator.push(context, MaterialPageRoute(builder: (context)=> UploadPage(file:file)));
     }
   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: false,
      resizeToAvoidBottomInset: false,
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: controller,
        children: [
          HomePage(),
          SearchPage(),

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {getimage();},
        child: Icon(Icons.add, size: 30,),
        backgroundColor: Colors.blueAccent,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 3,
        color: Colors.blue,
        child: Container(
          height: 65,
          child: Row( //children inside bottom appbar
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(icon: Icon(Icons.home, color: Colors.white, size: 30,), onPressed: () {
                controller.animateToPage(0, duration: Duration(milliseconds: 200), curve: Curves.ease);
              },),
              IconButton(icon: Icon(Icons.search, color: Colors.white, size: 30,), onPressed: () {
                controller.animateToPage(1, duration: Duration(milliseconds: 200), curve: Curves.ease);
              },),
            ],
          ),
        ),
      ),
    );
  }
}
