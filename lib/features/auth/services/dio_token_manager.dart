import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenManager extends Interceptor {
  static final TokenManager _instance = TokenManager._internal();

  static TokenManager get instance => _instance;
  TokenManager._internal();

  String? _token;
  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    if (response.statusCode == 200) {
      var data = Map<String, dynamic>.from(response.data);
      if (data['access_token'] != null) {
        saveToken(data['access_token']);
      } else if (response.statusCode == 401) {}
    }
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    options.headers['Token'] = _token;
    return super.onRequest(options, handler);
  }

  Future<void> initToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('x-auth-token');
  }

  void saveToken(String newToken) async {
    if (_token != newToken) {
      _token = newToken;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('x-auth-token', _token!);
    }
  }
}
