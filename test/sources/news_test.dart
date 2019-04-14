import 'dart:io';

import 'post_checker.dart';

import 'package:news_checker/sources/news.dart';
import 'package:test/test.dart';

void main() {
  test('news api', () async {
    var query = 'iPhone XS';
    expect(
        containsPostQuery(
            await getNews(Platform.environment['NEWS_API_KEY'], query), query),
        isTrue);
  });
}
