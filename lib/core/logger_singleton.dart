// ignore_for_file: deprecated_member_use

import 'package:golden_thailand/core/global.dart';
import 'package:logger/logger.dart';

class LogService {
  static final LogService _instance = LogService._internal();
  factory LogService() => _instance;

  final Logger _logger;

  LogService._internal() : _logger = Logger();

  void logDebug(String message) {
    if (Global.enableLog) {
      _logger.v(message, stackTrace: StackTrace.fromString(""));
    }
  }

  void logInfo(String message) {
    if (Global.enableLog) {
      _logger.i(message);
    }
  }

  void logWarning(String message, {dynamic error, StackTrace? stackTrace}) {
    if (Global.enableLog) {
      _logger.w(
        message,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  void logError(String message, {dynamic title, StackTrace? stackTrace}) {
    if (Global.enableLog) {
      _logger.e(
        "",
        error: title,
        //stackTrace: stackTrace,
      );
    }
  }

}
