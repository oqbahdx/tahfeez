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
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: TahfeezColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.delete_outline_rounded,
                color: TahfeezColors.error,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(l10n.deleteClass),
          ],
        ),
        content: Text(l10n.deleteClassConfirmation(classEntity.name)),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(ctx),
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              context
                  .read<ClassBloc>()
                  .add(DeleteClassEvent(classEntity.id));
            },
            style: FilledButton.styleFrom(
              backgroundColor: TahfeezColors.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
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
          body: SafeArea(
            child: Column(
              children: [
                // Custom header section
                _buildHeader(l10n, displayClasses, hasData),
                // Search bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    style: TahfeezTextStyles.bodyMd.copyWith(
                      color: TahfeezColors.onSurface,
                    ),
                    decoration: InputDecoration(
                      hintText: l10n.searchClasses,
                      hintStyle: TahfeezTextStyles.bodyMd.copyWith(
                        color: TahfeezColors.onSurfaceVariant,
                      ),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: TahfeezColors.onSurfaceVariant,
                        size: 20,
                      ),
                      filled: true,
                      fillColor: TahfeezColors.surfaceContainerLowest,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: TahfeezColors.surfaceContainer,
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: TahfeezColors.surfaceContainer,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: TahfeezColors.primary.withOpacity(0.5),
                          width: 1.5,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
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
          ),
          floatingActionButton: _isPrivileged
              ? FloatingActionButton.extended(
                  onPressed: _navigateToAddClass,
                  backgroundColor: TahfeezColors.primary,
                  foregroundColor: TahfeezColors.onPrimary,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  icon: const Icon(Icons.add_rounded, size: 22),
                  label: Text(
                    l10n.addClassTitle,
                    style: TahfeezTextStyles.labelLg.copyWith(
                      color: TahfeezColors.onPrimary,
                    ),
                  ),
                )
              : null,
        );
      },
    );
  }

  Widget _buildHeader(
    AppLocalizations l10n,
    List<ClassEntity> classes,
    bool hasData,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.classesManagement,
                  style: TahfeezTextStyles.headlineLg.copyWith(
                    color: TahfeezColors.onSurface,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (hasData && classes.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: TahfeezColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      l10n.classesCount(classes.length),
                      style: TahfeezTextStyles.labelMd.copyWith(
                        color: TahfeezColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Notification icon
          Container(
            decoration: BoxDecoration(
              color: TahfeezColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: TahfeezColors.surfaceContainer,
                width: 1,
              ),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.notifications_outlined,
                color: TahfeezColors.onSurfaceVariant,
                size: 22,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
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
                l10n.failedToLoadClasses,
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
                    context.read<ClassBloc>().add(GetAllClassesEvent()),
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

    if (!hasData || displayClasses.isEmpty) {
      return EmptyClassesWidget(
        onRetry: () => context.read<ClassBloc>().add(GetAllClassesEvent()),
      );
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: TahfeezColors.primary,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
        itemCount: displayClasses.length,
        itemBuilder: (context, i) => ClassCard(
          classEntity: displayClasses[i],
          showDelete: _isPrivileged,
          deleteDisabled: isRefreshing,
          onTap: () {},
          onDelete: () => _showDeleteConfirmation(displayClasses[i]),
        ),
      ),
    );
  }
}