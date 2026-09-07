part of '../generation/pdf_generation_manager.dart';

/// Priority-aware queue used by the public manager.
///
/// Ordering policy is isolated from orchestration so it can be tested and
/// changed independently.
class _GeniusPdfPriorityQueue extends IterableBase<GeniusPdfJob> {
  final Queue<GeniusPdfJob> _items = Queue<GeniusPdfJob>();

  @override
  Iterator<GeniusPdfJob> get iterator => _items.iterator;

  @override
  int get length => _items.length;
  @override
  bool get isNotEmpty => _items.isNotEmpty;

  GeniusPdfJob removeFirst() => _items.removeFirst();

  void addByPriority(GeniusPdfJob job) {
    final items = _items.toList();
    final insertionIndex = switch (job.priority) {
      GeniusPdfJobPriority.urgent => 0,
      GeniusPdfJobPriority.high => items.indexWhere(
          (item) => item.priority != GeniusPdfJobPriority.urgent,
        ),
      GeniusPdfJobPriority.normal => items.indexWhere(
          (item) => item.priority == GeniusPdfJobPriority.low,
        ),
      GeniusPdfJobPriority.low => items.length,
    };

    items.insert(insertionIndex < 0 ? items.length : insertionIndex, job);
    _replace(items);
  }

  bool removeById(String id) {
    final before = _items.length;
    _items.removeWhere((job) => job.id == id);
    return before != _items.length;
  }

  bool move(String id, int offset) {
    if (offset == 0) return false;
    final items = _items.toList();
    final index = items.indexWhere((job) => job.id == id);
    if (index < 0) return false;
    final nextIndex =
        (index + offset).clamp(0, items.length - 1).toInt();
    if (nextIndex == index) return false;
    final job = items.removeAt(index);
    items.insert(nextIndex, job);
    _replace(items);
    return true;
  }

  bool reorder(List<String> orderedIds) {
    if (orderedIds.isEmpty || _items.isEmpty) return false;
    final byId = <String, GeniusPdfJob>{for (final job in _items) job.id: job};
    final reordered = <GeniusPdfJob>[];
    for (final id in orderedIds) {
      final job = byId.remove(id);
      if (job != null) reordered.add(job);
    }
    reordered.addAll(_items.where((job) => byId.containsKey(job.id)));
    if (_sameOrder(reordered, _items.toList())) return false;
    _replace(reordered);
    return true;
  }

  void clear() => _items.clear();

  void _replace(Iterable<GeniusPdfJob> jobs) {
    _items
      ..clear()
      ..addAll(jobs);
  }

  bool _sameOrder(List<GeniusPdfJob> a, List<GeniusPdfJob> b) {
    if (a.length != b.length) return false;
    for (var index = 0; index < a.length; index++) {
      if (a[index].id != b[index].id) return false;
    }
    return true;
  }
}
