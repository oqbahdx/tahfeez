class ApiConstants {
  static const String baseUrl = 'https://alamin.gleeze.com';
  static const String authEndpoint = '/connect/token';
  static const String registerEndpoint = '/api/auth/register';
  static const String usersEndpoint = '/api/users';
  static const String studentsEndpoint = '/api/students';
  static const String classesEndpoint = '/api/classes';
  static const String recitationsEndpoint = '/api/recitations';
  static const String salariesEndpoint = '/api/salaries';
  static const String subscriptionsEndpoint = '/api/subscriptions';
  static const String attendanceEndpoint = '/api/attendance';

  static String assignClassEndpoint(String studentId) =>
    '/api/Students/$studentId/assign-class';
}

class RoleConstants {
  static const String admin = 'Admin';
  static const String teacher = 'Teacher';
  static const String student = 'Student';
  static const String parent = 'Parent';
  static const String accountant = 'Accountant';
  static const String supervisor = 'Supervisor';
  static const String assistant = 'Assistant';

  /// Order matches the server enum: Admin=1, Teacher=2, Student=3,
  /// Parent=4, Accountant=5, Supervisor=6, Assistant=7
  static const List<String> allRoles = [
    admin,
    teacher,
    student,
    parent,
    accountant,
    supervisor,
    assistant,
  ];
}

class ClassTypeConstants {
  static const String quran = 'Quran';
  static const String hadeeth = 'Hadeeth';
  static const String language = 'Language';

  static const List<String> all = [quran, hadeeth, language];
}

class ClassModeConstants {
  static const String online = 'Online';
  static const String offline = 'Offline';
  static const String hybrid = 'Hybrid';

  static const List<String> all = [online, offline, hybrid];
}

class RecitationTypeConstants {
  static const String memorization = 'Memorization';
  static const String review = 'Review';
  static const String tajweed = 'Tajweed';

  static const List<String> all = [memorization, review, tajweed];
}

class AttendanceStatusConstants {
  static const String present = 'Present';
  static const String absent = 'Absent';
  static const String late = 'Late';
  static const String excused = 'Excused';

  static const List<String> all = [present, absent, late, excused];
}

class SubscriptionTypeConstants {
  static const String monthly = 'Monthly';
  static const String quarterly = 'Quarterly';
  static const String yearly = 'Yearly';

  static const List<String> all = [monthly, quarterly, yearly];
}

class PaymentMethodConstants {
  static const String cash = 'Cash';
  static const String card = 'Card';
  static const String bankTransfer = 'BankTransfer';

  static const List<String> all = [cash, card, bankTransfer];
}

class SalaryStatusConstants {
  static const String pending = 'Pending';
  static const String paid = 'Paid';
}
