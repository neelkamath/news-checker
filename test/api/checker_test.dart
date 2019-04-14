import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:news_checker/app.dart';
import 'package:news_checker/components/server.dart';
import 'package:http/http.dart';
import 'package:string_processor/string_processor.dart';
import 'package:test/test.dart';

import 'uri.dart';
import '../values.dart';

Future<void> main() async {
  group('check', () {
    setUp(() async => await start(dbInfo));

    tearDown(() async => await stop(force: true, deleteDB: true));

    test('known without database', () async {
      await for (File entity in Directory('test/api/responses')
          .list(recursive: true)
          .where((FileSystemEntity entity) => entity is File)) {
        Map<String, dynamic> jsonFile =
            jsonDecode(await File(entity.path).readAsString());

        Map<String, dynamic> expectedResponse = jsonFile['response'];

        String request = jsonFile['request'];

        Response serverResponse =
            await get(getUri(Server.info, 'check', pathParameters: request));
        Map<String, dynamic> actualResponse = jsonDecode(serverResponse.body);

        // We only want to test the fields which are present in the file.
        for (MapEntry<String, dynamic> entry in expectedResponse.entries) {
          if (entry.key == 'news') {
            _testNewsPair(
                entity.path, request, expectedResponse, actualResponse);
          } else if (entry.key == 'relatedNews') {
            _testRelatedNews(actualResponse);
          } else {
            expect(actualResponse, containsPair(entry.key, entry.value),
                reason: '${entity.path} contains this in its response');
          }
        }
      }
    }, timeout: Timeout.none);
    test('known with database', () async {
      var title = "Neel is now the CEO of everything in the universe's history";
      var type = 'fake';
      Response beforeResponse =
          await get(getUri(Server.info, 'check', pathParameters: title));
      Map<String, dynamic> beforeBody = jsonDecode(beforeResponse.body);
      expect(beforeBody['status'], 'unsure',
          reason: "This article title hasn't been reported yet.");

      await post(getUri(Server.info, 'report'),
          headers: {'Content-Type': 'application/json'},
          body: '{"title":"$title","type":"$type"}');
      Response afterResponse =
          await get(getUri(Server.info, 'check', pathParameters: title));
      Map<String, dynamic> afterBody = jsonDecode(afterResponse.body);
      var reason = 'The article title has been added to the database';
      expect(afterBody['news']['matchedTitle'], title, reason: reason);
      expect(afterBody['isReported'], isTrue, reason: reason);
    });
    test('unsure', () async {
      Response response =
          await get(getUri(Server.info, 'check', pathParameters: 'balksdf'));
      expect(jsonDecode(response.body), containsPair('status', 'unsure'),
          reason: "The news article doesn't exist");
    });
  });
}

/// Tests the value of the `'news'` key in the response.
///
/// [request] is the query sent to the server for the expected response.
/// [path] is the path to the file containing [expectedResponse].
void _testNewsPair(
    String path,
    String request,
    Map<String, dynamic> expectedResponse,
    Map<String, dynamic> actualResponse) {
  var reasonPath = 'Response being checked: $path';

  expect(actualResponse['news']['matchedTitle'],
      expectedResponse['news']['matchedTitle'],
      reason: "The article title we're checking against isn't the same one the "
          "server gave us back. This doesn't necessarily indicate a failure in "
          'our code, but might be because the article we were checking was '
          "removed, etc. So update $reasonPath's response first.");

  int percentage = actualResponse['news']['percentage'];
  String matchedTitle = expectedResponse['news']['matchedTitle'];
  expect(percentage,
      getPercentageMatched(matchedTitle, request, ignoreArticles: true),
      reason:
          '$reasonPath\n$request should match $matchedTitle by $percentage%');
  expectedResponse['news']..remove('percentage')..remove('matchedTitle');

  for (MapEntry<String, dynamic> entry in expectedResponse['news'].entries) {
    expect(entry.value, actualResponse['news'][entry.key], reason: reasonPath);
  }
}

/// Tests that related news is ordered in descending order of match percentage.
void _testRelatedNews(Map<String, dynamic> body) {
  List<dynamic> relatedNews = body['relatedNews'];
  if (relatedNews != null) {
    expect(
        relatedNews,
        relatedNews
          ..sort((news1, news2) => (news1['percentage'] as int)
              .compareTo((news2['percentage'] as int))),
        reason: 'It should be ordered in descending order of match percentage');
  }
}
