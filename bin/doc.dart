/// Creates the file `json/api.json` containing the HTTP API's documentation.
///
/// You can pass an optional command line argument indicating the server's URL
/// (`0.0.0.0:5000` will be used by default).
import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:http/http.dart';

Future<void> main(List<String> args) async {
  List<String> arguments = ArgParser().parse(args).arguments;
  String serverUrl;
  if (arguments.isEmpty) {
    serverUrl = '0.0.0.0:5000';
  } else if (arguments.length > 1) {
    throw ArgumentError('Only one argument can be taken.');
  } else {
    serverUrl = arguments.first;
  }
  Response json = await get('http://$serverUrl/discovery/v1/apis/api/v1/rest');
  await File('json/api.json').create(recursive: true)
    ..writeAsString(json.body);
}
