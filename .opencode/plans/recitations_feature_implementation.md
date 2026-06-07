# Recitations Feature - Full Implementation

## Files to Create (16)

---

### 1. `lib/features/recitation/domain/enums/recitation_type.dart`

```dart
enum RecitationType {
  recitation(1),
  review(2);

  final int value;
  const RecitationType(this.value);

  String get displayName {
    switch (this) {
      case RecitationType.recitation:
        return 'Recitation';
      case RecitationType.review:
        return 'Review';
    }
  }

  static RecitationType fromInt(int value) {
    return RecitationType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => RecitationType.recitation,
    );
  }
}
```

---

### 2. `lib/features/recitation/domain/entities/recitation.dart` (UPDATE)

**Current file** — change `type` from `String` to `RecitationType`:

```dart
import 'package:equatable/equatable.dart';
import '../enums/recitation_type.dart';

class Recitation extends Equatable {
  final String id;
  final String studentId;
  final String? studentName;
  final String teacherId;
  final String? teacherName;
  final DateTime date;
  final int ayahsCount;
  final RecitationType type;
  final int grade;
  final String? gradeLabel;
  final String? notes;

  const Recitation({
    required this.id,
    required this.studentId,
    this.studentName,
    required this.teacherId,
    this.teacherName,
    required this.date,
    required this.ayahsCount,
    required this.type,
    required this.grade,
    this.gradeLabel,
    this.notes,
  });

  int get typeValue => type.value;
  String get typeName => type.displayName;

  @override
  List<Object?> get props => [
    id, studentId, studentName, teacherId, teacherName,
    date, ayahsCount, type, grade, gradeLabel, notes,
  ];
}
```

---

### 3. `lib/features/recitation/domain/repositories/recitation_repository.dart`

```dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/recitation.dart';
import '../enums/recitation_type.dart';

abstract class RecitationRepository {
  Future<Either<Failure, String>> logRecitation({
    required String studentId,
    required String teacherId,
    required DateTime date,
    required int ayahsCount,
    required RecitationType type,
    required int grade,
    String? notes,
  });

  Future<Either<Failure, List<Recitation>>> getRecitationsByStudent(
    String studentId,
  );

  Future<Either<Failure, List<Recitation>>> getRecitationsByClass({
    required String classId,
    String? month,
  });
}
```

---

### 4. `lib/features/recitation/domain/usecases/log_recitation_usecase.dart`

```dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../enums/recitation_type.dart';
import '../repositories/recitation_repository.dart';

class LogRecitationUseCase {
  final RecitationRepository repository;

  LogRecitationUseCase(this.repository);

  Future<Either<Failure, String>> call({
    required String studentId,
    required String teacherId,
    required DateTime date,
    required int ayahsCount,
    required RecitationType type,
    required int grade,
    String? notes,
  }) {
    return repository.logRecitation(
      studentId: studentId,
      teacherId: teacherId,
      date: date,
      ayahsCount: ayahsCount,
      type: type,
      grade: grade,
      notes: notes,
    );
  }
}
```

---

### 5. `lib/features/recitation/domain/usecases/get_recitations_by_student_usecase.dart`

```dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/recitation.dart';
import '../repositories/recitation_repository.dart';

class GetRecitationsByStudentUseCase {
  final RecitationRepository repository;

  GetRecitationsByStudentUseCase(this.repository);

  Future<Either<Failure, List<Recitation>>> call(String studentId) {
    return repository.getRecitationsByStudent(studentId);
  }
}
```

---

### 6. `lib/features/recitation/domain/usecases/get_recitations_by_class_usecase.dart`

```dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/recitation.dart';
import '../repositories/recitation_repository.dart';

class GetRecitationsByClassUseCase {
  final RecitationRepository repository;

  GetRecitationsByClassUseCase(this.repository);

  Future<Either<Failure, List<Recitation>>> call({
    required String classId,
    String? month,
  }) {
    return repository.getRecitationsByClass(
      classId: classId,
      month: month,
    );
  }
}
```

---

### 7. `lib/features/recitation/data/models/recitation_model.dart`

```dart
import '../../domain/enums/recitation_type.dart';
import '../../domain/entities/recitation.dart';

class RecitationModel extends Recitation {
  const RecitationModel({
    required super.id,
    required super.studentId,
    super.studentName,
    required super.teacherId,
    super.teacherName,
    required super.date,
    required super.ayahsCount,
    required super.type,
    required super.grade,
    super.gradeLabel,
    super.notes,
  });

  factory RecitationModel.fromJson(Map<String, dynamic> json) {
    return RecitationModel(
      id: json['id'] as String? ?? '',
      studentId: json['studentId'] as String? ?? '',
      studentName: json['studentName'] as String?,
      teacherId: json['teacherId'] as String? ?? '',
      teacherName: json['teacherName'] as String?,
      date: json['date'] != null
          ? DateTime.parse(json['date'] as String)
          : DateTime.now(),
      ayahsCount: (json['ayahsCount'] as int?) ?? 0,
      type: RecitationType.fromInt((json['type'] as int?) ?? 1),
      grade: (json['grade'] as int?) ?? 1,
      gradeLabel: json['gradeLabel'] as String?,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'studentName': studentName,
      'teacherId': teacherId,
      'teacherName': teacherName,
      'date': _formatDate(date),
      'ayahsCount': ayahsCount,
      'type': typeValue,
      'grade': grade,
      'gradeLabel': gradeLabel,
      'notes': notes,
    };
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'studentId': studentId,
      'teacherId': teacherId,
      'date': _formatDate(date),
      'ayahsCount': ayahsCount,
      'type': typeValue,
      'grade': grade,
      if (notes != null && notes!.isNotEmpty) 'notes': notes,
    };
  }

  static String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
```

---

### 8. `lib/features/recitation/data/datasources/recitation_remote_datasource.dart`

```dart
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/error/exceptions.dart';
import '../models/recitation_model.dart';
import '../../domain/enums/recitation_type.dart';

abstract class RecitationRemoteDataSource {
  Future<String> logRecitation({
    required String studentId,
    required String teacherId,
    required String date,
    required int ayahsCount,
    required int type,
    required int grade,
    String? notes,
  });

  Future<List<RecitationModel>> getRecitationsByStudent(String studentId);

  Future<List<RecitationModel>> getRecitationsByClass({
    required String classId,
    String? month,
  });
}

class RecitationRemoteDataSourceImpl implements RecitationRemoteDataSource {
  final ApiClient apiClient;

  RecitationRemoteDataSourceImpl(this.apiClient);

  @override
  Future<String> logRecitation({
    required String studentId,
    required String teacherId,
    required String date,
    required int ayahsCount,
    required int type,
    required int grade,
    String? notes,
  }) async {
    try {
      final response = await apiClient.post(
        ApiConstants.recitationsEndpoint,
        data: {
          'studentId': studentId,
          'teacherId': teacherId,
          'date': date,
          'ayahsCount': ayahsCount,
          'type': type,
          'grade': grade,
          if (notes != null && notes.isNotEmpty) 'notes': notes,
        },
      );
      final id = response['value'];
      if (id == null || id is! String) {
        throw ServerException(message: 'Invalid response: missing recitation ID');
      }
      return id;
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<RecitationModel>> getRecitationsByStudent(String studentId) async {
    try {
      final response = await apiClient.get(
        '${ApiConstants.recitationsEndpoint}/student/$studentId',
      );
      final raw = response['value'];
      if (raw == null || raw is! List) return [];
      return raw
          .whereType<Map<String, dynamic>>()
          .map((e) => RecitationModel.fromJson(e))
          .toList();
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<RecitationModel>> getRecitationsByClass({
    required String classId,
    String? month,
  }) async {
    try {
      final response = await apiClient.get(
        '${ApiConstants.recitationsEndpoint}/class/$classId',
        queryParameters: month != null ? {'month': month} : null,
      );
      final raw = response['value'];
      if (raw == null || raw is! List) return [];
      return raw
          .whereType<Map<String, dynamic>>()
          .map((e) => RecitationModel.fromJson(e))
          .toList();
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
```

---

### 9. `lib/features/recitation/data/repositories/recitation_repository_impl.dart`

```dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/recitation.dart';
import '../../domain/enums/recitation_type.dart';
import '../../domain/repositories/recitation_repository.dart';
import '../datasources/recitation_remote_datasource.dart';
import '../models/recitation_model.dart';

class RecitationRepositoryImpl implements RecitationRepository {
  final RecitationRemoteDataSource remoteDataSource;

  RecitationRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, String>> logRecitation({
    required String studentId,
    required String teacherId,
    required DateTime date,
    required int ayahsCount,
    required RecitationType type,
    required int grade,
    String? notes,
  }) async {
    try {
      final result = await remoteDataSource.logRecitation(
        studentId: studentId,
        teacherId: teacherId,
        date: RecitationModel._formatDate(date),
        ayahsCount: ayahsCount,
        type: type.value,
        grade: grade,
        notes: notes,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Recitation>>> getRecitationsByStudent(
    String studentId,
  ) async {
    try {
      final result = await remoteDataSource.getRecitationsByStudent(studentId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Recitation>>> getRecitationsByClass({
    required String classId,
    String? month,
  }) async {
    try {
      final result = await remoteDataSource.getRecitationsByClass(
        classId: classId,
        month: month,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    }
  }
}
```

---

### 10. `lib/features/recitation/presentation/blocs/recitation_event.dart`

```dart
import 'package:equatable/equatable.dart';
import '../../domain/enums/recitation_type.dart';

abstract class RecitationEvent extends Equatable {
  const RecitationEvent();
  @override
  List<Object?> get props => [];
}

class LogRecitationEvent extends RecitationEvent {
  final String studentId;
  final String teacherId;
  final DateTime date;
  final int ayahsCount;
  final RecitationType type;
  final int grade;
  final String? notes;

  const LogRecitationEvent({
    required this.studentId,
    required this.teacherId,
    required this.date,
    required this.ayahsCount,
    required this.type,
    required this.grade,
    this.notes,
  });

  @override
  List<Object?> get props => [
    studentId, teacherId, date, ayahsCount, type, grade, notes,
  ];
}

class GetRecitationsByStudentEvent extends RecitationEvent {
  final String studentId;

  const GetRecitationsByStudentEvent(this.studentId);

  @override
  List<Object?> get props => [studentId];
}

class GetRecitationsByClassEvent extends RecitationEvent {
  final String classId;
  final String? month;

  const GetRecitationsByClassEvent({
    required this.classId,
    this.month,
  });

  @override
  List<Object?> get props => [classId, month];
}

class SetSelectedMonthEvent extends RecitationEvent {
  final String? month;

  const SetSelectedMonthEvent(this.month);

  @override
  List<Object?> get props => [month];
}

class ResetRecitationOperationStateEvent extends RecitationEvent {
  const ResetRecitationOperationStateEvent();
}
```

---

### 11. `lib/features/recitation/presentation/blocs/recitation_state.dart`

```dart
import 'package:equatable/equatable.dart';
import '../../domain/entities/recitation.dart';

abstract class RecitationState extends Equatable {
  const RecitationState();
  @override
  List<Object?> get props => [];
}

class RecitationInitial extends RecitationState {}

class RecitationLoading extends RecitationState {}

class RecitationsLoaded extends RecitationState {
  final List<Recitation> recitations;
  final List<Recitation> filteredRecitations;
  final String? selectedMonth;

  const RecitationsLoaded({
    required this.recitations,
    required this.filteredRecitations,
    this.selectedMonth,
  });

  @override
  List<Object?> get props => [recitations, filteredRecitations, selectedMonth];
}

class RecitationOperationLoading extends RecitationState {
  const RecitationOperationLoading();
}

class RecitationOperationSuccess extends RecitationState {
  final String message;
  const RecitationOperationSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class RecitationError extends RecitationState {
  final String message;
  const RecitationError(this.message);
  @override
  List<Object?> get props => [message];
}
```

---

### 12. `lib/features/recitation/presentation/blocs/recitation_bloc.dart`

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/recitation.dart';
import '../../domain/usecases/log_recitation_usecase.dart';
import '../../domain/usecases/get_recitations_by_student_usecase.dart';
import '../../domain/usecases/get_recitations_by_class_usecase.dart';
import 'recitation_event.dart';
import 'recitation_state.dart';

class RecitationBloc extends Bloc<RecitationEvent, RecitationState> {
  final LogRecitationUseCase logRecitationUseCase;
  final GetRecitationsByStudentUseCase getRecitationsByStudentUseCase;
  final GetRecitationsByClassUseCase getRecitationsByClassUseCase;

  List<Recitation> _cachedRecitations = [];
  String? _selectedMonth;

  RecitationBloc({
    required this.logRecitationUseCase,
    required this.getRecitationsByStudentUseCase,
    required this.getRecitationsByClassUseCase,
  }) : super(RecitationInitial()) {
    on<LogRecitationEvent>(_onLogRecitation);
    on<GetRecitationsByStudentEvent>(_onGetByStudent);
    on<GetRecitationsByClassEvent>(_onGetByClass);
    on<SetSelectedMonthEvent>(_onSetSelectedMonth);
    on<ResetRecitationOperationStateEvent>(_onResetOperationState);
  }

  Future<void> _onLogRecitation(
    LogRecitationEvent event,
    Emitter<RecitationState> emit,
  ) async {
    emit(const RecitationOperationLoading());
    final result = await logRecitationUseCase(
      studentId: event.studentId,
      teacherId: event.teacherId,
      date: event.date,
      ayahsCount: event.ayahsCount,
      type: event.type,
      grade: event.grade,
      notes: event.notes,
    );
    result.fold(
      (failure) => emit(RecitationError(failure.message)),
      (_) => emit(const RecitationOperationSuccess('logged')),
    );
  }

  Future<void> _onGetByStudent(
    GetRecitationsByStudentEvent event,
    Emitter<RecitationState> emit,
  ) async {
    emit(RecitationLoading());
    final result = await getRecitationsByStudentUseCase(event.studentId);
    result.fold(
      (failure) => emit(RecitationError(failure.message)),
      (recitations) {
        _cachedRecitations = List.from(recitations);
        _applyMonthFilter(emit);
      },
    );
  }

  Future<void> _onGetByClass(
    GetRecitationsByClassEvent event,
    Emitter<RecitationState> emit,
  ) async {
    emit(RecitationLoading());
    final result = await getRecitationsByClassUseCase(
      classId: event.classId,
      month: event.month,
    );
    result.fold(
      (failure) => emit(RecitationError(failure.message)),
      (recitations) {
        _cachedRecitations = List.from(recitations);
        _applyMonthFilter(emit);
      },
    );
  }

  void _onSetSelectedMonth(
    SetSelectedMonthEvent event,
    Emitter<RecitationState> emit,
  ) {
    _selectedMonth = event.month;
    if (_cachedRecitations.isNotEmpty) {
      _applyMonthFilter(emit);
    }
  }

  void _onResetOperationState(
    ResetRecitationOperationStateEvent event,
    Emitter<RecitationState> emit,
  ) {
    if (_cachedRecitations.isNotEmpty) {
      _applyMonthFilter(emit);
    } else {
      emit(RecitationInitial());
    }
  }

  void _applyMonthFilter(Emitter<RecitationState> emit) {
    if (_selectedMonth == null) {
      emit(RecitationsLoaded(
        recitations: List.from(_cachedRecitations),
        filteredRecitations: List.from(_cachedRecitations),
      ));
    } else {
      final filtered = _cachedRecitations.where((r) {
        final monthKey = '${r.date.year}-${r.date.month.toString().padLeft(2, '0')}';
        return monthKey == _selectedMonth;
      }).toList();
      emit(RecitationsLoaded(
        recitations: List.from(_cachedRecitations),
        filteredRecitations: filtered,
        selectedMonth: _selectedMonth,
      ));
    }
  }
}
```

---

### 13. `lib/features/recitation/presentation/widgets/recitation_card.dart`

```dart
import 'package:flutter/material.dart';
import '../../../../theme/tahfeez_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/recitation.dart';

class RecitationCard extends StatelessWidget {
  final Recitation recitation;

  const RecitationCard({super.key, required this.recitation});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isRecitation = recitation.typeValue == 1;

    final typeColor = isRecitation
        ? TahfeezColors.primary
        : TahfeezColors.tertiary;
    final typeBgColor = isRecitation
        ? TahfeezColors.primary.withOpacity(0.12)
        : TahfeezColors.tertiary.withOpacity(0.12);

    final gradeColor = recitation.grade >= 8
        ? TahfeezColors.primary
        : recitation.grade >= 5
            ? TahfeezColors.secondary
            : TahfeezColors.error;

    final gradeLabel = recitation.gradeLabel ??
        (recitation.grade >= 8
            ? l10n.excellentGrade
            : recitation.grade >= 5
                ? l10n.gradeGood
                : l10n.gradeNeedsWork);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: TahfeezColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TahfeezColors.outlineVariant),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 12,
                          color: TahfeezColors.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatDate(recitation.date),
                          style: TahfeezTextStyles.labelMd.copyWith(
                            color: TahfeezColors.onSurfaceVariant,
                          ),
                        ),
                        if (recitation.teacherName != null) ...[
                          const SizedBox(width: 12),
                          const Icon(
                            Icons.person_outline,
                            size: 12,
                            color: TahfeezColors.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            recitation.teacherName!,
                            style: TahfeezTextStyles.labelMd.copyWith(
                              color: TahfeezColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.ayahsCount(recitation.ayahsCount),
                      style: TahfeezTextStyles.titleLg.copyWith(
                        color: TahfeezColors.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: typeBgColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  recitation.typeName,
                  style: TahfeezTextStyles.labelMd.copyWith(
                    color: typeColor,
                    fontSize: 10,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: TahfeezColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: TahfeezColors.outlineVariant),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: gradeColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      gradeLabel,
                      style: TahfeezTextStyles.labelLg.copyWith(
                        color: gradeColor,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: gradeColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${recitation.grade}/10',
                        style: TahfeezTextStyles.labelMd.copyWith(
                          color: gradeColor,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (recitation.notes != null && recitation.notes!.isNotEmpty) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '"${recitation.notes}"',
                    style: TahfeezTextStyles.bodyMd.copyWith(
                      color: TahfeezColors.onSurfaceVariant,
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        ],
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
```

---

### 14. `lib/features/recitation/presentation/widgets/empty_recitations_widget.dart`

```dart
import 'package:flutter/material.dart';
import '../../../../theme/tahfeez_theme.dart';
import '../../../../l10n/app_localizations.dart';

class EmptyRecitationsWidget extends StatelessWidget {
  final VoidCallback? onRetry;

  const EmptyRecitationsWidget({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 120,
              height: 120,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: TahfeezColors.primary.withOpacity(0.04),
                    ),
                  ),
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: TahfeezColors.primary.withOpacity(0.07),
                    ),
                  ),
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: TahfeezColors.primary.withOpacity(0.10),
                    ),
                    child: const Icon(
                      Icons.menu_book_rounded,
                      size: 32,
                      color: TahfeezColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.noRecitationsFound,
              style: TahfeezTextStyles.titleLg.copyWith(
                color: TahfeezColors.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.noRecitationsFoundSubtitle,
              style: TahfeezTextStyles.bodyMd.copyWith(
                color: TahfeezColors.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 28),
              FilledButton.icon(
                onPressed: onRetry,
                style: FilledButton.styleFrom(
                  backgroundColor: TahfeezColors.primary,
                  foregroundColor: TahfeezColors.onPrimary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: Text(
                  l10n.retry,
                  style: TahfeezTextStyles.labelLg,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
```

---

### 15. `lib/features/recitation/presentation/pages/log_recitation_page.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../../../core/network/api_client.dart';
import '../../../../core/utils/toast_helper.dart';
import '../../../../theme/tahfeez_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../student/presentation/blocs/student_bloc.dart';
import '../../../student/presentation/blocs/student_state.dart';
import '../../../student/presentation/blocs/student_event.dart';
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
  String? _selectedStudentName;
  String? _teacherId;
  String? _teacherName;
  DateTime _selectedDate = DateTime.now();
  RecitationType _recitationType = RecitationType.recitation;
  double _grade = 8;
  bool _isLoadingTeacher = true;

  @override
  void initState() {
    super.initState();
    if (widget.studentId != null) {
      _selectedStudentId = widget.studentId;
      _selectedStudentName = widget.studentName;
    }
    _loadTeacherInfo();
  }

  @override
  void dispose() {
    _notesController.dispose();
    _ayahsCountController.dispose();
    super.dispose();
  }

  Future<void> _loadTeacherInfo() async {
    try {
      final apiClient = di.sl<ApiClient>();
      final token = await apiClient.getAccessToken();
      if (token != null && !JwtDecoder.isExpired(token)) {
        final claims = JwtDecoder.decode(token);
        if (mounted) {
          setState(() {
            _teacherId = claims['sub'] as String?;
            _teacherName = claims['name'] as String?;
            _isLoadingTeacher = false;
          });
        }
      } else {
        if (mounted) setState(() => _isLoadingTeacher = false);
      }
    } catch (_) {
      if (mounted) setState(() => _isLoadingTeacher = false);
    }
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
                  // Intro card
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

                  // Form card
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
                        // Student field
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
                                          _selectedStudentName = students
                                              .firstWhere((s) => s.id == v)
                                              .fullName;
                                        });
                                      },
                                      validator: (v) =>
                                          v == null ? l10n.selectStudent : null,
                                    );
                                  },
                                ),
                        ),

                        _buildDivider(),

                        // Teacher field
                        _buildFormSection(
                          icon: Icons.school_outlined,
                          title: l10n.teacher,
                          child: _isLoadingTeacher
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Container(
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
                                        _teacherName ?? l10n.teacher,
                                        style: TahfeezTextStyles.bodyMd.copyWith(
                                          color: TahfeezColors.onSurface,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),

                        _buildDivider(),

                        // Date field
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

                        // Recitation Type
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

                        // Ayahs Count
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

                        // Grade slider
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

                  // Notes field
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

                  // Submit button
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
                child: Icon(
                  icon,
                  size: 14,
                  color: TahfeezColors.primary,
                ),
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
            color: isSelected
                ? selectedText
                : TahfeezColors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
```

---

### 16. `lib/features/recitation/presentation/pages/recitation_history_page.dart`

```dart
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

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
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
            if (months.isNotEmpty && _selectedMonth != null && !months.contains(_selectedMonth)) {
              _selectedMonth = months.first;
            }
          }

          return Column(
            children: [
              // Header context with student name
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
                                          : TahfeezColors.surfaceContainerLowest,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: isSelected
                                            ? Colors.transparent
                                            : TahfeezColors.outlineVariant,
                                      ),
                                    ),
                                    child: Text(
                                      _monthLabel(m),
                                      style: TahfeezTextStyles.labelLg.copyWith(
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
                  months,
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
    List<String> months,
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
      return EmptyRecitationsWidget(
        onRetry: _onRefresh,
      );
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: TahfeezColors.primary,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Monthly summary
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

          // Recitation cards
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
```

---

## Files to Delete

1. `lib/screens/log_recitation_screen.dart`
2. `lib/screens/recitation_history_screen.dart`

---

## Files to Modify

### A. `lib/core/di/injection_container.dart`

**Add these imports** (after the student feature imports):

```dart
import '../../features/recitation/data/datasources/recitation_remote_datasource.dart';
import '../../features/recitation/data/repositories/recitation_repository_impl.dart';
import '../../features/recitation/domain/repositories/recitation_repository.dart';
import '../../features/recitation/domain/usecases/log_recitation_usecase.dart';
import '../../features/recitation/domain/usecases/get_recitations_by_student_usecase.dart';
import '../../features/recitation/domain/usecases/get_recitations_by_class_usecase.dart';
import '../../features/recitation/presentation/blocs/recitation_bloc.dart';
```

**Add registrations** (after StudentRemoteDataSource registration):

```dart
  sl.registerLazySingleton<RecitationRemoteDataSource>(
    () => RecitationRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<RecitationRepository>(
    () => RecitationRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(() => LogRecitationUseCase(sl()));
  sl.registerLazySingleton(() => GetRecitationsByStudentUseCase(sl()));
  sl.registerLazySingleton(() => GetRecitationsByClassUseCase(sl()));

  sl.registerFactory(
    () => RecitationBloc(
      logRecitationUseCase: sl(),
      getRecitationsByStudentUseCase: sl(),
      getRecitationsByClassUseCase: sl(),
    ),
  );
```

### B. `lib/screens/students_screen.dart`

**Change imports** (lines 11-12):
```dart
// REMOVE:
import 'recitation_history_screen.dart';
import 'log_recitation_screen.dart';
// ADD:
import '../features/recitation/presentation/pages/log_recitation_page.dart';
import '../features/recitation/presentation/pages/recitation_history_page.dart';
```

Also need to add BlocProvider for RecitationBloc in `students_screen.dart`. Add this import:
```dart
import '../features/recitation/presentation/blocs/recitation_bloc.dart';
import '../core/di/injection_container.dart' as di;
```

Then wrap the navigation destinations with BlocProvider:
```dart
onLogRecitation: () => Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => BlocProvider.value(
      value: context.read<RecitationBloc>(),
      child: LogRecitationPage(
        studentId: displayStudents[i].id,
        studentName: displayStudents[i].fullName ?? '',
      ),
    ),
  ),
),
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
```

Also wrap the StudentsScreen in a BlocProvider<RecitationBloc> in the main_shell.dart, or provide it in `students_screen.dart` itself.

Actually, the simplest approach: in `students_screen.dart`, at the top level of `build`, wrap the entire Scaffold with a `BlocProvider.value` for `RecitationBloc` that children can access. But a cleaner approach is to provide `RecitationBloc` in `main_shell.dart` alongside `StudentBloc` and `ClassBloc`.

**Update `main_shell.dart`** — add import and BlocProvider:

```dart
// Add import:
import '../features/recitation/presentation/blocs/recitation_bloc.dart';
// In main_shell.dart, wrap inside BlocProvider<StudentBloc>:
child: BlocProvider<RecitationBloc>(
  create: (_) => di.sl<RecitationBloc>(),
  child: BlocProvider<StudentBloc>(
    create: (_) => di.sl<StudentBloc>()..add(GetStudentsEvent()),
    child: Scaffold(...)
  ),
),
```

---

## L10n Keys Already Available

These keys exist in both l10n files and are used by the new code:

| Key | Usage |
|-----|-------|
| `logRecitation` | Page title, intro card |
| `logRecitationSubtitle` | Intro card subtitle |
| `selectStudent` | Dropdown hint |
| `student` | Field label |
| `teacher` | Field label |
| `teacherRequired` | Validation message |
| `date` | Field label |
| `recitationType` | Section label |
| `newHifdh` | Type option label |
| `reviewMurajaah` | Type option label |
| `ayahsCount` | Field label |
| `ayahsRequired` | Validation message |
| `ayahsInvalid` | Validation message |
| `qualityGrade` | Section label |
| `needsWork` | Grade range label |
| `perfect` | Grade range label |
| `observationsNotes` | Notes section label |
| `observationsHint` | Notes hint |
| `saveLog` | Submit button |
| `recitationLogSaved` | Success toast |
| `recitationHistory` | Page title |
| `monthlyProgress` | Summary section |
| `sessions` | Count label |
| `excellentGrade` | Grade label (8-10) |
| `gradeGood` | Grade label (5-7) |
| `gradeNeedsWork` | Grade label (1-4) |
| `filterChipsAll` | Filter chip |
| `filterChipsExcellent` | Filter chip |
| `filterChipsGood` | Filter chip |
| `filterChipsNeedsWork` | Filter chip |
| `noRecitationsFound` | Empty state (check exists) |
| `noRecitationsFoundSubtitle` | Empty state (check exists) |
| `failedToLoadRecitations` | Error state (check exists) |
| `checkConnectionAndRetry` | Error state |
| `retry` | Retry button |
| `submitting` | Loading button text |
| `cancel` | Cancel button |

**Note**: If `noRecitationsFound`, `noRecitationsFoundSubtitle`, `failedToLoadRecitations`, `ayahsRequired`, `ayahsInvalid`, or `teacherRequired` don't exist in the l10n files, add them. Check `app_localizations_en.dart` first.

---

## Summary of All Changes

**16 new files:**
| # | File |
|---|------|
| 1 | `lib/features/recitation/domain/enums/recitation_type.dart` |
| 2 | `lib/features/recitation/domain/repositories/recitation_repository.dart` |
| 3 | `lib/features/recitation/domain/usecases/log_recitation_usecase.dart` |
| 4 | `lib/features/recitation/domain/usecases/get_recitations_by_student_usecase.dart` |
| 5 | `lib/features/recitation/domain/usecases/get_recitations_by_class_usecase.dart` |
| 6 | `lib/features/recitation/data/models/recitation_model.dart` |
| 7 | `lib/features/recitation/data/datasources/recitation_remote_datasource.dart` |
| 8 | `lib/features/recitation/data/repositories/recitation_repository_impl.dart` |
| 9 | `lib/features/recitation/presentation/blocs/recitation_event.dart` |
| 10 | `lib/features/recitation/presentation/blocs/recitation_state.dart` |
| 11 | `lib/features/recitation/presentation/blocs/recitation_bloc.dart` |
| 12 | `lib/features/recitation/presentation/widgets/recitation_card.dart` |
| 13 | `lib/features/recitation/presentation/widgets/empty_recitations_widget.dart` |
| 14 | `lib/features/recitation/presentation/pages/log_recitation_page.dart` |
| 15 | `lib/features/recitation/presentation/pages/recitation_history_page.dart` |
| 16 | `lib/core/di/injection_container.dart` (modified) |

**1 modified entity file:**
| # | File |
|---|------|
| 1 | `lib/features/recitation/domain/entities/recitation.dart` |

**2 modified existing files:**
| # | File |
|---|------|
| 1 | `lib/screens/students_screen.dart` |
| 2 | `lib/screens/main_shell.dart` |

**2 deleted files:**
| # | File |
|---|------|
| 1 | `lib/screens/log_recitation_screen.dart` |
| 2 | `lib/screens/recitation_history_screen.dart` |
