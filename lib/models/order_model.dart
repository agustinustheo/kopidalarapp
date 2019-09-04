import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:kopidalar/models/goods_model.dart';

class OrdersModel extends ChangeNotifier {
  /// Internal, private state of the cart.
  final List<Goods> goodsList = [];

  /// An unmodifiable view of the items in the cart.
  UnmodifiableListView<Goods> get getGoods => UnmodifiableListView(goodsList);

  /// The current total price of all items (assuming all items cost $42).
  int get totalPrice => goodsList.length * 42;

  /// Adds [Goods] to cart. This is the only way to add the cart from outside.
  void add(Goods goods) {
    goodsList.add(goods);
  }

  int findToDelete(Goods goods){
    int index = -1;
    goodsList.asMap().forEach((i, value){
      if(value.name == goods.name){
        index = i;
      }
    });
    return index;
  }

  /// Removes [Goods] to cart. This is the only way to remove the cart from outside.
  void remove(Goods goods) {
    int index = this.findToDelete(goods);
    if(index >= 0)
      goodsList.removeAt(index);
  }

  void addToList(List<Goods> goods){
    this.removeAllFromList();
    goods.forEach((value){
      goodsList.add(value);
    });
  }

  void removeAllFromList(){
    for(int i = goodsList.length - 1; i >= 0; i--){
      goodsList.removeAt(i);
    }
  }

  int itemLength(String searchedId){
    int count = 0;
    goodsList.forEach((value){
      if(value.id == searchedId)
        count++;
    });
    return count;
  }

  void printList(){
    goodsList.forEach((value){
      print(value.name);
    });
  }
}