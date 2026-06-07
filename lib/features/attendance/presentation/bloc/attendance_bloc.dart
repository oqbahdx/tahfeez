import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_attendance_by_date_usecase.dart';
import '../../domain/usecases/get_attendance_history_usecase.dart';
import '../../domain/usecases/get_attendance_report_usecase.dart';
import '../../domain/usecases/record_attendance_usecase.dart';
import '../../domain/usecases/update_attendance_usecase.dart';
import 'attendance_event.dart';
import 'attendance_state.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final GetAttendanceByDateUseCase getAttendanceByDateUseCase;
  final GetAttendanceHistoryUseCase getAttendanceHistoryUseCase;
  final GetAttendanceReportUseCase getAttendanceReportUseCase;
  final RecordAttendanceUseCase recordAttendanceUseCase;
  final UpdateAttendanceUseCase updateAttendanceUseCase;

  AttendanceEvent? _lastFetchEvent;

  AttendanceBloc({
    required this.getAttendanceByDateUseCase,
    required this.getAttendanceHistoryUseCase,
    required this.getAttendanceReportUseCase,
    required this.recordAttendanceUseCase,
    required this.updateAttendanceUseCase,
  }) : super(const AttendanceInitial()) {
    on<FetchAttendanceByDate>(_onFetchByDate);
    on<FetchAttendanceHistory>(_onFetchHistory);
    on<FetchAttendanceReport>(_onFetchReport);
    on<RecordAttendanceEvent>(_onRecord);
    on<UpdateAttendanceEvent>(_onUpdate);
    on<RefreshAttendance>(_onRefresh);
    on<ClearAttendance>(_onClear);
  }

  Future<void> _onFetchByDate(
    FetchAttendanceByDate event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(const AttendanceLoading());
    _lastFetchEvent = event;
    final result = await getAttendanceByDateUseCase(event.date);
    result.fold(
      (failure) => emit(AttendanceError(failure.message)),
      (attendances) {
        if (attendances.isEmpty) {
          emit(const AttendanceEmpty());
        } else {
          emit(AttendanceLoaded(attendances));
        }
      },
    );
  }

  Future<void> _onFetchHistory(
    FetchAttendanceHistory event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(const AttendanceLoading());
    _lastFetchEvent = event;
    final result = await getAttendanceHistoryUseCase(event.userId);
    result.fold(
      (failure) => emit(AttendanceError(failure.message)),
      (attendances) {
        if (attendances.isEmpty) {
          emit(const AttendanceEmpty());
        } else {
          emit(AttendanceLoaded(attendances));
        }
      },
    );
  }

  Future<void> _onFetchReport(
    FetchAttendanceReport event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(const AttendanceLoading());
    _lastFetchEvent = event;
    final result = await getAttendanceReportUseCase(
      classId: event.classId,
      from: event.from,
      to: event.to,
    );
    result.fold(
      (failure) => emit(AttendanceError(failure.message)),
      (attendances) {
        if (attendances.isEmpty) {
          emit(const AttendanceEmpty());
        } else {
          emit(AttendanceLoaded(attendances));
        }
      },
    );
  }

  Future<void> _onRecord(
    RecordAttendanceEvent event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(const AttendanceSubmitting());
    for (final record in event.records) {
      final result = await recordAttendanceUseCase(
        userId: record['userId'] as String,
        date: record['date'] as DateTime,
        status: record['status'] as int,
        notes: record['notes'] as String?,
      );
      final failure = result.fold(
        (failure) => failure,
        (_) => null,
      );
      if (failure != null) {
        emit(AttendanceError(failure.message));
        return;
      }
    }
    emit(const AttendanceSuccess('Attendance saved successfully'));
  }

  Future<void> _onUpdate(
    UpdateAttendanceEvent event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(const AttendanceSubmitting());
    final result = await updateAttendanceUseCase(
      attendanceId: event.attendanceId,
      status: event.status,
      notes: event.notes,
    );
    result.fold(
      (failure) => emit(AttendanceError(failure.message)),
      (_) => emit(const AttendanceSuccess('Attendance updated successfully')),
    );
  }

  Future<void> _onRefresh(
    RefreshAttendance event,
    Emitter<AttendanceState> emit,
  ) async {
    if (_lastFetchEvent != null) {
      add(_lastFetchEvent!);
    }
  }

  void _onClear(
    ClearAttendance event,
    Emitter<AttendanceState> emit,
  ) {
    _lastFetchEvent = null;
    emit(const AttendanceInitial());
  }
}
