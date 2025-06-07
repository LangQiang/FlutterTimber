import 'dart:developer' as developer;

import 'log_level.dart';
import 'tree.dart';

/// 调试Tree实现
/// 
/// 仅在Debug模式下输出日志，支持IDEA颜色方案
/// 输出格式: [HH:mm:ss.SSS] LEVEL [TAG]: message
class DebugTree extends Tree {
  /// 构造函数
  /// 
  /// [enableColors] 是否启用颜色输出，默认为true
  DebugTree({this.enableColors = true});

  /// 是否启用颜色输出
  final bool enableColors;

  @override
  void log(LogLevel level, String message, String? tag, StackTrace? stackTrace) {
    // 检查是否为Release模式（简化判断，在纯Dart环境中）
    if (const bool.fromEnvironment('dart.vm.product')) return;

    final timestamp = _formatTimestamp(DateTime.now());
    final levelStr = level.name;
    final tagStr = tag != null ? '[$tag]' : '';
    
    String logMessage;
    if (enableColors) {
      // 带颜色的输出
      logMessage = '${level.ansiColor}[$timestamp] $levelStr $tagStr: $message${LogLevel.ansiReset}';
    } else {
      // 无颜色的输出
      logMessage = '[$timestamp] $levelStr $tagStr: $message';
    }

    // 使用dart:developer的log函数输出，这样可以在IDE中正确显示
    developer.log(
      logMessage,
      name: tag ?? 'Timber',
      level: _mapLogLevel(level),
      stackTrace: stackTrace,
    );

    // 同时输出到print，确保在控制台可见
    // ignore: avoid_print
    print(logMessage);

    // 如果有堆栈跟踪，也输出堆栈信息
    if (stackTrace != null) {
      _logStackTrace(stackTrace, level, tag);
    }
  }

  @override
  bool isLogEnabled(LogLevel level) {
    // 在非Product模式下启用所有级别的日志
    return !const bool.fromEnvironment('dart.vm.product');
  }

  /// 格式化时间戳
  String _formatTimestamp(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final second = dateTime.second.toString().padLeft(2, '0');
    final millisecond = dateTime.millisecond.toString().padLeft(3, '0');
    return '$hour:$minute:$second.$millisecond';
  }

  /// 将LogLevel映射到dart:developer的日志级别
  int _mapLogLevel(LogLevel level) {
    switch (level) {
      case LogLevel.verbose:
        return 500;
      case LogLevel.debug:
        return 500;
      case LogLevel.info:
        return 800;
      case LogLevel.warn:
        return 900;
      case LogLevel.error:
        return 1000;
    }
  }

  /// 输出堆栈跟踪
  void _logStackTrace(StackTrace stackTrace, LogLevel level, String? tag) {
    final lines = stackTrace.toString().split('\n');
    for (final line in lines) {
      if (line.trim().isNotEmpty) {
        final timestamp = _formatTimestamp(DateTime.now());
        final levelStr = level.name;
        final tagStr = tag != null ? '[$tag]' : '';
        
        String logMessage;
        if (enableColors) {
          logMessage = '${level.ansiColor}[$timestamp] $levelStr $tagStr:   $line${LogLevel.ansiReset}';
        } else {
          logMessage = '[$timestamp] $levelStr $tagStr:   $line';
        }
        
        // ignore: avoid_print
        print(logMessage);
      }
    }
  }
} 