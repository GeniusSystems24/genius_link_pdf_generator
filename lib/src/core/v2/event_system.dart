import 'dart:async';

/// Event-driven architecture for PDF generator.
///
/// Provides a centralized event bus for loose coupling between components.
///
/// ## Example
/// ```dart
/// final eventBus = PdfEventBus.instance;
///
/// // Subscribe to events
/// eventBus.on<DocumentCreatedEvent>().listen((event) {
///   print('Document created: ${event.documentId}');
/// });
///
/// // Emit events
/// eventBus.emit(DocumentCreatedEvent(documentId: '123'));
/// ```
class GeniusPdfEventBus {
  GeniusPdfEventBus._();

  static GeniusPdfEventBus? _instance;

  /// Singleton instance.
  static GeniusPdfEventBus get instance {
    _instance ??= GeniusPdfEventBus._();
    return _instance!;
  }

  /// Reset the event bus.
  static void reset() {
    _instance?._dispose();
    _instance = null;
  }

  final _controller = StreamController<GeniusPdfEvent>.broadcast();
  final Map<Type, List<Function>> _handlers = {};
  final List<StreamSubscription> _subscriptions = [];

  /// Stream of all events.
  Stream<GeniusPdfEvent> get events => _controller.stream;

  /// Emits an event to all listeners.
  void emit<T extends GeniusPdfEvent>(T event) {
    if (_controller.isClosed) return;
    _controller.add(event);

    // Call type-specific handlers
    final handlers = _handlers[T];
    if (handlers != null) {
      for (final handler in handlers) {
        try {
          handler(event);
        } catch (_) {
          // Silently ignore handler errors
        }
      }
    }
  }

  /// Emits an event asynchronously.
  Future<void> emitAsync<T extends GeniusPdfEvent>(T event) async {
    emit(event);
    // Allow listeners to process
    await Future.delayed(Duration.zero);
  }

  /// Listens to events of a specific type.
  Stream<T> on<T extends GeniusPdfEvent>() {
    return _controller.stream.where((e) => e is T).cast<T>();
  }

  /// Registers a handler for a specific event type.
  void handle<T extends GeniusPdfEvent>(void Function(T event) handler) {
    _handlers.putIfAbsent(T, () => []);
    _handlers[T]!.add(handler);
  }

  /// Removes a handler.
  void removeHandler<T extends GeniusPdfEvent>(void Function(T event) handler) {
    _handlers[T]?.remove(handler);
  }

  /// Removes all handlers for a type.
  void removeAllHandlers<T extends GeniusPdfEvent>() {
    _handlers.remove(T);
  }

  /// Subscribes to events with automatic cleanup.
  StreamSubscription<T> subscribe<T extends GeniusPdfEvent>(
    void Function(T event) onEvent, {
    void Function(Object error)? onError,
    void Function()? onDone,
  }) {
    final subscription = on<T>().listen(
      onEvent,
      onError: onError,
      onDone: onDone,
    );
    _subscriptions.add(subscription);
    return subscription;
  }

  /// Waits for a specific event type.
  Future<T> waitFor<T extends GeniusPdfEvent>({Duration? timeout}) {
    if (timeout != null) {
      return on<T>().first.timeout(timeout);
    }
    return on<T>().first;
  }

  /// Filters events by a predicate.
  Stream<T> where<T extends GeniusPdfEvent>(bool Function(T event) predicate) {
    return on<T>().where(predicate);
  }

  void _dispose() {
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    _subscriptions.clear();
    _handlers.clear();
    _controller.close();
  }
}

/// Base class for all PDF events.
abstract class GeniusPdfEvent {
  const GeniusPdfEvent({
    DateTime? timestamp,
  }) : timestamp = timestamp;

  /// When the event occurred.
  final DateTime? timestamp;

  /// Event name for logging.
  String get name => runtimeType.toString();

  @override
  String toString() => '$name($timestamp)';
}

// ============================================================================
// Document Events
// ============================================================================

/// Emitted when a document is created.
class GeniusDocumentCreatedEvent extends GeniusPdfEvent {
  const GeniusDocumentCreatedEvent({
    required this.documentId,
    this.title,
  });

  final String documentId;
  final String? title;
}

/// Emitted when a document is modified.
class GeniusDocumentModifiedEvent extends GeniusPdfEvent {
  const GeniusDocumentModifiedEvent({
    required this.documentId,
    required this.changeType,
  });

  final String documentId;
  final String changeType;
}

/// Emitted when a document is saved.
class GeniusDocumentSavedEvent extends GeniusPdfEvent {
  const GeniusDocumentSavedEvent({
    required this.documentId,
    required this.filePath,
    this.fileSize,
  });

  final String documentId;
  final String filePath;
  final int? fileSize;
}

// ============================================================================
// Page Events
// ============================================================================

/// Emitted when a page is added.
class GeniusPageAddedEvent extends GeniusPdfEvent {
  const GeniusPageAddedEvent({
    required this.documentId,
    required this.pageIndex,
  });

  final String documentId;
  final int pageIndex;
}

/// Emitted when a page is removed.
class GeniusPageRemovedEvent extends GeniusPdfEvent {
  const GeniusPageRemovedEvent({
    required this.documentId,
    required this.pageIndex,
  });

  final String documentId;
  final int pageIndex;
}

// ============================================================================
// Render Events
// ============================================================================

/// Emitted when rendering starts.
class GeniusRenderStartedEvent extends GeniusPdfEvent {
  const GeniusRenderStartedEvent({
    required this.documentId,
    this.totalPages,
  });

  final String documentId;
  final int? totalPages;
}

/// Emitted during rendering progress.
class GeniusRenderProgressEvent extends GeniusPdfEvent {
  const GeniusRenderProgressEvent({
    required this.documentId,
    required this.currentPage,
    required this.totalPages,
  });

  final String documentId;
  final int currentPage;
  final int totalPages;

  double get progress => totalPages > 0 ? currentPage / totalPages : 0;
}

/// Emitted when rendering completes.
class GeniusRenderCompletedEvent extends GeniusPdfEvent {
  const GeniusRenderCompletedEvent({
    required this.documentId,
    required this.duration,
    this.outputPath,
  });

  final String documentId;
  final Duration duration;
  final String? outputPath;
}

/// Emitted when rendering fails.
class GeniusRenderFailedEvent extends GeniusPdfEvent {
  const GeniusRenderFailedEvent({
    required this.documentId,
    required this.error,
    this.stackTrace,
  });

  final String documentId;
  final Object error;
  final StackTrace? stackTrace;
}

// ============================================================================
// Export Events
// ============================================================================

/// Emitted when export starts.
class GeniusExportStartedEvent extends GeniusPdfEvent {
  const GeniusExportStartedEvent({
    required this.documentId,
    required this.format,
  });

  final String documentId;
  final String format;
}

/// Emitted when export completes.
class GeniusExportCompletedEvent extends GeniusPdfEvent {
  const GeniusExportCompletedEvent({
    required this.documentId,
    required this.format,
    required this.outputPath,
  });

  final String documentId;
  final String format;
  final String outputPath;
}

// ============================================================================
// Template Events
// ============================================================================

/// Emitted when a template is loaded.
class GeniusTemplateLoadedEvent extends GeniusPdfEvent {
  const GeniusTemplateLoadedEvent({
    required this.templateId,
    required this.templateName,
  });

  final String templateId;
  final String templateName;
}

/// Emitted when a template is applied.
class GeniusTemplateAppliedEvent extends GeniusPdfEvent {
  const GeniusTemplateAppliedEvent({
    required this.documentId,
    required this.templateId,
  });

  final String documentId;
  final String templateId;
}

// ============================================================================
// Error Events
// ============================================================================

/// General error event.
class GeniusErrorEvent extends GeniusPdfEvent {
  const GeniusErrorEvent({
    required this.error,
    this.context,
    this.stackTrace,
  });

  final Object error;
  final String? context;
  final StackTrace? stackTrace;
}

/// Warning event.
class GeniusWarningEvent extends GeniusPdfEvent {
  const GeniusWarningEvent({
    required this.message,
    this.context,
  });

  final String message;
  final String? context;
}

// ============================================================================
// Reactive Streams
// ============================================================================

/// Provides reactive streams for PDF operations.
class GeniusPdfReactiveStreams {
  GeniusPdfReactiveStreams._();

  static GeniusPdfReactiveStreams? _instance;

  static GeniusPdfReactiveStreams get instance {
    _instance ??= GeniusPdfReactiveStreams._();
    return _instance!;
  }

  static void reset() {
    _instance?._dispose();
    _instance = null;
  }

  final _progressController =
      StreamController<GeniusOperationProgress>.broadcast();
  final _stateController =
      StreamController<GeniusDocumentState>.broadcast();

  /// Stream of operation progress updates.
  Stream<GeniusOperationProgress> get progress => _progressController.stream;

  /// Stream of document state changes.
  Stream<GeniusDocumentState> get state => _stateController.stream;

  /// Updates progress for an operation.
  void updateProgress(GeniusOperationProgress progress) {
    if (!_progressController.isClosed) {
      _progressController.add(progress);
    }
  }

  /// Updates document state.
  void updateState(GeniusDocumentState state) {
    if (!_stateController.isClosed) {
      _stateController.add(state);
    }
  }

  void _dispose() {
    _progressController.close();
    _stateController.close();
  }
}

/// Represents progress of an operation.
class GeniusOperationProgress {
  const GeniusOperationProgress({
    required this.operationId,
    required this.operationType,
    required this.current,
    required this.total,
    this.message,
  });

  final String operationId;
  final String operationType;
  final int current;
  final int total;
  final String? message;

  double get percentage => total > 0 ? (current / total) * 100 : 0;
  bool get isComplete => current >= total;

  @override
  String toString() =>
      'Progress($operationType: ${percentage.toStringAsFixed(1)}%)';
}

/// Represents the state of a document.
class GeniusDocumentState {
  const GeniusDocumentState({
    required this.documentId,
    required this.status,
    this.pageCount,
    this.lastModified,
    this.metadata,
  });

  final String documentId;
  final GeniusDocumentStatus status;
  final int? pageCount;
  final DateTime? lastModified;
  final Map<String, dynamic>? metadata;

  GeniusDocumentState copyWith({
    String? documentId,
    GeniusDocumentStatus? status,
    int? pageCount,
    DateTime? lastModified,
    Map<String, dynamic>? metadata,
  }) {
    return GeniusDocumentState(
      documentId: documentId ?? this.documentId,
      status: status ?? this.status,
      pageCount: pageCount ?? this.pageCount,
      lastModified: lastModified ?? this.lastModified,
      metadata: metadata ?? this.metadata,
    );
  }
}

/// Document status states.
enum GeniusDocumentStatus {
  creating,
  editing,
  rendering,
  saving,
  saved,
  error,
}

/// Mixin for event-aware classes.
mixin GeniusEventEmitter {
  GeniusPdfEventBus get eventBus => GeniusPdfEventBus.instance;

  void emit<T extends GeniusPdfEvent>(T event) => eventBus.emit(event);

  Stream<T> on<T extends GeniusPdfEvent>() => eventBus.on<T>();

  StreamSubscription<T> subscribe<T extends GeniusPdfEvent>(
    void Function(T event) handler,
  ) {
    return eventBus.subscribe<T>(handler);
  }
}
