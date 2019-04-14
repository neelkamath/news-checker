import 'package:news_checker/components/db.dart';
import 'package:test/test.dart';

/// Tests if the database is not connected to (displays [reason] if it fails).
///
/// [hasBeenOpened] is whether the DB connection has been opened previously.
void testDBIsNotConnected({String reason, bool hasBeenOpened = true}) =>
    expect(DB.connection?.isClosed, hasBeenOpened ? isTrue : isNull,
        reason: reason);

/// Tests if the database is connected to (displays [reason] if it fails).
void testDBIsConnected([String reason]) =>
    expect(DB.connection.isClosed, isFalse, reason: reason);
