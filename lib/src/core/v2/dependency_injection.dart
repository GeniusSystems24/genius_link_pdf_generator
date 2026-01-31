import 'dart:async';

/// Lightweight dependency injection container for the PDF generator.
///
/// Supports singleton, factory, and lazy registration patterns.
///
/// ## Example
/// ```dart
/// final container = PdfContainer.instance;
///
/// // Register singleton
/// container.registerSingleton<PdfConfig>(myConfig);
///
/// // Register factory
/// container.registerFactory<PdfService>(() => PdfService());
///
/// // Register lazy singleton
/// container.registerLazySingleton<PdfTemplateEngine>(() {
///   return PdfTemplateEngine(config: container.get<GeniusPdfConfig>());
/// });
///
/// // Resolve dependencies
/// final config = container.get<PdfConfig>();
/// final service = container.get<PdfService>();
/// ```
class GeniusPdfContainer {
  GeniusPdfContainer._();

  static GeniusPdfContainer? _instance;

  /// Singleton instance.
  static GeniusPdfContainer get instance {
    _instance ??= GeniusPdfContainer._();
    return _instance!;
  }

  /// Reset the container.
  static void reset() {
    _instance?._clear();
    _instance = null;
  }

  final Map<Type, _Registration> _registrations = {};
  final Map<Type, dynamic> _singletons = {};
  final Map<String, _Registration> _namedRegistrations = {};
  final Map<String, dynamic> _namedSingletons = {};

  /// Registers a singleton instance.
  void registerSingleton<T>(T instance, {String? name}) {
    if (name != null) {
      _namedSingletons[name] = instance;
      _namedRegistrations[name] = _Registration<T>(
        type: _RegistrationType.singleton,
        factory: () => instance,
      );
    } else {
      _singletons[T] = instance;
      _registrations[T] = _Registration<T>(
        type: _RegistrationType.singleton,
        factory: () => instance,
      );
    }
  }

  /// Registers a factory that creates a new instance each time.
  void registerFactory<T>(T Function() factory, {String? name}) {
    if (name != null) {
      _namedRegistrations[name] = _Registration<T>(
        type: _RegistrationType.factory,
        factory: factory,
      );
    } else {
      _registrations[T] = _Registration<T>(
        type: _RegistrationType.factory,
        factory: factory,
      );
    }
  }

  /// Registers a lazy singleton (created on first access).
  void registerLazySingleton<T>(T Function() factory, {String? name}) {
    if (name != null) {
      _namedRegistrations[name] = _Registration<T>(
        type: _RegistrationType.lazySingleton,
        factory: factory,
      );
    } else {
      _registrations[T] = _Registration<T>(
        type: _RegistrationType.lazySingleton,
        factory: factory,
      );
    }
  }

  /// Registers an async factory.
  void registerAsyncFactory<T>(Future<T> Function() factory, {String? name}) {
    if (name != null) {
      _namedRegistrations[name] = _Registration<T>(
        type: _RegistrationType.asyncFactory,
        asyncFactory: factory,
      );
    } else {
      _registrations[T] = _Registration<T>(
        type: _RegistrationType.asyncFactory,
        asyncFactory: factory,
      );
    }
  }

  /// Gets an instance of type [T].
  T get<T>({String? name}) {
    if (name != null) {
      return _resolveNamed<T>(name);
    }
    return _resolve<T>();
  }

  /// Gets an instance asynchronously.
  Future<T> getAsync<T>({String? name}) async {
    if (name != null) {
      return _resolveNamedAsync<T>(name);
    }
    return _resolveAsync<T>();
  }

  /// Tries to get an instance, returns null if not registered.
  T? tryGet<T>({String? name}) {
    try {
      return get<T>(name: name);
    } catch (_) {
      return null;
    }
  }

  /// Checks if a type is registered.
  bool isRegistered<T>({String? name}) {
    if (name != null) {
      return _namedRegistrations.containsKey(name);
    }
    return _registrations.containsKey(T);
  }

  /// Unregisters a type.
  void unregister<T>({String? name}) {
    if (name != null) {
      _namedRegistrations.remove(name);
      _namedSingletons.remove(name);
    } else {
      _registrations.remove(T);
      _singletons.remove(T);
    }
  }

  T _resolve<T>() {
    // Check for singleton first
    if (_singletons.containsKey(T)) {
      return _singletons[T] as T;
    }

    final registration = _registrations[T];
    if (registration == null) {
      throw GeniusDependencyException('No registration found for type $T');
    }

    switch (registration.type) {
      case _RegistrationType.singleton:
        return _singletons[T] as T;

      case _RegistrationType.factory:
        return registration.factory!() as T;

      case _RegistrationType.lazySingleton:
        if (!_singletons.containsKey(T)) {
          _singletons[T] = registration.factory!();
        }
        return _singletons[T] as T;

      case _RegistrationType.asyncFactory:
        throw GeniusDependencyException(
          'Use getAsync() for async factories: $T',
        );
    }
  }

  Future<T> _resolveAsync<T>() async {
    // Check for singleton first
    if (_singletons.containsKey(T)) {
      return _singletons[T] as T;
    }

    final registration = _registrations[T];
    if (registration == null) {
      throw GeniusDependencyException('No registration found for type $T');
    }

    switch (registration.type) {
      case _RegistrationType.singleton:
        return _singletons[T] as T;

      case _RegistrationType.factory:
        return registration.factory!() as T;

      case _RegistrationType.lazySingleton:
        if (!_singletons.containsKey(T)) {
          _singletons[T] = registration.factory!();
        }
        return _singletons[T] as T;

      case _RegistrationType.asyncFactory:
        return await registration.asyncFactory!() as T;
    }
  }

  T _resolveNamed<T>(String name) {
    if (_namedSingletons.containsKey(name)) {
      return _namedSingletons[name] as T;
    }

    final registration = _namedRegistrations[name];
    if (registration == null) {
      throw GeniusDependencyException('No registration found for name: $name');
    }

    switch (registration.type) {
      case _RegistrationType.singleton:
        return _namedSingletons[name] as T;

      case _RegistrationType.factory:
        return registration.factory!() as T;

      case _RegistrationType.lazySingleton:
        if (!_namedSingletons.containsKey(name)) {
          _namedSingletons[name] = registration.factory!();
        }
        return _namedSingletons[name] as T;

      case _RegistrationType.asyncFactory:
        throw GeniusDependencyException(
          'Use getAsync() for async factories: $name',
        );
    }
  }

  Future<T> _resolveNamedAsync<T>(String name) async {
    if (_namedSingletons.containsKey(name)) {
      return _namedSingletons[name] as T;
    }

    final registration = _namedRegistrations[name];
    if (registration == null) {
      throw GeniusDependencyException('No registration found for name: $name');
    }

    switch (registration.type) {
      case _RegistrationType.singleton:
        return _namedSingletons[name] as T;

      case _RegistrationType.factory:
        return registration.factory!() as T;

      case _RegistrationType.lazySingleton:
        if (!_namedSingletons.containsKey(name)) {
          _namedSingletons[name] = registration.factory!();
        }
        return _namedSingletons[name] as T;

      case _RegistrationType.asyncFactory:
        return await registration.asyncFactory!() as T;
    }
  }

  void _clear() {
    _registrations.clear();
    _singletons.clear();
    _namedRegistrations.clear();
    _namedSingletons.clear();
  }
}

enum _RegistrationType {
  singleton,
  factory,
  lazySingleton,
  asyncFactory,
}

class _Registration<T> {
  const _Registration({
    required this.type,
    this.factory,
    this.asyncFactory,
  });

  final _RegistrationType type;
  final T Function()? factory;
  final Future<T> Function()? asyncFactory;
}

/// Exception thrown when dependency resolution fails.
class GeniusDependencyException implements Exception {
  const GeniusDependencyException(this.message);

  final String message;

  @override
  String toString() => 'DependencyException: $message';
}

/// Service locator mixin for easy access to dependencies.
mixin GeniusServiceLocator {
  /// Gets an instance from the container.
  T resolve<T>({String? name}) => GeniusPdfContainer.instance.get<T>(name: name);

  /// Gets an instance asynchronously.
  Future<T> resolveAsync<T>({String? name}) =>
      GeniusPdfContainer.instance.getAsync<T>(name: name);

  /// Tries to get an instance, returns null if not found.
  T? tryResolve<T>({String? name}) =>
      GeniusPdfContainer.instance.tryGet<T>(name: name);
}

/// Shorthand function for getting dependencies.
T inject<T>({String? name}) => GeniusPdfContainer.instance.get<T>(name: name);

/// Shorthand function for getting async dependencies.
Future<T> injectAsync<T>({String? name}) =>
    GeniusPdfContainer.instance.getAsync<T>(name: name);
