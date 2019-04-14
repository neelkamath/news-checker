import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';

import 'post.dart';

/// Returns posts searched using [query] in [subreddit].
///
/// [Post.url] will be the URL of the post (so an image post using imgur will
/// contain the URL to the imgur image being posted, and not the Reddit post).
///
/// If `null` is returned, that means Reddit's API is unserviceable at the time.
Future<List<Post>> getSubredditPostTitles(
    String subreddit, String query) async {
  Response response = await get(Uri(
      scheme: 'https',
      host: 'reddit.com',
      path: 'r/$subreddit/search/.json',
      queryParameters: {'q': query, 'restrict_sr': '1', 'raw_json': '1'}));
  Map<String, dynamic> body = jsonDecode(response.body);
  if (body['error'] == 503) {
    return null;
  }
  List<dynamic> children = body['data']['children'];
  var posts = <Post>[];
  for (Map<String, dynamic> child in children) {
    var post = child['data'];
    posts.add(Post(post['title'], post['url']));
  }
  return posts;
}
