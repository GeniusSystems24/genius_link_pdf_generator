
import 'package:flutter/material.dart';
import 'package:super_core/super_core.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
class ExampleFeatureCard extends StatelessWidget {
  const ExampleFeatureCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
    this.badge,
  });

  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    final spacing = context.superTheme.spacing;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: spacing.cardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(icon, color: Theme.of(context).colorScheme.primary),
                  const Spacer(),
                  if (badge != null)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: spacing.space2, vertical: spacing.space1),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(badge!, style: context.superTextTheme.labelSm),
                    ),
                ],
              ),
              SizedBox(height: spacing.space4),
              Text(title, style: context.superTextTheme.titleMd),
              SizedBox(height: spacing.space2),
              Text(
                description,
                style: context.superTextTheme.bodySm.copyWith(color: context.superTheme.fg2),
              ),
              SizedBox(height: spacing.space4),
              Row(
                children: <Widget>[
                  Text(pdfLocalization.open, style: context.superTextTheme.labelMd.copyWith(color: Theme.of(context).colorScheme.primary)),
                  SizedBox(width: spacing.space1),
                  const Icon(Icons.arrow_forward_rounded, size: 18),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
