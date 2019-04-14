/// Contains functions pertaining to the application's lifecycle.
import 'dart:async';

import 'components/db.dart';
import 'components/server.dart';

/// Starts the app by starting the server, database, and logger.
///
/// Only the app's components which haven't been started, will be; so it is safe
/// to call this function even if components are already running.
///
/// [initializeDB] is whether to create the required DB data (such as tables) if
/// it doesn't already exist.
Future<void> start(PostgresConnectionInfo info,
    {bool initializeDB = true}) async {
  if (Server.info == null) {
    await Server.start();
  }
  if (DB.connection == null || DB.connection.isClosed) {
    await DB.connect(info);
  }
  if (initializeDB) {
    await initDB();
  }
}

/// Stops the app by shutting down the server, and closing the DB connection.
///
/// Only the components running will be shut down, so it is safe to call this
/// function even if some components have already been shut down.
///
/// [force] is whether to force shut down the server.
/// [deleteDB] is whether the DB's structure should be deleted.
Future<void> stop({bool force = false, bool deleteDB = false}) async {
  if (deleteDB && !DB.connection.isClosed) {
    await deleteDBStructure();
  }
  if (Server.info != null) {
    await Server.shutDown(force: force);
  }
  if (!DB.connection.isClosed) {
    await DB.connection.close();
  }
}
