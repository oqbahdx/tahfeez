import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/auth/auth_service.dart';
import '../core/di/injection_container.dart' as di;
import '../core/utils/toast_helper.dart';
import '../features/auth/domain/entities/user.dart';
import '../features/class/domain/entities/class_entity.dart';
import '../features/class/domain/usecases/class_usecases.dart';
import '../features/class/presentation/blocs/class_bloc.dart';
import '../features/student/presentation/blocs/student_bloc.dart';
import '../features/student/presentation/widgets/student_shimmer.dart';
import '../features/student/presentation/blocs/student_event.dart';
import '../features/recitation/presentation/blocs/recitation_bloc.dart';
import '../features/student/presentation/blocs/student_state.dart';
import '../theme/tahfeez_theme.dart';
import '../l10n/app_localizations.dart';
import '../features/recitation/presentation/pages/log_recitation_page.dart';
import '../features/recitation/presentation/pages/recitation_history_page.dart';
import '../features/attendance/presentation/bloc/attendance_bloc.dart';
import '../features/attendance/presentation/pages/attendance_history_page.dart';
import 'add_student_screen.dart';

enum _StudentFilter { all, active, pending }

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  final _searchController = TextEditingController();
  _StudentFilter _filter = _StudentFilter.all;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<User> _filteredStudents(StudentsLoaded state) {
    final q = _searchController.text.toLowerCase().trim();
    return state.students.where((s) {
      final name = (s.fullName ?? '').toLowerCase();
      final matchesSearch = name.contains(q) || s.email.toLowerCase().contains(q);
      final matchesFilter = switch (_filter) {
        _StudentFilter.all => true,
        _StudentFilter.active => s.status == 'Active',
        _StudentFilter.pending => s.status == 'Pending',
      };
      return matchesSearch && matchesFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocConsumer<StudentBloc, StudentState>(
      listener: (context, state) {
        if (state is StudentOperationSuccess &&
            state.message == 'assigned_to_class') {
          AppToast.success(l10n.assignToClassSuccess);
          context.read<StudentBloc>().add(const ResetStudentOperationStateEvent());
        } else if (state is StudentError) {
          if (context.read<StudentBloc>().state is! StudentsLoaded) {
            AppToast.error(state.message);
          }
        }
      },
      builder: (context, state) {
        final isLoading = state is StudentLoading;
        final initialError = state is StudentError;
        final hasData = state is StudentsLoaded;

        final displayStudents = hasData ? _filteredStudents(state) : <User>[];
        final allStudents = hasData ? state.students : <User>[];
        final canAccessAttendance = di.sl<AuthService>().canAccessAttendance;

        return Scaffold(
          backgroundColor: TahfeezColors.background,
          appBar: AppBar(
            title: Text(
              l10n.students,
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
          body: Column(
            children: [
              // Search + filter
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.search,
                            color: TahfeezColors.outline,
                          ),
                          hintText: l10n.searchStudents,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: const BorderSide(
                              color: TahfeezColors.outlineVariant,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: const BorderSide(
                              color: TahfeezColors.secondary,
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: TahfeezColors.surfaceContainerLowest,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Filter chips
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _StudentFilter.values.map((f) {
                      final label = switch (f) {
                        _StudentFilter.all => l10n.filterChipsAll,
                        _StudentFilter.active => l10n.active,
                        _StudentFilter.pending => l10n.pending,
                      };
                      final isSelected = _filter == f;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(label),
                          selected: isSelected,
                          onSelected: (_) =>
                              setState(() => _filter = f),
                          backgroundColor:
                              TahfeezColors.surfaceContainerLowest,
                          selectedColor: TahfeezColors.primaryContainer
                              .withOpacity(0.15),
                          checkmarkColor: TahfeezColors.primaryContainer,
                          labelStyle: TahfeezTextStyles.labelLg.copyWith(
                            color: isSelected
                                ? TahfeezColors.primaryContainer
                                : TahfeezColors.onSurfaceVariant,
                          ),
                          side: BorderSide(
                            color: isSelected
                                ? TahfeezColors.primaryContainer
                                : TahfeezColors.outlineVariant,
                          ),
                          shape: const StadiumBorder(),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              // Stats row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(
                      hasData
                          ? l10n.studentsCount(displayStudents.length)
                          : '',
                      style: TahfeezTextStyles.labelMd.copyWith(
                        color: TahfeezColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // Content
              Expanded(
                child: _buildContent(
                  l10n,
                  isLoading,
                  initialError,
                  hasData,
                  displayStudents,
                  allStudents,
                  canAccessAttendance,
                ),
              ),
            ],
          ),
          floatingActionButton: hasData && allStudents.isNotEmpty
              ? FloatingActionButton.extended(
                  heroTag: 'students_fab',
                  onPressed: () async {
                    final result = await Navigator.push<bool>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AddStudentScreen(),
                      ),
                    );
                    if (result == true && mounted) {
                      context.read<StudentBloc>().add(RefreshStudentsEvent());
                    }
                  },
                  backgroundColor: TahfeezColors.primary,
                  foregroundColor: TahfeezColors.onPrimary,
                  icon: const Icon(Icons.person_add_outlined),
                  label: Text(
                    l10n.addStudent,
                    style: TahfeezTextStyles.labelLg.copyWith(
                      color: TahfeezColors.onPrimary,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                )
              : null,
        );
      },
    );
  }

  Widget _buildContent(
    AppLocalizations l10n,
    bool isLoading,
    bool initialError,
    bool hasData,
    List<User> displayStudents,
    List<User> allStudents,
    bool canAccessAttendance,
  ) {
    if (isLoading) {
      return const StudentShimmer();
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
                l10n.failedToLoadStudents,
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
                onPressed: () =>
                    context.read<StudentBloc>().add(GetStudentsEvent()),
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

    if (!hasData || allStudents.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: TahfeezColors.primaryFixed.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.people_outline_rounded,
                size: 36,
                color: TahfeezColors.primaryContainer,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.noStudentsFound,
              style: TahfeezTextStyles.titleLg.copyWith(
                color: TahfeezColors.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<StudentBloc>().add(RefreshStudentsEvent());
      },
      color: TahfeezColors.primary,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
        itemCount: displayStudents.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, i) => _StudentCard(
          student: displayStudents[i],
          canAccessAttendance: canAccessAttendance,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<RecitationBloc>(),
                child: RecitationHistoryPage(
                  studentId: displayStudents[i].id,
                  studentName: displayStudents[i].fullName ?? '',
                ),
              ),
            ),
          ),
          onLogRecitation: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<ClassBloc>(),
                child: BlocProvider.value(
                  value: context.read<RecitationBloc>(),
                  child: LogRecitationPage(
                    studentId: displayStudents[i].id,
                    studentName: displayStudents[i].fullName ?? '',
                  ),
                ),
              ),
            ),
          ),
          onActivate: displayStudents[i].status != 'Active'
              ? () => _confirmActivate(context, displayStudents[i])
              : null,
          onAssignToClass: () => _showAssignToClassDialog(displayStudents[i]),
        ),
      ),
    );
  }

  void _confirmActivate(BuildContext context, User student) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: TahfeezColors.surfaceContainerLowest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(l10n.activateStudentConfirm,
          style: TahfeezTextStyles.titleLg.copyWith(color: TahfeezColors.onSurface),
        ),
        content: Text(l10n.activateStudentConfirmSubtitle,
          style: TahfeezTextStyles.bodyMd.copyWith(color: TahfeezColors.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel,
              style: TahfeezTextStyles.labelLg.copyWith(color: TahfeezColors.onSurfaceVariant),
            ),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<StudentBloc>().add(ActivateStudentEvent(student.id));
            },
            style: FilledButton.styleFrom(backgroundColor: TahfeezColors.primary),
            child: Text(l10n.activate,
              style: TahfeezTextStyles.labelLg.copyWith(color: TahfeezColors.onPrimary),
            ),
          ),
        ],
      ),
    );
  }






Future<void> _showAssignToClassDialog(User student) async {
  final l10n = AppLocalizations.of(context)!;
  final useCase = di.sl<GetAllClassesUseCase>();
  final result = await useCase();

  List<ClassEntity> classes = [];
  final hadFailure = result.fold(
    (failure) {
      if (mounted) AppToast.error(failure.message);
      return true;
    },
    (list) {
      classes = list;
      return false;
    },
  );

  if (hadFailure || !mounted || classes.isEmpty) {
    if (mounted && !hadFailure && classes.isEmpty) {
      AppToast.error(l10n.noClassesFound);
    }
    return;
  }

  ClassEntity? selectedClass;
  final levelController = TextEditingController();

  final assigned = await showDialog<bool>(
    context: context,
    barrierColor: Colors.black54,
    builder: (ctx) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: StatefulBuilder(
        builder: (ctx, setDialogState) => Container(
          decoration: BoxDecoration(
            color: TahfeezColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 40,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                // ── Header strip ────────────────────────────────
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 18, 16, 16),
                  decoration: BoxDecoration(
                    color: TahfeezColors.primary.withOpacity(0.05),
                    border: Border(
                      bottom: BorderSide(
                        color: TahfeezColors.outlineVariant.withOpacity(0.4),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Icon badge
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: TahfeezColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.menu_book_rounded,
                          color: TahfeezColors.primary,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.assignToClass,
                              style: TahfeezTextStyles.titleLg.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 1),
                            Text(
                              student.fullName ?? student.email,
                              style: TahfeezTextStyles.bodyMd.copyWith(
                                color: TahfeezColors.onSurfaceVariant,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      // Close button
                      SizedBox(
                        width: 32,
                        height: 32,
                        child: IconButton.filled(
                          onPressed: () => Navigator.pop(ctx, false),
                          icon: const Icon(Icons.close_rounded, size: 16),
                          style: IconButton.styleFrom(
                            backgroundColor:
                                TahfeezColors.outlineVariant.withOpacity(0.3),
                            foregroundColor: TahfeezColors.onSurfaceVariant,
                          ),
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Body ────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // Section: class list
                      _SectionLabel(label: l10n.selectClassToAssign),
                      const SizedBox(height: 10),

                      ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 210),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: List.generate(classes.length, (i) {
                              final cls = classes[i];
                              final isSelected = selectedClass?.id == cls.id;
                              return _ClassTile(
                                classEntity: cls,
                                isSelected: isSelected,
                                onTap: () => setDialogState(
                                  () => selectedClass = cls,
                                ),
                              );
                            }),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Section: level
                      _SectionLabel(label: l10n.levelAdvanced),
                      const SizedBox(height: 10),

                      TextField(
                        controller: levelController,
                        style: TahfeezTextStyles.bodyMd,
                        decoration: InputDecoration(
                          hintText: 'e.g. Beginner, Advanced',
                          hintStyle: TahfeezTextStyles.bodyMd.copyWith(
                            color: TahfeezColors.onSurfaceVariant
                                .withOpacity(0.45),
                          ),
                          filled: true,
                          fillColor: TahfeezColors.surfaceContainer,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: TahfeezColors.primary,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Actions
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              style: OutlinedButton.styleFrom(
                                foregroundColor:
                                    TahfeezColors.onSurfaceVariant,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                side: BorderSide(
                                  color: TahfeezColors.outlineVariant,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                l10n.cancel,
                                style: TahfeezTextStyles.labelLg,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: FilledButton(
                              onPressed: selectedClass != null
                                  ? () => Navigator.pop(ctx, true)
                                  : null,
                              style: FilledButton.styleFrom(
                                backgroundColor: TahfeezColors.primary,
                                disabledBackgroundColor:
                                    TahfeezColors.primary.withOpacity(0.28),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                l10n.submit,
                                style: TahfeezTextStyles.labelLg.copyWith(
                                  color: Colors.white,
                                ),
                              ),
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
      ),
    ),
  );

  if (assigned == true && selectedClass != null && mounted) {
    context.read<StudentBloc>().add(AssignStudentToClassEvent(
      studentId: student.id,
      classId: selectedClass!.id,
      level: levelController.text.trim().isEmpty
          ? 'Beginner'
          : levelController.text.trim(),
    ));
  }
}

  
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: TahfeezTextStyles.labelMd.copyWith(
        color: TahfeezColors.onSurfaceVariant,
        letterSpacing: 0.9,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _ClassTile extends StatelessWidget {
  const _ClassTile({
    required this.classEntity,
    required this.isSelected,
    required this.onTap,
  });

  final ClassEntity classEntity;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: isSelected
              ? TahfeezColors.primary.withOpacity(0.07)
              : TahfeezColors.surfaceContainer,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? TahfeezColors.primary.withOpacity(0.35)
                : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          splashColor: TahfeezColors.primary.withOpacity(0.06),
          highlightColor: Colors.transparent,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                // Radio dot
                AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? TahfeezColors.primary
                        : Colors.transparent,
                    border: Border.all(
                      color: isSelected
                          ? TahfeezColors.primary
                          : TahfeezColors.outlineVariant,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check_rounded,
                          size: 12,
                          color: Colors.white,
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    classEntity.name,
                    style: TahfeezTextStyles.bodyMd.copyWith(
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: isSelected
                          ? TahfeezColors.primary
                          : TahfeezColors.onSurface,
                    ),
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

class _StudentCard extends StatelessWidget {
  final User student;
  final bool canAccessAttendance;
  final VoidCallback onTap;
  final VoidCallback onLogRecitation;
  final VoidCallback? onActivate;
  final VoidCallback onAssignToClass;

  const _StudentCard({
    required this.student,
    this.canAccessAttendance = false,
    required this.onTap,
    required this.onLogRecitation,
    this.onActivate,
    required this.onAssignToClass,
  });

  String get _initials {
    final name = student.fullName ?? student.email;
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  Color get _statusColor {
    if (student.status == 'Active') return TahfeezColors.primary;
    return TahfeezColors.error;
  }

  String _statusLabel(AppLocalizations l10n) {
    if (student.status == 'Active') return l10n.active;
    return l10n.pending;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: TahfeezColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: TahfeezColors.outlineVariant.withOpacity(0.5),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: TahfeezColors.primaryFixed.withOpacity(0.5),
              child: Text(
                _initials,
                style: TahfeezTextStyles.labelLg.copyWith(
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
                        child: Text(
                          student.fullName ?? student.email,
                          style: TahfeezTextStyles.labelLg.copyWith(
                            color: TahfeezColors.onSurface,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          _statusLabel(l10n),
                          style: TahfeezTextStyles.labelMd.copyWith(
                            color: _statusColor,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    student.email,
                    style: TahfeezTextStyles.labelMd.copyWith(
                      color: TahfeezColors.primaryContainer,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    student.createdAt != null
                        ? l10n.joinedDate(_formatDate(student.createdAt!))
                        : '',
                    style: TahfeezTextStyles.bodyMd.copyWith(
                      color: TahfeezColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (v) {
                if (v == 'log') onLogRecitation();
                if (v == 'history') onTap();
                if (v == 'activate') onActivate?.call();
                if (v == 'attendance') {
                  final bloc = context.read<AttendanceBloc>();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: bloc,
                        child: AttendanceHistoryPage(
                          userId: student.id,
                          userName: student.fullName ?? student.email,
                        ),
                      ),
                    ),
                  );
                } else if (v == 'assign_class') {
                  onAssignToClass();
                }
              },
              icon: const Icon(
                Icons.more_vert,
                color: TahfeezColors.onSurfaceVariant,
                size: 20,
              ),
              itemBuilder: (_) => [
                PopupMenuItem(value: 'log', child: Text(l10n.logRecitation)),
                PopupMenuItem(value: 'history', child: Text(l10n.viewHistory)),
                if (onActivate != null)
                  PopupMenuItem(
                    value: 'activate',
                    child: Text(l10n.activate,
                      style: const TextStyle(color: TahfeezColors.primary),
                    ),
                  ),
                if (canAccessAttendance)
                  PopupMenuItem(
                      value: 'attendance', child: Text(l10n.attendance)),
                PopupMenuItem(
                  value: 'assign_class',
                  child: Text(l10n.assignToClass),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
