import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/tahfeez_theme.dart';
import '../widgets/shared_widgets.dart';
import '../l10n/app_localizations.dart';
import '../features/class/presentation/blocs/class_bloc.dart';
import '../features/class/presentation/blocs/class_state.dart';
import '../features/attendance/presentation/bloc/attendance_bloc.dart';
import '../features/attendance/presentation/pages/attendance_by_date_page.dart';

class DashboardScreen extends StatefulWidget {
  final Function(Locale)? onLocaleChange;

  const DashboardScreen({super.key, this.onLocaleChange});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: TahfeezColors.background,
      appBar: AppBar(
        backgroundColor: TahfeezColors.surfaceContainerLowest,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.overview,
              style: TahfeezTextStyles.headlineLg.copyWith(
                color: TahfeezColors.onSurface,
                fontSize: 24,
              ),
            ),
            Text(
              l10n.welcomeBackSubtitle,
              style: TahfeezTextStyles.bodyMd.copyWith(
                color: TahfeezColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: TahfeezColors.onSurfaceVariant,
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: TahfeezColors.error,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: TahfeezColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: TahfeezColors.outlineVariant),
            ),
            child: Text(
              l10n.hijriDate,
              style: TahfeezTextStyles.labelMd.copyWith(
                color: TahfeezColors.onSurface,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats Grid
            LayoutBuilder(
              builder: (context, constraints) {
                final crossCount = constraints.maxWidth > 600 ? 4 : 2;
                return GridView.count(
                  crossAxisCount: crossCount,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: constraints.maxWidth > 600 ? 1.2 : 1.1,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    StatCard(
                      icon: Icons.group,
                      label: l10n.totalStudents,
                      value: '1,248',
                      badge: l10n.thisMonthBadge,
                    ),
                    StatCard(
                      icon: Icons.school,
                      label: l10n.activeClasses,
                      value: '42',
                      iconBgColor: TahfeezColors.secondaryContainer,
                      iconColor: TahfeezColors.secondary,
                    ),
                    StatCard(
                      icon: Icons.how_to_reg,
                      label: l10n.todaysAttendance,
                      value: '94%',
                      bgColor: TahfeezColors.primaryContainer,
                      iconBgColor: Colors.white.withOpacity(0.2),
                      iconColor: TahfeezColors.onPrimary,
                    ),
                    StatCard(
                      icon: Icons.payments_outlined,
                      label: l10n.overdueSubscriptions,
                      value: '18',
                      iconBgColor: TahfeezColors.errorContainer,
                      iconColor: TahfeezColors.onErrorContainer,
                      valueColor: TahfeezColors.error,
                      badge: l10n.actionNeeded,
                      badgeColor: TahfeezColors.errorContainer,
                      badgeTextColor: TahfeezColors.onErrorContainer,
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 24),

            // Recent Activity + Quick Actions layout
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 800) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 2, child: _buildActivityFeed(context)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildRightColumn(context)),
                    ],
                  );
                }
                return Column(
                  children: [
                    _buildActivityFeed(context),
                    const SizedBox(height: 16),
                    _buildRightColumn(context),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityFeed(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        color: TahfeezColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TahfeezColors.surfaceVariant),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SectionHeader(
              title: l10n.recentActivity,
              leadingIcon: Icons.history,
              actionLabel: l10n.viewAll,
              onAction: () {},
            ),
          ),
          const Divider(height: 1),
          _ActivityItem(
            name: 'Omar Hasan',
            action: l10n.completed,
            detail: 'Surah Al-Mulk',
            time: '10 min ago',
            classLabel: 'Class A - Morning',
            statusLabel: l10n.excellent,
            statusColor: TahfeezColors.secondary,
            initials: 'OH',
          ),
          const Divider(height: 1),
          _ActivityItem(
            name: 'Fatima Ali',
            action: l10n.revised,
            detail: "Juz' Amma",
            time: '45 min ago',
            classLabel: 'Class B - Evening',
            progressValue: 0.8,
            initials: 'FA',
          ),
          const Divider(height: 1),
          _ActivityItem(
            name: 'Zaid Yusuf',
            action: l10n.missed,
            detail: 'scheduled recitation',
            time: '2 hrs ago',
            statusLabel: l10n.needsFollowUp,
            statusColor: TahfeezColors.error,
            initials: 'ZY',
            actionIsError: true,
          ),
        ],
      ),
    );
  }

  Widget _buildRightColumn(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        // Quick Actions
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: TahfeezColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: TahfeezColors.surfaceVariant),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.quickActions,
                style: TahfeezTextStyles.titleLg.copyWith(
                  color: TahfeezColors.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1.3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _QuickAction(
                    icon: Icons.how_to_reg,
                    label: l10n.markAttendance,
                    color: TahfeezColors.primaryContainer,
                    onTap: () {
                      final classBloc = context.read<ClassBloc>();
                      final classState = classBloc.state;
                      String classId = '';
                      String className = '';
                      if (classState is ClassesLoaded && classState.classes.isNotEmpty) {
                        classId = classState.classes.first.id;
                        className = classState.classes.first.name;
                      }
                      final bloc = context.read<AttendanceBloc>();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: bloc,
                            child: AttendanceByDatePage(
                              classId: classId,
                              className: className,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  _QuickAction(
                    icon: Icons.person_add_outlined,
                    label: l10n.addStudent,
                    color: TahfeezColors.tertiary,
                  ),
                  _QuickAction(
                    icon: Icons.event_outlined,
                    label: l10n.scheduleExam,
                    color: TahfeezColors.secondary,
                  ),
                  _QuickAction(
                    icon: Icons.campaign_outlined,
                    label: l10n.sendAnnouncement,
                    color: TahfeezColors.onSurfaceVariant,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Upcoming Today
        Container(
          decoration: BoxDecoration(
            color: TahfeezColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: TahfeezColors.surfaceVariant),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Text(
                  l10n.upcomingToday,
                  style: TahfeezTextStyles.titleLg.copyWith(
                    color: TahfeezColors.onSurface,
                  ),
                ),
              ),
              const Divider(height: 1),
              _UpcomingItem(
                title: l10n.hifzRevisionAdvanced,
                time: '14:00 - 15:30',
                color: TahfeezColors.primaryContainer,
              ),
              _UpcomingItem(
                title: l10n.tajweedBasicsBeginners,
                time: '16:00 - 17:00',
                color: TahfeezColors.tertiaryContainer,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final String name, action, detail, time, initials;
  final String? classLabel, statusLabel;
  final Color? statusColor;
  final double? progressValue;
  final bool actionIsError;

  const _ActivityItem({
    required this.name,
    required this.action,
    required this.detail,
    required this.time,
    required this.initials,
    this.classLabel,
    this.statusLabel,
    this.statusColor,
    this.progressValue,
    this.actionIsError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: TahfeezColors.primaryContainer.withOpacity(0.2),
            child: Text(
              initials,
              style: TahfeezTextStyles.labelMd.copyWith(
                color: TahfeezColors.primaryContainer,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: name,
                              style: TahfeezTextStyles.labelLg.copyWith(
                                color: TahfeezColors.onSurface,
                              ),
                            ),
                            TextSpan(
                              text: ' $action ',
                              style: TahfeezTextStyles.bodyMd.copyWith(
                                color: actionIsError
                                    ? TahfeezColors.error
                                    : TahfeezColors.onSurfaceVariant,
                              ),
                            ),
                            TextSpan(
                              text: detail,
                              style: TahfeezTextStyles.labelLg.copyWith(
                                color: TahfeezColors.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      time,
                      style: TahfeezTextStyles.labelMd.copyWith(
                        color: TahfeezColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    if (classLabel != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: TahfeezColors.primaryContainer.withOpacity(
                            0.1,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          classLabel!,
                          style: TahfeezTextStyles.labelMd.copyWith(
                            color: TahfeezColors.primaryContainer,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    if (statusLabel != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: (statusColor ?? TahfeezColors.error)
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          statusLabel!,
                          style: TahfeezTextStyles.labelMd.copyWith(
                            color: statusColor ?? TahfeezColors.error,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                    if (progressValue != null) ...[
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 80,
                        height: 6,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: LinearProgressIndicator(
                            value: progressValue,
                            backgroundColor: TahfeezColors.surfaceVariant,
                            valueColor: const AlwaysStoppedAnimation(
                              TahfeezColors.primaryContainer,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${(progressValue! * 100).round()}%',
                        style: TahfeezTextStyles.labelMd.copyWith(
                          color: TahfeezColors.onSurfaceVariant,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: TahfeezColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(
              label,
              style: TahfeezTextStyles.labelMd.copyWith(
                color: TahfeezColors.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _UpcomingItem extends StatelessWidget {
  final String title, time;
  final Color color;

  const _UpcomingItem({
    required this.title,
    required this.time,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TahfeezTextStyles.labelLg.copyWith(
                        color: TahfeezColors.onSurface,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.schedule,
                          size: 12,
                          color: TahfeezColors.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          time,
                          style: TahfeezTextStyles.bodyMd.copyWith(
                            color: TahfeezColors.onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
