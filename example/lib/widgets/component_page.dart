import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/code_viewer.dart';

class ComponentPage extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final List<Color> gradient;
  final bool isDark;
  final bool isRTL;
  final ValueChanged<bool> onRTLChanged;
  final bool isGenerating;
  final VoidCallback? onGenerate;
  final String codeExample;
  final Widget preview;

  const ComponentPage({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.gradient,
    required this.isDark,
    required this.isRTL,
    required this.onRTLChanged,
    required this.isGenerating,
    this.onGenerate,
    required this.codeExample,
    required this.preview,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          _buildOptions(),
          const SizedBox(height: 16),
          _buildPreview(),
          const SizedBox(height: 16),
          _buildCode(),
          const SizedBox(height: 16),
          _buildGenerateButton(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          gradient.first.withValues(alpha: isDark ? 0.2 : 0.1),
          gradient.last.withValues(alpha: isDark ? 0.1 : 0.05),
        ]),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: gradient.first.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradient),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                    color: gradient.first.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4))
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color:
                            isDark ? AppColors.darkText : AppColors.lightText)),
                const SizedBox(height: 4),
                Text(description,
                    style: TextStyle(
                        fontSize: 14,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Row(
        children: [
          Icon(Icons.tune_rounded,
              size: 18,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary),
          const SizedBox(width: 8),
          Text('Options',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkText : AppColors.lightText)),
          const Spacer(),
          Text('LTR',
              style: TextStyle(
                  fontSize: 12,
                  color:
                      !isRTL ? AppColors.primary : AppColors.darkTextSecondary,
                  fontWeight: !isRTL ? FontWeight.w600 : FontWeight.normal)),
          Switch(
              value: isRTL,
              onChanged: onRTLChanged,
              activeThumbColor: AppColors.primary),
          Text('RTL',
              style: TextStyle(
                  fontSize: 12,
                  color:
                      isRTL ? AppColors.primary : AppColors.darkTextSecondary,
                  fontWeight: isRTL ? FontWeight.w600 : FontWeight.normal)),
        ],
      ),
    );
  }

  Widget _buildPreview() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.preview_rounded,
                size: 18,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary),
            const SizedBox(width: 8),
            Text('Preview',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkText : AppColors.lightText)),
          ]),
          const SizedBox(height: 16),
          preview,
        ],
      ),
    );
  }

  Widget _buildCode() {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(children: [
              Icon(Icons.code_rounded,
                  size: 18,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary),
              const SizedBox(width: 8),
              Text('Code Example',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color:
                          isDark ? AppColors.darkText : AppColors.lightText)),
            ]),
          ),
          CodeViewer(code: codeExample, height: 200),
        ],
      ),
    );
  }

  Widget _buildGenerateButton() {
    if (onGenerate == null) return const SizedBox.shrink();
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: isGenerating ? null : onGenerate,
        icon: isGenerating
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white))
            : const Icon(Icons.picture_as_pdf_rounded),
        label: Text(isGenerating ? 'جاري الإنشاء...' : 'إنشاء PDF'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: gradient.first,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}
