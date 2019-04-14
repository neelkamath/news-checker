import 'package:link_checker/link_checker.dart';
import 'package:test/test.dart';

void main() {
  test('dead links', () async {
    var badLinks = <BadLink>[];
    await for (BadLink badLink in getBadLinksInDirectory(blacklistedFilePaths: [
      'pubspec.lock'
    ], blacklistedDirectories: [
      BlacklistedDirectory('.git'),
      BlacklistedDirectory('json'),
      BlacklistedDirectory('.dart_tool'),
      BlacklistedDirectory('.idea')
    ], blacklistedLinksRegexes: [
      RegExp(r'.*reddit.com\/.*search.*'),
      RegExp(r'http:\/\/\d*\.\d*\.\d*\.\d*:\d*'),
      RegExp(r'https?:\/\/.*/discovery.*'),
      RegExp(r'.*\.git'),
      RegExp(r'https:\/\/fake-news-checker\.herokuapp\.com\/*'),
      RegExp(r'https:\/\/newsapi\.org\/v2\/.*')
    ])) {
      badLinks.add(badLink);
    }
    expect(badLinks, isEmpty,
        reason: "There shouldn't be dead links in the project");
  }, timeout: Timeout.none);
}
