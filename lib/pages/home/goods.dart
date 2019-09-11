import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kopidalar/models/order_model.dart';
import 'package:kopidalar/pages/home/checkout/cart.dart';
import 'package:kopidalar/util/session_util.dart';
import 'package:kopidalar/models/goods_model.dart';

class GoodsPage extends StatefulWidget {
  @override
  _GoodsState createState() => _GoodsState();
}

class _GoodsState extends State<GoodsPage>{
  String _userID = "";
  bool _cartIsNotEmpty = false;
  final orders = OrdersModel();

  _GoodsState() {
    getUserLogin().then((val) => setState(() {
          _userID = val;
        }
      )
    );
    if(Cart.orders != null){
      _cartIsNotEmpty = true;
      orders.addToList(Cart.orders);
    }
  }

  @override
    Widget build(BuildContext context){
      return Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: 25.0, 
              left: 12.0, 
              right: 12.0,
              bottom: (_cartIsNotEmpty == true ? 50.0 : 0.0)
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
          ),
          _showCart(context),
        ],
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
                if(Cart.orders.length == 0){
                  _cartIsNotEmpty = false;
                }
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
                    document['name'].length > 11 ? document['name'].substring(0, 8) + '...' : document['name'],
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
                      _cartIsNotEmpty = true;
                      orders.add(_goods);
                      Cart.orders = orders.goodsList;
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

  Widget _showCart(BuildContext context){
      if(Cart.orders != null){
        if(Cart.orders.length > 0){
          int totalPrice = 0;
          Cart.orders.forEach((value) {
            totalPrice += value.price;
          });
          return new Positioned(
            bottom: 0.0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(
                top: 15.0,
                bottom: 15.0,
                left: 20.0,
                right: 15.0,
              ),
              color: Colors.grey[50],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Material(
                        child: Text(
                          'Total',
                          style: new TextStyle(
                            fontSize: 16.0, 
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Material(
                        child: Text(
                          'Rp. ' + totalPrice.toString(),
                          style: new TextStyle(
                            fontSize: 22.0, 
                            color: Colors.brown,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 150.0,
                    child: RaisedButton(
                      onPressed: (){
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => CartPage())
                        )
                        .then(
                          (result){
                            if(result == 'success'){
                              orders.removeAllFromList();
                            }
                          }
                        );
                      },
                      padding: EdgeInsets.all(15.0),
                      color: Colors.yellow[900],
                      child: Text(
                        'View Cart',
                        style: new TextStyle(
                          fontSize: 16.0, 
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
            ),
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
}