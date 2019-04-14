import 'dart:async';
import 'dart:io';

import 'package:rpc/rpc.dart';

import '../api/api.dart';

/// This application's HTTP API server.
abstract class Server {
  static HttpServer _server;
  static ApiServerInfo _info;

  /// This will be the address if the server is running, and `null` if it isn't.
  static ApiServerInfo get info => _info;

  /// Starts the HTTP API server, hence setting [info].
  ///
  /// An error will be thrown if [info] isn't `null`.
  static Future<void> start() async {
    if (info != null) {
      throw 'Server has already been started';
    }

    var apiServer = ApiServer()
      ..addApi(Api())
      ..enableDiscoveryApi();
    HttpServer httpServer = await HttpServer.bind(
        InternetAddress.anyIPv4, int.parse(Platform.environment['PORT']),
        shared: true);
    httpServer.listen(apiServer.httpRequestHandler);
    _server = httpServer;
    List<String> api = apiServer.apis[0].split(r'/');
    _info =
        ApiServerInfo(httpServer.address.host, httpServer.port, api[1], api[2]);
  }

  /// Shuts down the server, hence setting [info] to `null`.
  static Future<void> shutDown({bool force = false}) async {
    await _server.close(force: force);
    _info = null;
  }
}

class ApiServerInfo {
  String host;
  int port;
  String name;
  String version;
  String protocol;

  String get address => '$host:$port';

  String get baseUrl => '${protocol}://$address$basePath';

  String get rootUrl => '${protocol}://$address/';

  String get servicePath => '$name/$version/';

  String get basePath => '/$servicePath';

  ApiServerInfo(this.host, this.port, this.name, this.version,
      {this.protocol = 'http'});

  @override
  String toString() => baseUrl;
}
