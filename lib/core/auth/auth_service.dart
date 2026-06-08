import '../constants/api_constants.dart';

class AuthService {
  String? _role;

  String? get role => _role;
  bool get isAdmin => _role == RoleConstants.admin;
  bool get isTeacher => _role == RoleConstants.teacher;
  bool get isSupervisor => _role == RoleConstants.supervisor;
  bool get canAccessStudents => isAdmin || isTeacher;
  bool get canAccessAttendance => isAdmin || isTeacher;
  bool get isPrivileged =>
      _role == RoleConstants.admin ||
      _role == RoleConstants.teacher ||
      _role == RoleConstants.supervisor;

  void setRole(String role) => _role = role;
  void clear() => _role = null;
}
