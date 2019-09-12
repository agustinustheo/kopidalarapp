import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:kopidalar/pages/home/profile.dart';
import 'package:kopidalar/util/session_util.dart';

class AddGoodsPage extends StatefulWidget {
  @override
  _AddGoodsState createState() => _AddGoodsState();
}

class _AddGoodsState extends State<AddGoodsPage> with SingleTickerProviderStateMixin{
  String _userID = "";
  String _name, _price;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File _imageFile;

  _AddGoodsState() {
    getUserLogin().then((val) => setState(() {
          _userID = val;
        }
      )
    );
  }

  @override
  Widget build(BuildContext context){
    final Shader _linearGradientTtile = LinearGradient(
      colors: <Color>[
        Color(0xff422605), 
        Color(0xffb3671b),
      ],
    ).createShader(
      Rect.fromLTWH(
        0.0, 
        0.0, 
        60.0, 
        10.0
      )
    );

    return new Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.brown, //change your color here
        ),
        title: new Text(
          'Add Goods',
          style: new TextStyle(
            fontWeight: FontWeight.bold,
            foreground: Paint()..shader = _linearGradientTtile,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      resizeToAvoidBottomPadding: false,
      body: Form(
        key: _formKey,
        child: Align(
          child: Column(
            children: <Widget>[
              new GestureDetector(
                child: Container(
                  width: 100.0,
                  padding: const EdgeInsets.only(
                    top: 20.0,
                    bottom: 10.0, 
                  ),
                  child: new ClipRRect(
                    borderRadius: new BorderRadius.circular(20.0),
                    child: FadeInImage(
                      image: NetworkImage('https://www.povertyalliance.org/wp-content/uploads/2019/03/Portrait_Placeholder.png'),
                      placeholder: AssetImage('assets/graphics/user/anonymous.jpg'),
                      fadeInDuration: Duration(milliseconds: 100),
                      fadeOutDuration: Duration(milliseconds: 100),
                    ),
                  ),
                ),
                onTap: _pickImage,
              ),
              new Container(
                margin: const EdgeInsets.all(
                  5.0,
                ),
                child: new SizedBox(
                  width: 275.0,
                  child: TextFormField(
                    cursorColor: Colors.brown,
                    validator: (input){
                      if(input.isEmpty){
                        return 'Please type your item name';
                      }
                    },
                    onSaved: (input) => _name = input,
                    decoration: InputDecoration(
                      labelText: 'Item Name',
                      labelStyle: TextStyle(
                        color: Colors.brown,
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.brown,
                    ),
                  ),
                ),
              ),
              new Container(
                margin: const EdgeInsets.all(
                  10.0,
                ),
                child: new SizedBox(
                  width: 275.0,
                  child: TextFormField(
                    cursorColor: Colors.brown,
                    validator: (input){
                      if(input.isEmpty){
                        return 'Please provide your item price';
                      }
                      try{
                        int.parse(input);
                      }
                      catch(e){
                        return 'Price must be a number';
                      }
                    },
                    onSaved: (input) => _price = input,
                    decoration: InputDecoration(
                      labelText: 'Price',
                      labelStyle: TextStyle(
                        color: Colors.brown,
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.brown,
                    ),
                  ),
                ),
              ),
              new Container(
                margin: const EdgeInsets.all(
                  10.0,
                ),
                child: new SizedBox(
                  width: 255.0,
                  child: RaisedButton(
                    onPressed: saveGoodsRecord,
                    padding: EdgeInsets.all(13.0),
                    color: Colors.brown,
                    child: Text(
                      'Add New Goods',
                      style: new TextStyle(
                        fontSize: 16.0, 
                        color: Colors.white,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(25.0)
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async{
    File selected = await ImagePicker.pickImage(source: ImageSource.gallery);
    selected = await ImageCropper.cropImage(
      sourcePath: selected.path,
      toolbarColor: Colors.brown,
      toolbarWidgetColor: Colors.white,
      toolbarTitle: 'Crop Image'
    );

    setState(() {
     _imageFile = selected; 
    });
  }

  Future<void> saveGoodsRecord() async{
    final formState = _formKey.currentState;
    final databaseReference = Firestore.instance;

    if(formState.validate()){
      formState.save();

      try{
        DocumentSnapshot userData = await getUserByAuthUID(_userID);

        databaseReference.collection("goods")
          .add({
            'uname': userData['fullname'],
            'uid': _userID,
            'name': _name,
            'price': int.parse(_price),
            'img_url': "",
          }
        );
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfilePage()));
      }
      catch(e){
        print(e);
      }
    }
  }
}