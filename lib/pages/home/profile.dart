import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:kopidalar/pages/splash/splash.dart';
import 'package:kopidalar/util/session_util.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<ProfilePage>{
  String _userID = "";

  _ProfileState() {
    getUserLogin().then((val) => setState(() {
          _userID = val;
        }));
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
        title: new Text(
          'Profile',
          style: new TextStyle(
            fontWeight: FontWeight.bold,
            foreground: Paint()..shader = _linearGradientTtile,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: new Padding(
        padding: const EdgeInsets.only(
          top: 10.0, 
          left: 12.0, 
          right: 12.0,
        ),
        child: new Center(
          child: new Column(
            children: <Widget>[
              new Expanded(
                child: new StreamBuilder(
                  stream: Firestore.instance.collection('users').where("auth_uid", isEqualTo: _userID).snapshots(),
                  builder: (context, snapshot){
                    if(!snapshot.hasData) return new Center(child: new CircularProgressIndicator());
                    return ListView.builder(
                      itemCount: 1,
                      itemBuilder: (context, index) =>
                        _buildProfile(context, snapshot.data.documents[index]),
                    );
                  }
                ),
              ),
            ]
          ),
        ),
      ),
    );
  }

  
  Widget _buildProfile(BuildContext context, DocumentSnapshot document){
    Widget _imageLoad(){
      if(document['profile_pic_url'] == ""){
        return new Image.asset(
          'assets/graphics/user/anonymous.jpg',
        );
      }
      else{
        return new FadeInImage(
          image: NetworkImage(document['profile_pic_url']),
          placeholder: AssetImage('assets/graphics/user/anonymous.jpg'),
          fadeInDuration: Duration(milliseconds: 100),
          fadeOutDuration: Duration(milliseconds: 100),
        );
      }
    }
    return ListTile(
      title: Column(
        children: <Widget> [
          new Container(
            width: 150.0,
            padding: const EdgeInsets.only(
              top: 10.0, 
              bottom: 20.0, 
            ),
            child: new ClipRRect(
              borderRadius: new BorderRadius.circular(100.0),
              child: _imageLoad(),
            ),
          ),
          new Text(
            document['fullname'],
            style: new TextStyle(
              fontSize: 24.0, 
              fontWeight: FontWeight.bold,
              color: Colors.brown,
            ),
          ),
          new Container(
            margin: const EdgeInsets.all(
              10.0,
            ),
            child: new SizedBox(
              width: 255.0,
              child: RaisedButton(
                onPressed: signOut,
                padding: EdgeInsets.all(13.0),
                color: Colors.white,
                child: Text(
                  'Sign Out',
                  style: new TextStyle(
                    fontSize: 16.0, 
                    color: Colors.brown,
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
    );
  }

  Future<void> signOut(){
    try{
      removeUserLogin();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SplashPage()));
    }
    catch(e){
      print(e);
    }
  }
}