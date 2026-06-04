import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/class_entity.dart';
import '../../domain/usecases/class_usecases.dart';
import 'class_event.dart';
import 'class_state.dart';

class ClassBloc extends Bloc<ClassEvent, ClassState> {
  final GetAllClassesUseCase getAllClassesUseCase;
  final GetClassByIdUseCase getClassByIdUseCase;
  final GetClassStudentsUseCase getClassStudentsUseCase;
  final CreateClassUseCase createClassUseCase;
  final UpdateClassUseCase updateClassUseCase;
  final DeleteClassUseCase deleteClassUseCase;
  final AssignStaffUseCase assignStaffUseCase;
  final GetUsersByRoleUseCase getUsersByRoleUseCase;

  List<ClassEntity> _cachedClasses = [];
  String _currentSearchQuery = '';

  ClassBloc({
    required this.getAllClassesUseCase,
    required this.getClassByIdUseCase,
    required this.getClassStudentsUseCase,
    required this.createClassUseCase,
    required this.updateClassUseCase,
    required this.deleteClassUseCase,
    required this.assignStaffUseCase,
    required this.getUsersByRoleUseCase,
  }) : super(ClassInitial()) {
    on<GetAllClassesEvent>(_onGetAllClasses);
    on<RefreshClassesEvent>(_onRefreshClasses);
    on<GetClassByIdEvent>(_onGetClassById);
    on<GetClassStudentsEvent>(_onGetClassStudents);
    on<CreateClassEvent>(_onCreateClass);
    on<UpdateClassEvent>(_onUpdateClass);
    on<DeleteClassEvent>(_onDeleteClass);
    on<AssignStaffEvent>(_onAssignStaff);
    on<SearchClassesEvent>(_onSearchClasses);
    on<FetchUsersEvent>(_onFetchUsers);
    on<ResetOperationStateEvent>(_onResetOperationState);
  }

  Future<void> _onGetAllClasses(
    GetAllClassesEvent event,
    Emitter<ClassState> emit,
  ) async {
    emit(ClassLoading());
    final result = await getAllClassesUseCase();
    result.fold(
      (failure) => emit(ClassError(failure.message)),
      (classes) {
        _cachedClasses = List.from(classes);
        _applySearchFilter(emit, classes);
      },
    );
  }

  Future<void> _onRefreshClasses(
    RefreshClassesEvent event,
    Emitter<ClassState> emit,
  ) async {
    final result = await getAllClassesUseCase();
    result.fold(
      (failure) {
        if (_cachedClasses.isNotEmpty) {
          _applySearchFilter(emit, _cachedClasses);
        } else {
          emit(ClassError(failure.message));
        }
      },
      (classes) {
        _cachedClasses = List.from(classes);
        _applySearchFilter(emit, classes);
      },
    );
  }

  Future<void> _onGetClassById(
    GetClassByIdEvent event,
    Emitter<ClassState> emit,
  ) async {
    emit(ClassLoading());
    final result = await getClassByIdUseCase(event.id);
    result.fold(
      (failure) => emit(ClassError(failure.message)),
      (classEntity) => emit(ClassLoaded(classEntity)),
    );
  }

  Future<void> _onGetClassStudents(
    GetClassStudentsEvent event,
    Emitter<ClassState> emit,
  ) async {
    emit(ClassLoading());
    final result = await getClassStudentsUseCase(event.classId);
    result.fold(
      (failure) => emit(ClassError(failure.message)),
      (students) => emit(ClassStudentsLoaded(students)),
    );
  }

  Future<void> _onCreateClass(
    CreateClassEvent event,
    Emitter<ClassState> emit,
  ) async {
    emit(const ClassOperationLoading());
    final result = await createClassUseCase(
      name: event.name,
      type: event.type,
      mode: event.mode,
      teacherId: event.teacherId,
      assistantId: event.assistantId,
      supervisorId: event.supervisorId,
    );
    result.fold(
      (failure) => emit(ClassError(failure.message)),
      (_) => emit(const ClassOperationSuccess('created')),
    );
  }

  Future<void> _onUpdateClass(
    UpdateClassEvent event,
    Emitter<ClassState> emit,
  ) async {
    emit(const ClassOperationLoading());
    final result = await updateClassUseCase(
      id: event.id,
      name: event.name,
      type: event.type,
      mode: event.mode,
    );
    result.fold(
      (failure) => emit(ClassError(failure.message)),
      (_) => emit(const ClassOperationSuccess('updated')),
    );
  }

  Future<void> _onDeleteClass(
    DeleteClassEvent event,
    Emitter<ClassState> emit,
  ) async {
    final previousState = state;
    if (previousState is ClassesLoaded) {
      final updatedClasses = previousState.classes
          .where((c) => c.id != event.id)
          .toList();
      _cachedClasses = updatedClasses;
      _applySearchFilter(emit, updatedClasses);
    }
    emit(const ClassOperationLoading());
    final result = await deleteClassUseCase(event.id);
    result.fold(
      (failure) {
        add(GetAllClassesEvent());
        emit(ClassError(failure.message));
      },
      (_) => emit(const ClassOperationSuccess('deleted')),
    );
  }

  Future<void> _onAssignStaff(
    AssignStaffEvent event,
    Emitter<ClassState> emit,
  ) async {
    emit(const ClassOperationLoading());
    final result = await assignStaffUseCase(
      classId: event.classId,
      teacherId: event.teacherId,
      assistantId: event.assistantId,
      supervisorId: event.supervisorId,
    );
    result.fold(
      (failure) => emit(ClassError(failure.message)),
      (_) => emit(const ClassOperationSuccess('staff_assigned')),
    );
  }

  Future<void> _onSearchClasses(
    SearchClassesEvent event,
    Emitter<ClassState> emit,
  ) async {
    _currentSearchQuery = event.query;
    if (_cachedClasses.isNotEmpty) {
      _applySearchFilter(emit, _cachedClasses);
    }
  }

  Future<void> _onFetchUsers(
    FetchUsersEvent event,
    Emitter<ClassState> emit,
  ) async {
    final result = await getUsersByRoleUseCase(event.role);
    result.fold(
      (failure) => null,
      (users) => emit(UsersLoaded(users)),
    );
  }

  Future<void> _onResetOperationState(
    ResetOperationStateEvent event,
    Emitter<ClassState> emit,
  ) async {
    if (_cachedClasses.isNotEmpty) {
      _applySearchFilter(emit, _cachedClasses);
    } else {
      emit(ClassInitial());
    }
  }

  void _applySearchFilter(
    Emitter<ClassState> emit,
    List<ClassEntity> classes,
  ) {
    final query = _currentSearchQuery.toLowerCase().trim();
    if (query.isEmpty) {
      emit(ClassesLoaded(
        classes: List.from(classes),
        filteredClasses: List.from(classes),
      ));
    } else {
      final filtered = classes.where((c) {
        return c.name.toLowerCase().contains(query);
      }).toList();
      emit(ClassesLoaded(
        classes: List.from(classes),
        filteredClasses: filtered,
        searchQuery: _currentSearchQuery,
      ));
    }
  }
}
