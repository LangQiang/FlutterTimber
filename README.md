<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

# Flutter Timber

一个受Android Timber启发的Flutter日志工具库，提供简单且可扩展的日志记录API，采用Tree模式管理输出策略，专为开发调试设计。

## 🎯 特性

- **🌳 Tree模式**: 通过 `Timber.plant(tree)` 管理日志输出策略
- **🚀 静态API**: 全局静态调用方式，使用简单
- **🎨 IDEA颜色方案**: 支持彩色日志输出，提升开发体验
- **🏷️ 标签支持**: 支持带标签的日志记录
- **📚 堆栈跟踪**: 内置堆栈跟踪功能
- **🔒 Release安全**: Release模式下自动静默，不影响生产环境
- **🛡️ 线程安全**: 确保多线程环境下的安全性

## 📦 安装

在 `pubspec.yaml` 中添加依赖：

```yaml
dependencies:
  flutter_timber: ^1.0.0
```

然后运行：

```bash
flutter pub get
```

## 🚀 快速开始

### 基础使用

```dart
import 'package:flutter_timber/flutter_timber.dart';

void main() {
  // 植入调试Tree
  Timber.plant(DebugTree());
  
  // 记录日志
  Timber.d("Debug message");
  Timber.i("Info message");
  Timber.w("Warning message");
  Timber.e("Error message");
  
  runApp(MyApp());
}
```

### 带标签的日志

```dart
// 网络请求日志
Timber.tag("Network").d("开始请求数据");
Timber.tag("Network").i("请求成功");

// 数据库操作日志
Timber.tag("Database").d("执行查询");
Timber.tag("Database").w("查询耗时较长");
```

### 堆栈跟踪

```dart
// 打印当前位置堆栈
Timber.stack();

// 打印指定堆栈
try {
  riskyOperation();
} catch (e, stackTrace) {
  Timber.e("操作失败: $e");
  Timber.stack(stackTrace);
}
```

## 📖 详细API

### 基础日志方法

```dart
Timber.v("Verbose message");  // 详细信息
Timber.d("Debug message");    // 调试信息
Timber.i("Info message");     // 一般信息
Timber.w("Warning message");  // 警告信息
Timber.e("Error message");    // 错误信息
```

### Tree管理

```dart
// 植入Tree
Timber.plant(DebugTree());

// 植入多个Tree
Timber.plantAll([
  DebugTree(),
  CustomTree(),
]);

// 移除所有Tree
Timber.uprootAll();

// 移除指定Tree
Timber.uproot(specificTree);

// 获取Tree数量
int count = Timber.treeCount;
```

### 自定义Tree

```dart
class CustomTree extends Tree {
  @override
  void log(LogLevel level, String message, String? tag, StackTrace? stackTrace) {
    // 自定义日志处理逻辑
    final logMessage = '${level.name}: $message';
    if (tag != null) {
      print('[$tag] $logMessage');
    } else {
      print(logMessage);
    }
  }
}

// 使用自定义Tree
Timber.plant(CustomTree());
```

## 🎨 日志输出格式

DebugTree 输出格式：`[HH:mm:ss.SSS] LEVEL [TAG]: message`

示例输出：
```
[14:30:15.123] D [Network]: 开始网络请求
[14:30:15.456] I [Network]: 请求成功，状态码: 200
[14:30:15.789] W [Database]: 连接池接近上限
[14:30:16.012] E [UI]: 渲染失败
```

## 🌈 颜色方案

| 级别 | 颜色 | ANSI代码 |
|------|------|----------|
| Verbose | 白色/灰色 | `\x1B[37m` |
| Debug | 青色/蓝色 | `\x1B[36m` |
| Info | 绿色 | `\x1B[32m` |
| Warn | 黄色 | `\x1B[33m` |
| Error | 红色 | `\x1B[31m` |

## ⚙️ 配置选项

### DebugTree 配置

```dart
// 启用颜色输出（默认）
Timber.plant(DebugTree(enableColors: true));

// 禁用颜色输出
Timber.plant(DebugTree(enableColors: false));
```

## 🏗️ 最佳实践

### 1. 应用初始化

```dart
void main() {
  // 仅在Debug模式下植入Tree
  if (kDebugMode) {
    Timber.plant(DebugTree());
  }
  
  runApp(MyApp());
}
```

### 2. 模块化日志

```dart
class NetworkService {
  static final _logger = Timber.tag("Network");
  
  Future<void> fetchData() async {
    _logger.d("开始获取数据");
    try {
      // 网络请求逻辑
      _logger.i("数据获取成功");
    } catch (e) {
      _logger.e("数据获取失败: $e");
    }
  }
}
```

### 3. 条件日志

```dart
// 仅在特定条件下记录详细日志
if (kDebugMode && enableVerboseLogging) {
  Timber.v("详细的调试信息");
}
```

## 🔧 技术规格

- **Flutter**: >= 3.0.0
- **Dart**: >= 2.17.0
- **平台**: 仅支持Flutter项目（不支持纯Dart项目）

## 📝 许可证

MIT License - 详见 [LICENSE](LICENSE) 文件

## 🤝 贡献

欢迎提交 Issues 和 Pull Requests！

## 📚 更多示例

查看 [example](example/) 目录获取更多使用示例。

---

**注意**: 此包专为开发调试设计，不建议在生产环境中进行日志收集。Release模式下所有日志输出都会被自动禁用。
