import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kopidalar/models/goods_model.dart';
import 'package:kopidalar/util/session_util.dart';

class CartPage extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

int _setState = 0;
List<Widget> v = [];
List<List<Goods>> allGoodsList = [];

class _CartState extends State<CartPage>{
  String _userID = "";
  String _prevUname;

  _CartState() {
    _setState = 0;
    getUserLogin().then((val) => setState(() {
          _userID = val;
        }
      )
    );
    Cart.orders.sort((a, b) => a.name.compareTo(b.name));
    Cart.orders.sort((a, b) => a.uname.compareTo(b.uname));
    
    v = [];
    allGoodsList = [];
    List<Goods> goodsList = [];
    for (int index = 0; index < Cart.orders.length; index++){
      goodsList.add(Cart.orders[index]);
      if(index + 1 < Cart.orders.length){
        if(Cart.orders[index].id != Cart.orders[index+1].id){
          allGoodsList.add(goodsList);
          goodsList = [];
        }
      }
      else if(index + 1 == Cart.orders.length){
        allGoodsList.add(goodsList);
        goodsList = [];
      }
    }

    for (List<Goods> x in allGoodsList){
      if(x[0].uname != _prevUname){
        addTitleToCartViewList(x[0].uname);
      }
      else{
        v.add(new Divider());
      }
      addToCartViewList(x[0].name, x[0].img_url, x[0].price.toString(), x[0].uname, x.length.toString());
      _prevUname = x[0].uname;
    }
  }

  @override
    Widget build(BuildContext context){
      return new Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.brown, //change your color here
          ),
          title: new Text(
            'Cart',
            style: new TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.brown,
            ),
          ),
          backgroundColor: Colors.white,
        ),
        body: Container(
          padding: const EdgeInsets.only(
            left: 12.0, 
            right: 12.0,
          ),
          color: Colors.grey[50],
          child: new Stack(
            children: [
              new Center(
                child: new Column(
                  children: <Widget>[
                    new Expanded(
                      child: ListView(
                        children: v,
                      ),
                    ),
                  ],
                ),
              ),
              _checkout(context),
            ],
          ),
        ),
      );
    }

  Widget _checkout(BuildContext context){
    Widget  _isLoading(){
      if(_setState == 0){
        return new Text(
          'Checkout',
          style: new TextStyle(
            fontSize: 16.0, 
            color: Colors.white
          ),
        );
      }
      else{
        return new SizedBox(
          height: 20.0,
          width: 20.0,
          child: new CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        );
      }
    }

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
              left: 10.0,
              right: 25.0,
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
                      setState(() {
                        _setState = 1;
                      });
                      saveCart();
                    },
                    padding: EdgeInsets.all(15.0),
                    color: Colors.yellow[900],
                    child: _isLoading(),
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

  void addTitleToCartViewList(String name){
    v.add(
      new Container(
        padding: const EdgeInsets.only(
          top: 25.0,
        ),
        child: new Text(
          'Ordered from ' + name,
          style: new TextStyle(
            color: Colors.brown,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
    v.add(new Divider(
      color: Colors.grey,
    ));
  }

  void addToCartViewList(String name, String imgUrl, String price, String uname, String itemCount){
    v.add(
      new ListTile(
        leading: Container(
          child: new ClipRRect(
            borderRadius: new BorderRadius.circular(10.0),
            child: FadeInImage(
              image: NetworkImage(imgUrl),
              placeholder: AssetImage('assets/graphics/user/anonymous.jpg'),
              fadeInDuration: Duration(milliseconds: 100),
              fadeOutDuration: Duration(milliseconds: 100),
            ),
          ),
        ),
        title: new Text(
          name,
          style: new TextStyle(
            color: Colors.brown,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: new Text('Rp. ' + price),
        trailing: new Text(
          "x" + itemCount,
          style: new TextStyle(color: Colors.lightBlue),
          textScaleFactor: 1.2,
        ),
      ),
    );
  }

  void saveCart() async{
    final databaseReference = Firestore.instance;
    final FirebaseMessaging _fcm = FirebaseMessaging();

    DocumentSnapshot buyer = await getUserByAuthUID(_userID);
    DocumentReference transaction;
    DocumentSnapshot seller;
    String prevUname;

    allGoodsList = [];
    List<Goods> goodsList = [];
    for (int index = 0; index < Cart.orders.length; index++){
      goodsList.add(Cart.orders[index]);
      if(index + 1 < Cart.orders.length){
        if(Cart.orders[index].id != Cart.orders[index+1].id){
          allGoodsList.add(goodsList);
          goodsList = [];
        }
      }
      else if(index + 1 == Cart.orders.length){
        allGoodsList.add(goodsList);
        goodsList = [];
      }
    }

    for (List<Goods> x in allGoodsList){
      if(x[0].uname != prevUname){
        transaction = await databaseReference.collection("transactions")
          .add({
            'time': DateTime.now(),
          }
        );
        seller = await getUserByAuthUID(x[0].uid);

        await databaseReference.collection("transactions").document(transaction.documentID).collection("buyer")
          .add({
            'auth_uid': buyer['auth_uid'],
            'name': buyer['fullname'],
            'phone': buyer['phone'],
          }
        );

        await databaseReference.collection("transactions").document(transaction.documentID).collection("seller")
          .add({
            'auth_uid': seller['auth_uid'],
            'name': seller['fullname'],
            'phone': seller['phone'],
          }
        );

        await databaseReference.collection("notifications")
          .add({
            'auth_uid': seller['auth_uid'],
            'message': 'You have a pending order',
            'time':  DateTime.now(),
            'transaction_id': transaction.documentID,
            'notification_type': 'seller',
          }
        );

        await databaseReference.collection("notifications")
          .add({
            'auth_uid': buyer['auth_uid'],
            'message': 'Your order is being processed',
            'time':  DateTime.now(),
            'transaction_id': transaction.documentID,
            'notification_type': 'buyer',
          }
        );

        _fcm.configure(
          onMessage: (Map<String, dynamic> message) async{
            print("onMessage:${message}");

            final snackbar = SnackBar(
              content: Text(''),
              action: SnackBarAction(
                label: 'Go',
                onPressed: (){},
              ),
            );

            Scaffold.of(context).showSnackBar(snackbar);
          },
          onResume: (Map<String, dynamic> message) async{
            print("onResume:${message}");
          },
          onLaunch: (Map<String, dynamic> message) async{
            print("onLaunch:${message}");
          },
        );
      }
      
      await databaseReference.collection("transactions").document(transaction.documentID).collection("item")
        .add({
          'id': x[0].id,
          'name': x[0].name,
          'price': x[0].price,
          'img_url': x[0].img_url,
          'qty': x.length,
        }
      );

      prevUname = x[0].uname;
    }

    Cart.orders = [];
    Navigator.pop(context, 'success');
  }
}