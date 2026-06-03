import 'package:flutter/material.dart';
import '../theme/tahfeez_theme.dart';
import '../l10n/app_localizations.dart';

class StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? bgColor;
  final Color iconBgColor;
  final Color iconColor;
  final Color? valueColor;
  final String? badge;
  final Color? badgeColor;
  final Color? badgeTextColor;

  const StatCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.bgColor,
    this.iconBgColor = TahfeezColors.primaryContainer,
    this.iconColor = TahfeezColors.primaryContainer,
    this.valueColor,
    this.badge,
    this.badgeColor,
    this.badgeTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor ?? TahfeezColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: TahfeezColors.outlineVariant.withOpacity(0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const Spacer(),
              if (badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color:
                        badgeColor ??
                        TahfeezColors.primaryContainer.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    badge!,
                    style: TahfeezTextStyles.labelMd.copyWith(
                      color: badgeTextColor ?? TahfeezColors.primaryContainer,
                      fontSize: 10,
                    ),
                  ),
                ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TahfeezTextStyles.headlineLg.copyWith(
                  fontSize: 24,
                  color: valueColor ?? TahfeezColors.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TahfeezTextStyles.labelMd.copyWith(
                  color: TahfeezColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final IconData? leadingIcon;
  final String? actionLabel;
  final VoidCallback? onAction;

  const SectionHeader({
    super.key,
    required this.title,
    this.leadingIcon,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (leadingIcon != null) ...[
          Icon(leadingIcon, size: 18, color: TahfeezColors.primary),
          const SizedBox(width: 8),
        ],
        Expanded(
          child: Text(
            title,
            style: TahfeezTextStyles.titleLg.copyWith(
              color: TahfeezColors.onSurface,
            ),
          ),
        ),
        if (actionLabel != null)
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
            ),
            child: Text(
              actionLabel!,
              style: TahfeezTextStyles.labelMd.copyWith(
                color: TahfeezColors.primary,
              ),
            ),
          ),
      ],
    );
  }
}

class TahfeezChip extends StatelessWidget {
  final String label;
  final Color bgColor;
  final Color textColor;
  final IconData? icon;

  const TahfeezChip({
    super.key,
    required this.label,
    required this.bgColor,
    required this.textColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: textColor),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TahfeezTextStyles.labelMd.copyWith(
              color: textColor,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class TahfeezDrawer extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const TahfeezDrawer({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dashboard = l10n?.dashboard ?? 'Dashboard';
    final classes = l10n?.classes ?? 'Classes';
    final students = l10n?.students ?? 'Students';
    final reports = l10n?.reports ?? 'Reports';
    final settings = l10n?.settings ?? 'Settings';
    final appTitle = l10n?.appTitle ?? 'Tahfeez';

    return Container(
      color: TahfeezColors.surfaceContainerLowest,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: TahfeezColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.auto_stories,
                    color: TahfeezColors.onPrimary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  appTitle,
                  style: TahfeezTextStyles.titleLg.copyWith(
                    color: TahfeezColors.onSurface,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _DrawerItem(
                  icon: Icons.dashboard_outlined,
                  label: dashboard,
                  isSelected: currentIndex == 0,
                  onTap: () => onTap(0),
                ),
                _DrawerItem(
                  icon: Icons.school_outlined,
                  label: classes,
                  isSelected: currentIndex == 1,
                  onTap: () => onTap(1),
                ),
                _DrawerItem(
                  icon: Icons.people_outline,
                  label: students,
                  isSelected: currentIndex == 2,
                  onTap: () => onTap(2),
                ),
                _DrawerItem(
                  icon: Icons.analytics_outlined,
                  label: reports,
                  isSelected: currentIndex == 3,
                  onTap: () => onTap(3),
                ),
                _DrawerItem(
                  icon: Icons.settings_outlined,
                  label: settings,
                  isSelected: currentIndex == 4,
                  onTap: () => onTap(4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected
              ? TahfeezColors.primary
              : TahfeezColors.onSurfaceVariant,
        ),
        title: Text(
          label,
          style: TahfeezTextStyles.labelLg.copyWith(
            color: isSelected ? TahfeezColors.primary : TahfeezColors.onSurface,
          ),
        ),
        selected: isSelected,
        selectedTileColor: TahfeezColors.primaryContainer.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        onTap: onTap,
      ),
    );
  }
}

class TahfeezBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const TahfeezBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final classes = l10n?.classes ?? 'Classes';
    final students = l10n?.students ?? 'Students';
    final reports = l10n?.reports ?? 'Reports';
    final settings = l10n?.settings ?? 'Settings';

    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      backgroundColor: TahfeezColors.surfaceContainerLowest,
      indicatorColor: TahfeezColors.primaryContainer.withOpacity(0.3),
      destinations: [
        NavigationDestination(
          icon: const Icon(Icons.school_outlined),
          selectedIcon: const Icon(Icons.school, color: TahfeezColors.primary),
          label: classes,
        ),
        NavigationDestination(
          icon: const Icon(Icons.people_outline),
          selectedIcon: const Icon(Icons.people, color: TahfeezColors.primary),
          label: students,
        ),
        NavigationDestination(
          icon: const Icon(Icons.analytics_outlined),
          selectedIcon: const Icon(
            Icons.analytics,
            color: TahfeezColors.primary,
          ),
          label: reports,
        ),
        NavigationDestination(
          icon: const Icon(Icons.settings_outlined),
          selectedIcon: const Icon(
            Icons.settings,
            color: TahfeezColors.primary,
          ),
          label: settings,
        ),
      ],
    );
  }
}
