
/// Metadata for a navigable example destination.
final class DashboardDestination {
  const DashboardDestination({
    required this.id,
    required this.title,
    this.description = '',
    this.code,
    this.keywords = const <String>[],
  });

  final String id;
  final String title;
  final String description;
  final String? code;
  final List<String> keywords;
}
