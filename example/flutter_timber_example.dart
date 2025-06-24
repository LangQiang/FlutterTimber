import 'package:flutter_timber/flutter_timber.dart';

/// 示例类，演示自动标签功能
class NetworkService {
  void fetchData() {
    // 自动使用类名 "NetworkService" 作为标签
    Timber.d("开始获取数据");
    Timber.i("数据获取成功");
    Timber.w("网络连接较慢");
  }
  
  void handleError() {
    // 手动标签会覆盖自动标签
    Timber.tag("ErrorHandler").e("网络请求失败");
  }
}

class UserService {
  void login() {
    // 自动使用类名 "UserService" 作为标签
    Timber.d("用户登录请求");
    Timber.i("登录成功");
  }
}

/// 顶层函数
void globalFunction() {
  // 自动使用文件名作为标签
  Timber.d("全局函数调用");
}

/// Flutter Timber 使用示例
void main() {
  // 植入DebugTree，启用自动标签功能
  Timber.plant(DebugTree(
    enableColors: true,
    autoTag: true,
  ));

  print('=== Flutter Timber 自动标签示例 ===');
  
  // 测试类方法调用
  final networkService = NetworkService();
  networkService.fetchData();
  networkService.handleError();
  
  final userService = UserService();
  userService.login();
  
  // 测试顶层函数调用
  globalFunction();
  
  // 测试手动标签
  Timber.tag("Manual").d("手动指定的标签");
  
  // 测试不同日志级别
  Timber.v("详细信息");
  Timber.d("调试信息"); 
  Timber.i("一般信息");
  Timber.w("警告信息");
  Timber.e("错误信息");
  
  // 测试堆栈跟踪
  Timber.stack();
  
  // 测试禁用自动标签
  print('\n=== 禁用自动标签测试 ===');
  Timber.uprootAll();
  Timber.plant(DebugTree(autoTag: false));
  
  final testService = NetworkService();
  testService.fetchData(); // 这时不会有自动标签
  
  print('=== 示例结束 ===');
}
