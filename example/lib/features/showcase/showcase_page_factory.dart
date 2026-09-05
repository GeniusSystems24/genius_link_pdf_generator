import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide TextDirection;
import '../../app/dependencies/example_dependencies.dart';
import '../../app/localization/showcase_localizations.dart';
import '../../app/navigation/showcase_catalog.dart';
import '../../app/settings/showcase_settings.dart';
import '../../shared/pdf/showcase_documents.dart';
import '../../shared/presentation/code/showcase_usage_sources.dart';
import '../../shared/presentation/widgets/code_preview.dart';
import '../../shared/presentation/widgets/pdf_workbench.dart';
import '../../shared/presentation/widgets/showcase_page.dart';
import '../jobs/job_queue_page.dart';
import '../legacy_examples/legacy_examples_page.dart';
import '../operations/pdf_operations_page.dart';
import '../package_modules/package_module_page.dart';
import '../templates/template_gallery_page.dart';

abstract final class ShowcasePageFactory {
  static Widget build(ShowcaseDestination destination) {
    return switch (destination.kind) {
      ShowcasePageKind.operations => PdfOperationsPage(
        destination: destination,
      ),
      ShowcasePageKind.jobs => JobQueuePage(destination: destination),
      ShowcasePageKind.gallery => TemplateGalleryPage(destination: destination),
      ShowcasePageKind.module => PackageModulePage(destination: destination),
      ShowcasePageKind.legacy => LegacyExamplesPage(destination: destination),
      ShowcasePageKind.workbench => _WorkbenchPage(destination: destination),
      ShowcasePageKind.reference => _ReferencePage(destination: destination),
      ShowcasePageKind.dashboard => const SizedBox.shrink(),
    };
  }
}

class _WorkbenchPage extends StatelessWidget {
  const _WorkbenchPage({required this.destination});
  final ShowcaseDestination destination;

  @override
  Widget build(BuildContext context) {
    final l10n = ShowcaseL10n.of(context);
    final settings = ShowcaseSettings.of(context);
    final demoName = destination.demo.name;
    final code = ShowcaseUsageSources.workbench(destination);
    final config = geniusPdfConfig.copyWith(
      textDirection: settings.textDirection,
    );

    return ShowcasePage(
      title: l10n.destinationTitle(destination.id, destination.title),
      description: l10n.destinationDescription(
        destination.id,
        destination.description,
      ),
      icon: destination.icon,
      api: destination.api,
      children: [
        ResponsiveSplit(
          primary: ShowcaseSection(
            title: l10n.tr('Working example'),
            subtitle: l10n.tr('Generate a fresh builder for every action.'),
            child: PdfWorkbench(
              builderFactory: () =>
                  createShowcaseBuilder(demoName, config: config),
              fileName: 'showcase_${destination.id.replaceAll('-', '_')}',
              runInBackground: destination.id == 'background-generation',
            ),
          ),
          secondary: ShowcaseSection(
            title: l10n.tr('Usage'),
            subtitle: l10n.tr('Exact builder and generation path used by this screen.'),
            child: CodePreview(code: code, height: 620),
          ),
        ),
      ],
    );
  }
}

class _ReferencePage extends StatelessWidget {
  const _ReferencePage({required this.destination});
  final ShowcaseDestination destination;

  @override
  Widget build(BuildContext context) {
    final l10n = ShowcaseL10n.of(context);
    final code = ShowcaseUsageSources.reference(destination);
    return ShowcasePage(
      title: l10n.destinationTitle(destination.id, destination.title),
      description: l10n.destinationDescription(
        destination.id,
        destination.description,
      ),
      icon: destination.icon,
      api: destination.api,
      children: [
        ShowcaseSection(
          title: l10n.tr('API focus'),
          child: Text(
            destination.api.isEmpty
                ? (l10n.isArabic
                      ? 'هذه الوحدة الاختيارية موجودة في المستودع الحالي وتبقى قابلة للاستكشاف دون افتراض سلوك غير مدعوم.'
                      : 'This optional module is present in the current repository and remains discoverable without inventing unsupported behavior.')
                : (l10n.isArabic
                      ? 'يركز هذا المثال على ${destination.api.join(', ')}. استخدم الشريط الجانبي للمقارنة مع أمثلة التوليد والتسليم التفاعلية.'
                      : 'This example focuses on ${destination.api.join(', ')}. Use the sidebar to compare it with the working generation and delivery examples.'),
          ),
        ),
        ShowcaseSection(
          title: l10n.tr('Usage'),
          child: CodePreview(code: code),
        ),
      ],
    );
  }
}
