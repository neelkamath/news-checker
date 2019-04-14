import 'dart:convert';
import 'dart:io';

import 'package:news_checker/app.dart';
import 'package:news_checker/components/db.dart';
import 'package:test/test.dart';

import 'db.dart';
import '../values.dart';

void main() {
  group('DB', () {
    tearDown(() async => await DB.connection.close());

    test('database connection', () async {
      testDBIsNotConnected(
          reason: "The connection hasn't been opened yet",
          hasBeenOpened: false);
      await DB.connect(dbInfo);
      testDBIsConnected('The connection is open');
      await expectLater(DB.connect(dbInfo), throwsA(TypeMatcher<String>()),
          reason: 'A connection is already open');
      await DB.connection.close();
      testDBIsNotConnected(reason: 'The connection has been closed');
    });
  });

  group('database manipulation', () {
    setUp(() async => await start(dbInfo, initializeDB: false));

    tearDown(() async => await stop(force: true, deleteDB: true));

    test('getting table names', () async {
      await initDB();
      await expectLater(getTableNames(), completion(contains('reported')));
    });

    test('initializing the DB', () async {
      await expectLater(getTableNames(), completion(isEmpty),
          reason:
              "There are no tables yet since the DB hasn't been initialized");
      await initDB();
      await expectLater(getTableNames(), completion(isNotEmpty),
          reason: 'The DB initializer created one or more tables');
    });

    test('deleting DB data', () async {
      await initDB();
      await DB.connection
          .query("INSERT INTO reported VALUES ('satire', 'title');");
      await deleteDBData();
      await expectLater(getTableNames(), completion(isNotEmpty),
          reason: "The tables shouldn't have been deleted");
      await expectLater(
          DB.connection.query('SELECT * FROM reported'), completion(isEmpty),
          reason: "Table rows should've been removed");
    });

    test('checking if the DB has been initialized', () async {
      await expectLater(DBIsInitialized(), completion(isFalse),
          reason: "The DB hasn't been initialized yet");
      await initDB();
      await expectLater(DBIsInitialized(), completion(isTrue),
          reason: 'The DB has been initialized');
    });

    test('delete DB structure', () async {
      await initDB();
      await deleteDBStructure();
      await expectLater(getTableNames(), completion(isEmpty),
          reason: 'There should be no tables after deleting the structure');
    });
  });

  test('URI parser', () async {
    Map<String, dynamic> json =
        jsonDecode(await File('test/components/db.json').readAsString());
    var scheme = 'postgres://';
    var uriEnd = '${json['host']}:${json['port']}/${json['database']}';
    PostgresUrl url = PostgresUrl.fromUri(
        '$scheme${json['username']}:${json['password']}@$uriEnd');
    expect(url.username, json['username']);
    expect(url.password, json['password']);
    expect(url.host, json['host']);
    expect(url.port, json['port']);
    expect(url.database, json['database']);
  });
}
