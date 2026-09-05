import 'package:flutter/material.dart';
import 'app/bootstrap/example_bootstrap.dart';
import 'app/genius_pdf_showcase_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ExampleBootstrap.initialize();
  runApp(const GeniusPdfShowcaseApp());
}
