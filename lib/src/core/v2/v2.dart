/// PDF Generator v2 Architecture
///
/// This module provides the new v2 architecture with:
/// - Plugin system for extensibility
/// - Dependency injection container
/// - Event-driven architecture
/// - Enhanced Fluent API
/// - Smart caching system
/// - Platform compatibility
///
/// ## Quick Start
/// ```dart
/// import 'package:genius_link_pdf_generator/v2.dart';
///
/// // Build a PDF with the Fluent API
/// final pdf = PdfBuilder()
///   .metadata(title: 'Report', author: 'System')
///   .rtl(true)
///   .addPage((page) => page
///     .header('Monthly Report')
///     .paragraph('Content here...')
///     .table([['Name', 'Value'], ['Item', '100']]))
///   .build();
///
/// // Listen to events
/// PdfEventBus.instance.on<DocumentCreatedEvent>().listen((e) {
///   print('Document created: ${e.documentId}');
/// });
///
/// // Use plugins
/// await PluginManager.instance.register(MyPlugin());
/// await PluginManager.instance.initializeAll();
///
/// // Use DI container
/// PdfContainer.instance.registerSingleton<MyService>(myService);
/// final service = inject<MyService>();
/// ```
library;

export 'plugin_system.dart';
export 'dependency_injection.dart';
export 'event_system.dart';
export 'fluent_api.dart';
export 'cache_system.dart';
export 'platform_utils.dart';
