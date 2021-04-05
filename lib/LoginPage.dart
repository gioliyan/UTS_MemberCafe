import 'package:uts_membercafe/sqlite/itemcard.dart';
import 'sqlite/dbhelper.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'LoginResponse.dart';
import 'entrycard.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> implements LoginCallBack {
  DbHelper dbHelper = DbHelper();
  bool _isLoading = false;
  BuildContext _ctx;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  LoginResponse _response;

  _LoginPageState() {
    _response = new LoginResponse(this);
  }

  void _submit() {
    final form = formKey.currentState;
    if (form.validate()) {
      setState(() {
        _isLoading = true;
        form.save();
        _response.doLogin(usernameController.text, passwordController.text);
      });
    }
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(text),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0, top: 150),
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 100),
              alignment: Alignment.center,
              child: Text("Login Admin",
                  style: TextStyle(fontSize: 50, color: Colors.brown)),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
              child: TextField(
                controller: usernameController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (value) {},
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
              child: TextField(
                controller: passwordController,
                obscureText: true,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (value) {},
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4),
              child: Material(
                shadowColor: Colors.lightBlueAccent.shade100,
                child: RaisedButton(
                  color: Colors.brown,
                  onPressed: _submit,
                  child: Text(
                    'Log In',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            FlatButton(
              child: Text(
                'Create an Account',
                style: TextStyle(color: Colors.black54),
              ),
              onPressed: () async {
                var login = await navigateToRegisterPage(context, null);
                if (login != null) {
                  int result = await dbHelper.insertcard(login);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<ItemCard> navigateToRegisterPage(
      BuildContext context, ItemCard login) async {
    var result = await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return EntryFormCard(login);
    }));
    return result;
  }

  @override
  void onLoginError(String error) {
    AlertDialog(
      content: new Text("Username atau Password Salah"),
    );
    _showSnackBar(error);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void onLoginSuccess(ItemCard login) async {
    if (login != null) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
    } else {
      AlertDialog(
        content: new Text("Username atau Password Salah"),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }
}
