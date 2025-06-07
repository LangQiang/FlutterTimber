import 'package:flutter_timber/flutter_timber.dart';

/// Flutter Timber 使用示例
/// 
/// 展示了如何使用flutter_timber进行日志记录
void main() {
  // 1. 植入DebugTree（仅在Debug模式下输出）
  Timber.plant(DebugTree());
  
  // 2. 基础日志调用（无标签）
  print('\n=== 基础日志API ===');
  Timber.v("这是一条Verbose消息");
  Timber.d("这是一条Debug消息"); 
  Timber.i("这是一条Info消息");
  Timber.w("这是一条Warning消息");
  Timber.e("这是一条Error消息");

  // 3. 带标签调用
  print('\n=== 带标签日志API ===');
  Timber.tag("MyClass").d("带标签的Debug消息");
  Timber.tag("Network").i("网络请求完成");
  Timber.tag("Database").w("数据库连接警告");
  Timber.tag("UI").e("界面渲染错误");

  // 4. 堆栈跟踪API
  print('\n=== 堆栈跟踪API ===');
  _demonstrateStackTrace();

  // 5. Tree管理API
  print('\n=== Tree管理API ===');
  print('当前Tree数量: ${Timber.treeCount}');
  
  // 植入多个Tree（实际使用中可能不常见）
  Timber.plant(DebugTree(enableColors: false));
  print('植入无颜色Tree后数量: ${Timber.treeCount}');
  
  // 移除所有Tree
  Timber.uprootAll();
  print('移除所有Tree后数量: ${Timber.treeCount}');
  
  // 重新植入一个Tree
  Timber.plant(DebugTree());
  print('重新植入后数量: ${Timber.treeCount}');

  // 6. Release模式测试（在Release模式下不输出）
  print('\n=== Release模式行为 ===');
  Timber.d("这条消息在Release模式下不会输出");

  // 7. 复杂使用场景
  print('\n=== 复杂使用场景 ===');
  _demonstrateComplexUsage();

  print('\n=== 示例完成 ===');
}

/// 演示堆栈跟踪功能
void _demonstrateStackTrace() {
  Timber.stack(); // 打印当前位置堆栈
  
  try {
    _throwException();
  } catch (e, stackTrace) {
    Timber.tag("Exception").e("捕获到异常: $e");
    Timber.stack(stackTrace); // 打印指定堆栈
  }
}

/// 抛出异常用于演示
void _throwException() {
  throw Exception("这是一个示例异常");
}

/// 演示复杂使用场景
void _demonstrateComplexUsage() {
  // 模拟网络请求
  _simulateNetworkRequest();
  
  // 模拟数据库操作
  _simulateDatabaseOperation();
  
  // 模拟UI更新
  _simulateUIUpdate();
}

/// 模拟网络请求
void _simulateNetworkRequest() {
  final logger = Timber.tag("Network");
  
  logger.d("开始网络请求");
  logger.i("请求URL: https://api.example.com/data");
  
  // 模拟请求成功
  logger.i("请求成功，状态码: 200");
  logger.d("响应数据: {\"id\": 1, \"name\": \"Example\"}");
}

/// 模拟数据库操作
void _simulateDatabaseOperation() {
  final logger = Timber.tag("Database");
  
  logger.d("开始数据库查询");
  logger.v("SQL: SELECT * FROM users WHERE id = ?");
  
  // 模拟查询成功
  logger.i("查询完成，返回1条记录");
}

/// 模拟UI更新
void _simulateUIUpdate() {
  final logger = Timber.tag("UI");
  
  logger.d("开始UI更新");
  logger.v("更新组件: UserProfile");
  
  // 模拟更新完成
  logger.i("UI更新完成");
}
