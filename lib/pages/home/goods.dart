import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kopidalar/models/order_model.dart';
import 'package:kopidalar/util/session_util.dart';
import 'package:kopidalar/models/goods_model.dart';

class GoodsPage extends StatefulWidget {
  @override
  _GoodsState createState() => _GoodsState();
}

class _GoodsState extends State<GoodsPage>{
  String _userID = "";
  final orders = OrdersModel();

  _GoodsState() {
    getUserLogin().then((val) => setState(() {
          _userID = val;
        }
      )
    );
    if(Cart.orders != null){
      orders.addToList(Cart.orders);
    }
  }

  @override
    Widget build(BuildContext context){
      return new Padding(
        padding: const EdgeInsets.only(
          top: 25.0, 
          left: 12.0, 
          right: 12.0,
        ),
        child: new Center(
          child: new Column(
            children: <Widget>[
              new Container(
                child: new Image.asset(
                    'assets/graphics/kopidalar_text_logo.png',
                    height: 60.0,
                  ),
                  alignment: Alignment(-0.9, 0.0),
              ),
              new Divider(
                color: Colors.grey,
              ),
              new Expanded(
                child: new StreamBuilder(
                  stream: Firestore.instance.collection('goods').snapshots(),
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
      );
    }
    
  Widget _buildListItem(BuildContext context, DocumentSnapshot document){
    Goods _goods = Goods(document.documentID, document['name'], document['price'], document['img_url'], document['uid'], document['uname']);

    Widget _buildQuantityText(){
      if(Cart.orders != null){
        if(orders.itemLength(document.documentID) > 0){
          return new Text(
            orders.itemLength(document.documentID).toString(),
            style: new TextStyle(
              fontSize: 22.0, 
              fontWeight: FontWeight.bold,
              color: Colors.brown,
            ),
            textAlign: TextAlign.center,
          );
        }
        else{
          return new Container();
        }
      }
      else{
        return new Container();
      }
    }

    Widget _buildMinButton(){
      if(Cart.orders != null){
        if(orders.itemLength(document.documentID) > 0){
          return new RawMaterialButton(
            shape: new CircleBorder(),
            fillColor: Colors.white,
            child: Text(
              '-',
              style: new TextStyle(
                fontSize: 22.0, 
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            onPressed: () => {
              setState(() {
                orders.remove(_goods);
                Cart.orders = orders.goodsList;
              })
            },
          );
        }
        else{
          return new Container();
        }
      }
      else{
        return new Container();
      }
    }

    if(
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
                child: FadeInImage(
                  image: NetworkImage(document['img_url']),
                  placeholder: AssetImage('assets/graphics/user/anonymous.jpg'),
                  fadeInDuration: Duration(milliseconds: 100),
                  fadeOutDuration: Duration(milliseconds: 100),
                ),
              ),
              onTap: (){
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Form(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                      // createRecord(document);
                                      orders.add(_goods);
                                      Navigator.pop(context, false);
                                    },
                                    padding: EdgeInsets.all(13.0),
                                    color: Colors.white,
                                    child: Text(
                                      'Buy',
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
        trailing: new Container(
          width: 120.0,
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                width: 30.0,
                height: 30.0,
                child: _buildMinButton()
              ),
              Container(
                padding: const EdgeInsets.only(
                  left: 10.0, 
                  right: 10.0,
                ),
                height: 30.0,
                child: _buildQuantityText()
              ),
              Container(
                width: 30.0,
                height: 30.0,
                
                child: new RawMaterialButton(
                  shape: new CircleBorder(),
                  fillColor: Colors.brown,
                  child: Text(
                    '+',
                    style: new TextStyle(
                      fontSize: 25.0, 
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () => {
                    setState(() {
                      orders.add(_goods);
                      Cart.orders = orders.goodsList;
                      for(int i = Cart.orders.length - 1; i >= 0; i--){
                        print(Cart.orders[i].name);
                      }
                    }),
                  },
                ),
              ),
            ],
          ),
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

  void createRecord(DocumentSnapshot document) async{
    final databaseReference = Firestore.instance;
    
    DocumentReference transaction = await databaseReference.collection("transactions")
      .add({
        'time': DateTime.now(),
      }
    );

    DocumentSnapshot buyer = await getUserByAuthUID(_userID);
    DocumentSnapshot seller = await getUserByAuthUID(document['uid']);
    DocumentSnapshot item = await getGoodsByAuthUID(document['uid']);

    databaseReference.collection("transactions").document(transaction.documentID).collection("buyer")
      .add({
        'auth_uid': buyer['auth_uid'],
        'name': buyer['fullname'],
        'phone': buyer['phone'],
      }
    );

    databaseReference.collection("transactions").document(transaction.documentID).collection("seller")
      .add({
        'auth_uid': seller['auth_uid'],
        'name': seller['fullname'],
        'phone': seller['phone'],
      }
    );
    
    databaseReference.collection("transactions").document(transaction.documentID).collection("item")
      .add({
        'id': item.documentID,
        'name': item['name'],
        'price': item['price'],
        'qty': '2',
      }
    );
    
    databaseReference.collection("notifications")
      .add({
        'auth_uid': seller['auth_uid'],
        'message': 'You have a pending order',
        'time':  DateTime.now(),
        'transaction_id': transaction.documentID,
      }
    );

    databaseReference.collection("notifications")
      .add({
        'auth_uid': buyer['auth_uid'],
        'message': 'Your order is being processed',
        'time':  DateTime.now(),
        'transaction_id': transaction.documentID,
      }
    );
  }
}