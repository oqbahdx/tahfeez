import 'package:flutter/material.dart';
import '../theme/tahfeez_theme.dart';
import '../l10n/app_localizations.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: TahfeezColors.background,
      appBar: AppBar(
        title: Text(
          l10n.reports,
          style: TahfeezTextStyles.headlineLg.copyWith(
            color: TahfeezColors.onSurface,
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              color: TahfeezColors.onSurfaceVariant,
            ),
            onPressed: () {},
          ),
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: TahfeezColors.onSurfaceVariant,
                ),
                onPressed: () {},
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
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: TahfeezColors.primary,
          unselectedLabelColor: TahfeezColors.onSurfaceVariant,
          indicatorColor: TahfeezColors.primary,
          labelStyle: TahfeezTextStyles.labelLg,
          unselectedLabelStyle: TahfeezTextStyles.labelLg,
          tabs: [
            Tab(text: l10n.attendance),
            Tab(text: l10n.subscriptions),
            Tab(text: l10n.salaries),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_AttendanceReportTab(), _SubscriptionsTab(), _SalariesTab()],
      ),
    );
  }
}

// ─── Attendance Report Tab ────────────────────────────────────────────────────
class _AttendanceReportTab extends StatelessWidget {
  const _AttendanceReportTab();

  final _rows = const [
    _AttendanceRow(
      name: 'Ahmed Al-Farsi',
      id: '1042',
      present: 22,
      absent: 0,
      excused: 0,
      rate: 1.0,
    ),
    _AttendanceRow(
      name: 'Fatima Zahra',
      id: '1045',
      present: 20,
      absent: 1,
      excused: 1,
      rate: 0.91,
    ),
    _AttendanceRow(
      name: 'Omar Tariq',
      id: '1051',
      present: 18,
      absent: 4,
      excused: 0,
      rate: 0.81,
    ),
    _AttendanceRow(
      name: 'Yusuf Ibrahim',
      id: '1058',
      present: 21,
      absent: 0,
      excused: 1,
      rate: 0.95,
    ),
    _AttendanceRow(
      name: 'Zainab Khalil',
      id: '1033',
      present: 19,
      absent: 2,
      excused: 1,
      rate: 0.86,
    ),
    _AttendanceRow(
      name: 'Ibrahim Said',
      id: '1077',
      present: 17,
      absent: 3,
      excused: 2,
      rate: 0.77,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Page header
          Text(
            l10n.attendanceReport,
            style: TahfeezTextStyles.headlineLg.copyWith(
              color: TahfeezColors.onSurface,
            ),
          ),
          Text(
            l10n.attendanceReportSubtitle,
            style: TahfeezTextStyles.bodyMd.copyWith(
              color: TahfeezColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),

          // Filters
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: TahfeezColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: TahfeezColors.surfaceVariant),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 500;
                return Flex(
                  direction: isWide ? Axis.horizontal : Axis.vertical,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: isWide ? 1 : 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.selectClass,
                            style: TahfeezTextStyles.labelMd.copyWith(
                              color: TahfeezColors.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            value: 'Advanced Tajweed - Group A',
                            decoration: _dropdownDecoration(),
                            items: const [
                              DropdownMenuItem(
                                value: 'Advanced Tajweed - Group A',
                                child: Text('Advanced Tajweed - Group A'),
                              ),
                              DropdownMenuItem(
                                value: 'Beginner Hifz - Morning',
                                child: Text('Beginner Hifz - Morning'),
                              ),
                            ],
                            onChanged: (_) {},
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: isWide ? 16 : 0, height: isWide ? 0 : 12),
                    Flexible(
                      flex: isWide ? 1 : 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.dateRange,
                            style: TahfeezTextStyles.labelMd.copyWith(
                              color: TahfeezColors.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            readOnly: true,
                            initialValue: 'Oct 01, 2023 - Oct 31, 2023',
                            decoration: _dropdownDecoration().copyWith(
                              prefixIcon: const Icon(
                                Icons.date_range_outlined,
                                color: TahfeezColors.outline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: isWide ? 16 : 0, height: isWide ? 0 : 12),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: FilledButton.icon(
                        onPressed: () {},
                        style: FilledButton.styleFrom(
                          backgroundColor: TahfeezColors.primary,
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                        icon: const Icon(Icons.download_outlined, size: 16),
                        label: Text(
                          l10n.export,
                          style: TahfeezTextStyles.labelLg.copyWith(
                            color: TahfeezColors.onPrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          // Table
          Container(
            decoration: BoxDecoration(
              color: TahfeezColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: TahfeezColors.surfaceVariant),
            ),
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Text(
                        l10n.studentSummary,
                        style: TahfeezTextStyles.titleLg.copyWith(
                          color: TahfeezColors.onSurface,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: TahfeezColors.primaryContainer,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${_rows.length} Students',
                          style: TahfeezTextStyles.labelMd.copyWith(
                            color: TahfeezColors.onPrimaryContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                // Column headers
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.student,
                          style: TahfeezTextStyles.labelLg.copyWith(
                            color: TahfeezColors.onSurfaceVariant,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 52,
                        child: Text(
                          l10n.presentCount,
                          style: TahfeezTextStyles.labelLg.copyWith(
                            color: TahfeezColors.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        width: 52,
                        child: Text(
                          l10n.absentCount,
                          style: TahfeezTextStyles.labelLg.copyWith(
                            color: TahfeezColors.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        width: 52,
                        child: Text(
                          l10n.attendanceRate,
                          style: TahfeezTextStyles.labelLg.copyWith(
                            color: TahfeezColors.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                // Rows
                ...(_rows.map((r) => _AttendanceTableRow(row: r))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _dropdownDecoration() => InputDecoration(
    filled: true,
    fillColor: TahfeezColors.surface,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: TahfeezColors.outlineVariant),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: TahfeezColors.outlineVariant),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: TahfeezColors.secondary, width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
  );
}

class _AttendanceTableRow extends StatelessWidget {
  final _AttendanceRow row;
  const _AttendanceTableRow({required this.row});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final rateColor = row.rate >= 0.9
        ? TahfeezColors.primary
        : row.rate >= 0.8
        ? TahfeezColors.onSurface
        : TahfeezColors.error;

    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: TahfeezColors.surfaceVariant)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: TahfeezColors.primaryFixed,
                        child: Text(
                          row.name[0],
                          style: TahfeezTextStyles.labelLg.copyWith(
                            color: TahfeezColors.onPrimaryFixed,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              row.name,
                              style: TahfeezTextStyles.labelLg.copyWith(
                                color: TahfeezColors.onSurface,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '${l10n.idLabel} ${row.id}',
                              style: TahfeezTextStyles.labelMd.copyWith(
                                color: TahfeezColors.onSurfaceVariant,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 52,
                  child: Center(
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: TahfeezColors.surfaceContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          '${row.present}',
                          style: TahfeezTextStyles.labelLg.copyWith(
                            color: TahfeezColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 52,
                  child: Center(
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: row.absent > 0
                            ? TahfeezColors.errorContainer.withOpacity(0.3)
                            : TahfeezColors.surfaceContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          '${row.absent}',
                          style: TahfeezTextStyles.labelLg.copyWith(
                            color: row.absent > 0
                                ? TahfeezColors.error
                                : TahfeezColors.onSurface,
                            fontWeight: row.absent > 2
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 52,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '${(row.rate * 100).round()}%',
                        style: TahfeezTextStyles.labelLg.copyWith(
                          color: rateColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AttendanceRow {
  final String name, id;
  final int present, absent, excused;
  final double rate;
  const _AttendanceRow({
    required this.name,
    required this.id,
    required this.present,
    required this.absent,
    required this.excused,
    required this.rate,
  });
}

// ─── Subscriptions Tab ────────────────────────────────────────────────────────
class _SubscriptionsTab extends StatelessWidget {
  const _SubscriptionsTab();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.subscriptions,
            style: TahfeezTextStyles.headlineLg.copyWith(
              color: TahfeezColors.onSurface,
            ),
          ),
          Text(
            l10n.subscriptionsSubtitle,
            style: TahfeezTextStyles.bodyMd.copyWith(
              color: TahfeezColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),

          // Summary cards
          LayoutBuilder(
            builder: (context, constraints) {
              final crossCount = constraints.maxWidth > 500 ? 3 : 2;
              return GridView.count(
                crossAxisCount: crossCount,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _SummaryCard(
                    icon: Icons.account_balance_wallet_outlined,
                    label: l10n.collectedThisMonth,
                    value: '\$12,450',
                    iconColor: TahfeezColors.primaryContainer,
                  ),
                  _SummaryCard(
                    icon: Icons.warning_outlined,
                    label: l10n.overdueTotal,
                    value: '\$1,200',
                    iconColor: TahfeezColors.error,
                    valueColor: TahfeezColors.error,
                    hasBorder: true,
                  ),
                  _SummaryCard(
                    icon: Icons.groups_outlined,
                    label: l10n.activeSubscriptions,
                    value: '342',
                    iconColor: TahfeezColors.tertiaryContainer,
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 16),

          // Tabs row
          DefaultTabController(
            length: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TabBar(
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  labelColor: TahfeezColors.error,
                  unselectedLabelColor: TahfeezColors.onSurfaceVariant,
                  indicatorColor: TahfeezColors.error,
                  tabs: [
                    Tab(text: l10n.allRecords),
                    Tab(text: l10n.active),
                    Tab(text: '${l10n.overdue}  •  12'),
                  ],
                ),
                const Divider(height: 1),
                const SizedBox(height: 12),
                ...[
                  _OverdueCard(
                    initials: 'AY',
                    name: 'Ahmad Yusuf',
                    classLabel: 'Hifz Class A',
                    parent: 'Yusuf Ali',
                    amount: '\$100.00',
                    payType: 'Monthly • Cash',
                    dueDate: 'Oct 01, 2023',
                    daysLate: '15 Days Late',
                  ),
                  const SizedBox(height: 10),
                  _OverdueCard(
                    initials: 'FO',
                    name: 'Fatima Omar',
                    classLabel: 'Qaida Noorania',
                    amount: '\$50.00',
                    payType: 'Monthly • Transfer',
                    dueDate: 'Oct 05, 2023',
                    daysLate: '11 Days Late',
                  ),
                  const SizedBox(height: 10),
                  _OverdueCard(
                    initials: 'MK',
                    name: 'Mohammed Khalid',
                    classLabel: 'Tajweed Basics',
                    parent: 'Khalid Hasan',
                    amount: '\$75.00',
                    payType: 'Quarterly • Cash',
                    dueDate: 'Oct 10, 2023',
                    daysLate: '6 Days Late',
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final Color iconColor;
  final Color? valueColor;
  final bool hasBorder;

  const _SummaryCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
    this.valueColor,
    this.hasBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: TahfeezColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: hasBorder
            ? Border.all(color: TahfeezColors.errorContainer.withOpacity(0.3))
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: iconColor, size: 22),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TahfeezTextStyles.labelMd.copyWith(
                  color: hasBorder
                      ? TahfeezColors.error
                      : TahfeezColors.onSurfaceVariant,
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TahfeezTextStyles.headlineLg.copyWith(
                  color: valueColor ?? TahfeezColors.onSurface,
                  fontSize: 22,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OverdueCard extends StatelessWidget {
  final String initials, name, classLabel, amount, payType, dueDate, daysLate;
  final String? parent;

  const _OverdueCard({
    required this.initials,
    required this.name,
    required this.classLabel,
    required this.amount,
    required this.payType,
    required this.dueDate,
    required this.daysLate,
    this.parent,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: TahfeezColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TahfeezColors.errorContainer),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: TahfeezColors.secondaryContainer.withOpacity(
                  0.3,
                ),
                child: Text(
                  initials,
                  style: TahfeezTextStyles.titleLg.copyWith(
                    color: TahfeezColors.onSurface,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TahfeezTextStyles.titleLg.copyWith(
                        color: TahfeezColors.onSurface,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 8,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: TahfeezColors.surfaceVariant,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            classLabel,
                            style: TahfeezTextStyles.labelMd.copyWith(
                              color: TahfeezColors.onSurfaceVariant,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        if (parent != null)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.family_restroom,
                                size: 12,
                                color: TahfeezColors.outline,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${l10n.parentLabel} $parent',
                                style: TahfeezTextStyles.labelMd.copyWith(
                                  color: TahfeezColors.outline,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.more_vert,
                  color: TahfeezColors.primaryContainer,
                  size: 20,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: TahfeezColors.primaryContainer.withOpacity(
                    0.1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: TahfeezColors.errorContainer.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _InfoItem(label: l10n.amount, value: amount),
                  const SizedBox(width: 20),
                  _InfoItem(label: l10n.typeMode, value: payType),
                  const SizedBox(width: 20),
                  _InfoItem(label: l10n.dueDate, value: dueDate, isError: true),
                  const SizedBox(width: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: TahfeezColors.errorContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 12,
                          color: TahfeezColors.onErrorContainer,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          daysLate,
                          style: TahfeezTextStyles.labelMd.copyWith(
                            color: TahfeezColors.onErrorContainer,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label, value;
  final bool isError;
  const _InfoItem({
    required this.label,
    required this.value,
    this.isError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TahfeezTextStyles.labelMd.copyWith(
            color: isError
                ? TahfeezColors.error
                : TahfeezColors.onSurfaceVariant,
            fontSize: 10,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TahfeezTextStyles.bodyMd.copyWith(
            color: isError ? TahfeezColors.error : TahfeezColors.onSurface,
            fontWeight: isError ? FontWeight.w500 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

// ─── Salaries Tab ─────────────────────────────────────────────────────────────
class _SalariesTab extends StatelessWidget {
  const _SalariesTab();

  final _staff = const [
    _StaffSalary(
      name: 'Ahmed Ali',
      initials: 'AA',
      role: 'Lead Teacher',
      amount: '\$1,200',
      isPaid: true,
    ),
    _StaffSalary(
      name: 'Fatima Hassan',
      initials: 'FH',
      role: 'Instructor',
      amount: '\$850',
      isPaid: false,
    ),
    _StaffSalary(
      name: 'Omar Saeed',
      initials: 'OS',
      role: 'Administrator',
      amount: '\$1,500',
      isPaid: true,
    ),
    _StaffSalary(
      name: 'Maryam Khalil',
      initials: 'MK',
      role: 'Senior Instructor',
      amount: '\$1,100',
      isPaid: false,
    ),
    _StaffSalary(
      name: 'Yusuf Noor',
      initials: 'YN',
      role: 'Instructor',
      amount: '\$800',
      isPaid: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.salariesTab,
            style: TahfeezTextStyles.headlineLg.copyWith(
              color: TahfeezColors.onSurface,
            ),
          ),
          Text(
            'Manage staff payroll and payments.',
            style: TahfeezTextStyles.bodyMd.copyWith(
              color: TahfeezColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.staffMembers,
                      style: TahfeezTextStyles.titleLg.copyWith(
                        color: TahfeezColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 8,
                      children: [
                        Text(
                          l10n.staffMember,
                          style: TahfeezTextStyles.labelMd.copyWith(
                            color: TahfeezColors.onSurfaceVariant,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              DropdownButton<String>(
                value: 'October 2023',
                underline: const SizedBox(),
                style: TahfeezTextStyles.bodyMd.copyWith(
                  color: TahfeezColors.onSurface,
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'October 2023',
                    child: Text('October 2023'),
                  ),
                  DropdownMenuItem(
                    value: 'September 2023',
                    child: Text('September 2023'),
                  ),
                ],
                onChanged: (_) {},
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Summary cards
          LayoutBuilder(
            builder: (context, constraints) {
              return Row(
                children: [
                  Expanded(
                    child: _SalarySummaryCard(
                      label: l10n.totalPayroll,
                      value: '\$12,450',
                      subtitle: 'For October 2023',
                      icon: Icons.payments_outlined,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SalarySummaryCard(
                      label: l10n.paid,
                      value: '\$8,200',
                      subtitle: '15 Staff Members',
                      icon: Icons.check_circle_outline,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SalarySummaryCard(
                      label: l10n.unpaid,
                      value: '\$4,250',
                      subtitle: '7 Staff Members',
                      icon: Icons.pending_actions_outlined,
                      valueColor: TahfeezColors.error,
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),

          // Staff list
          Container(
            decoration: BoxDecoration(
              color: TahfeezColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: TahfeezColors.surfaceContainer),
            ),
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: TahfeezColors.surfaceContainer,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.staffMember,
                          style: TahfeezTextStyles.labelLg.copyWith(
                            color: TahfeezColors.onSurfaceVariant,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 120,
                        child: Text(
                          l10n.role,
                          style: TahfeezTextStyles.labelLg.copyWith(
                            color: TahfeezColors.onSurfaceVariant,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 80,
                        child: Text(
                          'Amount',
                          style: TahfeezTextStyles.labelLg.copyWith(
                            color: TahfeezColors.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      SizedBox(
                        width: 80,
                        child: Text(
                          l10n.status,
                          style: TahfeezTextStyles.labelLg.copyWith(
                            color: TahfeezColors.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: 40),
                    ],
                  ),
                ),
                ...(_staff.map((s) => _SalaryRow(staff: s))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SalarySummaryCard extends StatelessWidget {
  final String label, value, subtitle;
  final IconData icon;
  final Color? valueColor;

  const _SalarySummaryCard({
    required this.label,
    required this.value,
    required this.subtitle,
    required this.icon,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: TahfeezColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TahfeezColors.surfaceContainer),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: TahfeezColors.primaryContainer.withOpacity(0.6),
            size: 20,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TahfeezTextStyles.labelMd.copyWith(
              color: TahfeezColors.onSurfaceVariant,
              letterSpacing: 0.5,
            ),
          ),
          Text(
            value,
            style: TahfeezTextStyles.headlineMd.copyWith(
              color: valueColor ?? TahfeezColors.primaryContainer,
              fontSize: 22,
            ),
          ),
          Text(
            subtitle,
            style: TahfeezTextStyles.bodyMd.copyWith(
              color: TahfeezColors.outline,
            ),
          ),
        ],
      ),
    );
  }
}

class _SalaryRow extends StatelessWidget {
  final _StaffSalary staff;
  const _SalaryRow({required this.staff});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: TahfeezColors.surfaceContainer),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(
                    width: 200,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: staff.isPaid
                              ? TahfeezColors.primaryFixed
                              : TahfeezColors.tertiaryFixedDim,
                          child: Text(
                            staff.initials,
                            style: TahfeezTextStyles.labelMd.copyWith(
                              color: staff.isPaid
                                  ? TahfeezColors.onPrimaryFixed
                                  : TahfeezColors.onTertiaryFixed,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            staff.name,
                            style: TahfeezTextStyles.labelLg.copyWith(
                              color: TahfeezColors.onSurface,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 120,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: TahfeezColors.primaryContainer.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        staff.role,
                        style: TahfeezTextStyles.labelMd.copyWith(
                          color: TahfeezColors.primaryContainer,
                          fontSize: 11,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 80,
                    child: Text(
                      staff.amount,
                      style: TahfeezTextStyles.bodyLg.copyWith(
                        color: TahfeezColors.onSurface,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  SizedBox(
                    width: 80,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: staff.isPaid
                              ? TahfeezColors.surfaceContainer
                              : TahfeezColors.errorContainer.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: staff.isPaid
                                ? TahfeezColors.outlineVariant
                                : TahfeezColors.errorContainer,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: staff.isPaid
                                    ? TahfeezColors.primary
                                    : TahfeezColors.error,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              staff.isPaid ? 'Paid' : 'Unpaid',
                              style: TahfeezTextStyles.labelMd.copyWith(
                                color: staff.isPaid
                                    ? TahfeezColors.primary
                                    : TahfeezColors.error,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 40,
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.more_vert,
                        size: 18,
                        color: TahfeezColors.outline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StaffSalary {
  final String name, initials, role, amount;
  final bool isPaid;
  const _StaffSalary({
    required this.name,
    required this.initials,
    required this.role,
    required this.amount,
    required this.isPaid,
  });
}
