import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:kopidalar/pages/home.dart';
import 'package:kopidalar/util/session_util.dart';

class RegisterUserPage extends StatefulWidget {
  @override
  _RegisterUserState createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUserPage>{
  String _userID = "";
  String _username, _fullname, _phone;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _RegisterUserState() {
    getUserLogin().then((val) => setState(() {
          _userID = val;
        }));
  }

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Form(
        key: _formKey,
        child: Align(
          alignment: Alignment.center,
          child: new ListView(
            children: <Widget>[
              new Column(
                children: <Widget>[
                  new Container(
                    padding: EdgeInsets.only(
                      top: 30.0,
                      bottom: 10.0,
                    ),
                    child: new Text(
                      'Create Profile',
                      style: new TextStyle(
                        color: Colors.brown,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    alignment: Alignment(-0.5, 0.0),
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
                            return 'Please type a username';
                          }
                        },
                        onSaved: (input) => _username = input,
                        decoration: InputDecoration(
                          labelText: 'Username',
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
                            return 'Please type your fullname';
                          }
                        },
                        onSaved: (input) => _fullname = input,
                        decoration: InputDecoration(
                          labelText: 'Fullname',
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
                          RegExp regExp = new RegExp(
                            r"^\+?([ -]?\d+)+|\(\d+\)([ -]\d+)",
                            caseSensitive: false,
                            multiLine: false,
                          );
                          if(input.isEmpty){
                            return 'Please provide your phone number';
                          }
                          else if(input.length < 8){
                            return 'A phone number must be more than 7 characters';
                          }
                          else if(!regExp.hasMatch(input)){
                            return 'Phone number is not valid';
                          }
                        },
                        onSaved: (input) => _phone = input,
                        decoration: InputDecoration(
                          labelText: 'Phone',
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
                        onPressed: saveUserRecord,
                        padding: EdgeInsets.all(13.0),
                        color: Colors.brown,
                        child: Text(
                          'Save Profile',
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
            ],
          ),
        ),
      ),
    );
  }

  Future<void> saveUserRecord() async{
    final formState = _formKey.currentState;
    final databaseReference = Firestore.instance;

    if(formState.validate()){
      formState.save();

      try{
        Query userData = Firestore.instance.collection('users').where("username", isEqualTo: _username);
        QuerySnapshot userDataSnapshot = await userData.getDocuments();
        if(userDataSnapshot.documents.isEmpty){
          databaseReference.collection("users")
            .add({
              'auth_uid': _userID,
              'username': _username,
              'fullname': _fullname,
              'phone': _phone,
              'profile_pic_url': "",
            }
          );
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
        }
        else{
          return showDialog<void>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  'Error',
                  style: new TextStyle(
                    color: Colors.red[600],
                  ),
                ),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text('Username has been used!\nPlease enter another one.'),
                    ],
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text(
                      'Close',
                      style: new TextStyle(
                        color: Colors.red[600],
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      }
      catch(e){
        print(e);
      }
    }
  }
}