import 'package:news_checker/components/server.dart';
import 'package:test/test.dart';

import 'server.dart';

void main() {
  group('server', () {
    tearDown(() async => await Server.shutDown(force: true));

    test('server', () async {
      await testServerIsOffline("Server hasn't been started");
      await Server.start();
      await testServerIsOnline('Server has been started');
      await Server.shutDown(force: true);
      await testServerIsOffline('Server has been shut down');
    });

    test('connecting when a connection is already open', () async {
      await Server.start();
      await expectLater(Server.start(), throwsA(anything));
    });
  });
}
