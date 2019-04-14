import 'dart:async';

import 'package:rpc/rpc.dart';

import '../components/db.dart';

class NewsReporter {
  @ApiMethod(
      path: 'report',
      method: 'POST',
      description: "Reports a news article's title to improve the database")
  Future<VoidMessage> report(Article article) async {
    await DB.connection.query('INSERT INTO reported VALUES (@type, @title)',
        substitutionValues: {'type': article.type, 'title': article.title});
    return null;
  }
}

class Article {
  @ApiProperty(description: 'The type of news.', required: true, values: {
    'fake': 'Fake news',
    'satire': 'Fake news which is satirical in nature',
    'faux_satire': 'Real news which looks fake because it seems satirical',
    'real': 'Real news'
  })
  String type;

  @ApiProperty(description: "The article's title", required: true)
  String title;

  @override
  String toString() => 'TYPE:$type TITLE:$title';
}
