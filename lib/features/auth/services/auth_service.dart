import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:amazon_clone_tutorial/models/user.dart';
import 'package:amazon_clone_tutorial/constants/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:amazon_clone_tutorial/providers/user_provider.dart';
import 'package:amazon_clone_tutorial/constants/error_handling.dart';
import 'package:amazon_clone_tutorial/constants/global_variables.dart';
import 'package:amazon_clone_tutorial/features/home/screens/home_screen.dart';

// import 'package:http/http.dart' as http;
class AuthService {
  // Sign up user

  void signUpUser(
      {required BuildContext context,
      required String username,
      required String password,
      required String name}) async {
    try {
      User user = User(
          id: "",
          name: name,
          username: username,
          password: password,
          address: "",
          status: "",
          access_token: "");

      var res = await GlobalVariables.dio
          .post('$uri/api/signup', data: user.toJson());

      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context,
              'Account has been created login with the same credentials');
        },
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      showSnackBar(context, e.toString());
    }
  }

  // Sign In user
  void signInUser(
      {required BuildContext context,
      required String username,
      required String password}) async {
    try {
      final body = FormData.fromMap({
        "username": username,
        "password": password,
      });

      var res = await GlobalVariables.dio.post('$uri/token', data: body);

      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          // ignore: use_build_context_synchronously
          Provider.of<UserProvider>(context, listen: false)
              .setUser(jsonEncode(res.data));
          await prefs.setString('x-auth-token', res.data['access_token']);
          // ignore: use_build_context_synchronously
          Navigator.pushNamedAndRemoveUntil(
            context,
            HomeScreen.routeName,
            (route) => false,
          );
        },
      );
    } catch (e) {
      // print('Error during sign-in: $e');
      // ignore: use_build_context_synchronously
      showSnackBar(context, e.toString());
    }
  }

  // get User Data In user

  void getUserData(
    BuildContext context,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? storedToken = prefs.getString('x-auth-token');

      if (storedToken == null || storedToken.isEmpty) {
        // ignore: use_build_context_synchronously
        showSnackBar(context, 'Token is missing or invalid');
        prefs.setString('x-auth-token', '');
      }

      Response res = await GlobalVariables.dio.get('$uri/users/me',
          options: Options(headers: {'Authorization': 'Bearer $storedToken'}));

      // Check if the request was successful

      // ignore: use_build_context_synchronously
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            String backendToken = res.headers.map['authorization']?.first ?? '';
            if (kDebugMode) {
              print(backendToken);
            }
          });
    } catch (e) {
      // print('Error during sign-in: $e');
      // ignore: use_build_context_synchronously
      showSnackBar(context, e.toString());
    }
  }
}
