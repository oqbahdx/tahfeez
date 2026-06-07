import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/toast_helper.dart';
import '../../../../theme/tahfeez_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../auth/domain/enums/user_role.dart';
import '../../../class/presentation/blocs/class_bloc.dart';
import '../../../class/presentation/blocs/class_event.dart';
import '../../../class/presentation/blocs/class_state.dart';
import '../../../student/presentation/blocs/student_bloc.dart';
import '../../../student/presentation/blocs/student_state.dart';
import '../../domain/enums/recitation_type.dart';
import '../blocs/recitation_bloc.dart';
import '../blocs/recitation_event.dart';
import '../blocs/recitation_state.dart';

class LogRecitationPage extends StatefulWidget {
  final String? studentId;
  final String? studentName;

  const LogRecitationPage({super.key, this.studentId, this.studentName});

  @override
  State<LogRecitationPage> createState() => _LogRecitationPageState();
}

class _LogRecitationPageState extends State<LogRecitationPage> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();
  final _ayahsCountController = TextEditingController();

  String? _selectedStudentId;
  String? _teacherId;
  DateTime _selectedDate = DateTime.now();
  RecitationType _recitationType = RecitationType.recitation;
  double _grade = 8;

  @override
  void initState() {
    super.initState();
    if (widget.studentId != null) {
      _selectedStudentId = widget.studentId;
    }
    context.read<ClassBloc>().add(FetchUsersEvent(UserRole.teacher.value));
  }

  @override
  void dispose() {
    _notesController.dispose();
    _ayahsCountController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedStudentId == null) {
      AppToast.error(AppLocalizations.of(context)!.selectStudent);
      return;
    }
    if (_teacherId == null) {
      AppToast.error(AppLocalizations.of(context)!.teacherRequired);
      return;
    }

    final ayahsCount = int.tryParse(_ayahsCountController.text.trim()) ?? 0;

    context.read<RecitationBloc>().add(LogRecitationEvent(
          studentId: _selectedStudentId!,
          teacherId: _teacherId!,
          date: _selectedDate,
          ayahsCount: ayahsCount,
          type: _recitationType,
          grade: _grade.round(),
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocConsumer<RecitationBloc, RecitationState>(
      listenWhen: (previous, current) =>
          current is RecitationOperationSuccess || current is RecitationError,
      listener: (context, state) {
        if (state is RecitationOperationSuccess) {
          AppToast.success(l10n.recitationLogSaved);
          Navigator.of(context).pop();
        } else if (state is RecitationError) {
          AppToast.error(state.message);
        }
      },
      builder: (context, state) {
        final isSubmitting = state is RecitationOperationLoading;

        return Scaffold(
          backgroundColor: TahfeezColors.background,
          appBar: AppBar(
            backgroundColor: TahfeezColors.background,
            elevation: 0,
            scrolledUnderElevation: 0,
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
              l10n.logRecitation,
              style: TahfeezTextStyles.headlineLg.copyWith(
                color: TahfeezColors.onSurface,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: TahfeezColors.primary.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: TahfeezColors.primary.withOpacity(0.15),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: TahfeezColors.primary.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.menu_book_rounded,
                            color: TahfeezColors.primary,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.logRecitation,
                                style: TahfeezTextStyles.titleLg.copyWith(
                                  color: TahfeezColors.onSurface,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                l10n.logRecitationSubtitle,
                                style: TahfeezTextStyles.bodyMd.copyWith(
                                  color: TahfeezColors.onSurfaceVariant,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  Container(
                    decoration: BoxDecoration(
                      color: TahfeezColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: TahfeezColors.surfaceContainer,
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: TahfeezColors.onSurface.withOpacity(0.04),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildFormSection(
                          icon: Icons.face_outlined,
                          title: l10n.student,
                          isFirst: true,
                          child: widget.studentId != null
                              ? Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    color: TahfeezColors.surfaceContainerLowest,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: TahfeezColors.surfaceContainer,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.person,
                                        size: 16,
                                        color: TahfeezColors.onSurfaceVariant,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        widget.studentName ?? '',
                                        style: TahfeezTextStyles.bodyMd.copyWith(
                                          color: TahfeezColors.onSurface,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : BlocBuilder<StudentBloc, StudentState>(
                                  builder: (context, studentState) {
                                    List<User> students = [];
                                    if (studentState is StudentsLoaded) {
                                      students = studentState.students;
                                    }
                                    return DropdownButtonFormField<String>(
                                      value: _selectedStudentId,
                                      decoration: _inputDecoration(),
                                      hint: Text(
                                        l10n.selectStudent,
                                        style: TahfeezTextStyles.bodyMd.copyWith(
                                          color: TahfeezColors.onSurfaceVariant,
                                        ),
                                      ),
                                      items: students
                                          .map((s) => DropdownMenuItem(
                                                value: s.id,
                                                child: Text(
                                                  s.fullName ?? s.email,
                                                  style: TahfeezTextStyles.bodyMd
                                                      .copyWith(
                                                    color: TahfeezColors
                                                        .onSurface,
                                                  ),
                                                ),
                                              ))
                                          .toList(),
                                      onChanged: (v) {
                                        setState(() {
                                          _selectedStudentId = v;
                                        });
                                      },
                                      validator: (v) =>
                                          v == null ? l10n.student : null,
                                    );
                                  },
                                ),
                        ),

                        _buildDivider(),

                        _buildFormSection(
                          icon: Icons.school_outlined,
                          title: l10n.teacher,
                          child: BlocBuilder<ClassBloc, ClassState>(
                            builder: (context, classState) {
                              final teachers = classState is UsersLoaded
                                  ? classState.users
                                  : <User>[];
                              return DropdownButtonFormField<String>(
                                value: _teacherId,
                                decoration: _inputDecoration(),
                                hint: Text(
                                  l10n.teacher,
                                  style: TahfeezTextStyles.bodyMd.copyWith(
                                    color: TahfeezColors.onSurfaceVariant,
                                  ),
                                ),
                                items: teachers
                                    .map((t) => DropdownMenuItem(
                                          value: t.id,
                                          child: Text(
                                            t.fullName ?? t.email,
                                            style: TahfeezTextStyles.bodyMd
                                                .copyWith(
                                              color: TahfeezColors.onSurface,
                                            ),
                                          ),
                                        ))
                                    .toList(),
                                onChanged: (v) {
                                  setState(() => _teacherId = v);
                                },
                                validator: (v) =>
                                    v == null ? l10n.teacherRequired : null,
                              );
                            },
                          ),
                        ),

                        _buildDivider(),

                        _buildFormSection(
                          icon: Icons.calendar_today_outlined,
                          title: l10n.date,
                          child: InkWell(
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: _selectedDate,
                                firstDate: DateTime(2020),
                                lastDate: DateTime.now(),
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: Theme.of(context)
                                          .colorScheme
                                          .copyWith(
                                            primary: TahfeezColors.primary,
                                          ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (picked != null) {
                                setState(() => _selectedDate = picked);
                              }
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                color: TahfeezColors.surfaceContainerLowest,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: TahfeezColors.surfaceContainer,
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_today_outlined,
                                    size: 16,
                                    color: TahfeezColors.onSurfaceVariant,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _formatDate(_selectedDate),
                                    style: TahfeezTextStyles.bodyMd.copyWith(
                                      color: TahfeezColors.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        _buildDivider(),

                        _buildFormSection(
                          icon: Icons.category_outlined,
                          title: l10n.recitationType,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: TahfeezColors.surfaceContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: _TypeOption(
                                    label: l10n.newHifdh,
                                    isSelected:
                                        _recitationType == RecitationType.recitation,
                                    selectedBg: TahfeezColors.primary,
                                    selectedText: TahfeezColors.onPrimary,
                                    onTap: () => setState(
                                      () => _recitationType = RecitationType.recitation,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: _TypeOption(
                                    label: l10n.reviewMurajaah,
                                    isSelected:
                                        _recitationType == RecitationType.review,
                                    selectedBg: TahfeezColors.tertiary,
                                    selectedText: TahfeezColors.onTertiary,
                                    onTap: () => setState(
                                      () => _recitationType = RecitationType.review,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        _buildDivider(),

                        _buildFormSection(
                          icon: Icons.numbers_outlined,
                          title: l10n.ayahsCount,
                          child: TextFormField(
                            controller: _ayahsCountController,
                            keyboardType: TextInputType.number,
                            style: TahfeezTextStyles.bodyMd.copyWith(
                              color: TahfeezColors.onSurface,
                            ),
                            decoration: _inputDecoration().copyWith(
                              hintText: '5',
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return l10n.ayahsRequired;
                              }
                              final count = int.tryParse(value.trim());
                              if (count == null || count <= 0) {
                                return l10n.ayahsInvalid;
                              }
                              return null;
                            },
                          ),
                        ),

                        _buildDivider(),

                        _buildFormSection(
                          icon: Icons.grade_outlined,
                          title: l10n.qualityGrade,
                          isLast: true,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '1 (${l10n.needsWork}) - 10 (${l10n.perfect})',
                                      style: TahfeezTextStyles.labelMd.copyWith(
                                        color: TahfeezColors.onSurfaceVariant,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: TahfeezColors.primary
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      '${_grade.round()}',
                                      style: TahfeezTextStyles.titleLg.copyWith(
                                        color: TahfeezColors.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              SliderTheme(
                                data: SliderThemeData(
                                  activeTrackColor: TahfeezColors.primary,
                                  inactiveTrackColor:
                                      TahfeezColors.outlineVariant,
                                  thumbColor: TahfeezColors.primary,
                                  overlayColor:
                                      TahfeezColors.primary.withOpacity(0.1),
                                  trackHeight: 4,
                                ),
                                child: Slider(
                                  value: _grade,
                                  min: 1,
                                  max: 10,
                                  divisions: 9,
                                  onChanged: (v) =>
                                      setState(() => _grade = v),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  Container(
                    decoration: BoxDecoration(
                      color: TahfeezColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: TahfeezColors.surfaceContainer,
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: TahfeezColors.onSurface.withOpacity(0.04),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: TahfeezColors.primary.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.notes_outlined,
                                  size: 14,
                                  color: TahfeezColors.primary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                l10n.observationsNotes,
                                style: TahfeezTextStyles.titleLg.copyWith(
                                  color: TahfeezColors.onSurface,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _notesController,
                            maxLines: 4,
                            maxLength: 1000,
                            style: TahfeezTextStyles.bodyMd.copyWith(
                              color: TahfeezColors.onSurface,
                            ),
                            decoration: _inputDecoration().copyWith(
                              hintText: l10n.observationsHint,
                              counterStyle: TahfeezTextStyles.labelMd.copyWith(
                                color: TahfeezColors.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  FilledButton(
                    onPressed: isSubmitting ? null : _submit,
                    style: FilledButton.styleFrom(
                      backgroundColor: TahfeezColors.primary,
                      disabledBackgroundColor:
                          TahfeezColors.primary.withOpacity(0.5),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: isSubmitting
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: TahfeezColors.onPrimary,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                l10n.submitting,
                                style: TahfeezTextStyles.labelLg.copyWith(
                                  color: TahfeezColors.onPrimary,
                                ),
                              ),
                            ],
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.save_outlined,
                                size: 18,
                                color: TahfeezColors.onPrimary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                l10n.saveLog,
                                style: TahfeezTextStyles.labelLg.copyWith(
                                  color: TahfeezColors.onPrimary,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFormSection({
    required IconData icon,
    required String title,
    required Widget child,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        isFirst ? 20 : 16,
        16,
        isLast ? 20 : 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: TahfeezColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 14, color: TahfeezColors.primary),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TahfeezTextStyles.titleLg.copyWith(
                  color: TahfeezColors.onSurface,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Divider(
        height: 1,
        thickness: 1,
        color: TahfeezColors.surfaceContainer,
      ),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: TahfeezColors.surfaceContainerLowest,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: TahfeezColors.surfaceContainer,
          width: 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: TahfeezColors.surfaceContainer,
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: TahfeezColors.primary.withOpacity(0.5),
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: TahfeezColors.error.withOpacity(0.6),
          width: 1,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: TahfeezColors.error,
          width: 1.5,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 14,
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

class _TypeOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color selectedBg, selectedText;
  final VoidCallback onTap;

  const _TypeOption({
    required this.label,
    required this.isSelected,
    required this.selectedBg,
    required this.selectedText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? selectedBg : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TahfeezTextStyles.labelLg.copyWith(
            color: isSelected ? selectedText : TahfeezColors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
