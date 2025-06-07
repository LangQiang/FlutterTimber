/// 日志级别枚举
/// 
/// 定义了五个日志级别，从低到高排序：verbose, debug, info, warn, error
enum LogLevel {
  /// 详细信息级别，通常用于调试详细流程
  verbose,
  
  /// 调试级别，用于调试信息
  debug,
  
  /// 信息级别，用于一般信息输出
  info,
  
  /// 警告级别，用于警告信息
  warn,
  
  /// 错误级别，用于错误信息
  error;

  /// 获取日志级别的字符串表示
  String get name {
    switch (this) {
      case LogLevel.verbose:
        return 'V';
      case LogLevel.debug:
        return 'D';
      case LogLevel.info:
        return 'I';
      case LogLevel.warn:
        return 'W';
      case LogLevel.error:
        return 'E';
    }
  }

  /// 获取ANSI颜色代码
  String get ansiColor {
    switch (this) {
      case LogLevel.verbose:
        return '\x1B[37m'; // 白色/灰色
      case LogLevel.debug:
        return '\x1B[36m'; // 青色/蓝色
      case LogLevel.info:
        return '\x1B[32m'; // 绿色
      case LogLevel.warn:
        return '\x1B[33m'; // 黄色
      case LogLevel.error:
        return '\x1B[31m'; // 红色
    }
  }

  /// ANSI重置代码
  static const String ansiReset = '\x1B[0m';
} 