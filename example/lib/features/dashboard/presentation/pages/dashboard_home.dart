
import 'package:flutter/material.dart';
import 'package:super_core/super_core.dart';

import 'package:genius_pdf_example/shared/presentation/widgets/example_page_shell.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/example_section.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/feature_card.dart';

class DashboardHome extends StatelessWidget {
  const DashboardHome({super.key, required this.onNavigate});

  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return ExamplePageShell(
      title: 'Genius Link PDF Generator',
      description:
          'Explore document generation, reusable PDF components, RTL/LTR behavior, templates, delivery workflows, job queues, security, and advanced package modules without losing any existing example coverage.',
      leading: const Icon(Icons.picture_as_pdf_outlined),
      actions: <Widget>[
        FilledButton.icon(
          onPressed: () => onNavigate('examples'),
          icon: const Icon(Icons.play_arrow_rounded),
          label: const Text('Open showcase'),
        ),
        OutlinedButton.icon(
          onPressed: () => onNavigate('s00_baseline'),
          icon: const Icon(Icons.fact_check_outlined),
          label: const Text('Getting started'),
        ),
      ],
      children: <Widget>[
        _PackageSummary(onNavigate: onNavigate),
        _FeatureGrid(onNavigate: onNavigate),
        ExampleSection(
          title: 'Coverage is preserved',
          description:
              'The navigation keeps the original S00-S26 verification modules and all existing demos as separate destinations. Similar examples are grouped together rather than merged or removed.',
          leading: const Icon(Icons.verified_outlined),
          child: Wrap(
            spacing: context.superTheme.spacing.space2,
            runSpacing: context.superTheme.spacing.space2,
            children: const <Widget>[
              Chip(label: Text('S00-S26 modules')),
              Chip(label: Text('Components')),
              Chip(label: Text('Templates')),
              Chip(label: Text('Reports')),
              Chip(label: Text('Export')),
              Chip(label: Text('Printing')),
              Chip(label: Text('Sharing')),
              Chip(label: Text('Security')),
              Chip(label: Text('Job queue')),
              Chip(label: Text('AI / Advanced')),
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
      title: 'Start with the workflow you need',
      description:
          'The example application is organized by responsibility instead of release sequence. Screen codes remain searchable for developers who know the S00-S26 module names.',
      leading: const Icon(Icons.route_outlined),
      child: Wrap(
        spacing: context.superTheme.spacing.space2,
        runSpacing: context.superTheme.spacing.space2,
        children: <Widget>[
          ActionChip(
            avatar: const Icon(Icons.widgets_outlined, size: 18),
            label: const Text('Components'),
            onPressed: () => onNavigate('components'),
          ),
          ActionChip(
            avatar: const Icon(Icons.description_outlined, size: 18),
            label: const Text('Templates'),
            onPressed: () => onNavigate('templates'),
          ),
          ActionChip(
            avatar: const Icon(Icons.work_history_outlined, size: 18),
            label: const Text('Job queue'),
            onPressed: () => onNavigate('job_manager'),
          ),
          ActionChip(
            avatar: const Icon(Icons.print_outlined, size: 18),
            label: const Text('Printing'),
            onPressed: () => onNavigate('printing'),
          ),
          ActionChip(
            avatar: const Icon(Icons.speed_outlined, size: 18),
            label: const Text('Performance'),
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
      const _DashboardFeature(
        id: 's03_flow_layout',
        title: 'Document Builder',
        description: 'Flow layout, pagination, page setup, and document construction.',
        icon: Icons.view_stream_outlined,
      ),
      const _DashboardFeature(
        id: 'components',
        title: 'Components',
        description: 'Tables, summaries, headers, rich text, info boxes, QR combinations, and RTL cases.',
        icon: Icons.widgets_outlined,
      ),
      const _DashboardFeature(
        id: 'business_balance_sheet',
        title: 'Business Templates',
        description: 'Open a dedicated business-template example; choose other financial, sales, and HR templates from the sidebar.',
        icon: Icons.business_center_outlined,
      ),
      const _DashboardFeature(
        id: 'template_engine',
        title: 'Template Engine',
        description: 'Built-in templates, JSON-backed templates, vNext engine, consolidation, and designer examples.',
        icon: Icons.account_tree_outlined,
      ),
      const _DashboardFeature(
        id: 'export',
        title: 'Delivery',
        description: 'Export, save/open workflows, sharing, printing profiles, and security/compliance examples.',
        icon: Icons.outbox_outlined,
      ),
      const _DashboardFeature(
        id: 'job_manager',
        title: 'Background Generation',
        description: 'Job manager, queues, batch/background workflows, status, and result handling.',
        icon: Icons.work_history_outlined,
      ),
      const _DashboardFeature(
        id: 'v2_architecture',
        title: 'Architecture',
        description: 'Application integration, advanced APIs, ERP domain calculations, and extension points.',
        icon: Icons.architecture_outlined,
      ),
      const _DashboardFeature(
        id: 's24_performance_regression',
        title: 'Benchmark & Performance',
        description: 'Regression verification and performance-oriented examples.',
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
