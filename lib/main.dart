import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:upstreet_flutter_code_challenge/data/model/albumHiveModel.dart';
import 'package:upstreet_flutter_code_challenge/ui/screens/albumList.dart';
import 'package:upstreet_flutter_code_challenge/util/sizeConfig.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Directory directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(AlbumAdapter());
  await Hive.openBox<Album>("album");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        SizeConfig().init(constraints, orientation);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Upstreet Flutter code challenge',
          theme: ThemeData(
            primaryColor: const Color(0xff01046d),
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: const AlbumList(),
        );
      });
    });
  }
}