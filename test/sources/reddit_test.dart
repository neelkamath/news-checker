import 'package:news_checker/sources/reddit.dart';
import 'package:test/test.dart';

import 'post_checker.dart';

void main() {
  test('get subreddit post titles', () async {
    var query = 'trump';
    var titles = await getSubredditPostTitles('politics', query);
    if (titles == null) {
      return;
    }
    expect(containsPostQuery(titles, query), isTrue);
  });
}
