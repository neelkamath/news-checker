import 'dart:async';
import 'dart:convert';

import 'post.dart';

import 'package:http/http.dart';

/// Returns news queried with [query].
///
/// The news returned is supposed to be real, but tests have shown that fake
/// news is also returned by this API.
///
/// [key] is your News API key. You can get one at https://newsapi.org/account.
Future<List<Post>> getNews(String key, String query) async {
  Response response = await get(
      'https://newsapi.org/v2/everything?q=${Uri.encodeQueryComponent(query)}',
      headers: {'X-Api-Key': key});
  List<dynamic> articles = jsonDecode(response.body)['articles'];
  var posts = <Post>[];
  for (var article in articles) {
    posts.add(Post(article['title'], article['url'],
        snippet: article['description']));
  }
  return posts;
}
