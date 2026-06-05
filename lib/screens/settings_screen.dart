import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/auth/presentation/blocs/auth_bloc.dart';
import '../features/auth/presentation/blocs/auth_event.dart';
import '../theme/tahfeez_theme.dart';
import '../l10n/app_localizations.dart';


class SettingsScreen extends StatefulWidget {
  final Function(Locale)? onLocaleChange;

  const SettingsScreen({super.key, this.onLocaleChange});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _emailAlerts = false;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: TahfeezColors.background,
      appBar: AppBar(
        title: Text(
          l10n.settings,
          style: TahfeezTextStyles.headlineLg.copyWith(
            color: TahfeezColors.onSurface,
            fontSize: 22,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: TahfeezColors.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: TahfeezColors.onPrimary.withOpacity(0.2),
                    child: const Icon(
                      Icons.person,
                      color: TahfeezColors.onPrimary,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.administrator,
                          style: TahfeezTextStyles.titleLg.copyWith(
                            color: TahfeezColors.onSurface,
                          ),
                        ),
                        Text(
                          'admin@domain.com',
                          style: TahfeezTextStyles.bodyMd.copyWith(
                            color: TahfeezColors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.superAdmin,
                          style: TahfeezTextStyles.labelMd.copyWith(
                            color: TahfeezColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.edit_outlined,
                      color: TahfeezColors.onPrimary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            _sectionTitle(l10n.institution),
            _SettingsTile(
              icon: Icons.calendar_today_outlined,
              title: l10n.academicYear,
              subtitle: '2023 - 2024',
              onTap: () {},
            ),
            _SettingsTile(
              icon: Icons.auto_stories_outlined,
              title: l10n.curriculum,
              subtitle: l10n.curriculumSubtitle,
              onTap: () {},
            ),
            _SettingsTile(
              icon: Icons.badge_outlined,
              title: l10n.staffDirectory,
              subtitle: l10n.staffCount(22),
              onTap: () {},
            ),
            _SettingsTile(
              icon: Icons.location_on_outlined,
              title: l10n.locationBranches,
              subtitle: l10n.locationValue,
              onTap: () {},
            ),

            const SizedBox(height: 8),
            _sectionTitle(l10n.notifications),
            _SwitchTile(
              icon: Icons.notifications_outlined,
              title: l10n.pushNotifications,
              subtitle: l10n.pushNotificationsSubtitle,
              value: _notificationsEnabled,
              onChanged: (v) => setState(() => _notificationsEnabled = v),
            ),
            _SwitchTile(
              icon: Icons.email_outlined,
              title: l10n.emailAlerts,
              subtitle: l10n.emailAlertsSubtitle,
              value: _emailAlerts,
              onChanged: (v) => setState(() => _emailAlerts = v),
            ),

            const SizedBox(height: 8),
            _sectionTitle(l10n.appearance),
            _SwitchTile(
              icon: Icons.dark_mode_outlined,
              title: l10n.darkMode,
              subtitle: l10n.darkModeSubtitle,
              value: _darkMode,
              onChanged: (v) => setState(() => _darkMode = v),
            ),
            _SettingsTile(
              icon: Icons.language_outlined,
              title: l10n.language,
              subtitle: Localizations.localeOf(context).languageCode == 'ar'
                  ? l10n.languageArabic
                  : l10n.languageEnglish,
              onTap: () {
                final currentLocale = Localizations.localeOf(context);
                final newLocale = currentLocale.languageCode == 'en'
                    ? const Locale('ar')
                    : const Locale('en');
                widget.onLocaleChange?.call(newLocale);
              },
            ),

            const SizedBox(height: 8),
            _sectionTitle(l10n.support),
            _SettingsTile(
              icon: Icons.help_outline,
              title: l10n.helpSupport,
              onTap: () {},
            ),
            _SettingsTile(
              icon: Icons.privacy_tip_outlined,
              title: l10n.privacyPolicy,
              onTap: () {},
            ),
            _SettingsTile(
              icon: Icons.info_outline,
              title: l10n.aboutTahfeez,
              subtitle: l10n.version,
              onTap: () {},
            ),

            const SizedBox(height: 16),
            // Sign out
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  context.read<AuthBloc>().add(LogoutEvent());
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: TahfeezColors.error,
                  side: const BorderSide(color: TahfeezColors.errorContainer),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: const Icon(Icons.logout_outlined),
                label: Text(
                  l10n.signOut,
                  style: TahfeezTextStyles.labelLg.copyWith(
                    color: TahfeezColors.error,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 8, top: 4),
    child: Text(
      title,
      style: TahfeezTextStyles.labelMd.copyWith(
        color: TahfeezColors.primaryContainer,
        letterSpacing: 0.5,
      ),
    ),
  );
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        color: TahfeezColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: TahfeezColors.primaryContainer.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: TahfeezColors.primaryContainer, size: 18),
        ),
        title: Text(
          title,
          style: TahfeezTextStyles.labelLg.copyWith(
            color: TahfeezColors.onSurface,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: TahfeezTextStyles.bodyMd.copyWith(
                  color: TahfeezColors.onSurfaceVariant,
                  fontSize: 12,
                ),
              )
            : null,
        trailing: const Icon(
          Icons.chevron_right,
          color: TahfeezColors.onSurfaceVariant,
          size: 20,
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        color: TahfeezColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: TahfeezColors.primaryContainer.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: TahfeezColors.primaryContainer, size: 18),
        ),
        title: Text(
          title,
          style: TahfeezTextStyles.labelLg.copyWith(
            color: TahfeezColors.onSurface,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TahfeezTextStyles.bodyMd.copyWith(
            color: TahfeezColors.onSurfaceVariant,
            fontSize: 12,
          ),
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: TahfeezColors.primaryContainer,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
