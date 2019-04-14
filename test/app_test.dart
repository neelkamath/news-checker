import 'package:news_checker/app.dart';
import 'package:news_checker/components/db.dart';
import 'package:test/test.dart';

import 'components/db.dart';
import 'components/server.dart';

import 'values.dart';

void main() {
  group('app lifecycle', () {
    tearDown(() async => await stop(force: true, deleteDB: true));

    test('app lifecycle', () async {
      _testShouldBeOffline(hasBeenOpened: false);

      await start(dbInfo);

      var reason = 'App is running';
      testServerIsOnline(reason);
      testDBIsConnected(reason);

      await stop(force: true);

      _testShouldBeOffline();
    });

    test('deleting the DB', () async {
      await start(dbInfo);
      await expectLater(getTableNames(), completion(isNotEmpty),
          reason: 'The DB contains content when starting the app');
      await stop(force: true, deleteDB: true);
      await DB.connect(dbInfo);
      await expectLater(getTableNames(), completion(isEmpty),
          reason: "When stopping the app, we passed a flag to delete the DB's "
              'contents');
    });
  });
}

/// [hasBeenOpened] is whether the database connection was previously opened.
void _testShouldBeOffline({bool hasBeenOpened = true}) {
  var reason = "The app hasn't been started yet";
  testServerIsOffline(reason);
  testDBIsNotConnected(reason: reason, hasBeenOpened: hasBeenOpened);
}
