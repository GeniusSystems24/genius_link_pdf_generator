import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/dashboard_widgets.dart';

/// Dashboard Home Screen
class DashboardHome extends StatelessWidget {
  final Function(String) onNavigate;

  const DashboardHome({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 1200;
    final isMedium = screenWidth > 800;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeHeader(isDark),
          const SizedBox(height: 24),
          _buildQuickActions(),
          const SizedBox(height: 32),
          _buildStatsSection(isDark, isWide, isMedium),
          const SizedBox(height: 32),
          _buildFeaturesSection(isDark, isWide, isMedium),
          const SizedBox(height: 32),
          _buildBottomSections(isDark, isWide),
        ],
      ),
    );
  }

  Widget _buildWelcomeHeader(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(isDark ? 0.2 : 0.1),
            AppColors.secondary.withOpacity(isDark ? 0.1 : 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Genius PDF Generator',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.darkText : AppColors.lightText,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: AppColors.successGradient,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'v2.3.3+1',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Professional PDF generation library with RTL support, charts, templates, and advanced features',
                  style: TextStyle(
                    fontSize: 15,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildFeatureChip(
                        Icons.format_textdirection_r_to_l, 'RTL/LTR'),
                    _buildFeatureChip(Icons.translate, 'Bilingual'),
                    _buildFeatureChip(Icons.insert_chart_rounded, 'Charts'),
                    _buildFeatureChip(Icons.security_rounded, 'Security'),
                    _buildFeatureChip(Icons.print_rounded, 'Printing'),
                    _buildFeatureChip(Icons.share_rounded, 'Sharing'),
                    _buildFeatureChip(Icons.smart_toy_rounded, 'AI Features'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: AppColors.primaryGradient,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Icon(
              Icons.picture_as_pdf_rounded,
              size: 56,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          QuickActionButton(
            label: 'Generate Invoice',
            icon: Icons.receipt_long_rounded,
            gradient: AppColors.primaryGradient,
            onTap: () => onNavigate('invoices'),
          ),
          const SizedBox(width: 12),
          QuickActionButton(
            label: 'Create Report',
            icon: Icons.assessment_rounded,
            gradient: AppColors.successGradient,
            onTap: () => onNavigate('financial'),
          ),
          const SizedBox(width: 12),
          QuickActionButton(
            label: 'Export PDF',
            icon: Icons.file_download_rounded,
            gradient: AppColors.infoGradient,
            onTap: () => onNavigate('export'),
          ),
          const SizedBox(width: 12),
          QuickActionButton(
            label: 'Print Document',
            icon: Icons.print_rounded,
            gradient: AppColors.purpleGradient,
            onTap: () => onNavigate('printing'),
          ),
          const SizedBox(width: 12),
          QuickActionButton(
            label: 'Share',
            icon: Icons.share_rounded,
            gradient: AppColors.cyanGradient,
            onTap: () => onNavigate('sharing'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(bool isDark, bool isWide, bool isMedium) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Library Statistics',
          subtitle: 'Overview of available features',
          icon: Icons.analytics_rounded,
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = isWide ? 4 : (isMedium ? 2 : 1);
            final childAspectRatio = isWide ? 1.4 : (isMedium ? 1.6 : 2.5);

            return GridView.count(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: childAspectRatio,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                StatCard(
                  title: 'Components',
                  value: '15+',
                  subtitle: 'Reusable PDF widgets',
                  icon: Icons.widgets_rounded,
                  gradient: AppColors.primaryGradient,
                  change: 'Core',
                  onTap: () => onNavigate('components'),
                ),
                StatCard(
                  title: 'Templates',
                  value: '20+',
                  subtitle: 'Business documents',
                  icon: Icons.description_rounded,
                  gradient: AppColors.successGradient,
                  change: 'Ready',
                  onTap: () => onNavigate('templates'),
                ),
                StatCard(
                  title: 'Chart Types',
                  value: '4',
                  subtitle: 'Bar, Line, Pie, Area',
                  icon: Icons.bar_chart_rounded,
                  gradient: AppColors.warningGradient,
                  change: 'Visual',
                  onTap: () => onNavigate('charts'),
                ),
                StatCard(
                  title: 'Export Formats',
                  value: '5',
                  subtitle: 'PDF, PNG, JPEG, HTML, Text',
                  icon: Icons.file_download_rounded,
                  gradient: AppColors.infoGradient,
                  change: 'Multi',
                  onTap: () => onNavigate('export'),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildFeaturesSection(bool isDark, bool isWide, bool isMedium) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Features',
          subtitle: 'Explore all capabilities',
          icon: Icons.auto_awesome_rounded,
          action: TextButton.icon(
            onPressed: () => onNavigate('advanced'),
            icon: const Icon(Icons.arrow_forward_rounded, size: 16),
            label: const Text('View All'),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = isWide ? 4 : (isMedium ? 2 : 1);
            final childAspectRatio = isWide ? 1.1 : (isMedium ? 1.2 : 2.0);

            return GridView.count(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: childAspectRatio,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                FeatureCard(
                  title: 'Data Grid',
                  description:
                      'Advanced tables with RTL support, styling, and pagination',
                  icon: Icons.table_chart_rounded,
                  gradient: AppColors.primaryGradient,
                  tags: const ['RTL', 'Styling'],
                  onTap: () => onNavigate('data_grid'),
                ),
                FeatureCard(
                  title: 'Rich Text',
                  description:
                      'Styled text with colors, fonts, and inline formatting',
                  icon: Icons.text_fields_rounded,
                  gradient: AppColors.purpleGradient,
                  tags: const ['Styled', 'Colors'],
                  onTap: () => onNavigate('rich_text'),
                ),
                FeatureCard(
                  title: 'Charts',
                  description:
                      'Bar, line, pie, and area charts with customization',
                  icon: Icons.insert_chart_rounded,
                  gradient: AppColors.successGradient,
                  tags: const ['4 Types', 'Animated'],
                  onTap: () => onNavigate('charts'),
                ),
                FeatureCard(
                  title: 'Security',
                  description:
                      'Watermarks, encryption, passwords, and digital signatures',
                  icon: Icons.security_rounded,
                  gradient: AppColors.errorGradient,
                  tags: const ['Encrypted', 'Protected'],
                  onTap: () => onNavigate('security'),
                ),
                FeatureCard(
                  title: 'Printing',
                  description:
                      'Advanced print settings, preview, and printer discovery',
                  icon: Icons.print_rounded,
                  gradient: AppColors.orangeGradient,
                  tags: const ['Preview', 'Profiles'],
                  onTap: () => onNavigate('printing'),
                ),
                FeatureCard(
                  title: 'Sharing',
                  description:
                      'Email, Bluetooth, WhatsApp, and cloud app sharing',
                  icon: Icons.share_rounded,
                  gradient: AppColors.cyanGradient,
                  tags: const ['Email', 'Apps'],
                  isNew: true,
                  onTap: () => onNavigate('sharing'),
                ),
                FeatureCard(
                  title: 'AI Features',
                  description:
                      'Content analysis, smart layout, and text summarization',
                  icon: Icons.smart_toy_rounded,
                  gradient: AppColors.warningGradient,
                  tags: const ['Smart', 'Analysis'],
                  isPro: true,
                  onTap: () => onNavigate('ai_features'),
                ),
                FeatureCard(
                  title: 'Template Engine',
                  description:
                      'Dynamic templates with variables, conditions, and loops',
                  icon: Icons.build_rounded,
                  gradient: AppColors.tealGradient,
                  tags: const ['Dynamic', 'Variables'],
                  onTap: () => onNavigate('advanced'),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildBottomSections(bool isDark, bool isWide) {
    if (isWide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _buildTemplatesSection(isDark)),
          const SizedBox(width: 24),
          Expanded(child: _buildActivitySection(isDark)),
        ],
      );
    }

    return Column(
      children: [
        _buildTemplatesSection(isDark),
        const SizedBox(height: 24),
        _buildActivitySection(isDark),
      ],
    );
  }

  Widget _buildTemplatesSection(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Document Templates',
            subtitle: 'Pre-built professional templates',
            icon: Icons.folder_rounded,
            action: TextButton(
              onPressed: () => onNavigate('templates'),
              child: const Text('View All'),
            ),
          ),
          const SizedBox(height: 8),
          _buildTemplateItem(
            'Tax Invoice',
            'ZATCA compliant invoices',
            Icons.receipt_long_rounded,
            AppColors.primaryGradient,
            () => onNavigate('invoices'),
          ),
          _buildTemplateItem(
            'Financial Reports',
            'Balance sheet, P&L, Cash flow',
            Icons.account_balance_rounded,
            AppColors.successGradient,
            () => onNavigate('financial'),
          ),
          _buildTemplateItem(
            'HR Documents',
            'Payslips, attendance, leave reports',
            Icons.people_rounded,
            AppColors.purpleGradient,
            () => onNavigate('hr'),
          ),
          _buildTemplateItem(
            'Sales Documents',
            'Quotations, PO, delivery notes',
            Icons.shopping_cart_rounded,
            AppColors.orangeGradient,
            () => onNavigate('sales'),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateItem(
    String title,
    String subtitle,
    IconData icon,
    List<Color> gradient,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: gradient),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: AppColors.lightTextSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivitySection(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Recent Updates',
            subtitle: 'Latest library changes',
            icon: Icons.update_rounded,
          ),
          const SizedBox(height: 8),
          const ActivityItem(
            title: 'Config Instance Pattern',
            description: 'Removed singleton, per-builder config',
            time: 'v2.3.3+1',
            icon: Icons.architecture_rounded,
            color: AppColors.error,
          ),
          const ActivityItem(
            title: 'App Sharing',
            description: 'WhatsApp, Telegram, cloud apps',
            time: 'v2.3.3',
            icon: Icons.share_rounded,
            color: AppColors.success,
          ),
          const ActivityItem(
            title: 'Bluetooth Sharing',
            description: 'Nearby Share, AirDrop support',
            time: 'v2.3.2',
            icon: Icons.bluetooth_rounded,
            color: AppColors.info,
          ),
          const ActivityItem(
            title: 'Email Sharing',
            description: 'Gmail, Outlook integration',
            time: 'v2.3.1',
            icon: Icons.email_rounded,
            color: AppColors.warning,
          ),
          const ActivityItem(
            title: 'Unified Sharing',
            description: 'Single API for all sharing',
            time: 'v2.3.0',
            icon: Icons.hub_rounded,
            color: AppColors.accent,
          ),
        ],
      ),
    );
  }
}
