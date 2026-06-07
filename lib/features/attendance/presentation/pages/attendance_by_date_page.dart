import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/toast_helper.dart';
import '../../../../theme/tahfeez_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/attendance.dart';
import '../../domain/enums/attendance_status.dart';
import '../bloc/attendance_bloc.dart';
import '../bloc/attendance_event.dart';
import '../bloc/attendance_state.dart';
import '../widgets/attendance_shimmer.dart';
import '../widgets/attendance_error_view.dart';
import '../widgets/attendance_empty_view.dart';
import '../widgets/attendance_status_dropdown.dart';

class AttendanceByDatePage extends StatefulWidget {
  final String classId;
  final String className;

  const AttendanceByDatePage({
    super.key,
    required this.classId,
    required this.className,
  });

  @override
  State<AttendanceByDatePage> createState() => _AttendanceByDatePageState();
}

class _AttendanceByDatePageState extends State<AttendanceByDatePage> {
  late DateTime _selectedDate;
  final Map<String, AttendanceStatus> _statusChanges = {};

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _fetchAttendance();
  }

  void _fetchAttendance() {
    context.read<AttendanceBloc>().add(
      FetchAttendanceByDate(
        date: _selectedDate,
        classId: widget.classId,
      ),
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: now,
      helpText: 'Select date',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: TahfeezColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      if (picked.isAfter(now)) {
        if (mounted) AppToast.error('Date cannot be in the future');
        return;
      }
      setState(() {
        _selectedDate = picked;
        _statusChanges.clear();
      });
      _fetchAttendance();
    }
  }

  void _onStatusChanged(String userId, AttendanceStatus? status) {
    if (status != null) {
      setState(() {
        _statusChanges[userId] = status;
      });
    }
  }

  void _submitAll() {
    final state = context.read<AttendanceBloc>().state;
    if (state is! AttendanceLoaded && state is! AttendanceEmpty) return;

    if (state is AttendanceLoaded && state.attendances.isEmpty) {
      AppToast.error('No students to save');
      return;
    }

    final records = <Map<String, dynamic>>[];
    if (state is AttendanceLoaded) {
      for (final a in state.attendances) {
        records.add({
          'userId': a.userId,
          'date': _selectedDate,
          'status': (_statusChanges[a.userId] ?? a.status).toApi(),
          'notes': null,
        });
      }
    }

    if (records.isEmpty) {
      AppToast.error('No attendance records to save');
      return;
    }

    context.read<AttendanceBloc>().add(RecordAttendanceEvent(records));
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: TahfeezColors.surfaceContainerLow,
      appBar: AppBar(
        backgroundColor: TahfeezColors.surfaceContainerLowest,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            color: TahfeezColors.surfaceContainerLowest,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                color: TahfeezColors.surfaceContainer,
                width: 1,
              ),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 16,
                color: TahfeezColors.onSurface,
              ),
            ),
          ),
        ),
        title: Text(
          l10n.recordAttendance,
          style: TahfeezTextStyles.headlineLg.copyWith(
            color: TahfeezColors.onSurface,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: BlocConsumer<AttendanceBloc, AttendanceState>(
        listenWhen: (previous, current) =>
            current is AttendanceSuccess || current is AttendanceError,
        listener: (context, state) {
          if (state is AttendanceSuccess) {
            AppToast.success(state.message);
            _fetchAttendance();
          } else if (state is AttendanceError) {
            final current = context.read<AttendanceBloc>().state;
            if (current is! AttendanceLoaded && current is! AttendanceEmpty) {
              AppToast.error(state.message);
            }
          }
        },
        builder: (context, state) {
          final isLoading = state is AttendanceLoading;
          final isSubmitting = state is AttendanceSubmitting;
          final hasData = state is AttendanceLoaded;
          final isEmpty = state is AttendanceEmpty;
          final error = state is AttendanceError;

          final List<Attendance> attendances =
              hasData ? state.attendances : [];

          return Column(
            children: [
              Container(
                color: TahfeezColors.surfaceContainerLowest,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Row(
                  children: [
                    InkWell(
                      onTap: _pickDate,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: TahfeezColors.surfaceContainer,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: TahfeezColors.outlineVariant,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              size: 16,
                              color: TahfeezColors.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _formatDate(_selectedDate),
                              style: TahfeezTextStyles.labelLg.copyWith(
                                color: TahfeezColors.onSurface,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.arrow_drop_down,
                              size: 18,
                              color: TahfeezColors.onSurfaceVariant,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: TahfeezColors.surfaceContainer,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: TahfeezColors.outlineVariant,
                          ),
                        ),
                        child: Text(
                          widget.className,
                          style: TahfeezTextStyles.labelLg.copyWith(
                            color: TahfeezColors.onSurface,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _buildBody(
                  isLoading,
                  isSubmitting,
                  hasData,
                  isEmpty,
                  error,
                  attendances,
                  state,
                  l10n,
                ),
              ),
              if (hasData || isEmpty)
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: isSubmitting ? null : _submitAll,
                        style: FilledButton.styleFrom(
                          backgroundColor: TahfeezColors.primary,
                          disabledBackgroundColor:
                              TahfeezColors.primary.withOpacity(0.5),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        icon: isSubmitting
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: TahfeezColors.onPrimary,
                                ),
                              )
                            : const Icon(
                                Icons.save_outlined,
                                size: 18,
                                color: TahfeezColors.onPrimary,
                              ),
                        label: Text(
                          isSubmitting ? 'Saving...' : 'Save Attendance',
                          style: TahfeezTextStyles.labelLg.copyWith(
                            color: TahfeezColors.onPrimary,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody(
    bool isLoading,
    bool isSubmitting,
    bool hasData,
    bool isEmpty,
    bool error,
    List<Attendance> attendances,
    AttendanceState state,
    AppLocalizations l10n,
  ) {
    if (isLoading && !hasData && !isEmpty) {
      return const AttendanceShimmer();
    }

    if (error && !hasData && !isEmpty) {
      return AttendanceErrorView(
        message: (state as AttendanceError).message,
        onRetry: _fetchAttendance,
      );
    }

    if (!hasData && isEmpty) {
      return AttendanceEmptyView(
        onRetry: _fetchAttendance,
      );
    }

    if (hasData && attendances.isEmpty) {
      return AttendanceEmptyView(
        title: 'No students found',
        subtitle: 'No attendance records for this date.',
        onRetry: _fetchAttendance,
      );
    }

    return RefreshIndicator(
      onRefresh: () async => _fetchAttendance(),
      color: TahfeezColors.primary,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: attendances.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final a = attendances[index];
          final overriddenStatus = _statusChanges[a.userId];

          return Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: TahfeezColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: TahfeezColors.outlineVariant),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor:
                      TahfeezColors.primaryFixedDim.withOpacity(0.4),
                  child: Text(
                    _initials(a.userName ?? '??'),
                    style: TahfeezTextStyles.labelLg.copyWith(
                      color: TahfeezColors.onPrimaryFixed,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    a.userName ?? 'Unknown',
                    style: TahfeezTextStyles.titleLg.copyWith(
                      color: TahfeezColors.onSurface,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                AttendanceStatusDropdown(
                  value: overriddenStatus ?? a.status,
                  onChanged: (s) => _onStatusChanged(a.userId, s),
                  compact: true,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}
