import 'package:news_checker/sources/post.dart';

/// Returns whether at least one [Post.title] in [posts] contained [query].
///
/// [query] is matched case-insensitively.
bool containsPostQuery(List<Post> posts, String query) => posts
    .where((post) => post.title.toLowerCase().contains(query.toLowerCase()))
    .isNotEmpty;
