import 'dart:convert';

import 'package:news_checker/app.dart';
import 'package:news_checker/components/db.dart';
import 'package:news_checker/components/server.dart';
import 'package:http/http.dart';
import 'package:test/test.dart';

import 'uri.dart';
import '../values.dart';

void main() {
  group('report', () {
    setUp(() async => await start(dbInfo));

    tearDown(() async => await stop(force: true, deleteDB: true));

    test('good request', () async {
      await expectLater(
          DB.connection.query('SELECT * FROM reported'), completion(isEmpty),
          reason: 'No articles have been reported yet');
      var type = 'faux_satire';
      var title =
          'Passenger takes the wheel after drunk Uber driver passes out';
      Response response = await post(getUri(Server.info, 'report'),
          headers: {'Content-Type': 'application/json'},
          body: '{"title":"$title","type":"$type"}');
      expect(response.statusCode, 204);
      await expectLater(
          DB.connection.query('SELECT * FROM reported'),
          completion([
            [type, title, TypeMatcher<DateTime>()]
          ]),
          reason: 'An article has been reported');
    });
    test('bad request', () async {
      Response response = await post(getUri(Server.info, 'report'),
          body: {'type': 'invalidType', 'title': 'dummy title'}.toString());
      Map<String, dynamic> json = jsonDecode(response.body);
      expect(json, contains('error'));
      Map<String, dynamic> error = json['error'];
      expect(error, containsPair('code', 400));
      expect(error['message'], contains('Invalid parameter'));
    });
  });
}
