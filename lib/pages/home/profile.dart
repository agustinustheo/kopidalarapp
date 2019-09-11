import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:kopidalar/pages/home/goods/addGoods.dart';
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
              new Container(
                child: new StreamBuilder(
                  stream: Firestore.instance.collection('users').where("auth_uid", isEqualTo: _userID).snapshots(),
                  builder: (context, snapshot){
                    if(!snapshot.hasData) return new Container();
                    return _buildProfile(context, snapshot.data.documents[0]);
                  }
                ),
              ),
              new Expanded(
                child: new StreamBuilder(
                  stream: Firestore.instance.collection('goods').where("uid", isEqualTo: _userID).snapshots(),
                  builder: (context, snapshot){
                    if(!snapshot.hasData) return new Center(child: new CircularProgressIndicator());
                    return ListView.separated(
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) =>
                        _buildListItem(context, snapshot.data.documents[index]),
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
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
    return Container(
      child: Column(
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
            margin: const EdgeInsets.only(
              top: 10.0,
              bottom: 25.0,
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
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Text(
                'Your Items',
                style: new TextStyle(
                  color: Colors.brown,
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              new SizedBox(
                width: 100.0,
                child: RaisedButton(
                  onPressed: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => AddGoodsPage())
                    );
                  },
                  padding: EdgeInsets.all(10.0),
                  color: Colors.yellow[900],
                  child: Text(
                    'Add Item',
                    style: new TextStyle(
                      fontSize: 14.0, 
                      color: Colors.white
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(25.0)
                  ),
                ),
              ),
            ],
          ),
          new Divider(
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
    
  Widget _buildListItem(BuildContext context, DocumentSnapshot document){if(
      document != null && document['name'] != null &&
      document['uname'] != null && document['price'] != null &&
      document['img_url'] != null
    )
    {
      return ListTile(
        title: Row(
          children: <Widget>[
            GestureDetector(
              child: Container(
                width: 75.0,
                padding: const EdgeInsets.only(
                  top: 10.0, 
                  bottom: 20.0, 
                  right: 10.0,
                ),
                child: new ClipRRect(
                  borderRadius: new BorderRadius.circular(10.0),
                  child: FadeInImage(
                    image: NetworkImage(document['img_url']),
                    placeholder: AssetImage('assets/graphics/user/anonymous.jpg'),
                    fadeInDuration: Duration(milliseconds: 100),
                    fadeOutDuration: Duration(milliseconds: 100),
                  ),
                ),
              ),
              onTap: (){
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Form(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              width: 250.0,
                              padding: const EdgeInsets.only(
                                top: 8.0, 
                              ),
                              child: document['img_url'] != '' ? Image.network(document['img_url']) : Container(),
                            ),
                            Text(
                              document['name'],
                              style: new TextStyle(
                                fontSize: 24.0, 
                                fontWeight: FontWeight.bold,
                                color: Colors.brown,
                              ),
                            ),
                            Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[

                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 8.0
                                  ),
                                  child: RaisedButton(
                                    onPressed: (){
                                      Navigator.pop(context, false);
                                    },
                                    padding: EdgeInsets.all(13.0),
                                    color: Colors.white,
                                    child: Text(
                                      'Close',
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
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                );
              },
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Text(
                    document['name'],
                    style: new TextStyle(
                      fontSize: 24.0, 
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                ),
                Text(
                  'Rp. ' + document['price'].toString(),
                  style: new TextStyle(
                    fontSize: 14.0, 
                    color: Colors.grey
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
    else{
      return new Padding(
        padding: const EdgeInsets.only(
          top: 15.0,
          bottom: 15.0
        ),
        child: new Container(
          child: new Center(
            child: new CircularProgressIndicator()
          ),
        ),
      );
    }
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