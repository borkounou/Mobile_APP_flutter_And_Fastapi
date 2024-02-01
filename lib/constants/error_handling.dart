import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:amazon_clone_tutorial/constants/utils.dart';
// import 'package:http/http.dart' as http;

void httpErrorHandle(
    {required Response response,
    required BuildContext context,
    required VoidCallback onSuccess}) {
  switch (response.statusCode) {
    case 200:
      onSuccess();
      break;
    case 201:
      onSuccess();
      break;
    case 400:
      showSnackBar(context, jsonDecode(response.data)["message"]);
      break;
    case 500:
      showSnackBar(context, jsonDecode(response.data)["error"]);
      break;
    default:
      showSnackBar(context, response.data);
  }
}
