import 'dart:async';
import 'sqlite/dbhelper.dart';
import 'sqlite/itemcard.dart';

class LoginRequest {
  DbHelper dbHelper = new DbHelper();
  Future<ItemCard> getLogin(String username, String password) {
    var result = dbHelper.getLogin(username, password);
    return result;
  }
}
