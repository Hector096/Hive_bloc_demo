import 'package:equatable/equatable.dart';

abstract class AlbumListEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchAlbumList extends AlbumListEvent {

  FetchAlbumList();

  @override
  List<Object> get props => [int];
}
