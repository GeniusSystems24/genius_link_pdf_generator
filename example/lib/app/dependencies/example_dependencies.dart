import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

GeniusPdfConfig? _config;

GeniusPdfConfig get geniusPdfConfig {
  final value = _config;
  if (value == null) {
    throw StateError('ExampleBootstrap.initialize() must run before the UI.');
  }
  return value;
}

void configureExamplePdf(GeniusPdfConfig value) {
  _config = value;
}

const geniusPdfClient = GeniusPdfClient();
