import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/auth_usecases.dart';
import '../../features/auth/presentation/blocs/auth_bloc.dart';

import '../../features/class/data/datasources/class_remote_datasource.dart';
import '../../features/class/data/repositories/class_repository_impl.dart';
import '../../features/class/domain/repositories/class_repository.dart';
import '../../features/class/domain/usecases/class_usecases.dart';
import '../../features/class/presentation/blocs/class_bloc.dart';

import '../../features/student/data/datasources/student_remote_datasource.dart';
import '../../features/student/data/repositories/student_repository_impl.dart';
import '../../features/student/domain/repositories/student_repository.dart';
import '../../features/student/domain/usecases/get_students_usecase.dart';
import '../../features/student/domain/usecases/activate_student_usecase.dart';
import '../../features/student/presentation/blocs/student_bloc.dart';

import '../../features/recitation/data/datasources/recitation_remote_datasource.dart';
import '../../features/recitation/data/repositories/recitation_repository_impl.dart';
import '../../features/recitation/domain/repositories/recitation_repository.dart';
import '../../features/recitation/domain/usecases/log_recitation_usecase.dart';
import '../../features/recitation/domain/usecases/get_recitations_by_student_usecase.dart';
import '../../features/recitation/domain/usecases/get_recitations_by_class_usecase.dart';
import '../../features/recitation/presentation/blocs/recitation_bloc.dart';

import '../../features/attendance/data/datasources/attendance_remote_datasource.dart';
import '../../features/attendance/data/repositories/attendance_repository_impl.dart';
import '../../features/attendance/domain/repositories/attendance_repository.dart';
import '../../features/attendance/domain/usecases/get_attendance_by_date_usecase.dart';
import '../../features/attendance/domain/usecases/get_attendance_history_usecase.dart';
import '../../features/attendance/domain/usecases/get_attendance_report_usecase.dart';
import '../../features/attendance/domain/usecases/record_attendance_usecase.dart';
import '../../features/attendance/domain/usecases/update_attendance_usecase.dart';
import '../../features/attendance/presentation/bloc/attendance_bloc.dart';

import '../network/api_client.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Keep SharedPreferences for non-sensitive app preferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);

  // Secure storage for tokens
  const secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );
  sl.registerSingleton<FlutterSecureStorage>(secureStorage);

  final dio = Dio();
  sl.registerSingleton<Dio>(dio);

  // ApiClient now uses FlutterSecureStorage
  sl.registerSingleton<ApiClient>(ApiClient(sl<Dio>(), sl<FlutterSecureStorage>()));

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<ClassRemoteDataSource>(
    () => ClassRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<StudentRemoteDataSource>(
    () => StudentRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<RecitationRemoteDataSource>(
    () => RecitationRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton<ClassRepository>(() => ClassRepositoryImpl(sl()));
  sl.registerLazySingleton<StudentRepository>(() => StudentRepositoryImpl(sl()));
  sl.registerLazySingleton<RecitationRepository>(() => RecitationRepositoryImpl(sl()));

  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetAccessTokenUseCase(sl()));
  sl.registerLazySingleton(() => RefreshTokenUseCase(sl()));

  sl.registerLazySingleton(() => GetAllClassesUseCase(sl()));
  sl.registerLazySingleton(() => GetClassByIdUseCase(sl()));
  sl.registerLazySingleton(() => GetClassStudentsUseCase(sl()));
  sl.registerLazySingleton(() => CreateClassUseCase(sl()));
  sl.registerLazySingleton(() => UpdateClassUseCase(sl()));
  sl.registerLazySingleton(() => DeleteClassUseCase(sl()));
  sl.registerLazySingleton(() => AssignStaffUseCase(sl()));
  sl.registerLazySingleton(() => GetUsersByRoleUseCase(sl()));

  sl.registerLazySingleton(() => GetStudentsUseCase(sl()));
  sl.registerLazySingleton(() => ActivateStudentUseCase(sl()));
  sl.registerLazySingleton(() => LogRecitationUseCase(sl()));
  sl.registerLazySingleton(() => GetRecitationsByStudentUseCase(sl()));
  sl.registerLazySingleton(() => GetRecitationsByClassUseCase(sl()));

  sl.registerFactory(() => StudentBloc(
    getStudentsUseCase: sl(),
    activateStudentUseCase: sl(),
  ));

  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      registerUseCase: sl(),
      logoutUseCase: sl(),
      getAccessTokenUseCase: sl(),
      refreshTokenUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => ClassBloc(
      getAllClassesUseCase: sl(),
      getClassByIdUseCase: sl(),
      getClassStudentsUseCase: sl(),
      createClassUseCase: sl(),
      updateClassUseCase: sl(),
      deleteClassUseCase: sl(),
      assignStaffUseCase: sl(),
      getUsersByRoleUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => RecitationBloc(
      logRecitationUseCase: sl(),
      getRecitationsByStudentUseCase: sl(),
      getRecitationsByClassUseCase: sl(),
    ),
  );

  sl.registerLazySingleton<AttendanceRemoteDataSource>(
    () => AttendanceRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<AttendanceRepository>(
    () => AttendanceRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetAttendanceByDateUseCase(sl()));
  sl.registerLazySingleton(() => GetAttendanceHistoryUseCase(sl()));
  sl.registerLazySingleton(() => GetAttendanceReportUseCase(sl()));
  sl.registerLazySingleton(() => RecordAttendanceUseCase(sl()));
  sl.registerLazySingleton(() => UpdateAttendanceUseCase(sl()));
  sl.registerFactory(
    () => AttendanceBloc(
      getAttendanceByDateUseCase: sl(),
      getAttendanceHistoryUseCase: sl(),
      getAttendanceReportUseCase: sl(),
      recordAttendanceUseCase: sl(),
      updateAttendanceUseCase: sl(),
    ),
  );
}
