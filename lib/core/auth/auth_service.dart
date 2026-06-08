import '../constants/api_constants.dart';

class AuthService {
  String? _role;

  String? get role => _role;
  bool get Admin => _role == RoleConstants.admin;
  bool get Teacher => _role == RoleConstants.teacher;
  bool get isSupervisor => _role == RoleConstants.supervisor;
  bool get canAccessStudents => Admin || Teacher;
  bool get canAccessAttendance =>   Teacher;
  bool get isPrivileged =>
      _role == RoleConstants.admin ||
      _role == RoleConstants.teacher ||
      _role == RoleConstants.supervisor;

  void setRole(String role) => _role = role;
  void clear() => _role = null;
}
