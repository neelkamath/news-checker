import 'package:news_checker/components/server.dart';
import 'package:test/test.dart';

/// Tests if the server is not up (displays [reason] if it fails).
void testServerIsOffline([String reason]) =>
    expect(Server.info, isNull, reason: reason);

/// Tests if the server is up (displays [reason] if it fails).
void testServerIsOnline([String reason]) =>
    expect(Server.info, isNotNull, reason: reason);
