import 'package:Demo_Hive_with_Bloc/data/model/albumDataModel.dart';
import 'package:Demo_Hive_with_Bloc/data/model/albumHiveModel.dart';
import 'package:hive/hive.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class AlbumlistRepo {
  Future<List<Album>> fetchlist() async {
    Box<Album> box = Hive.box<Album>("album");
    List<Album> data = box.values.toList().cast<Album>();
    if (data.isNotEmpty ) {
      data.sort((a,b)=>b.updatedAt.compareTo(a.updatedAt));
      return data;
    } else {
      try {
        String url = "https://jsonplaceholder.typicode.com/albums/1/photos";
        var response =
            await http.get(url, headers: {"Content-Type": "application/json"});
        if (response.statusCode == 200 || response.statusCode == 201) {
          var jsonResponse = convert.jsonDecode(response.body);
          AlbumModelResponse list = AlbumModelResponse.fromJson(jsonResponse);
          list.list.map((value) {
            Album album = Album(value.url, value.title, value.id, value.albumId,
                value.thumbnailUrl, DateTime.now(),null);
            box.add(album);
          }).toList();
          var data = box.values.toList().cast<Album>();
          data.sort((a,b)=>b.updatedAt.compareTo(a.updatedAt));
          return data;
        } else {
          Album album = Album(null,null, null,null ,null,DateTime.now(),"ERROR Fetching data from API");
          box.add(album);
          var data = box.values.toList().cast<Album>();
          return data;
        }
      } catch (e) {
        return data;

      }
    }
  }
}
