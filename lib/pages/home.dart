import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:kopidalar/pages/home/goods.dart';
import 'package:kopidalar/pages/home/profile.dart';
import 'package:kopidalar/pages/home/notification.dart';


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
    return Scaffold(
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
    );
  }
}