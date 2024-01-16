import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

const String _iosUrl = 'http://127.0.0.1:5000';
const String _androidUrl = 'http://10.0.2.2:5000';

const headers = <String, String>{
  'Content-Type': 'application/json; charset=UTF-8',
};

Future get(String url) async {
  var uri = Uri.parse(_androidUrl + url);
  http.Response response = await http.get(uri, headers: headers);
  return response.body;
}

Future post(String url, Object body) async {
  var uri = Uri.parse(_androidUrl + url);
  http.Response response =
      await http.post(uri, headers: headers, body: jsonEncode(body));
  return response.body;
}
