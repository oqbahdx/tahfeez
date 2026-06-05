import 'package:flutter/material.dart';
import '../theme/tahfeez_theme.dart';
import '../l10n/app_localizations.dart';

class NavItemData {
  final IconData icon;
  final String label;

  const NavItemData(this.icon, this.label);
}

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
  final List<NavItemData>? items;

  const TahfeezDrawer({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.items,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final appTitle = l10n?.appTitle ?? 'Tahfeez';
    final drawerItems = items ?? _defaultItems(l10n);

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
                for (var i = 0; i < drawerItems.length; i++)
                  _DrawerItem(
                    icon: drawerItems[i].icon,
                    label: drawerItems[i].label,
                    isSelected: currentIndex == i,
                    onTap: () => onTap(i),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<NavItemData> _defaultItems(AppLocalizations? l10n) {
    return [
      NavItemData(Icons.dashboard_outlined, l10n?.dashboard ?? 'Dashboard'),
      NavItemData(Icons.school_outlined, l10n?.classes ?? 'Classes'),
      NavItemData(Icons.people_outline, l10n?.students ?? 'Students'),
      NavItemData(Icons.analytics_outlined, l10n?.reports ?? 'Reports'),
      NavItemData(Icons.settings_outlined, l10n?.settings ?? 'Settings'),
    ];
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
  final List<NavItemData>? items;

  const TahfeezBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.items,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final navItems = items ?? _defaultItems(l10n);

    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      backgroundColor: TahfeezColors.surfaceContainerLowest,
      indicatorColor: TahfeezColors.primaryContainer.withOpacity(0.3),
      destinations: [
        for (final item in navItems)
          NavigationDestination(
            icon: Icon(item.icon),
            selectedIcon: Icon(item.icon, color: TahfeezColors.primary),
            label: item.label,
          ),
      ],
    );
  }

  List<NavItemData> _defaultItems(AppLocalizations? l10n) {
    return [
      NavItemData(Icons.school_outlined, l10n?.classes ?? 'Classes'),
      NavItemData(Icons.people_outline, l10n?.students ?? 'Students'),
      NavItemData(Icons.analytics_outlined, l10n?.reports ?? 'Reports'),
      NavItemData(Icons.settings_outlined, l10n?.settings ?? 'Settings'),
    ];
  }
}
