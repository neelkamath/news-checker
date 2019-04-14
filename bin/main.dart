/// This is the executable (it contains the `main` function) to start the app.
import 'dart:async';
import 'dart:io';

import 'package:news_checker/app.dart';
import 'package:news_checker/components/db.dart';
import 'package:news_checker/components/server.dart';
import 'package:logging/logging.dart';

Future<void> main() async {
  _startLogger();
  await start(PostgresConnectionInfo(
      PostgresUrl.fromUri(Platform.environment['DATABASE_URL'])));
  print('Serving on ${Server.info.address}');
}

/// [print]s the stack traces of warnings.
void _startLogger() {
  Logger.root.level = Level.WARNING;
  Logger.root.onRecord.listen((LogRecord record) {
    if (record.error != null) {
      print(record.error);
    }
    print('${record.message}\n${record.stackTrace}');
  });
}
