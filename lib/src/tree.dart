import 'log_level.dart';

/// Tree抽象类
/// 
/// 定义了日志输出策略的接口，用户可以通过继承此类来自定义日志输出行为
abstract class Tree {
  /// 记录日志的抽象方法
  /// 
  /// [level] 日志级别
  /// [message] 日志消息
  /// [tag] 可选的标签
  /// [stackTrace] 可选的堆栈跟踪信息
  void log(LogLevel level, String message, String? tag, StackTrace? stackTrace);

  /// 判断是否应该记录此级别的日志
  /// 
  /// 默认实现为总是返回true，子类可以重写此方法来过滤日志级别
  bool isLogEnabled(LogLevel level) => true;
} 