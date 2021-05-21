import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:upstreet_flutter_code_challenge/ui/widgets/loadingWidget.dart';
import 'package:upstreet_flutter_code_challenge/data/bloc/albumList/albumListBloc.dart';
import 'package:upstreet_flutter_code_challenge/data/bloc/albumList/albumListEvent.dart';
import 'package:upstreet_flutter_code_challenge/data/bloc/albumList/albumListState.dart';
import 'package:upstreet_flutter_code_challenge/data/model/albumHiveModel.dart';
import 'package:upstreet_flutter_code_challenge/ui/screens/albumDetail.dart';
import 'package:upstreet_flutter_code_challenge/ui/screens/editAlbum.dart';
import 'package:upstreet_flutter_code_challenge/util/sizeConfig.dart';

class AlbumList extends StatefulWidget {
  const AlbumList();

  @override
  _AlbumListState createState() => _AlbumListState();
}

class _AlbumListState extends State<AlbumList> {
  bool loadingProgress = false;
  bool status = false;
  AlbumListBloc _bloc;
  List<Album> listData = List<Album>();

  @override
  void initState() {
    super.initState();
    _bloc = AlbumListBloc(LoadingState());
    _bloc.add(FetchAlbumList());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: const Text('Album List'),
        ),
        body: LoadingOverlay(
          isLoading: loadingProgress,
          progressIndicator: CircularProgressIndicator(),
          child: BlocListener<AlbumListBloc, AlbumListState>(
            cubit: _bloc,
            listener: (context, state) {
              if (state is LoadingState) {
                setState(() {
                  loadingProgress = true;
                });
              } else {
                setState(() {
                  loadingProgress = false;
                });
              }
              if (state is Success) {
                if (state.response.isNotEmpty) {
                  setState(() {
                    listData = state.response;
                  });
                } else {
                  Flushbar(
                    message: "Something Went Wrong..",
                    duration: Duration(seconds: 2),
                    backgroundColor: Colors.red,
                  )..show(context);
                }
              }
              if (state is LoadingFailure) {
                Flushbar(
                  message: "Something Went Wrong..",
                  duration: Duration(seconds: 2),
                  backgroundColor: Colors.red,
                )..show(context);
              }
            },
            child: listData.isNotEmpty ? _buildListWidget(listData) : Center(),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add, color: Colors.white),
          onPressed: () {
            Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditAlbumScreen(edit: false,index: null)))
                .then((value) {
              if (value) {
                _refresh();
              }
            });
          },
        ),
      ),
    );
  }

  Widget _buildListWidget(List<Album> data) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView.builder(
          itemCount: data.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
                height: SizeConfig.heightMultiplier * 15,
                width: double.maxFinite,
                child: Card(
                    elevation: 0,
                    child: Center(
                        child: ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AlbumDetailScreen(
                                            index: index,
                                            data: data[index],
                                          ))).then((value) {
                                if (value) {
                                  _refresh();
                                }
                              });
                            },
                            leading: CircleAvatar(
                              radius: SizeConfig.imageSizeMultiplier * 8,
                              child: CachedNetworkImage(
                                imageUrl: data[index].thumbnailUrl,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) => Container(
                                  child: LoadingWidget(),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  child: Icon(Icons.error),
                                ),
                              ),
                            ),
                            title: Text(data[index].title, softWrap: true)))));
          }),
    );
  }

  Future<Null> _refresh() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      _bloc.add(FetchAlbumList());
    });
  }
}
