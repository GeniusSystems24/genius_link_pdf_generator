import 'dart:async';

/// Base interface for all PDF generator plugins.
///
/// Plugins extend the functionality of the PDF generator by providing
/// additional features like custom components, templates, or exporters.
///
/// ## Example
/// ```dart
/// class MyCustomPlugin extends GeniusPdfPlugin {
///   @override
///   String get id => 'my-custom-plugin';
///
///   @override
///   String get name => 'Custom Components';
///
///   @override
///   Future<void> initialize() async {
///     // Register custom components
///   }
/// }
/// ```
abstract class GeniusPdfPlugin {
  /// Unique identifier for this plugin.
  String get id;

  /// Human-readable name.
  String get name;

  /// Plugin version.
  String get version => '1.0.0';

  /// Plugin description.
  String get description => '';

  /// Dependencies on other plugins (by ID).
  List<String> get dependencies => [];

  /// Plugin priority (higher = loaded first).
  int get priority => 0;

  /// Whether this plugin is enabled.
  bool get isEnabled => true;

  /// Called when the plugin is initialized.
  Future<void> initialize();

  /// Called when the plugin is disposed.
  Future<void> dispose() async {}

  /// Called when the plugin is enabled.
  void onEnable() {}

  /// Called when the plugin is disabled.
  void onDisable() {}
}

/// Plugin manager for registering and managing plugins.
///
/// ## Example
/// ```dart
/// final manager = GeniusPluginManager.instance;
///
/// // Register plugins
/// await manager.register(MyCustomPlugin());
/// await manager.register(MyTemplatePlugin());
///
/// // Initialize all plugins
/// await manager.initializeAll();
///
/// // Get a specific plugin
/// final plugin = manager.get<MyCustomPlugin>('my-custom-plugin');
/// ```
class GeniusPluginManager {
  GeniusPluginManager._();

  static GeniusPluginManager? _instance;

  /// Singleton instance.
  static GeniusPluginManager get instance {
    _instance ??= GeniusPluginManager._();
    return _instance!;
  }

  /// Reset the singleton instance.
  static void resetInstance() {
    _instance?._dispose();
    _instance = null;
  }

  final Map<String, GeniusPdfPlugin> _plugins = {};
  final Map<String, bool> _initialized = {};
  final _eventController = StreamController<GeniusPluginEvent>.broadcast();

  /// Stream of plugin events.
  Stream<GeniusPluginEvent> get events => _eventController.stream;

  /// All registered plugins.
  List<GeniusPdfPlugin> get plugins => _plugins.values.toList();

  /// All registered plugin IDs.
  List<String> get pluginIds => _plugins.keys.toList();

  /// Number of registered plugins.
  int get count => _plugins.length;

  /// Registers a plugin.
  ///
  /// Returns true if registration was successful.
  Future<bool> register(GeniusPdfPlugin plugin) async {
    if (_plugins.containsKey(plugin.id)) {
      _eventController.add(GeniusPluginEvent(
        type: GeniusPluginEventType.error,
        pluginId: plugin.id,
        message: 'Plugin already registered: ${plugin.id}',
      ));
      return false;
    }

    // Check dependencies
    for (final depId in plugin.dependencies) {
      if (!_plugins.containsKey(depId)) {
        _eventController.add(GeniusPluginEvent(
          type: GeniusPluginEventType.error,
          pluginId: plugin.id,
          message: 'Missing dependency: $depId',
        ));
        return false;
      }
    }

    _plugins[plugin.id] = plugin;
    _initialized[plugin.id] = false;

    _eventController.add(GeniusPluginEvent(
      type: GeniusPluginEventType.registered,
      pluginId: plugin.id,
      message: 'Plugin registered: ${plugin.name}',
    ));

    return true;
  }

  /// Unregisters a plugin.
  Future<bool> unregister(String pluginId) async {
    final plugin = _plugins[pluginId];
    if (plugin == null) return false;

    // Check if other plugins depend on this one
    for (final other in _plugins.values) {
      if (other.dependencies.contains(pluginId)) {
        _eventController.add(GeniusPluginEvent(
          type: GeniusPluginEventType.error,
          pluginId: pluginId,
          message: 'Cannot unregister: ${other.id} depends on this plugin',
        ));
        return false;
      }
    }

    if (_initialized[pluginId] == true) {
      await plugin.dispose();
    }

    _plugins.remove(pluginId);
    _initialized.remove(pluginId);

    _eventController.add(GeniusPluginEvent(
      type: GeniusPluginEventType.unregistered,
      pluginId: pluginId,
      message: 'Plugin unregistered: ${plugin.name}',
    ));

    return true;
  }

  /// Gets a plugin by ID.
  T? get<T extends GeniusPdfPlugin>(String pluginId) {
    return _plugins[pluginId] as T?;
  }

  /// Checks if a plugin is registered.
  bool has(String pluginId) => _plugins.containsKey(pluginId);

  /// Checks if a plugin is initialized.
  bool isInitialized(String pluginId) => _initialized[pluginId] == true;

  /// Initializes a specific plugin.
  Future<bool> initialize(String pluginId) async {
    final plugin = _plugins[pluginId];
    if (plugin == null) return false;

    if (_initialized[pluginId] == true) return true;

    // Initialize dependencies first
    for (final depId in plugin.dependencies) {
      if (_initialized[depId] != true) {
        final success = await initialize(depId);
        if (!success) return false;
      }
    }

    try {
      _eventController.add(GeniusPluginEvent(
        type: GeniusPluginEventType.initializing,
        pluginId: pluginId,
        message: 'Initializing: ${plugin.name}',
      ));

      await plugin.initialize();
      _initialized[pluginId] = true;

      _eventController.add(GeniusPluginEvent(
        type: GeniusPluginEventType.initialized,
        pluginId: pluginId,
        message: 'Initialized: ${plugin.name}',
      ));

      return true;
    } catch (e) {
      _eventController.add(GeniusPluginEvent(
        type: GeniusPluginEventType.error,
        pluginId: pluginId,
        message: 'Initialization failed: $e',
      ));
      return false;
    }
  }

  /// Initializes all registered plugins.
  Future<void> initializeAll() async {
    // Sort by priority (higher first)
    final sorted = _plugins.values.toList()
      ..sort((a, b) => b.priority.compareTo(a.priority));

    for (final plugin in sorted) {
      if (plugin.isEnabled && !isInitialized(plugin.id)) {
        await initialize(plugin.id);
      }
    }
  }

  /// Enables a plugin.
  void enable(String pluginId) {
    final plugin = _plugins[pluginId];
    if (plugin != null) {
      plugin.onEnable();
      _eventController.add(GeniusPluginEvent(
        type: GeniusPluginEventType.enabled,
        pluginId: pluginId,
      ));
    }
  }

  /// Disables a plugin.
  void disable(String pluginId) {
    final plugin = _plugins[pluginId];
    if (plugin != null) {
      plugin.onDisable();
      _eventController.add(GeniusPluginEvent(
        type: GeniusPluginEventType.disabled,
        pluginId: pluginId,
      ));
    }
  }

  void _dispose() {
    for (final plugin in _plugins.values) {
      plugin.dispose();
    }
    _plugins.clear();
    _initialized.clear();
    _eventController.close();
  }
}

/// Event types for plugin lifecycle.
enum GeniusPluginEventType {
  registered,
  unregistered,
  initializing,
  initialized,
  enabled,
  disabled,
  error,
}

/// Plugin lifecycle event.
class GeniusPluginEvent {
  const GeniusPluginEvent({
    required this.type,
    required this.pluginId,
    this.message,
    this.data,
  });

  final GeniusPluginEventType type;
  final String pluginId;
  final String? message;
  final dynamic data;

  @override
  String toString() => 'PluginEvent($type, $pluginId, $message)';
}

/// Base class for component plugins.
abstract class GeniusComponentPlugin extends GeniusPdfPlugin {
  /// Register components provided by this plugin.
  void registerComponents();
}

/// Base class for template plugins.
abstract class GeniusTemplatePlugin extends GeniusPdfPlugin {
  /// Register templates provided by this plugin.
  void registerTemplates();
}

/// Base class for exporter plugins.
abstract class GeniusExporterPlugin extends GeniusPdfPlugin {
  /// Supported export formats.
  List<String> get supportedFormats;

  /// Register exporters provided by this plugin.
  void registerExporters();
}
