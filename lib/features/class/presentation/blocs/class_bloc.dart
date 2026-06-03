import 'package:flutter_bloc/flutter_bloc.dart';
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

  ClassBloc({
    required this.getAllClassesUseCase,
    required this.getClassByIdUseCase,
    required this.getClassStudentsUseCase,
    required this.createClassUseCase,
    required this.updateClassUseCase,
    required this.deleteClassUseCase,
    required this.assignStaffUseCase,
  }) : super(ClassInitial()) {
    on<GetAllClassesEvent>(_onGetAllClasses);
    on<GetClassByIdEvent>(_onGetClassById);
    on<GetClassStudentsEvent>(_onGetClassStudents);
    on<CreateClassEvent>(_onCreateClass);
    on<UpdateClassEvent>(_onUpdateClass);
    on<DeleteClassEvent>(_onDeleteClass);
    on<AssignStaffEvent>(_onAssignStaff);
  }

  Future<void> _onGetAllClasses(
    GetAllClassesEvent event,
    Emitter<ClassState> emit,
  ) async {
    emit(ClassLoading());
    final result = await getAllClassesUseCase();
    result.fold(
      (failure) => emit(ClassError(failure.message)),
      (classes) => emit(ClassesLoaded(classes)),
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
    emit(ClassLoading());
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
      (id) => emit(ClassOperationSuccess('Class created successfully (ID: $id)')),
    );
  }

  Future<void> _onUpdateClass(
    UpdateClassEvent event,
    Emitter<ClassState> emit,
  ) async {
    emit(ClassLoading());
    final result = await updateClassUseCase(
      id: event.id,
      name: event.name,
      type: event.type,
      mode: event.mode,
    );
    result.fold(
      (failure) => emit(ClassError(failure.message)),
      (_) => emit(const ClassOperationSuccess('Class updated successfully')),
    );
  }

  Future<void> _onDeleteClass(
    DeleteClassEvent event,
    Emitter<ClassState> emit,
  ) async {
    emit(ClassLoading());
    final result = await deleteClassUseCase(event.id);
    result.fold(
      (failure) => emit(ClassError(failure.message)),
      (_) => emit(const ClassOperationSuccess('Class deleted successfully')),
    );
  }

  Future<void> _onAssignStaff(
    AssignStaffEvent event,
    Emitter<ClassState> emit,
  ) async {
    emit(ClassLoading());
    final result = await assignStaffUseCase(
      classId: event.classId,
      teacherId: event.teacherId,
      assistantId: event.assistantId,
      supervisorId: event.supervisorId,
    );
    result.fold(
      (failure) => emit(ClassError(failure.message)),
      (_) => emit(const ClassOperationSuccess('Staff assigned successfully')),
    );
  }
}
