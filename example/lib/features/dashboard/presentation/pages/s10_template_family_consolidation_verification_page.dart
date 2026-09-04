
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;
import 'package:genius_pdf_example/app/dependencies/example_dependencies.dart';

import 'package:genius_pdf_example/shared/presentation/widgets/create_save_open_pdf_button.dart';
class S10TemplateFamilyConsolidationVerificationPage
    extends StatefulWidget {
  const S10TemplateFamilyConsolidationVerificationPage({super.key});

  @override
  State<S10TemplateFamilyConsolidationVerificationPage> createState() =>
      _S10TemplateFamilyConsolidationVerificationPageState();
}

class _S10TemplateFamilyConsolidationVerificationPageState
    extends State<S10TemplateFamilyConsolidationVerificationPage> {
  bool _rtl = false;
  late Future<Uint8List> _pdf;

  @override
  void initState() {
    super.initState();
    _pdf = _generate();
  }

  Future<Uint8List> _generate() async {
    final config = geniusPdfConfig.copyWith(
      textDirection: _rtl ? TextDirection.rtl : TextDirection.ltr,
    );
    final document = _S10FamilyAuditDocument(config);
    final bytes = Uint8List.fromList(document.generate());
    document.dispose();
    return bytes;
  }

  void _regenerate() {
    setState(() {
      _pdf = _generate();
    });
  }

  @override
  Widget build(BuildContext context) {
    final registrations =
        GeniusErpExistingTemplateFamilyRegistry.all;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Sprint S10 — Template Family Consolidation',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Expected Result: every current package template has an '
                    'explicit S08 family. Voucher classes converge through '
                    'GeniusPdfVoucherTemplate → GeniusErpVoucherDocument. '
                    'The mapping stays identical in LTR and RTL.',
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SegmentedButton<bool>(
                        segments: const [
                          ButtonSegment(
                            value: false,
                            label: Text('LTR'),
                          ),
                          ButtonSegment(
                            value: true,
                            label: Text('RTL'),
                          ),
                        ],
                        selected: {_rtl},
                        onSelectionChanged: (selection) {
                          _rtl = selection.first;
                          _regenerate();
                        },
                      ),
                      FilledButton.icon(
                        onPressed: _regenerate,
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Regenerate PDF'),
                      ),
                      CreateSaveOpenPdfButton(
                        onCreate: _generate,
                        fileName: 's10_template_family_consolidation.pdf',
                      ),
                      Chip(
                        label: Text(
                          '${registrations.length} family registrations',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 150,
                    child: ListView.builder(
                      itemCount: registrations.length,
                      itemBuilder: (context, index) {
                        final item = registrations[index];
                        return Text(
                          '${item.templateType} → ${item.familyKind.name}',
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: FutureBuilder<Uint8List>(
                future: _pdf,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: SelectableText(
                        'Generation failed:\n${snapshot.error}',
                      ),
                    );
                  }
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return GeniusPdfPreviewWidget(
                    pdfData: snapshot.data!,
                    canChangeOrientation: false,
                    canChangePageFormat: false,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _S10FamilyAuditDocument extends GeniusPdfDocumentBuilder {
  _S10FamilyAuditDocument(super.config);

  @override
  void build() {
    newPage();
    addLine(
      config.isRTL
          ? 'تدقيق عائلات القوالب — S10'
          : 'Template Family Audit — S10',
      font: config.headerFont,
      topMargin: 4,
    );
    addLine(
      config.isRTL
          ? 'يجب أن يبقى تعيين العائلات ثابتاً ولا يعتمد على اتجاه الصفحة.'
          : 'Family classification must be stable and independent of page direction.',
      topMargin: 4,
    );
    addHorizontalLine(spacing: 8);

    for (final registration
        in GeniusErpExistingTemplateFamilyRegistry.all) {
      addLine(
        '${registration.templateType} → ${registration.familyKind.name}',
        font: config.smallFont,
        topMargin: 3,
      );
    }
  }
}
