import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/utils/toast_helper.dart';
import '../../../../theme/tahfeez_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/class_entity.dart';
import '../blocs/class_bloc.dart';
import '../blocs/class_event.dart';
import '../blocs/class_state.dart';
import '../widgets/class_card.dart';
import '../widgets/class_shimmer.dart';
import '../widgets/empty_classes_widget.dart';
import 'add_class_screen.dart';

class ClassesScreen extends StatefulWidget {
  const ClassesScreen({super.key});

  @override
  State<ClassesScreen> createState() => _ClassesScreenState();
}

class _ClassesScreenState extends State<ClassesScreen> {
  bool _isPrivileged = false;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkRole();
    context.read<ClassBloc>().add(GetAllClassesEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _checkRole() async {
    try {
      final apiClient = di.sl<ApiClient>();
      final token = await apiClient.getAccessToken();
      if (token == null || JwtDecoder.isExpired(token)) return;
      final claims = JwtDecoder.decode(token);
      final role = claims['role'] as String?;
      if (mounted) {
        setState(() {
          _isPrivileged = role == RoleConstants.admin ||
              role == RoleConstants.supervisor;
        });
      }
    } catch (_) {}
  }

  void _onSearchChanged(String query) {
    context.read<ClassBloc>().add(SearchClassesEvent(query));
  }

  Future<void> _onRefresh() async {
    context.read<ClassBloc>().add(RefreshClassesEvent());
  }

  void _navigateToAddClass() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<ClassBloc>(),
          child: const AddClassScreen(),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(ClassEntity classEntity) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(l10n.deleteClass),
          content: Text(l10n.deleteClassConfirmation(classEntity.name)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(ctx);
                context.read<ClassBloc>().add(DeleteClassEvent(classEntity.id));
              },
              style: FilledButton.styleFrom(
                backgroundColor: TahfeezColors.error,
              ),
              child: Text(l10n.delete),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocConsumer<ClassBloc, ClassState>(
      listener: (context, state) {
        if (state is ClassOperationSuccess) {
          if (state.message == 'deleted') {
            AppToast.success(l10n.classDeleted);
          }
          context.read<ClassBloc>().add(const ResetOperationStateEvent());
          context.read<ClassBloc>().add(GetAllClassesEvent());
        } else if (state is ClassError) {
          if (context.read<ClassBloc>().state is! ClassesLoaded) {
            AppToast.error(state.message);
          }
        }
      },
      builder: (context, state) {
        final isLoading = state is ClassLoading;
        final showInitialLoading = state is ClassLoading;
        final initialError = state is ClassError;

        List<ClassEntity> displayClasses = [];
        bool hasData = false;

        if (state is ClassesLoaded) {
          displayClasses = state.filteredClasses;
          hasData = true;
        }

        return Scaffold(
          backgroundColor: TahfeezColors.background,
          appBar: AppBar(
            title: Text(
              l10n.classesManagement,
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
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    hintText: l10n.searchClasses,
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: TahfeezColors.surfaceContainerLowest,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: _buildBody(
                  l10n,
                  showInitialLoading,
                  initialError,
                  hasData,
                  displayClasses,
                  isLoading && hasData,
                ),
              ),
            ],
          ),
          floatingActionButton: _isPrivileged
              ? FloatingActionButton(
                  onPressed: _navigateToAddClass,
                  backgroundColor: TahfeezColors.primary,
                  foregroundColor: TahfeezColors.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.add, size: 28),
                )
              : null,
        );
      },
    );
  }

  Widget _buildBody(
    AppLocalizations l10n,
    bool showInitialLoading,
    bool hasError,
    bool hasData,
    List<ClassEntity> displayClasses,
    bool isRefreshing,
  ) {
    if (showInitialLoading) {
      return const ClassShimmer();
    }

    if (hasError && !hasData) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: TahfeezColors.error.withOpacity(0.7),
              ),
              const SizedBox(height: 16),
              Text(
                'Failed to load classes',
                style: TahfeezTextStyles.titleLg.copyWith(
                  color: TahfeezColors.error,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () =>
                    context.read<ClassBloc>().add(GetAllClassesEvent()),
                icon: const Icon(Icons.refresh, size: 18),
                label: Text(l10n.retry),
              ),
            ],
          ),
        ),
      );
    }

    if (!hasData || displayClasses.isEmpty) {
      return EmptyClassesWidget(
        onRetry: () => context.read<ClassBloc>().add(GetAllClassesEvent()),
      );
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(
              l10n.classesCount(displayClasses.length),
              style: TahfeezTextStyles.titleLg.copyWith(
                color: TahfeezColors.onSurface,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
              itemCount: displayClasses.length,
              itemBuilder: (context, i) => ClassCard(
                classEntity: displayClasses[i],
                showDelete: _isPrivileged,
                deleteDisabled: isRefreshing,
                onTap: () {},
                onDelete: () =>
                    _showDeleteConfirmation(displayClasses[i]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
