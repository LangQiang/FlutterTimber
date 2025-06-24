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
  /// [autoTag] 是否自动添加类名作为tag，默认为true
  DebugTree({this.enableColors = true, this.autoTag = true});

  /// 是否启用颜色输出
  final bool enableColors;
  
  /// 是否自动添加类名作为tag
  final bool autoTag;

  @override
  void log(LogLevel level, String message, String? tag, StackTrace? stackTrace) {
    // 检查是否为Release模式（简化判断，在纯Dart环境中）
    if (const bool.fromEnvironment('dart.vm.product')) return;

    // 自动生成tag（仅在Debug/Profile模式下执行）
    final finalTag = tag ?? (autoTag ? _getCallerClassName() : null);

    final timestamp = _formatTimestamp(DateTime.now());
    final levelStr = level.name;
    final tagStr = finalTag != null ? '[$finalTag]' : '';
    
    String logMessage;
    if (enableColors) {
      // 带颜色的输出
      logMessage = '${level.ansiColor}[$timestamp] $levelStr $tagStr: $message${LogLevel.ansiReset}';
    } else {
      // 无颜色的输出
      logMessage = '[$timestamp] $levelStr $tagStr: $message';
    }

    // 输出到print
    // ignore: avoid_print
    print(logMessage);

    // 如果有堆栈跟踪，也输出堆栈信息
    if (stackTrace != null) {
      _logStackTrace(stackTrace, level, finalTag);
    }
  }

  @override
  bool isLogEnabled(LogLevel level) {
    // 在非Product模式下启用所有级别的日志
    return !const bool.fromEnvironment('dart.vm.product');
  }

  /// 获取调用者类名
  String? _getCallerClassName() {
    try {
      final stackTrace = StackTrace.current;
      final frames = stackTrace.toString().split('\n');
      
      // 跳过timber内部的调用帧，找到真正的调用者
      for (final frame in frames) {
        if (frame.contains('#') && 
            !frame.contains('timber.dart') && 
            !frame.contains('debug_tree.dart') &&
            !frame.contains('tagged_logger.dart')) {
          return _extractClassName(frame);
        }
      }
    } catch (e) {
      // 如果解析失败，忽略错误，返回null
    }
    return null;
  }
  
  /// 从堆栈帧中提取类名
  String? _extractClassName(String frame) {
    try {
      // 堆栈帧格式示例: #2      MyWidget.build (package:my_app/main.dart:45:12)
      final regex = RegExp(r'#\d+\s+([A-Za-z_$][A-Za-z0-9_$]*)\.');
      final match = regex.firstMatch(frame);
      if (match != null) {
        return match.group(1);
      }
      
      // 如果是顶级函数，尝试提取文件名
      final fileRegex = RegExp(r'\(package:[^/]+/([^/]+)\.dart:\d+:\d+\)');
      final fileMatch = fileRegex.firstMatch(frame);
      if (fileMatch != null) {
        return fileMatch.group(1);
      }
    } catch (e) {
      // 解析失败时忽略
    }
    return null;
  }

  /// 格式化时间戳
  String _formatTimestamp(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final second = dateTime.second.toString().padLeft(2, '0');
    final millisecond = dateTime.millisecond.toString().padLeft(3, '0');
    return '$hour:$minute:$second.$millisecond';
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