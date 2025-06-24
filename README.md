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

## 🎯 核心特性

- **🌳 Tree模式**: 可插拔的日志输出策略
- **🔄 自动Fallback**: 无Tree植入时自动使用DebugTree
- **🔒 Release安全**: Release模式下在输出阶段自动拦截
- **🏷️ 智能标签**: 自动生成类名标签，支持手动标签
- **🎨 彩色输出**: 支持ANSI颜色的控制台输出

## 📦 安装

```yaml
dependencies:
  flutter_timber: ^1.0.2
```

## 🚀 快速开始

### 基础使用

```dart
import 'package:flutter_timber/flutter_timber.dart';

void main() {
  // 可选：显式植入Tree（推荐，提高代码可读性）
  Timber.plant(DebugTree());
  
  // 即使不植入Tree也可以直接使用（会自动使用DebugTree）
  Timber.d("Debug message");
  Timber.i("Info message");
  Timber.w("Warning message");
  Timber.e("Error message");
  
  runApp(MyApp());
}
```

### 智能标签日志

```dart
class NetworkService {
  void fetchData() {
    // 自动使用类名作为标签
    Timber.d("开始请求数据");  // 输出: [NetworkService] 开始请求数据
    Timber.i("请求成功");     // 输出: [NetworkService] 请求成功
  }
}

// 手动指定标签（会覆盖自动标签）
Timber.tag("CustomTag").d("自定义标签消息");
```

### 堆栈跟踪

```dart
// 打印当前堆栈
Timber.stack();

// 打印异常堆栈
try {
  riskyOperation();
} catch (e, stackTrace) {
  Timber.e("操作失败: $e");
  Timber.stack(stackTrace);
}
```

## 📖 API概览

### 日志方法

```dart
Timber.v("Verbose");  // 详细信息
Timber.d("Debug");    // 调试信息  
Timber.i("Info");     // 一般信息
Timber.w("Warning");  // 警告信息
Timber.e("Error");    // 错误信息
```

### Tree管理

```dart
// 植入Tree
Timber.plant(DebugTree());

// 植入多个Tree
Timber.plantAll([DebugTree(), CustomTree()]);

// 移除Tree
Timber.uprootAll();
Timber.uproot(specificTree);
```

## 🔧 自定义Tree

```dart
class CustomTree extends Tree {
  @override
  void log(LogLevel level, String message, String? tag, StackTrace? stackTrace) {
    // 自定义日志处理逻辑
    print('${level.name}: $message');
  }
  
  @override
  bool isLogEnabled(LogLevel level) {
    // 自定义日志级别过滤
    return level.index >= LogLevel.info.index;
  }
}

// 使用自定义Tree
Timber.plant(CustomTree());
```

## ⚙️ DebugTree配置

```dart
// 默认配置（启用颜色和自动标签）
Timber.plant(DebugTree());

// 自定义配置
Timber.plant(DebugTree(
  enableColors: true,   // 启用颜色输出
  autoTag: true,        // 启用自动类名标签
));

// 禁用自动标签
Timber.plant(DebugTree(autoTag: false));
```

输出格式：`[HH:mm:ss.SSS] LEVEL [TAG]: message`

### 自动标签说明
- **类方法调用**: 自动提取类名作为标签
- **顶层函数调用**: 自动提取文件名作为标签  
- **手动标签优先**: 使用`Timber.tag()`时会覆盖自动标签
- **Release安全**: 标签解析仅在Debug/Profile模式下执行

## 🔒 Release模式行为

### 工作原理
1. **自动Fallback**: 未植入Tree时自动使用DebugTree
2. **编译时检查**: DebugTree内部使用`dart.vm.product`判断
3. **输出拦截**: Release模式下在log方法内部直接return

### 性能说明
- **Debug模式**: 完整日志功能（格式化+输出）
- **Release模式**: 有轻微方法调用开销，但无格式化和I/O开销

### 推荐做法

```dart
void main() {
  // 方式1：显式植入（推荐，代码更清晰）
  Timber.plant(DebugTree());
  
  // 方式2：什么都不做（依赖自动fallback）
  // 代码会自动使用DebugTree
  
  runApp(MyApp());
}
```

## 🎨 日志颜色

| 级别 | 颜色 | 
|------|------|
| Verbose | 白色/灰色 |
| Debug | 青色/蓝色 |
| Info | 绿色 |
| Warn | 黄色 |
| Error | 红色 |

## 🔧 技术规格

- **Flutter**: >= 3.0.0
- **Dart**: >= 2.17.0

## 📝 许可证

MIT License

---

**重要提醒**: Release模式下日志调用仍有轻微开销（方法调用）可以忽略不计，自动标签解析仅在Debug/Profile模式下执行，如需零开销请手动移除日志调用。
