import 'debug_tree.dart';
import 'log_level.dart';
import 'tagged_logger.dart';
import 'tree.dart';

/// Timber主入口类
/// 
/// 提供静态的日志记录API，采用Tree模式管理日志输出策略
class Timber {
  // 私有构造函数，防止实例化
  Timber._();

  /// 已植入的Tree列表
  static final List<Tree> _trees = [];

  /// 线程安全锁
  static final Object _lock = Object();

  /// 植入一个Tree
  /// 
  /// [tree] 要植入的Tree实例
  static void plant(Tree tree) {
    synchronized(_lock, () {
      _trees.add(tree);
    });
  }

  /// 植入多个Tree
  /// 
  /// [trees] 要植入的Tree列表
  static void plantAll(List<Tree> trees) {
    synchronized(_lock, () {
      _trees.addAll(trees);
    });
  }

  /// 移除所有Tree
  static void uprootAll() {
    synchronized(_lock, () {
      _trees.clear();
    });
  }

  /// 移除指定的Tree
  /// 
  /// [tree] 要移除的Tree实例
  static void uproot(Tree tree) {
    synchronized(_lock, () {
      _trees.remove(tree);
    });
  }

  /// 获取当前植入的Tree数量
  static int get treeCount {
    return synchronized(_lock, () {
      return _trees.length;
    });
  }

  /// 记录Verbose级别日志
  /// 
  /// [message] 日志消息
  static void v(String message) {
    _log(LogLevel.verbose, message, null, null);
  }

  /// 记录Debug级别日志
  /// 
  /// [message] 日志消息
  static void d(String message) {
    _log(LogLevel.debug, message, null, null);
  }

  /// 记录Info级别日志
  /// 
  /// [message] 日志消息
  static void i(String message) {
    _log(LogLevel.info, message, null, null);
  }

  /// 记录Warning级别日志
  /// 
  /// [message] 日志消息
  static void w(String message) {
    _log(LogLevel.warn, message, null, null);
  }

  /// 记录Error级别日志
  /// 
  /// [message] 日志消息
  static void e(String message) {
    _log(LogLevel.error, message, null, null);
  }

  /// 创建带标签的日志器
  /// 
  /// [tag] 日志标签
  /// 返回一个TaggedLogger实例
  static TaggedLogger tag(String tag) {
    return TaggedLogger(tag, _log);
  }

  /// 打印堆栈跟踪
  /// 
  /// [stackTrace] 可选的堆栈跟踪，如果为null则获取当前堆栈
  static void stack([StackTrace? stackTrace]) {
    stackTrace ??= StackTrace.current;
    _log(LogLevel.debug, 'Stack trace:', null, stackTrace);
  }

  /// 内部日志记录方法
  /// 
  /// [level] 日志级别
  /// [message] 日志消息
  /// [tag] 可选的标签
  /// [stackTrace] 可选的堆栈跟踪
  static void _log(LogLevel level, String message, String? tag, StackTrace? stackTrace) {
    synchronized(_lock, () {
      if (_trees.isEmpty) {
        // 如果没有植入任何Tree，则默认植入DebugTree
        _trees.add(DebugTree());
      }

      // 遍历所有Tree并记录日志
      for (final tree in _trees) {
        if (tree.isLogEnabled(level)) {
          try {
            tree.log(level, message, tag, stackTrace);
          } catch (e, s) {
            // 如果日志记录失败，输出错误信息但不抛出异常
            // ignore: avoid_print
            print('Timber: Failed to log message: $e');
            // ignore: avoid_print
            print('Stack trace: $s');
          }
        }
      }
    });
  }

  /// 简单的同步方法实现
  /// 
  /// [lock] 锁对象
  /// [action] 要执行的操作
  static T synchronized<T>(Object lock, T Function() action) {
    // 注意：这里的实现是简化版本，在生产环境中可能需要更复杂的同步机制
    // Dart的Isolate模型通常不需要传统的线程同步，但为了API的完整性，我们保留了这个接口
    return action();
  }
} 