import 'dart:io';

import 'package:news_checker/components/db.dart';

var dbInfo = PostgresConnectionInfo(
    PostgresUrl.fromUri(Platform.environment['DATABASE_URL']));
