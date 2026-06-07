import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/toast_helper.dart';
import '../../../../theme/tahfeez_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/recitation.dart';
import '../blocs/recitation_bloc.dart';
import '../blocs/recitation_event.dart';
import '../blocs/recitation_state.dart';
import '../widgets/recitation_card.dart';
import '../widgets/empty_recitations_widget.dart';

class RecitationHistoryPage extends StatefulWidget {
  final String studentId;
  final String studentName;

  const RecitationHistoryPage({
    super.key,
    required this.studentId,
    required this.studentName,
  });

  @override
  State<RecitationHistoryPage> createState() => _RecitationHistoryPageState();
}

class _RecitationHistoryPageState extends State<RecitationHistoryPage> {
  String? _selectedMonth;

  @override
  void initState() {
    super.initState();
    context.read<RecitationBloc>().add(
      GetRecitationsByStudentEvent(widget.studentId),
    );
  }

  List<String> _extractMonths(List<Recitation> recitations) {
    final months = <String>{};
    for (final r in recitations) {
      months.add(
        '${r.date.year}-${r.date.month.toString().padLeft(2, '0')}',
      );
    }
    final sorted = months.toList()..sort((a, b) => b.compareTo(a));
    return sorted;
  }

  String _monthLabel(String monthKey) {
    final parts = monthKey.split('-');
    if (parts.length != 2) return monthKey;
    final month = int.tryParse(parts[1]) ?? 1;
    final year = parts[0];
    final monthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${monthNames[month - 1]} $year';
  }

  Future<void> _onRefresh() async {
    context.read<RecitationBloc>().add(
      GetRecitationsByStudentEvent(widget.studentId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: TahfeezColors.surfaceContainerLow,
      appBar: AppBar(
        backgroundColor: TahfeezColors.surfaceContainerLowest,
        leading: const BackButton(color: TahfeezColors.primary),
        title: Text(
          l10n.recitationHistory,
          style: TahfeezTextStyles.headlineLg.copyWith(
            color: TahfeezColors.onSurface,
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: TahfeezColors.onSurfaceVariant,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocConsumer<RecitationBloc, RecitationState>(
        listener: (context, state) {
          if (state is RecitationError) {
            if (context.read<RecitationBloc>().state is! RecitationsLoaded) {
              AppToast.error(state.message);
            }
          }
        },
        builder: (context, state) {
          final isLoading = state is RecitationLoading;
          final initialError = state is RecitationError;
          final hasData = state is RecitationsLoaded;

          List<Recitation> displayRecitations = [];
          List<Recitation> allRecitations = [];
          List<String> months = [];

          if (hasData) {
            allRecitations = state.recitations;
            displayRecitations = state.filteredRecitations;
            months = _extractMonths(allRecitations);
            if (_selectedMonth == null && months.isNotEmpty) {
              _selectedMonth = months.first;
            }
            if (months.isNotEmpty &&
                _selectedMonth != null &&
                !months.contains(_selectedMonth)) {
              _selectedMonth = months.first;
            }
          }

          return Column(
            children: [
              Container(
                color: TahfeezColors.surfaceContainerLowest,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.studentName,
                      style: TahfeezTextStyles.bodyLg.copyWith(
                        color: TahfeezColors.onSurfaceVariant,
                      ),
                    ),
                    if (months.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            ...months.map((m) {
                              final isSelected = _selectedMonth == m;
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: InkWell(
                                  onTap: () {
                                    setState(() => _selectedMonth = m);
                                    context.read<RecitationBloc>().add(
                                      SetSelectedMonthEvent(m),
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? TahfeezColors.primary
                                          : TahfeezColors
                                              .surfaceContainerLowest,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: isSelected
                                            ? Colors.transparent
                                            : TahfeezColors.outlineVariant,
                                      ),
                                    ),
                                    child: Text(
                                      _monthLabel(m),
                                      style: TahfeezTextStyles.labelLg
                                          .copyWith(
                                        color: isSelected
                                            ? TahfeezColors.onPrimary
                                            : TahfeezColors.onSurface,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Expanded(
                child: _buildBody(
                  l10n,
                  isLoading,
                  initialError,
                  hasData,
                  displayRecitations,
                  allRecitations,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody(
    AppLocalizations l10n,
    bool isLoading,
    bool initialError,
    bool hasData,
    List<Recitation> displayRecitations,
    List<Recitation> allRecitations,
  ) {
    if (isLoading && !hasData) {
      return _buildShimmer();
    }

    if (initialError && !hasData) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: TahfeezColors.error.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.wifi_off_rounded,
                  size: 36,
                  color: TahfeezColors.error.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                l10n.failedToLoadRecitations,
                style: TahfeezTextStyles.titleLg.copyWith(
                  color: TahfeezColors.onSurface,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.checkConnectionAndRetry,
                style: TahfeezTextStyles.bodyMd.copyWith(
                  color: TahfeezColors.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _onRefresh,
                style: FilledButton.styleFrom(
                  backgroundColor: TahfeezColors.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: Text(l10n.retry),
              ),
            ],
          ),
        ),
      );
    }

    if (!hasData || allRecitations.isEmpty) {
      return EmptyRecitationsWidget(onRetry: _onRefresh);
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: TahfeezColors.primary,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: TahfeezColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: TahfeezColors.outlineVariant),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.monthlyProgress.toUpperCase(),
                        style: TahfeezTextStyles.labelMd.copyWith(
                          color: TahfeezColors.onSurfaceVariant,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${displayRecitations.length} ${l10n.sessions}',
                        style: TahfeezTextStyles.titleLg.copyWith(
                          color: TahfeezColors.onSurface,
                        ),
                      ),
                      if (displayRecitations.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: [
                            _CategoryCard(
                              title: l10n.newHifdh,
                              count: displayRecitations
                                  .where((r) => r.typeValue == 1)
                                  .length,
                              color: TahfeezColors.primary,
                            ),
                            _CategoryCard(
                              title: l10n.reviewMurajaah,
                              count: displayRecitations
                                  .where((r) => r.typeValue == 2)
                                  .length,
                              color: TahfeezColors.tertiary,
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: TahfeezColors.primaryFixed,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: const Icon(
                    Icons.trending_up,
                    color: TahfeezColors.onPrimaryFixedVariant,
                  ),
                ),
              ],
            ),
          ),
          ...displayRecitations.map(
            (r) => RecitationCard(recitation: r),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmer() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: TahfeezColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: TahfeezColors.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 120,
                  height: 14,
                  decoration: BoxDecoration(
                    color: TahfeezColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const Spacer(),
                Container(
                  width: 60,
                  height: 22,
                  decoration: BoxDecoration(
                    color: TahfeezColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: 80,
              height: 14,
              decoration: BoxDecoration(
                color: TahfeezColors.surfaceContainer,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: 100,
              height: 28,
              decoration: BoxDecoration(
                color: TahfeezColors.surfaceContainer,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String title;
  final int count;
  final Color color;

  const _CategoryCard({
    required this.title,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$count ',
            style: TahfeezTextStyles.labelLg.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            title,
            style: TahfeezTextStyles.labelMd.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
