import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:kopidalar/util/session_util.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationState createState() => _NotificationState();
}

class _NotificationState extends State<NotificationPage>{
  String _userID = "";

  _NotificationState() {
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
        80.0, 
        10.0
      )
    );

    return new Scaffold(
      appBar: AppBar(
        title: new Text(
          'Notifications',
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
        ),
        child: new Center(
          child: new Column(
            children: <Widget>[
              new Expanded(
                child: new StreamBuilder(
                  stream: Firestore.instance
                    .collection('notifications')
                    .where("auth_uid", isEqualTo: _userID)
                    .orderBy("time")
                    .snapshots(),
                  builder: (context, snapshot){
                    if(!snapshot.hasData) return new Center(child: new CircularProgressIndicator());
                    return ListView.separated(
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) =>
                        _buildNotifications(context, snapshot.data.documents[index]),
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                    );
                  }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  
  Widget _buildNotifications(BuildContext context, DocumentSnapshot document){
    return ListTile(
      title: Row(
        children: <Widget>[
          new Image.asset(
            'assets/graphics/kopidalar_logo.png',
            height: 60.0,
          ),
          new Expanded(
            child: new Padding(
              padding: const EdgeInsets.only(
                right: 20.0,
                left: 20.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Text(
                        document['message'],
                        style: new TextStyle(
                          fontSize: 16.0, 
                          fontWeight: FontWeight.bold,
                          color: Colors.brown
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'View transaction',
                    style: new TextStyle(
                      fontSize: 14.0, 
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}