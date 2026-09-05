import 'package:flutter/widgets.dart';

import 'package:genius_pdf_example/features/architecture/presentation/pages/examples/v2_architecture/dependency_injection_register_services_example_screen.dart';

/// Compatibility entry point for the former architecture_dependency_injection aggregate example.
@Deprecated('Use the dedicated V2 Architecture example screens.')
class DependencyInjectionExampleScreen extends StatelessWidget {
  const DependencyInjectionExampleScreen({super.key});

  @override
  Widget build(BuildContext context) => const DependencyInjectionRegisterServicesExampleScreen();
}
