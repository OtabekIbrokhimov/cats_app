import 'package:cached_network_image/cached_network_image.dart';
import 'package:cats_app/model/catApp_model.dart';
import 'package:cats_app/servise/http_servise.dart';
import 'package:cats_app/servise/utils_servise.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'detail_page.dart';

class MyCat extends StatefulWidget {
  const MyCat({Key? key}) : super(key: key);
static const String id = "/myCAT";
  @override
  State<MyCat> createState() => _MyCatState();
}

class _MyCatState extends State<MyCat> {
  bool isloading = false;
  final ScrollController _scrollController = ScrollController();
  List<Cat> items = [];
  List <Cat> myCatImage = [];
  int pageNumber = 1;

  void getData()async{
    setState(() {
      isloading = true;
    });
    await HttpServise.GET(HttpServise.API_LIST, HttpServise.paramsPage(pageNumber++)).then((parseDate));
  }
  void parseDate(String? response){
    if(response != null){
      setState(() {
        items.addAll(HttpServise.parseResponse(response));
      });
    }else{
      UtilsServise.fireSnackBar("please try again later", context);
    }
  }
  void loadingMore(){
    if (_scrollController.position.maxScrollExtent ==
        _scrollController.position.pixels) {
      getData();
    }
  }
  @override
  void initState() {

    super.initState();
    _scrollController.addListener(loadingMore) ;
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      appBar: AppBar(
        toolbarHeight: 50,
       centerTitle: true,
        title: Text("My cats"),
      ),
      body: Stack(
        children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      MasonryGridView.count(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        itemCount: items.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 5,
                        itemBuilder: (context, index) {
                          return ImagesOfApp(items[index]);
                        },
                      )
                    ],
                  ),
                ),

          ),
          isloading
              ? Center(
            child: CircularProgressIndicator(),
          )
              : SizedBox(),
        ],
      ),
    );
  }

  Widget ImagesOfApp(Cat cat) {
    return AspectRatio(
      aspectRatio: cat.width! / cat.height!,
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              PageRouteBuilder(
                  transitionDuration: const Duration(seconds: 1),
                  pageBuilder: (context, anim, anim2) =>
                      DetailPage(imageId: cat.id, url: cat.url)));
        },
        child: Hero(
          tag: cat.id!,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: CachedNetworkImage(
              imageUrl: cat.url!,
              placeholder: (context, text) => Container(
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
