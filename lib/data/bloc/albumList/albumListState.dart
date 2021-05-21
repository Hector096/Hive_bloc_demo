import 'package:equatable/equatable.dart';
import 'package:upstreet_flutter_code_challenge/data/model/albumHiveModel.dart';


abstract class AlbumListState extends Equatable {
  const AlbumListState();

  @override
  List<Object> get props => [];
}

class LoadingState extends AlbumListState {}

class Success extends AlbumListState {
  final List<Album> response;

  const Success([this.response]);

  @override
  List<Object> get props => [response];

  @override
  String toString() => 'Success { List: $response }';
}

class LoadingFailure extends AlbumListState {}
