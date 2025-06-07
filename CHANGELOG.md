# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-01-01

### Added
- **🎉 初始版本发布**
- **🌳 Tree模式支持**: 通过 `Timber.plant(tree)` 管理日志输出策略
- **🚀 静态Facade API**: 提供全局静态调用方式
  - `Timber.v()` - Verbose级别日志
  - `Timber.d()` - Debug级别日志  
  - `Timber.i()` - Info级别日志
  - `Timber.w()` - Warning级别日志
  - `Timber.e()` - Error级别日志
- **🏷️ 标签支持**: 通过 `Timber.tag()` 创建带标签的日志器
- **📚 堆栈跟踪**: `Timber.stack()` 方法支持堆栈跟踪输出
- **🎨 DebugTree实现**: 
  - 仅在Debug模式下输出日志
  - 支持IDEA颜色方案（5种颜色）
  - 输出格式: `[HH:mm:ss.SSS] LEVEL [TAG]: message`
  - 可选择启用/禁用颜色输出
- **🔒 Release模式安全**: 通过 `kReleaseMode` 自动禁用输出
- **🛡️ 线程安全**: 内置同步机制确保多线程环境安全
- **📦 Tree管理API**:
  - `Timber.plant()` - 植入单个Tree
  - `Timber.plantAll()` - 植入多个Tree
  - `Timber.uprootAll()` - 移除所有Tree
  - `Timber.uproot()` - 移除指定Tree
  - `Timber.treeCount` - 获取Tree数量
- **🎯 核心类架构**:
  - `Timber` - 主入口类
  - `Tree` - 抽象基类
  - `DebugTree` - 调试Tree实现
  - `TaggedLogger` - 标签日志器
  - `LogLevel` - 日志级别枚举
- **📚 完整示例**: 提供详细的使用示例和文档
- **🔧 技术规范**: 
  - Flutter >= 3.0.0 支持
  - Dart >= 2.17.0 支持
  - 仅支持Flutter项目

### Features
- 借鉴Android Timber设计理念，采用Dart化实现
- 支持自定义Tree扩展
- 优化的性能表现，避免不必要的字符串处理
- 完整的API文档和使用指南

### Documentation
- 详细的README.md文档
- 完整的API参考
- 最佳实践指南
- 丰富的使用示例

---

## [Unreleased]

### Planned
- 更多内置Tree实现
- 日志过滤功能
- 性能优化
- 更多自定义选项
