import 'package:rpc/rpc.dart';

import 'checker.dart';
import 'reporter.dart';

@ApiClass(version: 'v1', description: 'Fake news checking API')
class Api {
  @ApiResource()
  final checker = NewsChecker();

  @ApiResource()
  final reporter = NewsReporter();
}
