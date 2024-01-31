import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

const String _iosUrl = 'http://127.0.0.1:5000';
const String _androidUrl = 'http://10.0.2.2:5000';
// This is the server URL at the moment, the IP can change but this is the format
// const String _serverUrl = 'http://54.215.238.217:8000';

const headers = <String, String>{
  'Content-Type': 'application/json; charset=UTF-8',
};

String _getBaseUrl() {
  if (Platform.isAndroid) {
    return _androidUrl;
  } else {
    return _iosUrl;
  }
}

Future get(String url) async {
  var uri = Uri.parse(_getBaseUrl() + url);
  http.Response response = await http.get(uri, headers: headers);
  return response.body;
}

Future post(String url, Object body) async {
  var uri = Uri.parse(_getBaseUrl() + url);
  http.Response response =
      await http.post(uri, headers: headers, body: jsonEncode(body));
  return response.body;
}

Future put(String url, Object body) async {
  var uri = Uri.parse(_getBaseUrl() + url);
  http.Response response =
      await http.put(uri, headers: headers, body: jsonEncode(body));
  return response.body;
}

Future delete(String url) async {
  var uri = Uri.parse(_getBaseUrl() + url);
  http.Response response = await http.delete(uri, headers: headers);
  return response.body;
}
