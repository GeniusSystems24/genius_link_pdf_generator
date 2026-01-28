import 'dart:async';
import 'dart:collection';

/// Smart caching system for PDF generator performance optimization.
///
/// Supports multiple caching strategies and automatic cache management.
///
/// ## Example
/// ```dart
/// final cache = PdfCache.instance;
///
/// // Cache a computed value
/// cache.set('template_123', renderedTemplate, ttl: Duration(minutes: 5));
///
/// // Get cached value
/// final template = cache.get<Widget>('template_123');
///
/// // Use compute-if-absent pattern
/// final result = await cache.getOrCompute(
///   'expensive_computation',
///   () => computeExpensiveValue(),
/// );
/// ```
class GeniusPdfCache {
  GeniusPdfCache._();

  static GeniusPdfCache? _instance;

  /// Singleton instance.
  static GeniusPdfCache get instance {
    _instance ??= GeniusPdfCache._();
    return _instance!;
  }

  /// Reset the cache.
  static void reset() {
    _instance?.clear();
    _instance = null;
  }

  final Map<String, _CacheEntry> _entries = {};
  final Map<String, int> _accessCount = {};
  int _maxSize = 100;
  GeniusCacheStrategy _strategy = GeniusCacheStrategy.lru;
  Timer? _cleanupTimer;

  /// Sets the maximum cache size.
  void setMaxSize(int size) {
    _maxSize = size;
    _enforceLimit();
  }

  /// Sets the caching strategy.
  void setStrategy(GeniusCacheStrategy strategy) {
    _strategy = strategy;
  }

  /// Gets a cached value.
  T? get<T>(String key) {
    final entry = _entries[key];
    if (entry == null) return null;

    // Check if expired
    if (entry.isExpired) {
      _entries.remove(key);
      _accessCount.remove(key);
      return null;
    }

    // Update access tracking
    _accessCount[key] = (_accessCount[key] ?? 0) + 1;
    entry.lastAccessed = DateTime.now();

    return entry.value as T?;
  }

  /// Sets a cached value.
  void set<T>(
    String key,
    T value, {
    Duration? ttl,
    GeniusCachePriority priority = GeniusCachePriority.normal,
  }) {
    _enforceLimit();

    _entries[key] = _CacheEntry(
      value: value,
      createdAt: DateTime.now(),
      lastAccessed: DateTime.now(),
      expiresAt: ttl != null ? DateTime.now().add(ttl) : null,
      priority: priority,
    );
    _accessCount[key] = 0;
  }

  /// Gets a value or computes it if not cached.
  T getOrSet<T>(
    String key,
    T Function() compute, {
    Duration? ttl,
    GeniusCachePriority priority = GeniusCachePriority.normal,
  }) {
    final cached = get<T>(key);
    if (cached != null) return cached;

    final value = compute();
    set(key, value, ttl: ttl, priority: priority);
    return value;
  }

  /// Gets a value or computes it asynchronously if not cached.
  Future<T> getOrCompute<T>(
    String key,
    Future<T> Function() compute, {
    Duration? ttl,
    GeniusCachePriority priority = GeniusCachePriority.normal,
  }) async {
    final cached = get<T>(key);
    if (cached != null) return cached;

    final value = await compute();
    set(key, value, ttl: ttl, priority: priority);
    return value;
  }

  /// Checks if a key exists and is valid.
  bool has(String key) {
    final entry = _entries[key];
    if (entry == null) return false;
    if (entry.isExpired) {
      _entries.remove(key);
      return false;
    }
    return true;
  }

  /// Removes a cached value.
  void remove(String key) {
    _entries.remove(key);
    _accessCount.remove(key);
  }

  /// Removes entries matching a pattern.
  void removeWhere(bool Function(String key) predicate) {
    final keysToRemove = _entries.keys.where(predicate).toList();
    for (final key in keysToRemove) {
      remove(key);
    }
  }

  /// Removes entries with a specific prefix.
  void removeByPrefix(String prefix) {
    removeWhere((key) => key.startsWith(prefix));
  }

  /// Clears all cached values.
  void clear() {
    _entries.clear();
    _accessCount.clear();
  }

  /// Gets cache statistics.
  GeniusCacheStats get stats {
    int expiredCount = 0;
    for (final entry in _entries.values) {
      if (entry.isExpired) expiredCount++;
    }

    return GeniusCacheStats(
      totalEntries: _entries.length,
      expiredEntries: expiredCount,
      maxSize: _maxSize,
      strategy: _strategy,
    );
  }

  /// Starts automatic cleanup.
  void startAutoCleanup({Duration interval = const Duration(minutes: 5)}) {
    stopAutoCleanup();
    _cleanupTimer = Timer.periodic(interval, (_) => _cleanup());
  }

  /// Stops automatic cleanup.
  void stopAutoCleanup() {
    _cleanupTimer?.cancel();
    _cleanupTimer = null;
  }

  void _cleanup() {
    // Remove expired entries
    final expiredKeys = _entries.entries
        .where((e) => e.value.isExpired)
        .map((e) => e.key)
        .toList();

    for (final key in expiredKeys) {
      remove(key);
    }
  }

  void _enforceLimit() {
    if (_entries.length < _maxSize) return;

    // Select entries to remove based on strategy
    switch (_strategy) {
      case GeniusCacheStrategy.lru:
        _evictLRU();
        break;
      case GeniusCacheStrategy.lfu:
        _evictLFU();
        break;
      case GeniusCacheStrategy.fifo:
        _evictFIFO();
        break;
      case GeniusCacheStrategy.priority:
        _evictByPriority();
        break;
    }
  }

  void _evictLRU() {
    // Remove least recently used
    final sorted = _entries.entries.toList()
      ..sort((a, b) => a.value.lastAccessed.compareTo(b.value.lastAccessed));

    if (sorted.isNotEmpty) {
      remove(sorted.first.key);
    }
  }

  void _evictLFU() {
    // Remove least frequently used
    final sorted = _accessCount.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));

    if (sorted.isNotEmpty) {
      remove(sorted.first.key);
    }
  }

  void _evictFIFO() {
    // Remove oldest
    final sorted = _entries.entries.toList()
      ..sort((a, b) => a.value.createdAt.compareTo(b.value.createdAt));

    if (sorted.isNotEmpty) {
      remove(sorted.first.key);
    }
  }

  void _evictByPriority() {
    // Remove lowest priority first
    final sorted = _entries.entries.toList()
      ..sort((a, b) => a.value.priority.index.compareTo(b.value.priority.index));

    if (sorted.isNotEmpty) {
      remove(sorted.first.key);
    }
  }
}

class _CacheEntry {
  _CacheEntry({
    required this.value,
    required this.createdAt,
    required this.lastAccessed,
    this.expiresAt,
    this.priority = GeniusCachePriority.normal,
  });

  final dynamic value;
  final DateTime createdAt;
  DateTime lastAccessed;
  final DateTime? expiresAt;
  final GeniusCachePriority priority;

  bool get isExpired =>
      expiresAt != null && DateTime.now().isAfter(expiresAt!);
}

/// Cache eviction strategies.
enum GeniusCacheStrategy {
  /// Least Recently Used - removes items not accessed recently.
  lru,

  /// Least Frequently Used - removes items with fewest accesses.
  lfu,

  /// First In First Out - removes oldest items.
  fifo,

  /// Priority-based - removes lowest priority items first.
  priority,
}

/// Cache entry priority levels.
enum GeniusCachePriority {
  low,
  normal,
  high,
  critical,
}

/// Cache statistics.
class GeniusCacheStats {
  const GeniusCacheStats({
    required this.totalEntries,
    required this.expiredEntries,
    required this.maxSize,
    required this.strategy,
  });

  final int totalEntries;
  final int expiredEntries;
  final int maxSize;
  final GeniusCacheStrategy strategy;

  int get activeEntries => totalEntries - expiredEntries;
  double get fillRatio => maxSize > 0 ? totalEntries / maxSize : 0;

  @override
  String toString() =>
      'CacheStats(active: $activeEntries, expired: $expiredEntries, '
      'fill: ${(fillRatio * 100).toStringAsFixed(1)}%)';
}

// ============================================================================
// Specialized Caches
// ============================================================================

/// Cache specifically for font data.
class GeniusFontCache {
  GeniusFontCache._();

  static GeniusFontCache? _instance;

  static GeniusFontCache get instance {
    _instance ??= GeniusFontCache._();
    return _instance!;
  }

  static void reset() {
    _instance?.clear();
    _instance = null;
  }

  final Map<String, dynamic> _fonts = {};

  /// Caches a font.
  void cache(String fontFamily, dynamic fontData) {
    _fonts[fontFamily] = fontData;
  }

  /// Gets a cached font.
  T? get<T>(String fontFamily) => _fonts[fontFamily] as T?;

  /// Checks if a font is cached.
  bool has(String fontFamily) => _fonts.containsKey(fontFamily);

  /// Removes a cached font.
  void remove(String fontFamily) => _fonts.remove(fontFamily);

  /// Clears all cached fonts.
  void clear() => _fonts.clear();

  /// Number of cached fonts.
  int get count => _fonts.length;
}

/// Cache specifically for images.
class GeniusImageCache {
  GeniusImageCache._();

  static GeniusImageCache? _instance;

  static GeniusImageCache get instance {
    _instance ??= GeniusImageCache._();
    return _instance!;
  }

  static void reset() {
    _instance?.clear();
    _instance = null;
  }

  final Map<String, dynamic> _images = {};
  int _maxSize = 50;

  /// Sets the maximum number of cached images.
  void setMaxSize(int size) {
    _maxSize = size;
    _enforceLimit();
  }

  /// Caches an image.
  void cache(String key, dynamic imageData) {
    _enforceLimit();
    _images[key] = imageData;
  }

  /// Gets a cached image.
  T? get<T>(String key) => _images[key] as T?;

  /// Checks if an image is cached.
  bool has(String key) => _images.containsKey(key);

  /// Removes a cached image.
  void remove(String key) => _images.remove(key);

  /// Clears all cached images.
  void clear() => _images.clear();

  /// Number of cached images.
  int get count => _images.length;

  void _enforceLimit() {
    while (_images.length >= _maxSize) {
      _images.remove(_images.keys.first);
    }
  }
}

/// Cache for template precompilation results.
class GeniusTemplateCache {
  GeniusTemplateCache._();

  static GeniusTemplateCache? _instance;

  static GeniusTemplateCache get instance {
    _instance ??= GeniusTemplateCache._();
    return _instance!;
  }

  static void reset() {
    _instance?.clear();
    _instance = null;
  }

  final Map<String, _CompiledTemplate> _templates = {};

  /// Caches a compiled template.
  void cache(String templateId, dynamic compiled, {int version = 1}) {
    _templates[templateId] = _CompiledTemplate(
      compiled: compiled,
      version: version,
      cachedAt: DateTime.now(),
    );
  }

  /// Gets a cached template if version matches.
  T? get<T>(String templateId, {int? requiredVersion}) {
    final entry = _templates[templateId];
    if (entry == null) return null;

    if (requiredVersion != null && entry.version != requiredVersion) {
      return null;
    }

    return entry.compiled as T?;
  }

  /// Invalidates a cached template.
  void invalidate(String templateId) {
    _templates.remove(templateId);
  }

  /// Invalidates all templates.
  void clear() => _templates.clear();

  /// Number of cached templates.
  int get count => _templates.length;
}

class _CompiledTemplate {
  const _CompiledTemplate({
    required this.compiled,
    required this.version,
    required this.cachedAt,
  });

  final dynamic compiled;
  final int version;
  final DateTime cachedAt;
}

// ============================================================================
// Memory Pool
// ============================================================================

/// Object pool for reducing allocation overhead.
class GeniusObjectPool<T> {
  GeniusObjectPool({
    required this.factory,
    this.reset,
    int initialSize = 10,
    int maxSize = 100,
  }) : _maxSize = maxSize {
    for (var i = 0; i < initialSize; i++) {
      _pool.add(factory());
    }
  }

  final T Function() factory;
  final void Function(T)? reset;
  final int _maxSize;
  final Queue<T> _pool = Queue();

  /// Acquires an object from the pool.
  T acquire() {
    if (_pool.isEmpty) {
      return factory();
    }
    return _pool.removeFirst();
  }

  /// Releases an object back to the pool.
  void release(T object) {
    if (_pool.length < _maxSize) {
      reset?.call(object);
      _pool.add(object);
    }
  }

  /// Clears the pool.
  void clear() => _pool.clear();

  /// Current pool size.
  int get size => _pool.length;

  /// Maximum pool size.
  int get maxSize => _maxSize;
}

/// Mixin for classes that support caching.
mixin GeniusCacheable {
  /// Unique cache key for this instance.
  String get cacheKey;

  /// Version for cache invalidation.
  int get cacheVersion => 1;

  /// Time-to-live for cached data.
  Duration? get cacheTtl => null;

  /// Cache priority.
  GeniusCachePriority get cachePriority => GeniusCachePriority.normal;

  /// Stores this instance in cache.
  void storeInCache() {
    GeniusPdfCache.instance.set(
      cacheKey,
      this,
      ttl: cacheTtl,
      priority: cachePriority,
    );
  }

  /// Retrieves from cache.
  static T? fromCache<T>(String key) {
    return GeniusPdfCache.instance.get<T>(key);
  }
}
