/// Flutter Timber - A logging utility inspired by Android Timber
/// 
/// Provides a simple and extensible API for logging with tree-based output 
/// strategies for debug builds only.
/// 
/// Example usage:
/// ```dart
/// import 'package:flutter_timber/flutter_timber.dart';
/// 
/// void main() {
///   // Plant a debug tree for development
///   Timber.plant(DebugTree());
///   
///   // Log messages
///   Timber.d("Debug message");
///   Timber.i("Info message");
///   Timber.w("Warning message");
///   Timber.e("Error message");
///   
///   // Log with tags
///   Timber.tag("Network").d("Request completed");
///   Timber.tag("Database").i("Query executed");
///   
///   // Print stack trace
///   Timber.stack();
/// }
/// ```
library flutter_timber;

// Core exports
export 'src/timber.dart';
export 'src/tree.dart';
export 'src/debug_tree.dart';
export 'src/tagged_logger.dart';
export 'src/log_level.dart';
