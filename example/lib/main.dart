import 'package:flutter/material.dart';

import 'package:genius_pdf_example/app/bootstrap/example_bootstrap.dart';
import 'package:genius_pdf_example/app/presentation/genius_pdf_example_app.dart';

export 'package:genius_pdf_example/app/dependencies/example_dependencies.dart'
    show geniusPdfConfig;
export 'package:genius_pdf_example/app/presentation/genius_pdf_example_app.dart'
    show GeniusPdfExampleApp;

Future<void> main() async {
  await ExampleBootstrap.initialize();
  runApp(const GeniusPdfExampleApp());
}
