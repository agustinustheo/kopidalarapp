import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:kopidalar/pages/home/goods.dart';
import 'package:kopidalar/pages/home/profile.dart';
import 'package:kopidalar/pages/home/notification.dart';
import 'package:kopidalar/util/session_util.dart';


class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<HomePage> {
  int _selectedPage = 0;
  final _pageOptions = [
    GoodsPage(),
    NotificationPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context){
    return WillPopScope(
      onWillPop: () async{
        if(Cart.orders != null){
          if(Cart.orders.length > 0){
            showDialog<void>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(
                    'Are you sure?',
                    style: new TextStyle(
                      color: Colors.brown,
                    ),
                  ),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text(
                          'You have items in your cart!\nIf you exit now, items in your cart will be discarded.',
                          style: new TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text(
                        'No',
                        style: new TextStyle(
                          color: Colors.brown,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    FlatButton(
                      child: Text(
                        'Yes',
                        style: new TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      onPressed: () {
                        exit(0);
                      },
                    ),
                  ],
                );
              },
            );
          }
        }
        else{
          return true;
        }
      },
      child: Scaffold(
        body: _pageOptions[_selectedPage],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedPage, // this will be set when a new tab is tapped
          items: [
            BottomNavigationBarItem(
              icon: new Icon(Icons.free_breakfast),
              title: new Text('Food'),
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.notifications),
              title: new Text('Notifications'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('Profile')
            )
          ],
          onTap: (int index){
            setState(() {
              _selectedPage = index; 
            });
          },
        ),
      ),
    );
  }
}