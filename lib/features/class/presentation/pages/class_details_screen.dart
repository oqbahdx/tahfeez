import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../../../core/utils/toast_helper.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../theme/tahfeez_theme.dart';
import '../../../attendance/presentation/bloc/attendance_bloc.dart';
import '../../../attendance/presentation/pages/attendance_history_page.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../student/presentation/blocs/student_bloc.dart';
import '../../../student/presentation/blocs/student_event.dart';
import '../../../student/presentation/blocs/student_state.dart';
import '../../domain/entities/class_entity.dart';
import '../../domain/enums/class_mode.dart';
import '../../domain/enums/class_type.dart';
import '../../domain/usecases/class_usecases.dart';
import '../blocs/class_bloc.dart';
import '../blocs/class_event.dart';
import '../blocs/class_state.dart';

class ClassDetailsScreen extends StatefulWidget {
  final String classId;

  const ClassDetailsScreen({super.key, required this.classId});

  @override
  State<ClassDetailsScreen> createState() => _ClassDetailsScreenState();
}

class _ClassDetailsScreenState extends State<ClassDetailsScreen> {
  ClassEntity? _classEntity;
  List<User>? _students;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    context.read<ClassBloc>().add(GetClassByIdEvent(widget.classId));
    context.read<ClassBloc>().add(GetClassStudentsEvent(widget.classId));
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
      builder: (ctx) => AlertDialog(
        backgroundColor: TahfeezColors.surfaceContainerLowest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(l10n.assignToClass),
        content: StatefulBuilder(
          builder: (ctx, setDialogState) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.selectClassToAssign,
                style: TahfeezTextStyles.bodyMd.copyWith(
                  color: TahfeezColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                constraints: const BoxConstraints(maxHeight: 200),
                decoration: BoxDecoration(
                  border: Border.all(color: TahfeezColors.outlineVariant),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (int i = 0; i < classes.length; i++)
                        Column(
                          children: [
                            if (i > 0) const Divider(height: 1),
                            ListTile(
                              dense: true,
                              selected: selectedClass?.id == classes[i].id,
                              selectedTileColor: TahfeezColors.primary.withOpacity(0.08),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              title: Text(classes[i].name),
                              trailing: selectedClass?.id == classes[i].id
                                  ? Icon(Icons.check_circle, color: TahfeezColors.primary, size: 20)
                                  : null,
                              onTap: () => setDialogState(() => selectedClass = classes[i]),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: levelController,
                decoration: InputDecoration(
                  hintText: 'e.g. Beginner, Advanced',
                  labelText: l10n.levelAdvanced,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: selectedClass != null
                ? () => Navigator.pop(ctx, true)
                : null,
            child: Text(l10n.submit),
          ),
        ],
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





  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: TahfeezColors.background,
      appBar: _buildAppBar(l10n),
      body: MultiBlocListener(
        listeners: [
          BlocListener<ClassBloc, ClassState>(
            listener: (context, state) {
              if (state is ClassLoaded) {
                setState(() {
                  _classEntity = state.classEntity;
                  _error = null;
                });
              } else if (state is ClassStudentsLoaded) {
                setState(() => _students = state.students);
              } else if (state is ClassError && _classEntity == null) {
                setState(() => _error = state.message);
              }
            },
          ),
          BlocListener<StudentBloc, StudentState>(
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
          ),
        ],
        child: BlocBuilder<ClassBloc, ClassState>(
          builder: (context, state) {
            if (_classEntity == null && _error != null) {
              return _ErrorView(error: _error!, onRetry: _loadData, l10n: l10n);
            }

            if (_classEntity == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ClassHeroCard(classEntity: _classEntity!, l10n: l10n),
                  const SizedBox(height: 24),
                  _StudentsSection(
                    students: _students,
                    l10n: l10n,
                    onAssignToClass: _showAssignToClassDialog,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  AppBar _buildAppBar(AppLocalizations l10n) {
    return AppBar(
      backgroundColor: TahfeezColors.background,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8),
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
        l10n.classDetails,
        style: TahfeezTextStyles.headlineLg.copyWith(
          color: TahfeezColors.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.4,
        ),
      ),
    );
  }
}

// ─────────────────────────── Hero Card ───────────────────────────

class _ClassHeroCard extends StatelessWidget {
  final ClassEntity classEntity;
  final AppLocalizations l10n;

  const _ClassHeroCard({
    required this.classEntity,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: TahfeezColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: TahfeezColors.surfaceContainer, width: 1),
        boxShadow: [
          BoxShadow(
            color: TahfeezColors.onSurface.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardHeader(classEntity: classEntity),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
            child: Column(
              children: [
                _MetaChipsRow(classEntity: classEntity, l10n: l10n),
                const SizedBox(height: 16),
                const Divider(height: 1, color: TahfeezColors.surfaceContainer),
                const SizedBox(height: 14),
                _DetailsList(classEntity: classEntity, l10n: l10n),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CardHeader extends StatelessWidget {
  final ClassEntity classEntity;

  const _CardHeader({required this.classEntity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 52),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            TahfeezColors.primary,
            TahfeezColors.primary.withOpacity(0.75),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Decorative circles
          Positioned(
            top: -24,
            right: -24,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),
          Positioned(
            bottom: -20,
            left: 60,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.white.withOpacity(0.18),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: const Icon(
                  Icons.menu_book_rounded,
                  size: 24,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      classEntity.name,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Class Info',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.72),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetaChipsRow extends StatelessWidget {
  final ClassEntity classEntity;
  final AppLocalizations l10n;

  const _MetaChipsRow({required this.classEntity, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final isOnline = classEntity.classMode == ClassMode.online;
    final isBoys = classEntity.classType == ClassType.boys;

    return Row(
      children: [
        Expanded(
          child: _MetaChip(
            icon: isBoys
                ? Icons.male_rounded
                : Icons.female_rounded,
            label: isBoys ? l10n.classTypeBoys : l10n.classTypeGirls,
            caption: l10n.classType,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _MetaChip(
            icon: isOnline
                ? Icons.desktop_windows_outlined
                : Icons.business_outlined,
            label: isOnline ? l10n.classModeOnline : l10n.classModeOffline,
            caption: l10n.classMode,
          ),
        ),
      ],
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String caption;

  const _MetaChip({
    required this.icon,
    required this.label,
    required this.caption,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: TahfeezColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TahfeezColors.surfaceContainer),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            caption.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
              color: TahfeezColors.onSurfaceVariant.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Icon(icon, size: 14, color: TahfeezColors.primary),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: TahfeezColors.onSurface,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailsList extends StatelessWidget {
  final ClassEntity classEntity;
  final AppLocalizations l10n;

  const _DetailsList({required this.classEntity, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _DetailRow(
          icon: Icons.person_outline_rounded,
          label: l10n.teacher,
          value: classEntity.teacherName ?? '-',
        ),
        if (classEntity.assistantName != null) ...[
          const SizedBox(height: 10),
          _DetailRow(
            icon: Icons.person_outline_rounded,
            label: l10n.assistant,
            value: classEntity.assistantName!,
          ),
        ],
        if (classEntity.supervisorName != null) ...[
          const SizedBox(height: 10),
          _DetailRow(
            icon: Icons.person_outline_rounded,
            label: l10n.supervisor,
            value: classEntity.supervisorName!,
          ),
        ],
        const SizedBox(height: 10),
        _DetailRow(
          icon: Icons.group_outlined,
          label: l10n.studentsList,
          trailing: _CountBadge(
            count: l10n.studentsCount(classEntity.studentCount),
          ),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final Widget? trailing;

  const _DetailRow({
    required this.icon,
    required this.label,
    this.value,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: TahfeezColors.onSurfaceVariant),
        const SizedBox(width: 8),
        Text(
          label,
          style: TahfeezTextStyles.bodyMd.copyWith(
            color: TahfeezColors.onSurfaceVariant,
            fontSize: 13,
          ),
        ),
        const Spacer(),
        if (trailing != null)
          trailing!
        else
          Text(
            value ?? '-',
            style: TahfeezTextStyles.bodyMd.copyWith(
              color: TahfeezColors.onSurface,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
      ],
    );
  }
}

class _CountBadge extends StatelessWidget {
  final String count;

  const _CountBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: TahfeezColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: TahfeezColors.primary.withOpacity(0.22),
          width: 1,
        ),
      ),
      child: Text(
        count,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: TahfeezColors.primary,
        ),
      ),
    );
  }
}

// ─────────────────────────── Students Section ───────────────────────────

class _StudentsSection extends StatelessWidget {
  final List<User>? students;
  final AppLocalizations l10n;
  final void Function(User student) onAssignToClass;

  const _StudentsSection({
    required this.students,
    required this.l10n,
    required this.onAssignToClass,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(l10n: l10n, studentCount: students?.length),
        const SizedBox(height: 12),
        _SectionBody(
          students: students,
          l10n: l10n,
          onAssignToClass: onAssignToClass,
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final AppLocalizations l10n;
  final int? studentCount;

  const _SectionHeader({required this.l10n, this.studentCount});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: TahfeezColors.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: TahfeezColors.primary.withOpacity(0.18),
              width: 1,
            ),
          ),
          child: Icon(
            Icons.group_rounded,
            size: 17,
            color: TahfeezColors.primary,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          l10n.studentsList,
          style: TahfeezTextStyles.titleLg.copyWith(
            color: TahfeezColors.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Spacer(),
        if (studentCount != null)
          Text(
            '${studentCount!} ${l10n.studentsList.toLowerCase()}',
            style: TahfeezTextStyles.labelMd.copyWith(
              color: TahfeezColors.onSurfaceVariant,
              fontSize: 12,
            ),
          ),
      ],
    );
  }
}

class _SectionBody extends StatelessWidget {
  final List<User>? students;
  final AppLocalizations l10n;
  final void Function(User student) onAssignToClass;

  const _SectionBody({
    required this.students,
    required this.l10n,
    required this.onAssignToClass,
  });

  // Cycles through a palette of distinct avatar bg/text combos
  static const List<(Color, Color, Color)> _avatarPalette = [
    (Color(0xFFFDF0E6), Color(0xFFF5D0A8), Color(0xFFB46A2C)),
    (Color(0xFFE8F4EE), Color(0xFFA8D9BB), Color(0xFF2A7A4E)),
    (Color(0xFFEEF0FD), Color(0xFFC4C8F5), Color(0xFF4A50B8)),
    (Color(0xFFFBECF2), Color(0xFFF4C0D1), Color(0xFF993556)),
  ];

  @override
  Widget build(BuildContext context) {
    if (students == null) return const _StudentSkeletons();
    if (students!.isEmpty) return _EmptyStudents(l10n: l10n);

    return Column(
      children: students!.indexed.map(
        (entry) {
          final (i, student) = entry;
          final palette = _avatarPalette[i % _avatarPalette.length];
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _StudentTile(
              student: student,
              avatarBg: palette.$1,
              avatarBorder: palette.$2,
              avatarText: palette.$3,
              l10n: l10n,
              onAssignToClass: () => onAssignToClass(student),
            ),
          );
        },
      ).toList(),
    );
  }
}

class _StudentTile extends StatelessWidget {
  final User student;
  final Color avatarBg;
  final Color avatarBorder;
  final Color avatarText;
  final AppLocalizations l10n;
  final VoidCallback onAssignToClass;

  const _StudentTile({
    required this.student,
    required this.avatarBg,
    required this.avatarBorder,
    required this.avatarText,
    required this.l10n,
    required this.onAssignToClass,
  });

  @override
  Widget build(BuildContext context) {
    final displayName = student.fullName ?? student.email;
    final initials = displayName
        .trim()
        .split(' ')
        .take(2)
        .map((w) => w.isNotEmpty ? w[0].toUpperCase() : '')
        .join();

    return Material(
      color: TahfeezColors.surface,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: TahfeezColors.surfaceContainer,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: avatarBg,
                border: Border.all(color: avatarBorder, width: 1.5),
              ),
              child: Center(
                child: Text(
                  initials,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: avatarText,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: TahfeezTextStyles.bodyMd.copyWith(
                      color: TahfeezColors.onSurface,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  if (student.fullName != null &&
                      student.email != student.fullName)
                    Text(
                      student.email,
                      style: TahfeezTextStyles.labelMd.copyWith(
                        color: TahfeezColors.onSurfaceVariant,
                        fontSize: 11,
                      ),
                    ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (v) {
                if (v == 'attendance') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<AttendanceBloc>(),
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
              icon: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: TahfeezColors.background,
                ),
                child: Icon(
                  Icons.more_horiz_rounded,
                  size: 16,
                  color: TahfeezColors.onSurfaceVariant.withOpacity(0.5),
                ),
              ),
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: 'attendance',
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: TahfeezColors.onSurfaceVariant),
                      const SizedBox(width: 8),
                      Text(l10n.attendance),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'assign_class',
                  child: Row(
                    children: [
                      Icon(Icons.swap_horiz_rounded, size: 16, color: TahfeezColors.onSurfaceVariant),
                      const SizedBox(width: 8),
                      Text(l10n.assignToClass),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────── Skeletons ───────────────────────────

class _StudentSkeletons extends StatelessWidget {
  const _StudentSkeletons();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        3,
        (i) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Container(
            height: 64,
            decoration: BoxDecoration(
              color: TahfeezColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: TahfeezColors.surfaceContainer),
            ),
            child: Row(
              children: [
                const SizedBox(width: 14),
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: TahfeezColors.surfaceContainer,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 11,
                        width: 120,
                        decoration: BoxDecoration(
                          color: TahfeezColors.surfaceContainer,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        height: 9,
                        width: 80,
                        decoration: BoxDecoration(
                          color: TahfeezColors.surfaceContainer.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(6),
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

// ─────────────────────────── Empty State ───────────────────────────

class _EmptyStudents extends StatelessWidget {
  final AppLocalizations l10n;

  const _EmptyStudents({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 36),
      decoration: BoxDecoration(
        color: TahfeezColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: TahfeezColors.surfaceContainer,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: TahfeezColors.background,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: TahfeezColors.surfaceContainer),
            ),
            child: Icon(
              Icons.people_outline_rounded,
              size: 26,
              color: TahfeezColors.onSurfaceVariant.withOpacity(0.45),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            l10n.noStudentsInClass,
            style: TahfeezTextStyles.bodyMd.copyWith(
              color: TahfeezColors.onSurfaceVariant,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────── Error View ───────────────────────────

class _ErrorView extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;
  final AppLocalizations l10n;

  const _ErrorView({
    required this.error,
    required this.onRetry,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: TahfeezColors.error.withOpacity(0.08),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: TahfeezColors.error.withOpacity(0.18),
                ),
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 30,
                color: TahfeezColors.error.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              error,
              style: TahfeezTextStyles.bodyMd.copyWith(
                color: TahfeezColors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onRetry,
              style: FilledButton.styleFrom(
                backgroundColor: TahfeezColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
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
}