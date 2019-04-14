import 'post_checker.dart';

import 'package:news_checker/sources/post.dart';
import 'package:test/test.dart';

void main() {
  group('checking posts', () {
    test('when there are no posts',
        () => expect(containsPostQuery([], 'iPhone'), isFalse));
    test('case insensitivity', () {
      var query = 'iPhone';
      expect(containsPostQuery([Post('iphone', 'https://apple.com')], query),
          isTrue);
    });
  });
}
