import 'log_level.dart';

/// 标签日志器
/// 
/// 用于记录带有特定标签的日志信息
class TaggedLogger {
  /// 构造函数
  /// 
  /// [tag] 日志标签
  /// [logFunction] 日志记录函数
  const TaggedLogger(this.tag, this.logFunction);

  /// 日志标签
  final String tag;

  /// 日志记录函数
  final void Function(LogLevel level, String message, String? tag, StackTrace? stackTrace) logFunction;

  /// 记录Verbose级别日志
  /// 
  /// [message] 日志消息
  void v(String message) {
    logFunction(LogLevel.verbose, message, tag, null);
  }

  /// 记录Debug级别日志
  /// 
  /// [message] 日志消息
  void d(String message) {
    logFunction(LogLevel.debug, message, tag, null);
  }

  /// 记录Info级别日志
  /// 
  /// [message] 日志消息
  void i(String message) {
    logFunction(LogLevel.info, message, tag, null);
  }

  /// 记录Warning级别日志
  /// 
  /// [message] 日志消息
  void w(String message) {
    logFunction(LogLevel.warn, message, tag, null);
  }

  /// 记录Error级别日志
  /// 
  /// [message] 日志消息
  void e(String message) {
    logFunction(LogLevel.error, message, tag, null);
  }
} 