import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/utils/toast_helper.dart';
import '../features/auth/domain/entities/user.dart';
import '../features/student/presentation/blocs/student_bloc.dart';
import '../features/student/presentation/widgets/student_shimmer.dart';
import '../features/student/presentation/blocs/student_event.dart';
import '../features/student/presentation/blocs/student_state.dart';
import '../theme/tahfeez_theme.dart';
import '../l10n/app_localizations.dart';
import 'recitation_history_screen.dart';
import 'log_recitation_screen.dart';

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
        if (state is StudentError) {
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
                ),
              ),
            ],
          ),
          floatingActionButton: hasData && allStudents.isNotEmpty
              ? FloatingActionButton.extended(
                  onPressed: () {},
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
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RecitationHistoryScreen(
                studentName: displayStudents[i].fullName ?? '',
              ),
            ),
          ),
          onLogRecitation: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const LogRecitationScreen(),
            ),
          ),
        ),
      ),
    );
  }
}

class _StudentCard extends StatelessWidget {
  final User student;
  final VoidCallback onTap;
  final VoidCallback onLogRecitation;

  const _StudentCard({
    required this.student,
    required this.onTap,
    required this.onLogRecitation,
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
              },
              icon: const Icon(
                Icons.more_vert,
                color: TahfeezColors.onSurfaceVariant,
                size: 20,
              ),
              itemBuilder: (_) => [
                PopupMenuItem(value: 'log', child: Text(l10n.logRecitation)),
                PopupMenuItem(value: 'history', child: Text(l10n.viewHistory)),
                PopupMenuItem(
                    value: 'attendance', child: Text(l10n.attendance)),
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
