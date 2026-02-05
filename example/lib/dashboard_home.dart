// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'widgets/dashboard_widgets.dart';

/// Modern Dashboard Home Screen
class DashboardHome extends StatelessWidget {
  final Function(String) onNavigate;

  const DashboardHome({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    // Get theme from context for responsiveness
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 1200;
    final isMedium = screenWidth > 800;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeroSection(context, isDark, theme),
          const SizedBox(height: 32),
          _buildQuickActions(isDark),
          const SizedBox(height: 48),
          _buildStatsGrid(isDark, isWide, isMedium),
          const SizedBox(height: 48),
          _buildFeatureSpotlight(isDark, isWide),
          const SizedBox(height: 48),
          _buildBottomGrid(isDark, isWide),
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, bool isDark, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  AppColors.primaryDark,
                  AppColors.darkSurface,
                ]
              : [
                  AppColors.primary,
                  AppColors.primaryLight,
                ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative background circles
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: -40,
            bottom: -40,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star_rounded,
                              color: Colors.amber, size: 16),
                          SizedBox(width: 8),
                          Text(
                            'v2.3.3+1 Now Available',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Welcome to Genius PDF',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'The most powerful Flutter PDF generation library. Create invoices, reports, and documents with RTL support.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => onNavigate('examples'),
                          icon: const Icon(Icons.play_arrow_rounded),
                          label: const Text('View Examples'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => onNavigate('new_templates'),
                          icon: const Icon(Icons.dashboard_customize_rounded),
                          label: const Text('Browse Templates'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (MediaQuery.of(context).size.width > 800) ...[
                const SizedBox(width: 48),
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.picture_as_pdf_rounded,
                      size: 64,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.darkText : AppColors.lightText,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 120,
          child: ListView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            children: [
              _QuickActionCard(
                label: 'New Invoice',
                icon: Icons.receipt_long_rounded,
                color: AppColors.primary,
                onTap: () => onNavigate('invoices'),
                isDark: isDark,
              ),
              const SizedBox(width: 16),
              _QuickActionCard(
                label: 'Financial Report',
                icon: Icons.analytics_rounded,
                color: AppColors.success,
                onTap: () => onNavigate('financial'),
                isDark: isDark,
              ),
              const SizedBox(width: 16),
              _QuickActionCard(
                label: 'Export Data',
                icon: Icons.upload_file_rounded,
                color: AppColors.warning,
                onTap: () => onNavigate('export'),
                isDark: isDark,
              ),
              const SizedBox(width: 16),
              _QuickActionCard(
                label: 'Print',
                icon: Icons.print_rounded,
                color: AppColors.info,
                onTap: () => onNavigate('printing'),
                isDark: isDark,
              ),
              const SizedBox(width: 16),
              _QuickActionCard(
                label: 'Scan QR',
                icon: Icons.qr_code_scanner_rounded,
                color: AppColors.secondary,
                onTap: () => onNavigate('barcodes'),
                isDark: isDark,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid(bool isDark, bool isWide, bool isMedium) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final childAspectRatio = isWide ? 1.4 : (isMedium ? 1.6 : 2.5);

        return GridView(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 300,
            mainAxisSpacing: 24,
            crossAxisSpacing: 24,
            childAspectRatio: childAspectRatio,
          ),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            StatCard(
              title: 'Components',
              value: '15+',
              subtitle: 'Core Widgets',
              icon: Icons.widgets_rounded,
              gradient: AppColors.primaryGradient,
              change: 'Updated',
              onTap: () => onNavigate('components'),
            ),
            StatCard(
              title: 'Templates',
              value: '24',
              subtitle: 'Ready to use',
              icon: Icons.description_rounded,
              gradient: AppColors.successGradient,
              change: '+4 New',
              onTap: () => onNavigate('templates'),
            ),
            StatCard(
              title: 'Barcodes',
              value: '10+',
              subtitle: 'QR & More',
              icon: Icons.qr_code_rounded,
              gradient: AppColors.warningGradient,
              change: 'ZATCA',
              onTap: () => onNavigate('barcodes'),
            ),
            StatCard(
              title: 'Formats',
              value: '5',
              subtitle: 'Export Options',
              icon: Icons.file_download_rounded,
              gradient: AppColors.infoGradient,
              change: 'Multi',
              onTap: () => onNavigate('export'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFeatureSpotlight(bool isDark, bool isWide) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Feature Spotlight',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.darkText : AppColors.lightText,
              ),
            ),
            TextButton(
              onPressed: () => onNavigate('advanced'),
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = isWide
                ? (constraints.maxWidth - 48) / 3
                : (constraints.maxWidth);

            return Wrap(
              spacing: 24,
              runSpacing: 24,
              children: [
                SizedBox(
                  width: cardWidth,
                  child: FeatureCard(
                    title: 'Smart Tables',
                    description: 'RTL support, pagination, custom styling',
                    icon: Icons.table_chart_rounded,
                    gradient: AppColors.primaryGradient,
                    tags: const ['RTL', 'Paginated'],
                    onTap: () => onNavigate('data_grid'),
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: FeatureCard(
                    title: 'Rich Text',
                    description: 'Styled mixed content with inline formatting',
                    icon: Icons.text_fields_rounded,
                    gradient: AppColors.purpleGradient,
                    tags: const ['Markdown', 'HTML'],
                    onTap: () => onNavigate('rich_text'),
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: FeatureCard(
                    title: 'AI Assistant',
                    description: 'Content generation and layout optimization',
                    icon: Icons.smart_toy_rounded,
                    gradient: AppColors.tealGradient,
                    tags: const ['Smart', 'Beta'],
                    isPro: true,
                    onTap: () => onNavigate('ai_features'),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildBottomGrid(bool isDark, bool isWide) {
    return isWide
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: _buildTemplatesList(isDark)),
              const SizedBox(width: 32),
              Expanded(flex: 2, child: _buildActivityFeed(isDark)),
            ],
          )
        : Column(
            children: [
              _buildTemplatesList(isDark),
              const SizedBox(height: 32),
              _buildActivityFeed(isDark),
            ],
          );
  }

  Widget _buildTemplatesList(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Popular Templates',
            subtitle: 'Start with a pre-built design',
            icon: Icons.folder_special_rounded,
          ),
          const SizedBox(height: 16),
          _buildTemplateRow(
            'Tax Invoice',
            'ZATCA compliant, QR code',
            Icons.receipt,
            AppColors.primaryGradient,
            () => onNavigate('invoices'),
            isDark,
          ),
          _buildTemplateRow(
            'Payslip',
            'Earnings, deductions, net',
            Icons.payments_rounded,
            AppColors.successGradient,
            () => onNavigate('hr'),
            isDark,
          ),
          _buildTemplateRow(
            'Sales Offer',
            'Quotation with terms',
            Icons.local_offer_rounded,
            AppColors.orangeGradient,
            () => onNavigate('sales'),
            isDark,
          ),
          _buildTemplateRow(
            'Certificate',
            'Award and completion',
            Icons.workspace_premium_rounded,
            AppColors.purpleGradient,
            () => onNavigate('templates'),
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateRow(
    String title,
    String subtitle,
    IconData icon,
    List<Color> gradient,
    VoidCallback onTap,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: gradient),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color:
                              isDark ? AppColors.darkText : AppColors.lightText,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActivityFeed(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Recent Updates',
            subtitle: 'New features & fixes',
            icon: Icons.history_rounded,
          ),
          const SizedBox(height: 24),
          // Timeline Style
          Stack(
            children: [
              Positioned(
                left: 19,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 2,
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              Column(
                children: const [
                  ActivityItem(
                    title: 'Config Instance Pattern',
                    description: 'Removed singleton, added builder config',
                    time: 'Just now',
                    icon: Icons.architecture_rounded,
                    color: AppColors.primary,
                  ),
                  ActivityItem(
                    title: 'App Sharing',
                    description: 'WhatsApp & Telegram integration',
                    time: '1 day ago',
                    icon: Icons.share_rounded,
                    color: AppColors.success,
                  ),
                  ActivityItem(
                    title: 'Report Headers',
                    description: 'Fixed bilingual RTL layout',
                    time: '3 days ago',
                    icon: Icons.article_rounded,
                    color: AppColors.warning,
                  ),
                  ActivityItem(
                    title: 'Dark Mode',
                    description: 'Full dark theme support',
                    time: '1 week ago',
                    icon: Icons.dark_mode_rounded,
                    color: AppColors.secondary,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool isDark;

  const _QuickActionCard({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 120,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : AppColors.lightCard,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 12),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
