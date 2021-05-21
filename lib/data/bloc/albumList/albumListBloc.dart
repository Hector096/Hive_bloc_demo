import 'dart:async';
import 'package:Demo_Hive_with_Bloc/data/bloc/albumList/albumListEvent.dart';
import 'package:Demo_Hive_with_Bloc/data/bloc/albumList/albumListRepository.dart';
import 'package:Demo_Hive_with_Bloc/data/bloc/albumList/albumListState.dart';
import 'package:bloc/bloc.dart';


class AlbumListBloc extends Bloc<AlbumListEvent, AlbumListState> {
  final AlbumlistRepo repository = AlbumlistRepo();

  AlbumListBloc(AlbumListState initialState) : super(initialState);

  @override
  Stream<AlbumListState> mapEventToState(AlbumListEvent event) async* {
    if (event is FetchAlbumList) yield* _fetchList();
  }

  Stream<AlbumListState> _fetchList() async* {
    yield LoadingState();
    try {
      yield Success(await repository.fetchlist());
    } catch (e) {
      print(e.toString());
      yield LoadingFailure();
    }
  }
}