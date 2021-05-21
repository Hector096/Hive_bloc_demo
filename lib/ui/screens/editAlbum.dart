import 'package:Demo_Hive_with_Bloc/data/model/albumHiveModel.dart';
import 'package:Demo_Hive_with_Bloc/util/sizeConfig.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:hive/hive.dart';

class EditAlbumScreen extends StatefulWidget {
     Album data;
  final int index;
  bool edit;
  EditAlbumScreen({Key key, this.data,@required this.edit ,@required this.index}) : super(key: key);
  @override
  _EditAlbumScreenState createState() => _EditAlbumScreenState(index, data,edit);
}

class _EditAlbumScreenState extends State<EditAlbumScreen> {
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String url, title;
  Box<Album> box;
  bool edit;
  Album data;
  final int index;
  _EditAlbumScreenState(this.index, this.data,this.edit);

  @override
  void initState() {
    super.initState();
    box = Hive.box<Album>("album");
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: edit ? data != null ? Text("Id: ${data.id}"):Text(""):Text('New Album'),
        leading: IconButton(icon: Icon(Icons.arrow_back_ios,color: Colors.white,),onPressed: ()=>Navigator.pop(context)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              SizedBox(height: SizeConfig.heightMultiplier * 3),
              TextFormField(
                onSaved: (input) => url = input,
                validator: MultiValidator([
                  RequiredValidator(errorText: 'required'),
                  PatternValidator(r"(https?|http)://([-A-Z0-9.]+)?", errorText: "Invalid Url")
                ]),
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: edit ? "Image url":"Album Image Url"),
              ),
              SizedBox(height: SizeConfig.heightMultiplier * 6),
              TextFormField(
                  onSaved: (input) => title = input,
                  validator: RequiredValidator(errorText: 'required'),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: edit ?"Title":"Album Title"))
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check, color: Colors.white),
        onPressed: () {
          if (_formkey.currentState.validate()) {
            _formkey.currentState.save();
            if(edit){
              data.title = title;
              data.thumbnailUrl = url;
              box.putAt(index, data);
              data.updatedAt = DateTime.now();
            Navigator.pop(context);
              Flushbar(
                message: "Data updated!",
                duration: Duration(seconds: 2),
                backgroundColor: Colors.green,
              )..show(context);
            } else{
              int id = box.values.toList().length + 1;
              data = Album(url,title,id,1,url,DateTime.now(),null);
              box.add(data);
              Navigator.pop(context,true);
              Flushbar(
                message: "New Album is created!",
                duration: Duration(seconds: 2),
                backgroundColor: Colors.green,
              )..show(context);
            }        }
        },
      ),
    );
  }
}
