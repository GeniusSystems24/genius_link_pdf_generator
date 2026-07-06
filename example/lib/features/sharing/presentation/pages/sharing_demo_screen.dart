import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;
import 'package:genius_pdf_example/app/dependencies/example_dependencies.dart' show geniusPdfConfig;
import 'package:genius_pdf_example/features/sharing/presentation/controllers/sharing_demo_controller.dart';

import 'package:genius_pdf_example/app/theme/app_theme.dart';

/// Demo screen for Sharing features (v2.3.x).
class SharingDemoScreen extends StatefulWidget {
  const SharingDemoScreen({super.key, this.controller});

  final SharingDemoController? controller;

  @override
  State<SharingDemoScreen> createState() => _SharingDemoScreenState();
}

class _SharingDemoScreenState extends State<SharingDemoScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late final SharingDemoController _controller;
  late final bool _ownsController;

  final List<_SharingTab> _tabs = [
    _SharingTab(
      id: 'quick',
      title: 'Quick Share',
      icon: Icons.flash_on_rounded,
      gradient: AppColors.primaryGradient,
    ),
    _SharingTab(
      id: 'email',
      title: 'Email',
      icon: Icons.email_rounded,
      gradient: AppColors.infoGradient,
    ),
    _SharingTab(
      id: 'bluetooth',
      title: 'Bluetooth',
      icon: Icons.bluetooth_rounded,
      gradient: AppColors.purpleGradient,
    ),
    _SharingTab(
      id: 'apps',
      title: 'Apps',
      icon: Icons.apps_rounded,
      gradient: AppColors.successGradient,
    ),
    _SharingTab(
      id: 'history',
      title: 'History',
      icon: Icons.history_rounded,
      gradient: AppColors.warningGradient,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _ownsController = widget.controller == null;
    _controller = widget.controller ?? SharingDemoController(
      config: geniusPdfConfig,
    );
    _controller.addListener(_onControllerChanged);
    _controller.initialize();
  }

  void _onControllerChanged() {
    if (mounted) setState(() {});
  }





  @override
  void dispose() {
    _tabController.dispose();
    _controller.removeListener(_onControllerChanged);
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeController,
      builder: (context, themeMode, _) {
        final isDark = themeMode == ThemeMode.dark;

        return Container(
          color: isDark ? AppColors.darkBg : AppColors.lightBg,
          child: Column(
            children: [
              _buildTabBar(isDark),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildQuickShareTab(isDark),
                    _buildEmailTab(isDark),
                    _buildBluetoothTab(isDark),
                    _buildAppsTab(isDark),
                    _buildHistoryTab(isDark),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTabBar(bool isDark) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        padding: const EdgeInsets.all(6),
        indicator: BoxDecoration(
          gradient: const LinearGradient(colors: AppColors.primaryGradient),
          borderRadius: BorderRadius.circular(12),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor:
            isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        unselectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
        tabs: _tabs.map((tab) {
          return Tab(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(tab.icon, size: 16),
                  const SizedBox(width: 6),
                  Text(tab.title),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildQuickShareTab(bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildHeaderCard(
          isDark: isDark,
          title: 'Quick Share',
          description: 'Share PDFs quickly using the unified sharing service.',
          icon: Icons.flash_on_rounded,
          gradient: AppColors.primaryGradient,
        ),
        const SizedBox(height: 16),
        _buildShareButton(
          isDark: isDark,
          label: 'System Share Sheet',
          icon: Icons.share_rounded,
          gradient: AppColors.primaryGradient,
          onPressed: () => _shareViaSystem(),
        ),
        const SizedBox(height: 8),
        _buildShareButton(
          isDark: isDark,
          label: 'Share via Email',
          icon: Icons.email_rounded,
          gradient: AppColors.infoGradient,
          onPressed: () => _shareViaEmail(),
        ),
        const SizedBox(height: 8),
        _buildShareButton(
          isDark: isDark,
          label: 'Share via Bluetooth',
          icon: Icons.bluetooth_rounded,
          gradient: AppColors.purpleGradient,
          onPressed: () => _shareViaBluetooth(),
        ),
        const SizedBox(height: 8),
        _buildShareButton(
          isDark: isDark,
          label: 'Save to Local Storage',
          icon: Icons.save_rounded,
          gradient: AppColors.successGradient,
          onPressed: () => _saveToLocal(),
        ),
        if (_controller.contacts.isNotEmpty) ...[
          const SizedBox(height: 24),
          _buildSectionTitle(isDark, 'Quick Share Contacts'),
          const SizedBox(height: 8),
          ..._controller.contacts.map((contact) => _buildContactCard(isDark, contact)),
        ],
        const SizedBox(height: 16),
        _buildStatusCard(isDark),
      ],
    );
  }

  Widget _buildEmailTab(bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildHeaderCard(
          isDark: isDark,
          title: 'Email Sharing',
          description: 'Send PDFs directly via email with custom templates.',
          icon: Icons.email_rounded,
          gradient: AppColors.infoGradient,
        ),
        const SizedBox(height: 16),
        _buildShareButton(
          isDark: isDark,
          label: 'Compose Email',
          icon: Icons.edit_rounded,
          gradient: AppColors.primaryGradient,
          onPressed: () => _composeEmail(),
        ),
        const SizedBox(height: 8),
        _buildShareButton(
          isDark: isDark,
          label: 'Open Gmail',
          icon: Icons.mail_rounded,
          gradient: AppColors.errorGradient,
          onPressed: () => _openGmail(),
        ),
        const SizedBox(height: 8),
        _buildShareButton(
          isDark: isDark,
          label: 'Open Outlook',
          icon: Icons.mail_outline_rounded,
          gradient: AppColors.infoGradient,
          onPressed: () => _openOutlook(),
        ),
        const SizedBox(height: 24),
        _buildSectionTitle(isDark, 'Email Templates'),
        const SizedBox(height: 8),
        ..._controller.templates
            .map((template) => _buildTemplateCard(isDark, template)),
        const SizedBox(height: 16),
        _buildStatusCard(isDark),
      ],
    );
  }

  Widget _buildBluetoothTab(bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildHeaderCard(
          isDark: isDark,
          title: 'Bluetooth Sharing',
          description:
              'Share PDFs with nearby devices via Bluetooth or Nearby Share.',
          icon: Icons.bluetooth_rounded,
          gradient: AppColors.purpleGradient,
        ),
        const SizedBox(height: 16),
        _buildShareButton(
          isDark: isDark,
          label: 'Nearby Share / AirDrop',
          icon: Icons.near_me_rounded,
          gradient: AppColors.cyanGradient,
          onPressed: () => _shareViaNearby(),
        ),
        const SizedBox(height: 8),
        _buildShareButton(
          isDark: isDark,
          label: 'Discover Devices',
          icon: Icons.bluetooth_searching_rounded,
          gradient: AppColors.purpleGradient,
          onPressed: () => _discoverDevices(),
        ),
        if (_controller.savedDevices.isNotEmpty) ...[
          const SizedBox(height: 24),
          _buildSectionTitle(isDark, 'Saved Devices'),
          const SizedBox(height: 8),
          ..._controller.savedDevices
              .map((device) => _buildDeviceCard(isDark, device)),
        ],
        const SizedBox(height: 16),
        _buildStatusCard(isDark),
      ],
    );
  }

  Widget _buildAppsTab(bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildHeaderCard(
          isDark: isDark,
          title: 'App Sharing',
          description: 'Share PDFs directly to messaging and cloud apps.',
          icon: Icons.apps_rounded,
          gradient: AppColors.successGradient,
        ),
        const SizedBox(height: 20),
        _buildSectionTitle(isDark, 'Messaging Apps'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildAppCard(
                isDark,
                'WhatsApp',
                Icons.message_rounded,
                AppColors.successGradient,
                () => _shareToApp(GeniusSharableApp.whatsApp())),
            _buildAppCard(
                isDark,
                'Telegram',
                Icons.send_rounded,
                AppColors.infoGradient,
                () => _shareToApp(GeniusSharableApp.telegram())),
            _buildAppCard(
                isDark,
                'Signal',
                Icons.shield_rounded,
                AppColors.purpleGradient,
                () => _shareToApp(GeniusSharableApp.signal())),
          ],
        ),
        const SizedBox(height: 20),
        _buildSectionTitle(isDark, 'Cloud Storage'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildAppCard(
                isDark,
                'Google Drive',
                Icons.cloud_rounded,
                AppColors.warningGradient,
                () => _shareToApp(GeniusSharableApp.googleDrive())),
            _buildAppCard(
                isDark,
                'Dropbox',
                Icons.folder_rounded,
                AppColors.infoGradient,
                () => _shareToApp(GeniusSharableApp.dropbox())),
            _buildAppCard(
                isDark,
                'OneDrive',
                Icons.cloud_queue_rounded,
                AppColors.primaryGradient,
                () => _shareToApp(GeniusSharableApp.oneDrive())),
          ],
        ),
        const SizedBox(height: 20),
        _buildSectionTitle(isDark, 'Local Storage'),
        const SizedBox(height: 12),
        _buildShareButton(
          isDark: isDark,
          label: 'Save to Downloads',
          icon: Icons.download_rounded,
          gradient: AppColors.successGradient,
          onPressed: () => _saveToDownloads(),
        ),
        const SizedBox(height: 8),
        _buildShareButton(
          isDark: isDark,
          label: 'Open in External App',
          icon: Icons.open_in_new_rounded,
          gradient: AppColors.infoGradient,
          onPressed: () => _openInExternalApp(),
        ),
        const SizedBox(height: 16),
        _buildStatusCard(isDark),
      ],
    );
  }

  Widget _buildHistoryTab(bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildHeaderCard(
          isDark: isDark,
          title: 'Share History',
          description: 'View your recent sharing activity.',
          icon: Icons.history_rounded,
          gradient: AppColors.warningGradient,
        ),
        const SizedBox(height: 16),
        if (_controller.history.isEmpty)
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : AppColors.lightCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.history_rounded,
                  size: 48,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
                const SizedBox(height: 16),
                Text(
                  'No sharing history yet',
                  style: TextStyle(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          )
        else ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_controller.history.length} shares',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                ),
              ),
              TextButton.icon(
                onPressed: _clearHistory,
                icon: const Icon(Icons.delete_outline_rounded, size: 18),
                label: const Text('Clear'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.error,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ..._controller.history.map((item) => _buildHistoryCard(isDark, item)),
        ],
      ],
    );
  }

  Widget _buildHeaderCard({
    required bool isDark,
    required String title,
    required String description,
    required IconData icon,
    required List<Color> gradient,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            gradient[0].withValues(alpha: 0.15),
            gradient[1].withValues(alpha: 0.05)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: gradient[0].withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradient),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
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
        ],
      ),
    );
  }

  Widget _buildShareButton({
    required bool isDark,
    required String label,
    required IconData icon,
    required List<Color> gradient,
    VoidCallback? onPressed,
  }) {
    final isEnabled =
        !_controller.isLoading && _controller.hasSample && onPressed != null;
    return Container(
      decoration: BoxDecoration(
        gradient: isEnabled ? LinearGradient(colors: gradient) : null,
        color: isEnabled
            ? null
            : (isDark ? AppColors.darkCard : AppColors.lightBorder),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? onPressed : null,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: isEnabled
                      ? Colors.white
                      : (isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary),
                  size: 20,
                ),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: TextStyle(
                    color: isEnabled
                        ? Colors.white
                        : (isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(bool isDark, String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: isDark ? AppColors.darkText : AppColors.lightText,
      ),
    );
  }

  Widget _buildAppCard(bool isDark, String name, IconData icon,
      List<Color> gradient, VoidCallback onPressed) {
    return Container(
      width: 100,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _controller.hasSample && !_controller.isLoading ? onPressed : null,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        gradient[0].withValues(alpha: 0.2),
                        gradient[1].withValues(alpha: 0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: gradient[0], size: 24),
                ),
                const SizedBox(height: 8),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactCard(bool isDark, GeniusQuickShareContact contact) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _quickShareToContact(contact),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  child: Text(
                    contact.name[0].toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contact.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color:
                              isDark ? AppColors.darkText : AppColors.lightText,
                        ),
                      ),
                      Text(
                        contact.target.type.displayName,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    contact.isFavorite
                        ? Icons.star_rounded
                        : Icons.star_border_rounded,
                    color: contact.isFavorite
                        ? AppColors.warning
                        : AppColors.darkTextSecondary,
                  ),
                  onPressed: () => _toggleFavorite(contact.id),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTemplateCard(bool isDark, GeniusShareMessageTemplate template) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _shareWithTemplate(template),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.description_rounded,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        template.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color:
                              isDark ? AppColors.darkText : AppColors.lightText,
                        ),
                      ),
                      Text(
                        template.subject,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.darkTextSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeviceCard(bool isDark, GeniusBluetoothDevice device) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _sendToDevice(device),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _getDeviceIcon(device.type),
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        device.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color:
                              isDark ? AppColors.darkText : AppColors.lightText,
                        ),
                      ),
                      Text(
                        device.type.displayName,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (device.isFavorite)
                  const Icon(
                    Icons.star_rounded,
                    color: AppColors.warning,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryCard(bool isDark, GeniusShareHistoryItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _getStatusColor(item.status).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _getStatusIcon(item.status),
                color: _getStatusColor(item.status),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.fileName,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    ),
                  ),
                  Text(
                    '${item.target.type.displayName} • ${_formatDate(item.timestamp)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Status',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                ),
              ),
              const SizedBox(width: 8),
              if (_controller.isLoading)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _controller.status.isEmpty ? 'Ready' : _controller.status,
            style: TextStyle(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getDeviceIcon(GeniusBluetoothDeviceType type) {
    switch (type) {
      case GeniusBluetoothDeviceType.computer:
        return Icons.computer_rounded;
      case GeniusBluetoothDeviceType.phone:
        return Icons.smartphone_rounded;
      case GeniusBluetoothDeviceType.tablet:
        return Icons.tablet_rounded;
      case GeniusBluetoothDeviceType.printer:
        return Icons.print_rounded;
      case GeniusBluetoothDeviceType.audio:
        return Icons.headphones_rounded;
      default:
        return Icons.bluetooth_rounded;
    }
  }

  IconData _getStatusIcon(GeniusShareStatus status) {
    switch (status) {
      case GeniusShareStatus.completed:
        return Icons.check_circle_rounded;
      case GeniusShareStatus.failed:
        return Icons.error_rounded;
      default:
        return Icons.pending_rounded;
    }
  }

  Color _getStatusColor(GeniusShareStatus status) {
    switch (status) {
      case GeniusShareStatus.completed:
        return AppColors.success;
      case GeniusShareStatus.failed:
        return AppColors.error;
      default:
        return AppColors.warning;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  // Actions
  Future<void> _shareViaSystem() => _controller.shareViaSystem();

  Future<void> _shareViaEmail() => _controller.shareViaEmail();

  Future<void> _shareViaBluetooth() => _controller.shareViaBluetooth();

  Future<void> _saveToLocal() => _controller.saveToLocal();

  Future<void> _composeEmail() => _controller.composeEmail();

  Future<void> _openGmail() => _controller.openGmail();

  Future<void> _openOutlook() => _controller.openOutlook();

  Future<void> _shareViaNearby() => _controller.shareViaNearby();

  Future<void> _discoverDevices() => _controller.discoverDevices();

  Future<void> _sendToDevice(GeniusBluetoothDevice device) =>
      _controller.sendToDevice(device);

  Future<void> _shareToApp(GeniusSharableApp app) =>
      _controller.shareToApp(app);

  Future<void> _saveToDownloads() => _controller.saveToDownloads();

  Future<void> _openInExternalApp() => _controller.openInExternalApp();

  void _toggleFavorite(String contactId) =>
      _controller.toggleFavorite(contactId);

  Future<void> _quickShareToContact(GeniusQuickShareContact contact) =>
      _controller.quickShareToContact(contact);

  Future<void> _shareWithTemplate(GeniusShareMessageTemplate template) =>
      _controller.shareWithTemplate(template);

  Future<void> _clearHistory() => _controller.clearHistory();
}

class _SharingTab {
  final String id;
  final String title;
  final IconData icon;
  final List<Color> gradient;

  _SharingTab({
    required this.id,
    required this.title,
    required this.icon,
    required this.gradient,
  });
}
