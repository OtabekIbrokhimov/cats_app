import 'dart:convert';

import 'package:cats_app/model/catApp_model.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
class HttpServise{
  static bool isTester = true;

  static String SERVER_DEVELOPMENT = "api.thecatapi.com";
  static String SERVER_PRODUCTION = "api.thecatapi.com";

  static Map <String, String> getHeaders(){
    Map <String, String> headers = {
      'Content-Type': 'application/json',
      'x-api-key': '8d9d1e1c-a72c-41c8-9e5c-8f5c23edc637'
    };
    return headers;
  }
static Map<String, String> getUploadHeaders(){
    Map <String, String >headers = {
      'Content-Type': 'multipart/form-data',
      'x-api-key': '8d9d1e1c-a72c-41c8-9e5c-8f5c23edc637'
    };
    return headers;
}
static String getServer(){
    if(isTester)return SERVER_DEVELOPMENT;
    return SERVER_PRODUCTION;
}
///Http requests

 static Future<String?> GET(String api,Map<String, dynamic>params )async{
    var uri = Uri.https(getServer(),api, params);
    var response = await get(uri, headers: getHeaders());
    if(response.statusCode == 200)return response.body;
    return null;
 }
 static Future<String?> MULTIPART(
     String api, String filepath, Map <String, String>body)async{
    var uri = Uri.https(getServer(), api);
    var request = MultipartRequest('POST', uri);
    request.headers.addAll(getUploadHeaders());
    request.files.add(await MultipartFile.fromPath("file",filepath,contentType: MediaType("image","jpeg")));
    request.fields.addAll(body);
    StreamedResponse response = await request.send();
    if(response.statusCode ==200 || response.statusCode == 201 ){
      return await response.stream.bytesToString();
    }else{
      return response.reasonPhrase;
    }
 }
 static Future <String?> DELETE(String api, Map <String, String>params )async{
  var uri = Uri.https(getServer(), api,params, );
 var responce = await delete(uri,headers: getUploadHeaders() );
 if(responce.statusCode ==200)return responce.body;
 return null;
}
///http Apis///
 static String API_LIST = "/v1/images/search";
  static String API_SEARCH_BREED = "/v1/breeds/search";
  static String API_GET_UPLOAD ='/v1/images';
  static String API_DELETE = '/v1/images/';
  static String API_UPLOAD = "/v1/images/upload";


  ///http Body ///
 static Map<String,String> bodyUpload(String subId){
   Map<String, String>body = {
     'sub_id':subId
   };
   return body;
 }
 ///http params//
static Map<String, String>paramsEmpty(){
   Map<String, String>params = {};
   return params;
}

static Map <String, dynamic > paramsPage(int pageNumber){
   Map<String,String> params = {};
   params.addAll({"limit":'25','page':pageNumber.toString()});
   return params;
 }
  static Map <String, dynamic > paramsSearch(String search,int pageNumber){
    Map<String,String> params = {};
    params.addAll({"breed_ids":search, "limit":'25','page':pageNumber.toString()});
    return params;
  }
 static Map <String, String> paramsBreedSearch(String search){
   Map< String, String> params = {};
   params.addAll({'q':search});
   return params;
   }
/*Http parsing*/

static  List<Cat> parseResponse(String response ){
  List json = jsonDecode(response);
  List<Cat> photos = List<Cat>.from(json.map((e) => Cat.fromJson(e)));
  return photos;
}
static List <Breeds> parseSerachBreed(String responce){
  List json = jsonDecode(responce);
  List<Breeds> categories = List<Breeds>.from(json.map((e) => Breeds.fromJson(e)));
  return categories;
}
}

