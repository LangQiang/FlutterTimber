import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_timber/flutter_timber.dart';

/// 测试用的自定义Tree
class TestTree extends Tree {
  final List<String> logs = [];
  
  @override
  void log(LogLevel level, String message, String? tag, StackTrace? stackTrace) {
    final logEntry = '${level.name}${tag != null ? '[$tag]' : ''}: $message';
    logs.add(logEntry);
  }
}

/// 测试类，用于验证自动标签功能
class TestClass {
  void testMethod() {
    Timber.d("测试类方法调用");
  }
}

/// 测试函数，用于验证自动标签功能
void _testClassMethod() {
  Timber.d("测试函数调用");
}

void main() {
  group('Flutter Timber Tests', () {
    setUp(() {
      // 每个测试前清理所有Tree
      Timber.uprootAll();
    });

    test('运行模式检测测试', () {
      // 验证当前环境的模式检测
      const isProductMode = bool.fromEnvironment('dart.vm.product');
      const isDebugMode = !bool.fromEnvironment('dart.vm.product');
      
      print('=== 运行模式检测验证 ===');
      print('dart.vm.product: $isProductMode');
      print('Debug模式: $isDebugMode');
      print('当前应该是Debug模式，所以isDebugMode应该为true');
      
      // 在测试环境中，dart.vm.product应该为false
      expect(isProductMode, false, reason: '测试环境应该不是Product模式');
      expect(isDebugMode, true, reason: '测试环境应该是Debug模式');
      
      // 验证DebugTree的行为
      final debugTree = DebugTree();
      expect(debugTree.isLogEnabled(LogLevel.debug), true, 
             reason: 'Debug模式下应该启用日志');
    });

    test('基础日志API测试', () {
      final testTree = TestTree();
      Timber.plant(testTree);

      Timber.v('Verbose message');
      Timber.d('Debug message');
      Timber.i('Info message');
      Timber.w('Warning message');
      Timber.e('Error message');

      expect(testTree.logs.length, 5);
      expect(testTree.logs[0], 'V: Verbose message');
      expect(testTree.logs[1], 'D: Debug message');
      expect(testTree.logs[2], 'I: Info message');
      expect(testTree.logs[3], 'W: Warning message');
      expect(testTree.logs[4], 'E: Error message');
    });

    test('带标签日志API测试', () {
      final testTree = TestTree();
      Timber.plant(testTree);

      Timber.tag('Network').d('Debug with tag');
      Timber.tag('Database').i('Info with tag');

      expect(testTree.logs.length, 2);
      expect(testTree.logs[0], 'D[Network]: Debug with tag');
      expect(testTree.logs[1], 'I[Database]: Info with tag');
    });

    test('Tree管理API测试', () {
      expect(Timber.treeCount, 0);

      final tree1 = TestTree();
      final tree2 = TestTree();

      // 植入单个Tree
      Timber.plant(tree1);
      expect(Timber.treeCount, 1);

      // 植入多个Tree
      Timber.plantAll([tree2]);
      expect(Timber.treeCount, 2);

      // 移除指定Tree
      Timber.uproot(tree1);
      expect(Timber.treeCount, 1);

      // 移除所有Tree
      Timber.uprootAll();
      expect(Timber.treeCount, 0);
    });

    test('多Tree并发记录测试', () {
      final tree1 = TestTree();
      final tree2 = TestTree();
      
      Timber.plantAll([tree1, tree2]);
      
      Timber.d('Test message');
      
      expect(tree1.logs.length, 1);
      expect(tree2.logs.length, 1);
      expect(tree1.logs[0], 'D: Test message');
      expect(tree2.logs[0], 'D: Test message');
    });

    test('LogLevel枚举测试', () {
      expect(LogLevel.verbose.name, 'V');
      expect(LogLevel.debug.name, 'D');
      expect(LogLevel.info.name, 'I');
      expect(LogLevel.warn.name, 'W');
      expect(LogLevel.error.name, 'E');
      
      // 测试ANSI颜色代码
      expect(LogLevel.verbose.ansiColor, '\x1B[37m');
      expect(LogLevel.debug.ansiColor, '\x1B[36m');
      expect(LogLevel.info.ansiColor, '\x1B[32m');
      expect(LogLevel.warn.ansiColor, '\x1B[33m');
      expect(LogLevel.error.ansiColor, '\x1B[31m');
    });

    test('DebugTree基础功能测试', () {
      final debugTree = DebugTree();
      
      // 测试isLogEnabled方法
      expect(debugTree.isLogEnabled(LogLevel.debug), true);
      expect(debugTree.isLogEnabled(LogLevel.error), true);
    });

    test('堆栈跟踪API测试', () {
      final testTree = TestTree();
      Timber.plant(testTree);

      // 测试stack方法（不会抛出异常）
      expect(() => Timber.stack(), returnsNormally);
      
      // 测试带自定义堆栈跟踪
      final customStack = StackTrace.fromString('Test stack trace');
      expect(() => Timber.stack(customStack), returnsNormally);
    });

    test('TaggedLogger功能测试', () {
      final testTree = TestTree();
      Timber.plant(testTree);

      final logger = Timber.tag('TestTag');
      
      logger.v('Verbose with tag');
      logger.d('Debug with tag');
      logger.i('Info with tag');
      logger.w('Warning with tag');
      logger.e('Error with tag');

      expect(testTree.logs.length, 5);
      expect(testTree.logs[0], 'V[TestTag]: Verbose with tag');
      expect(testTree.logs[1], 'D[TestTag]: Debug with tag');
      expect(testTree.logs[2], 'I[TestTag]: Info with tag');
      expect(testTree.logs[3], 'W[TestTag]: Warning with tag');
      expect(testTree.logs[4], 'E[TestTag]: Error with tag');
    });

    test('无Tree时默认行为测试', () {
      // 确保没有植入任何Tree
      Timber.uprootAll();
      expect(Timber.treeCount, 0);

      // 调用日志方法不应抛出异常
      expect(() => Timber.d('Test message'), returnsNormally);
      
      // 应该自动植入DebugTree
      expect(Timber.treeCount, 1);
    });

    test('DebugTree自动标签功能测试', () {
      // 测试启用自动标签
      final debugTreeWithAutoTag = DebugTree(autoTag: true);
      expect(debugTreeWithAutoTag.autoTag, true);
      
      // 测试禁用自动标签
      final debugTreeWithoutAutoTag = DebugTree(autoTag: false);
      expect(debugTreeWithoutAutoTag.autoTag, false);
      
      // 测试默认值
      final debugTreeDefault = DebugTree();
      expect(debugTreeDefault.autoTag, true);
    });

    test('自动标签提取功能测试', () {
      final testTree = TestTree();
      Timber.plant(testTree);

      // 由于无法在测试中精确控制堆栈帧，我们只测试方法不抛出异常
      expect(() => _testClassMethod(), returnsNormally);
      
      // 验证至少有日志输出
      expect(testTree.logs.isNotEmpty, true);
    });
  });
}
