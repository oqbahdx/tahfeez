import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/domain/entities/user.dart';
import '../../domain/usecases/get_students_usecase.dart';
import 'student_event.dart';
import 'student_state.dart';

class StudentBloc extends Bloc<StudentEvent, StudentState> {
  final GetStudentsUseCase getStudentsUseCase;

  List<User> _cachedStudents = [];
  String _currentSearchQuery = '';

  StudentBloc({
    required this.getStudentsUseCase,
  }) : super(StudentInitial()) {
    on<GetStudentsEvent>(_onGetStudents);
    on<RefreshStudentsEvent>(_onRefreshStudents);
    on<SearchStudentsEvent>(_onSearchStudents);
  }

  Future<void> _onGetStudents(
    GetStudentsEvent event,
    Emitter<StudentState> emit,
  ) async {
    emit(StudentLoading());
    final result = await getStudentsUseCase();
    result.fold(
      (failure) => emit(StudentError(failure.message)),
      (students) {
        _cachedStudents = List.from(students);
        _applySearchFilter(emit);
      },
    );
  }

  Future<void> _onRefreshStudents(
    RefreshStudentsEvent event,
    Emitter<StudentState> emit,
  ) async {
    final result = await getStudentsUseCase();
    result.fold(
      (failure) {
        if (_cachedStudents.isNotEmpty) {
          _applySearchFilter(emit);
        } else {
          emit(StudentError(failure.message));
        }
      },
      (students) {
        _cachedStudents = List.from(students);
        _applySearchFilter(emit);
      },
    );
  }

  Future<void> _onSearchStudents(
    SearchStudentsEvent event,
    Emitter<StudentState> emit,
  ) async {
    _currentSearchQuery = event.query;
    if (_cachedStudents.isNotEmpty) {
      _applySearchFilter(emit);
    }
  }

  void _applySearchFilter(Emitter<StudentState> emit) {
    final query = _currentSearchQuery.toLowerCase().trim();
    if (query.isEmpty) {
      emit(StudentsLoaded(
        students: List.from(_cachedStudents),
        filteredStudents: List.from(_cachedStudents),
      ));
    } else {
      final filtered = _cachedStudents.where((s) {
        final name = (s.fullName ?? '').toLowerCase();
        return name.contains(query);
      }).toList();
      emit(StudentsLoaded(
        students: List.from(_cachedStudents),
        filteredStudents: filtered,
        searchQuery: _currentSearchQuery,
      ));
    }
  }
}
