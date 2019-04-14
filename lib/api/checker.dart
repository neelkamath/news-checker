import 'dart:async';
import 'dart:io';

import 'package:rpc/rpc.dart';
import 'package:string_processor/string_processor.dart';

import '../components/db.dart';
import '../sources/news.dart';
import '../sources/post.dart';
import '../sources/reddit.dart';

class NewsChecker {
  @ApiMethod(
      path: 'check/{article}',
      description: 'Gets the type of news the article title, <article>, is.')
  Future<NewsType> check(String article) async {
    bool fromDB = false;

    _NewsMatch match = _getBestMatch([
      await _getSubredditNews('theonion', article, _Status.SATIRE),
      await _getSubredditNews('nottheonion', article, _Status.FAUX_SATIRE),
      await _getSubredditNews('fakenews', article, _Status.FAKE),
      await _getSubredditNews('EnoughFakeNewsSpam', article, _Status.FAKE),
      await _getSubredditNews('Clickhole', article, _Status.FAKE)
    ]);

    var invalidStatuses = [_Status.UNAVAILABLE, _Status.UNSURE];

    /*
    This should be used as a last resort, because the API being used here 
    sometimes returns fake news as real. 
     */
    if (invalidStatuses.contains(match.status)) {
      match = await _getPotentiallyRealNews(article);
      if (match.matches == null || match.matches.isEmpty) {
        match.status = _Status.UNSURE;
      }
    }

    /*
    The DB's data might be inaccurate since it has been gotten from users, and
    hence should only be used as a last resort.
     */
    _NewsMatch dbMatch = _getBestMatch(await _getDBMatches(article));
    if (dbMatch.status != _Status.UNSURE &&
        (invalidStatuses.contains(match.status) ||
            (getHighestMatchFromMatches(dbMatch.matches).percentage >
                getHighestMatchFromMatches(match.matches).percentage))) {
      match = dbMatch;
      fromDB = true;
    }

    if (invalidStatuses.contains(match.status)) {
      return NewsType(match.status);
    }

    /*
     It's okay if there are two posts having the same exact title since each
     post is of the same type (real, fake, etc.). Only the source will be
     different.
      */
    Post post;
    if (match.posts != null && match.posts.isNotEmpty) {
      post = match.posts.firstWhere((post) =>
          post.title == getHighestMatchFromMatches(match.matches).sentence);
    }

    PercentageMatch highestMatch = getHighestMatchFromMatches(match.matches);
    return NewsType(match.status,
        isReported: fromDB,
        news: News(highestMatch.percentage, highestMatch.sentence,
            source: post?.url, snippet: post?.snippet),
        relatedNews: match.posts == null
            ? null
            : _getNewsList(
                match.posts..remove(post),
                match.matches
                  ..remove(getHighestMatchFromMatches(match.matches))));
  }
}

/// Returns the posts on [subreddit] searched using [article].
///
/// [type] is the type of news (example: `'satire'`).
Future<_NewsMatch> _getSubredditNews(
        String subreddit, String article, _Status type) async =>
    _generateNewsMatch(article, type,
        posts: await getSubredditPostTitles(subreddit, article));

Future<_NewsMatch> _getPotentiallyRealNews(article) async =>
    _generateNewsMatch(article, _Status.REAL,
        posts: await getNews(Platform.environment['NEWS_API_KEY'], article));

_NewsMatch _generateNewsMatch(String article, _Status type,
    {List<Post> posts}) {
  var matches = <PercentageMatch>[];
  if (posts != null) {
    matches = getMatches(posts.map((post) => post.title).toList(), article,
        ignoreArticles: true);
  }
  return _NewsMatch(type, posts: posts, matches: matches);
}

/// The type of news (example: satirical news).
enum _Status {
  /// The news is fake.
  FAKE,

  /// The news is real.
  REAL,

  /// News that looks fake but is real.
  FAUX_SATIRE,

  /// Fake news that's satirical in nature.
  SATIRE,

  /// The type of news isn't decidable.
  UNSURE,

  /// The type of news can't be checked currently.
  UNAVAILABLE
}

class _NewsMatch {
  _Status status;

  /// This may be `null`.
  List<Post> posts;

  /// This may be `null`.
  List<PercentageMatch> matches;

  _NewsMatch(this.status, {this.posts, this.matches});

  @override
  String toString() {
    var string = status.toString();
    Map<dynamic, String> fields = {posts: 'posts', matches: 'matches'}
      ..removeWhere((key, value) => key == null);
    for (var field in fields.keys) {
      string += '\n${fields[field]}: $field';
    }
    return string;
  }
}

/// Returns the match with the highest [PercentageMatch.percentage].
///
/// `null` will be returned if [matches] has 0 non-`null`
/// [_NewsMatch.matches]es.
_NewsMatch _getHighestMatch(List<_NewsMatch> matches) {
  matches.removeWhere(
      (match) => getHighestMatchFromMatches(match.matches) == null);
  if (matches.isEmpty) {
    return null;
  }

  matches.sort((match1, match2) => getHighestMatchFromMatches(match1.matches)
      .percentage
      .compareTo(getHighestMatchFromMatches(match2.matches).percentage));
  return matches.last;
}

/// Returns the match from [matches] with the most accurate news data.
///
/// [matches] contain `null` values indicates that the API was unserviceable at
/// the time of matching.
_NewsMatch _getBestMatch(List<_NewsMatch> matches) {
  /// If the article doesn't match on any site, and at least one of the APIs
  /// were unserviceable, then we should declare our service to be unavailable,
  /// as it may have matched on one of the unserviceable APIs.
  var isUnavailable =
      matches.where((match) => match.matches == null).isNotEmpty;

  _NewsMatch match =
      _getHighestMatch(matches..removeWhere((match) => match.matches == null));
  if (match == null) {
    return _NewsMatch(isUnavailable ? _Status.UNAVAILABLE : _Status.UNSURE);
  }
  return match;
}

/// Returns the matches gotten for [article] from the DB.
///
/// Each [_NewsMatch] will be the best match for a type (such as fake) of news.
Future<List<_NewsMatch>> _getDBMatches(String article) async {
  List<Map<String, Map<String, dynamic>>> results =
      await DB.connection.mappedResultsQuery('SELECT * FROM reported');
  var data = <String, List<String>>{};
  for (var result in results) {
    var table = result['reported'];

    String type = table['type'];
    if (!data.containsKey(type)) {
      data[type] = <String>[];
    }

    data[type].add(table['article_title']);
  }

  return [
    _getNewsMatch(_Status.REAL, article, data),
    _getNewsMatch(_Status.FAUX_SATIRE, article, data),
    _getNewsMatch(_Status.FAKE, article, data),
    _getNewsMatch(_Status.SATIRE, article, data)
  ];
}

_NewsMatch _getNewsMatch(
    _Status type, String toCheck, Map<String, List<String>> data) {
  String status = _statusAsString(type);
  return _NewsMatch(type,
      matches: getMatches(data.containsKey(status) ? data[status] : [], toCheck,
          ignoreArticles: true));
}

List<News> _getNewsList(List<Post> posts, List<PercentageMatch> matches) {
  /*
    Even a matching percentage as low as 7 yields related articles since the
    articles have been searched using the API of the sites in question, which
    match them against various other factors, such as keywords.
   */
  matches.retainWhere((match) => match.percentage > 0);

  var newsList = <News>[];
  for (var index = 0; index < posts.length && index < matches.length; index++) {
    var currentMatch = matches[index];
    var currentPost = posts[index];
    newsList.add(News(currentMatch.percentage, currentMatch.sentence,
        source: currentPost?.url, snippet: currentPost.snippet));
  }
  return newsList
    ..sort((news1, news2) => news1.percentage.compareTo(news2.percentage))
    ..reversed.toList();
}

/// Contains the type of news and its metadata, and how the type was arrived at.
class NewsType {
  @ApiProperty(
      description:
          'Whether the news is probably fake, satirical, faux satirical, real '
          'or unsure. If the type is <"unsure"> or <"unavailable>, this will '
          'be the only field sent.',
      required: true,
      values: {
        'fake': 'Fake',
        'satire': 'Satire (fake)',
        'faux_satire': 'Seems satirical but is real',
        'real': 'Not fake',
        'unsure': 'No reputable sources were able to identify the article',
        'unavailable': 'The resources the server required to check the '
            'trustworthiness of this article are currently unavailable'
      })
  String status;

  @ApiProperty(
      description:
          "If <true>, this news might be incorrectly classified since it's "
          'from user reports',
      required: true)
  bool isReported;

  @ApiProperty(description: 'The highest matched news article.')
  News news;

  @ApiProperty(
      description:
          'Related news articles with the same <"status">. The articles will '
          'be ordered in descending order of match percentage.')
  List<News> relatedNews;

  NewsType(_Status type, {this.isReported = false, this.news, this.relatedNews})
      : status = _statusAsString(type);
}

/// Returns the [String] representation of [type].
///
/// A [String] will be thrown if [type] didn't have a [String] representation.
String _statusAsString(_Status type) {
  switch (type) {
    case _Status.FAKE:
      return 'fake';
    case _Status.FAUX_SATIRE:
      return 'faux_satire';
    case _Status.SATIRE:
      return 'satire';
    case _Status.REAL:
      return 'real';
    case _Status.UNSURE:
      return 'unsure';
    case _Status.UNAVAILABLE:
      return 'unavailable';
    default:
      throw 'Type not found';
  }
}

/// A news article's metadata.
class News {
  @ApiProperty(
      description: 'How correct the status of the news type is in percentage.',
      required: true,
      minValue: 0)
  int percentage;

  @ApiProperty(
      description: 'The title of the article which was matched the most',
      required: true)
  String matchedTitle;

  @ApiProperty(description: "The matched article's URL")
  String source;

  @ApiProperty(description: 'A snippet from the matched article.')
  String snippet;

  News(this.percentage, this.matchedTitle, {this.source, this.snippet});
}
