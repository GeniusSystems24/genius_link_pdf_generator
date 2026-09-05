import 'package:flutter/widgets.dart';
import 'package:genius_pdf_example/features/sharing/presentation/internal/sharing_single_example_host.dart';

/// Dedicated single-example screen for **Email Sharing**.
///
/// This screen deliberately contains no tabs and no sibling examples. It keeps
/// the original Sharing implementation and behavior through the
/// shared internal host while selecting only this example.
class EmailSharingExampleScreen extends StatelessWidget {
  const EmailSharingExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SharingSingleExampleHost(initialTab: 1);
  }
}
