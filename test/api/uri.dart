import 'package:news_checker/components/server.dart';

/// Returns the URI for the server's HTTP API endpoint [endpoint].
///
/// You can get [info] from [Server.info].
Uri getUri(ApiServerInfo info, String endpoint, {String pathParameters}) {
  /*
   The <Uri> constructor's <pathSegments> named parameter doesn't encode colons,
   etc., so we have to do it manually.
    */
  pathParameters =
      pathParameters == null ? '' : '/${Uri.encodeComponent(pathParameters)}';

  return Uri(
      scheme: 'http',
      host: info.host,
      port: info.port,
      path: '${info.servicePath}$endpoint$pathParameters');
}
