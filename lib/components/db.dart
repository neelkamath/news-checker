/// Contains the DB singleton as well as functions to create, wipe, etc. the DB.
import 'dart:async';

import 'package:postgres/postgres.dart';

/// A PostgreSQL database connection singleton.
abstract class DB {
  static PostgreSQLConnection _connection;

  /// This will be `null` if [connect] hasn't been used yet.
  ///
  /// You can close the connection by calling [PostgreSQLConnection.close].
  static PostgreSQLConnection get connection => _connection;

  /// An error will be thrown if this is called when [connection] isn't `null`.
  static Future<void> connect(PostgresConnectionInfo info) async {
    if (connection != null && !connection.isClosed) {
      throw 'There is already an open connection to a DB.';
    }
    _connection = PostgreSQLConnection(
        info.url.host, info.url.port, info.url.database,
        username: info.url.username,
        password: info.url.password,
        timeoutInSeconds: info.timeoutInSeconds,
        timeZone: info.timeZone,
        useSSL: info.useSSL);
    await _connection.open();
  }
}

/// The connection info for a DB connection to Postgres.
class PostgresConnectionInfo {
  final PostgresUrl url;
  final int timeoutInSeconds;
  final String timeZone;
  final bool useSSL;

  const PostgresConnectionInfo(this.url,
      {this.timeoutInSeconds = 30, this.timeZone = 'UTC', this.useSSL = false});
}

class PostgresUrl {
  String username;
  String password;
  String host;
  int port;
  String database;

  PostgresUrl(this.username, this.password,
      {this.host = 'localhost', this.port = 5432, this.database = 'postgres'});

  /// [uri] must contain the host, port, database, username, and password.
  PostgresUrl.fromUri(String uri) {
    Uri data = Uri.parse(uri);
    host = data.host;
    port = data.port;
    database = data.pathSegments.first;
    List<String> parts = data.userInfo.split(r':');
    username = parts[0];
    password = parts[1];
  }

  @override
  String toString() {
    var scheme = 'postgres://';
    var uri = scheme;
    if (username != null) {
      uri += username;
    }
    if (password != null) {
      uri += ':$password';
    }
    if (uri.length > scheme.length) {
      uri += '@';
    }
    uri += '$host:$port/$database';
    return uri;
  }
}

/// Returns whether the DB has been structured (whether tables exist, etc.).
Future<bool> DBIsInitialized() async => (await getTableNames()).isNotEmpty;

/// Returns the names of tables in the DB.
Future<List<dynamic>> getTableNames() async {
  List<List<dynamic>> results = await DB.connection
      .query("SELECT tablename FROM pg_tables WHERE schemaname='public'");
  return results.isEmpty
      ? results
      : results.reduce((previous, current) => previous..add(current.first));
}

/// Initializes the database (creates tables, etc.) if required.
Future<void> initDB() async {
  if (await DBIsInitialized()) {
    return;
  }

  await DB.connection.query('CREATE TABLE reported ('
      'type VARCHAR NOT NULL,'
      'article_title VARCHAR NOT NULL,'
      'date DATE NOT NULL DEFAULT CURRENT_TIMESTAMP,'
      "CHECK (type in ('fake', 'satire', 'faux_satire', 'real'))"
      ')');
}

/// Deletes the database's data (rows), but keeps the structure (tables).
Future<void> deleteDBData() async {
  if (!await DBIsInitialized()) {
    return;
  }

  await DB.connection.query('DELETE FROM reported');
}

/// Deletes the DB's structure (tables).
Future<void> deleteDBStructure() async {
  if (!await DBIsInitialized()) {
    return;
  }

  await DB.connection.query('DROP TABLE reported');
}
