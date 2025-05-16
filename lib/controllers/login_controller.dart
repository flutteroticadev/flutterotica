import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutterotica/env/consts.dart';
import 'package:flutterotica/env/global.dart';
import 'package:flutterotica/models/token.dart';
import 'package:flutterotica/services/session_manager.dart';
import 'package:loggy/loggy.dart';
import 'package:overlay_support/overlay_support.dart';

class LoginController extends GetxController {
  final _username = ''.obs;
  final _password = ''.obs;
  final _token = Token().obs;
  final _loginState = LoginState.loading.obs;
  final _obscurePassword = true.obs;
  SessionManagerService sessionManager = SessionManagerService();

  String get username => _username.value;
  set username(String value) => _username.value = value;

  String get password => _password.value;
  set password(String value) => _password.value = value;

  Token get token => _token.value;
  set token(Token value) => _token.value = value;

  LoginState get loginState => _loginState.value;
  set loginState(LoginState value) => _loginState.value = value;

  bool get obscurePassword => _obscurePassword.value;
  set obscurePassword(bool value) => _obscurePassword.value = value;

  Future<bool> isTokenValid() async {
    final token = preferences.getString('token') ?? '';
    if (token.isEmpty) {
      return false;
    }

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    int timestamp = decodedToken['exp'];
    DateTime expdate = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    logInfo("token expires at $expdate");

    if (DateTime.now().isAfter(expdate.toLocal())) {
      // loginState = LoginState.loggedout;
      await refreshToken();
      logInfo("token expired");
      if (loginState == LoginState.loggedIn) {
        await listController.fetchLists();
        logInfo("token refreshed");
        return true;
      }

      logWarning("unable to refresh token");
      return false;
    }
    return true;
  }

  Future<Token> login() async {
    Token responseToken = await api.login(username, password);
    if (responseToken.token != null) {
      loginState = LoginState.loggedIn;
      token = responseToken;

      preferences.setString('token', token.token!);
      preferences.setString('username', username);
      preferences.setString('password', password);
      toast('Logged In!');

      await listController.fetchLists();
    } else {
      loginState = LoginState.failure;
    }

    return responseToken;
  }

  Future<void> refreshToken() async {
    Token responseToken = await api.fetchToken();
    if (responseToken.token != null) {
      await listController.fetchLists();
      loginState = LoginState.loggedIn;
      token = responseToken;

      preferences.setString('token', token.token!);
    } else {
      loginState = LoginState.failure;
    }
  }

  Future<void> logout() async {
    await api.logout();
  }
}
