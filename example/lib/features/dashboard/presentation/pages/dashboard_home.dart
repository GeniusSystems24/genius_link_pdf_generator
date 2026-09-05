
import 'package:flutter/material.dart';
import 'package:super_core/super_core.dart';

import 'package:genius_pdf_example/shared/presentation/widgets/example_page_shell.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/example_section.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/feature_card.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
class DashboardHome extends StatelessWidget {
  const DashboardHome({super.key, required this.onNavigate});

  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return ExamplePageShell(
      title: pdfLocalization.geniusLinkPdfGenerator,
      description:
          pdfLocalization.documentGenerationReusablePdfDesc,
      leading: const Icon(Icons.picture_as_pdf_outlined),
      actions: <Widget>[
        FilledButton.icon(
          onPressed: () => onNavigate('examples'),
          icon: const Icon(Icons.play_arrow_rounded),
          label:  Text(pdfLocalization.openShowcase),
        ),
        OutlinedButton.icon(
          onPressed: () => onNavigate('s00_baseline'),
          icon: const Icon(Icons.fact_check_outlined),
          label:  Text(pdfLocalization.gettingStarted),
        ),
      ],
      children: <Widget>[
        _PackageSummary(onNavigate: onNavigate),
        _FeatureGrid(onNavigate: onNavigate),
        ExampleSection(
          title: pdfLocalization.coverageIsPreserved,
          description:
              pdfLocalization.navigationKeepsOriginalS00S26Desc,
          leading: const Icon(Icons.verified_outlined),
          child: Wrap(
            spacing: context.superTheme.spacing.space2,
            runSpacing: context.superTheme.spacing.space2,
            children:  <Widget>[
              Chip(label: Text(pdfLocalization.s00S26Modules)),
              Chip(label: Text(pdfLocalization.components)),
              Chip(label: Text(pdfLocalization.templates)),
              Chip(label: Text(pdfLocalization.reports)),
              Chip(label: Text(pdfLocalization.exportText)),
              Chip(label: Text(pdfLocalization.printing)),
              Chip(label: Text(pdfLocalization.sharing)),
              Chip(label: Text(pdfLocalization.security)),
              Chip(label: Text(pdfLocalization.jobQueue)),
              Chip(label: Text(pdfLocalization.aiAdvanced)),
            ],
          ),
        ),
      ],
    );
  }
}

class _PackageSummary extends StatelessWidget {
  const _PackageSummary({required this.onNavigate});

  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return ExampleSection(
      title: pdfLocalization.startWithTheWorkflowYouNeed,
      description:
          pdfLocalization.exampleApplicationIsOrganizedDesc,
      leading: const Icon(Icons.route_outlined),
      child: Wrap(
        spacing: context.superTheme.spacing.space2,
        runSpacing: context.superTheme.spacing.space2,
        children: <Widget>[
          ActionChip(
            avatar: const Icon(Icons.widgets_outlined, size: 18),
            label:  Text(pdfLocalization.components),
            onPressed: () => onNavigate('components'),
          ),
          ActionChip(
            avatar: const Icon(Icons.description_outlined, size: 18),
            label:  Text(pdfLocalization.templates),
            onPressed: () => onNavigate('templates'),
          ),
          ActionChip(
            avatar: const Icon(Icons.work_history_outlined, size: 18),
            label:  Text(pdfLocalization.jobQueue),
            onPressed: () => onNavigate('job_manager'),
          ),
          ActionChip(
            avatar: const Icon(Icons.print_outlined, size: 18),
            label:  Text(pdfLocalization.printing),
            onPressed: () => onNavigate('printing'),
          ),
          ActionChip(
            avatar: const Icon(Icons.speed_outlined, size: 18),
            label:  Text(pdfLocalization.performance),
            onPressed: () => onNavigate('s24_performance_regression'),
          ),
        ],
      ),
    );
  }
}

class _FeatureGrid extends StatelessWidget {
  const _FeatureGrid({required this.onNavigate});

  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    final items = <_DashboardFeature>[
       _DashboardFeature(
        id: 's03_flow_layout',
        title: pdfLocalization.documentBuilder,
        description: pdfLocalization.flowLayoutPaginationPageSetupDesc,
        icon: Icons.view_stream_outlined,
      ),
       _DashboardFeature(
        id: 'components',
        title: pdfLocalization.components,
        description: pdfLocalization.tablesSummariesHeadersRichTextInfoDesc,
        icon: Icons.widgets_outlined,
      ),
       _DashboardFeature(
        id: 'business_balance_sheet',
        title: pdfLocalization.businessTemplates,
        description: pdfLocalization.openDedicatedBusinessTemplateExampleDesc,
        icon: Icons.business_center_outlined,
      ),
       _DashboardFeature(
        id: 'template_engine',
        title: pdfLocalization.templateEngine,
        description: pdfLocalization.builtTemplatesJsonBackedTemplatesVDesc,
        icon: Icons.account_tree_outlined,
      ),
       _DashboardFeature(
        id: 'export',
        title: pdfLocalization.delivery,
        description: pdfLocalization.exportSaveOpenWorkflowsSharingDesc,
        icon: Icons.outbox_outlined,
      ),
       _DashboardFeature(
        id: 'job_manager',
        title: pdfLocalization.backgroundGeneration,
        description: pdfLocalization.jobManagerQueuesBatchBackgroundDesc,
        icon: Icons.work_history_outlined,
      ),
       _DashboardFeature(
        id: 'v2_architecture',
        title: pdfLocalization.architecture,
        description: pdfLocalization.applicationIntegrationAdvancedApisDesc,
        icon: Icons.architecture_outlined,
      ),
       _DashboardFeature(
        id: 's24_performance_regression',
        title: pdfLocalization.benchmarkAndPerformance,
        description: pdfLocalization.regressionVerificationPerformanceDesc,
        icon: Icons.speed_outlined,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 1200
            ? 4
            : constraints.maxWidth >= 760
                ? 2
                : 1;
        final gap = context.superTheme.spacing.space4;
        final width = columns == 1
            ? constraints.maxWidth
            : (constraints.maxWidth - gap * (columns - 1)) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: <Widget>[
            for (final item in items)
              SizedBox(
                width: width,
                child: ExampleFeatureCard(
                  title: item.title,
                  description: item.description,
                  icon: item.icon,
                  onTap: () => onNavigate(item.id),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _DashboardFeature {
  const _DashboardFeature({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
  });

  final String id;
  final String title;
  final String description;
  final IconData icon;
}
