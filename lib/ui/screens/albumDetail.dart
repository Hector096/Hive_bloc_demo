import 'package:Demo_Hive_with_Bloc/data/model/albumHiveModel.dart';
import 'package:Demo_Hive_with_Bloc/ui/screens/editAlbum.dart';
import 'package:Demo_Hive_with_Bloc/ui/widgets/loadingWidget.dart';
import 'package:Demo_Hive_with_Bloc/util/sizeConfig.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AlbumDetailScreen extends StatefulWidget {
  Album data;
  final int index;
  AlbumDetailScreen({Key key, this.data, @required this.index})
      : super(key: key);
  @override
  _AlbumDetailScreenState createState() => _AlbumDetailScreenState(index, data);
}

class _AlbumDetailScreenState extends State<AlbumDetailScreen> {
  Box<Album> box;
  Album data;
  final int index;
  _AlbumDetailScreenState(this.index, this.data);
  @override
  void initState() {
    super.initState();
    box = Hive.box<Album>("album");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: data != null ? Text("Id: ${data.id}") : Text(""),
        centerTitle: true,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true)),
      ),
      body: ValueListenableBuilder(
          valueListenable: box.listenable(),
          builder: (context, Box<Album> box, _) {
            data = box.getAt(index);
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: CachedNetworkImage(
                      imageUrl: data.thumbnailUrl,
                      imageBuilder: (context, imageProvider) => Container(
                        margin: EdgeInsets.only(
                            top: SizeConfig.heightMultiplier * 5),
                        height: SizeConfig.heightMultiplier * 25,
                        width: SizeConfig.widthMultiplier * 50,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,),
                        ),
                      ),
                      placeholder: (context, url) =>Container(
                        margin: EdgeInsets.only(
                            top: SizeConfig.heightMultiplier * 5),
                        height: SizeConfig.heightMultiplier * 25,
                        width: SizeConfig.widthMultiplier * 50,
                         child: LoadingWidget(),
                      ),

                      errorWidget: (context, url, error) =>Container(
                        margin: EdgeInsets.only(
                            top: SizeConfig.heightMultiplier * 5),
                        height: SizeConfig.heightMultiplier * 25,
                        width: SizeConfig.widthMultiplier * 50,
                        child: Icon(Icons.error),
                      ),
                    ),
                  ),
                  SizedBox(height: SizeConfig.heightMultiplier * 8),
                  Center(
                      child: Container(
                    child: Text(
                      data.title,
                      textAlign: TextAlign.center,
                      softWrap: true,
                      style: TextStyle(fontSize: SizeConfig.textMultiplier * 3),
                    ),
                  ))
                ],
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit, color: Colors.white),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditAlbumScreen(
                        index: index,
                        data: data,
                        edit: true,
                      )));
        },
      ),
    );
  }
}
