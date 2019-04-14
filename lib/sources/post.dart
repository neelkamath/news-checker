/// The title, URL, and optional snippet of a post.
class Post {
  String title;
  String url;
  String snippet;

  Post(this.title, this.url, {this.snippet});

  @override
  String toString() {
    var string = '$title ($url)';
    if (snippet != null) {
      string += ': $snippet';
    }
    return string;
  }
}
