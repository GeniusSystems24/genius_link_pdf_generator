import 'package:genius_pdf_example/app/localization/showcase_localizations.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';
import 'package:super_core/super_core.dart';
import '../../app/dependencies/example_dependencies.dart';
import '../../app/navigation/showcase_catalog.dart';
import '../../shared/pdf/showcase_documents.dart';
import '../../shared/presentation/widgets/operation_state.dart';
import '../../shared/presentation/widgets/showcase_page.dart';

class PdfOperationsPage extends StatefulWidget {
  const PdfOperationsPage({super.key, required this.destination});
  final ShowcaseDestination destination;

  @override
  State<PdfOperationsPage> createState() => _PdfOperationsPageState();
}

class _PdfOperationsPageState extends State<PdfOperationsPage> {
  Uint8List? _source;
  Uint8List? _result;
  bool _busy = false;
  String _message = 'Generate the source fixture, then run an operation.';
  OperationTone _tone = OperationTone.neutral;

  Future<void> _ensureSource() async {
    if (_source != null) return;
    final generated = await geniusPdfClient.generate(
      builder: createShowcaseBuilder('basic'),
      fileName: 'operations_source',
      runInBackground: false,
    );
    generated.when(
      onSuccess: (value) => _source = value.bytes,
      onFailure: (value) => throw StateError(value.message),
    );
  }

  Future<void> _perform(String label, Future<void> Function(Uint8List bytes) action) async {
    if (_busy) return;
    setState(() { _busy = true; _message = '$label…'; _tone = OperationTone.busy; });
    try {
      await _ensureSource();
      await action(_source!);
      if (mounted) setState(() { _message = '$label completed.'; _tone = OperationTone.success; });
    } catch (error) {
      if (mounted) setState(() { _message = error.toString(); _tone = OperationTone.error; });
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _info() => _perform('Inspecting document', (bytes) async {
    final info = await geniusPdfClient.getPdfInfo(bytes);
    if (info == null) throw StateError('No PDF information returned.');
    if (mounted) setState(() {
      _message = '${info.pageCount} page(s) • ${info.fileSizeFormatted} • encrypted: ${info.isEncrypted}';
    });
  });

  Future<void> _watermark() => _perform('Adding watermark', (bytes) async {
    final value = await geniusPdfClient.addWatermark(
      pdfBytes: bytes,
      watermarkText: 'SHOWCASE',
      outputFileName: 'watermarked_showcase',
    );
    value.when(
      onSuccess: (v) => _result = v.bytes,
      onFailure: (v) => throw StateError(v.message),
    );
  });

  Future<void> _rotate() => _perform('Rotating pages', (bytes) async {
    final value = await geniusPdfClient.rotatePages(
      pdfBytes: bytes,
      rotation: 90,
      outputFileName: 'rotated_showcase',
    );
    value.when(
      onSuccess: (v) => _result = v.bytes,
      onFailure: (v) => throw StateError(v.message),
    );
  });

  Future<void> _extract() => _perform('Extracting page 1', (bytes) async {
    final value = await geniusPdfClient.extractPages(
      pdfBytes: bytes,
      pageNumbers: const [1],
      outputFileName: 'extracted_showcase',
    );
    value.when(
      onSuccess: (v) => _result = v.bytes,
      onFailure: (v) => throw StateError(v.message),
    );
  });

  Future<void> _merge() => _perform('Merging fixtures', (bytes) async {
    final value = await geniusPdfClient.mergePdfs(
      pdfBytesList: [bytes, bytes],
      outputFileName: 'merged_showcase',
    );
    if (!value.success || value.bytes == null) {
      throw StateError(value.error ?? 'Merge failed.');
    }
    _result = value.bytes;
  });

  Future<void> _split() => _perform('Splitting fixture', (bytes) async {
    final value = await geniusPdfClient.splitPdf(
      pdfBytes: bytes,
      baseFileName: 'split_showcase',
      pagesPerFile: 1,
    );
    if (!value.success || value.files.isEmpty) {
      throw StateError(value.error ?? 'Split produced no files.');
    }
    _result = value.files.first.bytes;
    if (mounted) setState(() => _message = 'Split produced ${value.fileCount} file(s).');
  });

  @override
  Widget build(BuildContext context) {
    final l10n = ShowcaseL10n.of(context);
    final t = context.superTheme;
    return ShowcasePage(
      title: l10n.destinationTitle(widget.destination.id, widget.destination.title),
      description: l10n.destinationDescription(widget.destination.id, widget.destination.description),
      icon: widget.destination.icon,
      api: widget.destination.api,
      children: [
        ShowcaseSection(
          title: l10n.tr('Operations workbench'),
          subtitle: l10n.tr('All actions operate on generated in-memory PDF bytes.'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Wrap(
                spacing: t.spacing.space2,
                runSpacing: t.spacing.space2,
                children: [
                  SuperButton(label: l10n.tr('Document info'), onPressed: _busy ? null : _info, icon: const Icon(Icons.info_outline)),
                  SuperButton(label: l10n.tr('Merge'), variant: SuperButtonVariant.secondary, onPressed: _busy ? null : _merge),
                  SuperButton(label: l10n.tr('Split'), variant: SuperButtonVariant.secondary, onPressed: _busy ? null : _split),
                  SuperButton(label: l10n.tr('Extract'), variant: SuperButtonVariant.secondary, onPressed: _busy ? null : _extract),
                  SuperButton(label: l10n.tr('Rotate'), variant: SuperButtonVariant.secondary, onPressed: _busy ? null : _rotate),
                  SuperButton(label: l10n.tr('Watermark'), variant: SuperButtonVariant.secondary, onPressed: _busy ? null : _watermark),
                ],
              ),
              SizedBox(height: t.spacing.space3),
              OperationStatePanel(message: _message, tone: _tone),
              SizedBox(height: t.spacing.space3),
              Container(
                height: 560,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: t.inputBg,
                  border: Border.all(color: t.border),
                  borderRadius: t.spacing.borderRadiusCard,
                ),
                child: _result == null
                    ? Center(child: Text(l10n.tr('Transformed PDF preview appears here.'), style: context.superTextTheme.body.copyWith(color: t.fg2)))
                    : GeniusPdfPreviewWidget(pdfData: _result!),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
