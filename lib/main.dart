import 'dart:io';

import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import 'app.dart';

void main() {
  setupLogging();

  runApp(const App());
}

void setupLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    if (kDebugMode) {
      print('${record.loggerName}: ${record.message}');
    }

    // Create logs directory if it does not exist
    Directory('logs').createSync();

    final logFile = File('logs/${record.loggerName}.txt');
    logFile.createSync();
    logFile.writeAsStringSync(
      '${record.level.name}: ${record.message}\n',
      mode: FileMode.append,
      flush: true,
    );
  });
}
