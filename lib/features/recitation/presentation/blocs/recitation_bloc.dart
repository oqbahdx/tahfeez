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
