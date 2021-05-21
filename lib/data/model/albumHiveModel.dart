
import 'package:hive/hive.dart';

part 'albumHiveModel.g.dart';

@HiveType(typeId: 0)
class Album{
  @HiveField(0)
   int albumId;
  @HiveField(1)
   int id;
  @HiveField(2)
   String title;
  @HiveField(3)
   String url;
  @HiveField(4)
   String thumbnailUrl;
  @HiveField(5)
   DateTime updatedAt;
  @HiveField(6)
  String error;
  Album(this.url,this.title,this.id,this.albumId,this.thumbnailUrl,this.updatedAt,this.error);


}