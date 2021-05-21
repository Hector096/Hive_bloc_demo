

class AlbumModel {
  AlbumModel({
    this.albumId,
    this.id,
    this.title,
    this.url,
    this.thumbnailUrl,
  });

  int albumId;
  int id;
  String title;
  String url;
  String thumbnailUrl;

  factory AlbumModel.fromJson(Map<String, dynamic> json) => AlbumModel(
    albumId: json["albumId"] == null ? null : json["albumId"],
    id: json["id"] == null ? null : json["id"],
    title: json["title"] == null ? null : json["title"],
    url: json["url"] == null ? null : json["url"],
    thumbnailUrl: json["thumbnailUrl"] == null ? null : json["thumbnailUrl"],
  );

  Map<String, dynamic> toJson() => {
    "albumId": albumId == null ? null : albumId,
    "id": id == null ? null : id,
    "title": title == null ? null : title,
    "url": url == null ? null : url,
    "thumbnailUrl": thumbnailUrl == null ? null : thumbnailUrl,
  };
}


class AlbumModelResponse {

  final List<AlbumModel> list;
  final String error;

  AlbumModelResponse({this.list,this.error});

  factory AlbumModelResponse.fromJson(List<dynamic> parsedJson) {

    List<AlbumModel> list = new List<AlbumModel>();
    list = parsedJson.map((i)=>AlbumModel.fromJson(i)).toList();
    return new AlbumModelResponse(
      list: list,
    );
  }


}
