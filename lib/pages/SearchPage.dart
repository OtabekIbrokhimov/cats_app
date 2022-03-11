import 'package:cached_network_image/cached_network_image.dart';
import 'package:cats_app/servise/http_servise.dart';
import 'package:cats_app/servise/utils_servise.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../model/catApp_model.dart';
import 'detail_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);
static const String id = "SearchPage";
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
   bool isLoading = false;
  TextEditingController controller = TextEditingController();
   String search = "";
   List<Cat> items = [];
  
  
  void _search()async{
    search = controller.text.toString().trim();
    if(search.isNotEmpty){
      setState(() {
        isLoading = true;
      });
      await HttpServise.GET(HttpServise.API_SEARCH_BREED, HttpServise.paramsBreedSearch(search)).then((getCatigories));
      setState(() {
        isLoading = false;
      });

    }else{
      UtilsServise.fireSnackBar("Please enter search text", context);
    }
    
  }
  void getCatigories(String? response)async{
    setState(() {
      isLoading = true;
    });
    if(response != null){
      List<Breeds> list = HttpServise.parseSerachBreed(response);
      String? breedId;
      for(int i = 0; i< list.length; i++){
        if(list[i].name!.toLowerCase().startsWith(search.toLowerCase())){
          breedId = list[i].id;
          break;
        }
      }
      await HttpServise.GET(HttpServise.API_LIST,HttpServise.paramsSearch(breedId??"", 0)).then((getSearchCats));
    }else{
      UtilsServise.fireSnackBar("internal server error", context);
    }
    setState(() {
      isLoading = false;
    });
  }
  void getSearchCats(String? response){
    if(response != null){
      setState(() {
        items = HttpServise.parseResponse(response);
      });
    }else{
      UtilsServise.fireSnackBar("not found please enter that new key word", context);
    }
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBody: true,
        body: Stack(
          children: [
            // #body
            Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // #search
                    Container(
                      alignment: Alignment.center,
                      height: 50,
                      width: double.infinity,
                      margin:
                      EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Colors.grey,
                          )),
                      child: TextField(
                        controller: controller,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: const InputDecoration(
                          isCollapsed: true,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
                          hintText: "Search",
                          prefixIcon: Icon(Icons.search),
                        ),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.search,
                        onSubmitted: (text) {
                          _search();
                        },
                      ),
                    ),

                    // #gridview
                    MasonryGridView.count(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      itemCount: items.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,
                      itemBuilder: (context, index) {
                        return ImagesOfApp(items[index]);
                      },
                    ),
                  ],
                ),
              ),
            ),

            // #indicator
            isLoading
                ? Center(child: CircularProgressIndicator())
                : const SizedBox(
              height: 0,
              width: 0,
            ),
          ],
        ),
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
