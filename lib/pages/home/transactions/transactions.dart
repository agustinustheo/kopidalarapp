import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:kopidalar/util/session_util.dart';
import 'package:intl/intl.dart';

class TransactionPage extends StatefulWidget {
  final String transactionID, notificationType;

  TransactionPage({Key key, @required this.transactionID,  @required this.notificationType}) : super(key: key);
  
  @override
  _TransactionState createState() => _TransactionState();
}

List<Widget> v = [
  new Container(),
];
List<DocumentSnapshot> goodsList = [];
DocumentSnapshot user, transaction;

class _TransactionState extends State<TransactionPage>{
  String _userID = "";
  int _ready = 0;
  final date = new DateFormat('dd MMM yyyy, HH:mm');

  _TransactionState() {
    getUserLogin().then((value) => setState(() {
          _userID = value;

          DocumentReference transactionReference = Firestore.instance.collection('transactions').document(widget.transactionID);
          transactionReference.get().then(
            (val) => setState(() {
              transaction = val;
            })
          );
          print(widget.notificationType);
          if(widget.notificationType == 'buyer'){
            Query sellerQuery = Firestore.instance.collection('transactions').document(widget.transactionID).collection('seller');
            sellerQuery.getDocuments().then(
              (val) => setState(() {
                user = val.documents[0];
              })
            );
          }
          else{
            Query buyerQuery = Firestore.instance.collection('transactions').document(widget.transactionID).collection('buyer');
            buyerQuery.getDocuments().then(
              (val) => setState(() {
                user = val.documents[0];
              })
            );
          }
          Query goodsQuery = Firestore.instance.collection('transactions').document(widget.transactionID).collection('item');
          goodsQuery.getDocuments().then(
            (val) => setState(() {
              goodsList = [];
              for(DocumentSnapshot x in val.documents){
                goodsList.add(x);
              }
            })
          );
        }
      )
    );
  }

  @override
  Widget build(BuildContext context){
    Future.delayed(Duration (milliseconds: 750)).then((_) async{
      setState(() {
        _ready = 1;
      });
    });
    if(_ready == 1){
      return new Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.brown, //change your color here
          ),
          title: new Center(
            child: new Container(
              padding: EdgeInsets.only(
                right: 50.0,
              ),
              child: new Image.asset(
                  'assets/graphics/kopidalar_text_logo.png',
                  height: 55.0,
                ),
            ),
          ),
          backgroundColor: Colors.grey[50],
          elevation: 0.0,
        ),
        body: Container(
          padding: const EdgeInsets.only(
            left: 12.0, 
            right: 12.0,
          ),
          color: Colors.grey[50],
          child: _buildTransaction(),
        ),
      );
    }
    else{
      return new Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.brown, //change your color here
          ),
          title: new Center(
            child: new Container(
              padding: EdgeInsets.only(
                right: 50.0,
              ),
              child: new Image.asset(
                  'assets/graphics/kopidalar_text_logo.png',
                  height: 55.0,
                ),
            ),
          ),
          backgroundColor: Colors.grey[50],
          elevation: 0.0,
        ),
        body: new Center(child: new CircularProgressIndicator()),
      );
    }
  }

  Widget _buildTransaction(){
    if(user == null || transaction == null){
      return new Center(child: new CircularProgressIndicator());
    }
    else{
      addToList();
      return Container(
        child: new Stack(
          children: [
            new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Center(
                  child: new Column(
                    children: <Widget>[
                      new Container(
                        padding: EdgeInsets.only(
                          top: 40.0,
                          bottom: 10.0,
                        ),
                        child: Text(
                          'Order Success',
                          style: new TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown,
                          ),
                        ),
                      ),
                      new Container(
                        padding: EdgeInsets.only(
                          bottom: 10.0,
                        ),
                        child: Text(
                          (transaction == null ? '' : date.format(transaction['time'].toDate()).toString()),
                          style: new TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      new Divider(),
                    ],
                  ),
                ),
                new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                      padding: EdgeInsets.only(
                        top: 15.0,
                        left: 2.0,
                        right: 2.0,
                        bottom: 2.0,
                      ),
                      child: Text(
                        (widget.notificationType == 'buyer' ? 'Seller' : 'Buyer'),
                        style: new TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    new Container(
                      padding: EdgeInsets.all(
                        2.0
                      ),
                      child: Text(
                        (user == null ? '' : user['name']),
                        style: new TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown,
                        ),
                      ),
                    ),
                    new Container(
                      padding: EdgeInsets.only(
                        top: 15.0,
                        left: 2.0,
                        right: 2.0,
                        bottom: 2.0,
                      ),
                      child: Text(
                        ('Phone'),
                        style: new TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    new Container(
                      padding: EdgeInsets.all(
                        2.0
                      ),
                      child: Text(
                        (user == null ? '' : user['phone']),
                        style: new TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown,
                        ),
                      ),
                    ),
                    new Container(
                      padding: EdgeInsets.only(
                        top: 15.0,
                        left: 2.0,
                        right: 2.0,
                        bottom: 2.0,
                      ),
                      child: Text(
                        'Transaction ID',
                        style: new TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    new Container(
                      padding: EdgeInsets.all(
                        2.0
                      ),
                      child: Text(
                        (transaction == null ? '' : '#ID' + transaction.documentID.toUpperCase()),
                        style: new TextStyle(
                          fontSize: 16.0,
                          color: Colors.brown,
                        ),
                      ),
                    ),
                  ],
                ),
                new Container(
                  padding: EdgeInsets.only(
                    top: 20.0,
                    bottom: 10.0
                  ),
                  child: new Text(
                    'Goods List',
                    style: new TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
                new Expanded(
                  child: new ListView(
                    children: v
                  ),
                ),
              ],
            ),
            _total(context),
          ],
        ),
      );
    }
  }


  Widget _total(BuildContext context){
    if(goodsList != []){
      if(goodsList.length > 0){
        int totalPrice = 0;
        goodsList.forEach((value) {
          totalPrice += value['price'] * value['qty'];
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
                      Navigator.pop(context);
                    },
                    padding: EdgeInsets.all(15.0),
                    color: Colors.yellow[900],
                    child: Text(
                      'Close',
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

  void addToList(){
    v = [];
    for(DocumentSnapshot goods in goodsList){
      v.add(
        new ListTile(
          leading: Container(
            child: new ClipRRect(
              borderRadius: new BorderRadius.circular(10.0),
              child: FadeInImage(
                image: NetworkImage(goods['img_url']),
                placeholder: AssetImage('assets/graphics/user/anonymous.jpg'),
                fadeInDuration: Duration(milliseconds: 100),
                fadeOutDuration: Duration(milliseconds: 100),
              ),
            ),
          ),
          title: new Text(
            goods['name'],
            style: new TextStyle(
              color: Colors.brown,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: new Text('@Rp. ' + goods['price'].toString()),
          trailing: new Text(
            "x" + goods['qty'].toString(),
            style: new TextStyle(color: Colors.lightBlue),
            textScaleFactor: 1.2,
          ),
        ),
      );
    }
  }
}