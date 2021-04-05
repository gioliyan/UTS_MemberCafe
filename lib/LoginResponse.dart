import 'sqlite/itemcard.dart';
import 'LoginRequest.dart';

abstract class LoginCallBack {
  void onLoginSuccess(ItemCard login);
  void onLoginError(String error);
}

class LoginResponse {
  LoginCallBack _callBack;
  LoginRequest loginRequest = new LoginRequest();
  LoginResponse(this._callBack);

  //logic login
  doLogin(String username, String password) {
    loginRequest
        .getLogin(username, password)
        .then((login) => _callBack.onLoginSuccess(login))
        .catchError((onError) => _callBack.onLoginError(onError.toString()));
  }
}
