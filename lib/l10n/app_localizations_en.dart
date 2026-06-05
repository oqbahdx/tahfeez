// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Tahfeez';

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get pleaseSignIn =>
      'Please sign in to access your institutional dashboard.';

  @override
  String get emailAddress => 'Email Address';

  @override
  String get emailHint => 'admin@domain.com';

  @override
  String get password => 'Password';

  @override
  String get passwordHint => 'Enter your password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get signIn => 'Sign In';

  @override
  String get needHelp => 'Need help accessing your account?';

  @override
  String get contactAdministrator => 'Contact Administrator';

  @override
  String get secureAccess =>
      'Secure access for administrators, teachers, and staff.';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get overview => 'Overview';

  @override
  String get welcomeBackSubtitle =>
      'Welcome back, here is what\'s happening today.';

  @override
  String get totalStudents => 'Total Students';

  @override
  String get activeClasses => 'Active Classes';

  @override
  String get todaysAttendance => 'Today\'s Attendance';

  @override
  String get overdueSubscriptions => 'Overdue Subs.';

  @override
  String get thisMonth => 'this month';

  @override
  String get actionNeeded => 'Action needed';

  @override
  String get recentActivity => 'Recent Activity';

  @override
  String get viewAll => 'View All';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get markAttendance => 'Mark Attendance';

  @override
  String get addStudent => 'Add Student';

  @override
  String get scheduleExam => 'Schedule Exam';

  @override
  String get sendAnnouncement => 'Send Announcement';

  @override
  String get upcomingToday => 'Upcoming Today';

  @override
  String get completed => 'completed';

  @override
  String get revised => 'revised';

  @override
  String get missed => 'missed';

  @override
  String get excellent => 'Excellent';

  @override
  String get needsFollowUp => 'Needs Follow-up';

  @override
  String minutesAgo(String time) {
    return '$time min ago';
  }

  @override
  String hoursAgo(String time) {
    return '$time hrs ago';
  }

  @override
  String get classes => 'Classes';

  @override
  String get classesManagement => 'Classes Management';

  @override
  String get activeClassesSubtitle => 'Manage and monitor all ongoing sessions';

  @override
  String get searchClasses => 'Search classes...';

  @override
  String get filter => 'Filter';

  @override
  String get addClass => 'Add Class';

  @override
  String get addClassTitle => 'Add Class';

  @override
  String get className => 'Class Name';

  @override
  String get classType => 'Class Type';

  @override
  String get classMode => 'Class Mode';

  @override
  String get nameRequired => 'Please enter a class name';

  @override
  String get typeRequired => 'Please select a class type';

  @override
  String get modeRequired => 'Please select a class mode';

  @override
  String get submit => 'Submit';

  @override
  String get classCreated => 'Class created successfully!';

  @override
  String get classDeleted => 'Class deleted successfully!';

  @override
  String get retry => 'Retry';

  @override
  String get noClassesFound => 'No classes found';

  @override
  String get noClassesFoundSubtitle =>
      'No classes yet. Tap + to add your first class.';

  @override
  String get addClassSubtitle => 'Create a new class';

  @override
  String get classNameHint => 'e.g. Quran Class A';

  @override
  String get classTypePlaceholder => 'Select type';

  @override
  String get classModePlaceholder => 'Select mode';

  @override
  String get submitting => 'Submitting...';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get invalidEmail => 'Enter a valid email address';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get usernameRequired => 'Username is required';

  @override
  String get usernameMinLength => 'Username must be at least 3 characters';

  @override
  String get usernameInvalidChars =>
      'Username can only contain letters, numbers, and underscores';

  @override
  String get fullNameRequired => 'Full name is required';

  @override
  String get fullNameMinLength => 'Full name must be at least 2 characters';

  @override
  String get passwordComplexity =>
      'Password must be 8+ chars with uppercase, lowercase, and a special character';

  @override
  String get confirmPasswordRequired => 'Confirm password is required';

  @override
  String get failedToLoadClasses => 'Failed to load classes';

  @override
  String get failedToLoadStudents => 'Failed to load students';

  @override
  String get checkConnectionAndRetry => 'Check your connection and try again.';

  @override
  String get classNameTooLong => 'Class name is too long';

  @override
  String get manageStaffPayroll => 'Manage staff payroll and payments.';

  @override
  String get forOctober2023 => 'For October 2023';

  @override
  String staffMembersCount(Object count) {
    return '$count Staff Members';
  }

  @override
  String studentsListCount(int count) {
    return '$count Students';
  }

  @override
  String classesCount(int count) {
    return '$count classes';
  }

  @override
  String get delete => 'Delete';

  @override
  String get deleteClass => 'Delete Class';

  @override
  String deleteClassConfirmation(String name) {
    return 'Are you sure you want to delete $name?';
  }

  @override
  String get students => 'Students';

  @override
  String get searchStudents => 'Search students...';

  @override
  String get allStudents => 'All Students';

  @override
  String get addStudentBtn => 'Add Student';

  @override
  String get noStudentsFound => 'No students found';

  @override
  String get pending => 'Pending';

  @override
  String joinedDate(String date) {
    return 'Joined $date';
  }

  @override
  String get reports => 'Reports';

  @override
  String get settings => 'Settings';

  @override
  String get institution => 'Institution';

  @override
  String get academicYear => 'Academic Year';

  @override
  String get curriculum => 'Curriculum';

  @override
  String get staffDirectory => 'Staff Directory';

  @override
  String get locationBranches => 'Location & Branches';

  @override
  String get notifications => 'Notifications';

  @override
  String get pushNotifications => 'Push Notifications';

  @override
  String get pushNotificationsSubtitle => 'Attendance, recitation alerts';

  @override
  String get emailAlerts => 'Email Alerts';

  @override
  String get emailAlertsSubtitle => 'Daily summary & overdue notices';

  @override
  String get appearance => 'Appearance';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get darkModeSubtitle => 'Switch to dark theme';

  @override
  String get language => 'Language';

  @override
  String get support => 'Support';

  @override
  String get helpSupport => 'Help & Support';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get aboutTahfeez => 'About Tahfeez';

  @override
  String get signOut => 'Sign Out';

  @override
  String get administrator => 'Administrator';

  @override
  String get superAdmin => 'Super Admin';

  @override
  String get edit => 'Edit';

  @override
  String get classDetails => 'Class Details';

  @override
  String get typeRecitation => 'Type: Recitation';

  @override
  String get modeInPerson => 'Mode: In-Person';

  @override
  String get levelAdvanced => 'Advanced';

  @override
  String get assignedStaff => 'Assigned Staff';

  @override
  String get primaryTeacher => 'Primary Teacher';

  @override
  String get assistant => 'Assistant';

  @override
  String get supervisor => 'Supervisor';

  @override
  String get assignStaff => 'Assign Staff';

  @override
  String studentsTab(int count) {
    return 'Students ($count)';
  }

  @override
  String get attendance => 'Attendance';

  @override
  String get progress => 'Progress';

  @override
  String get viewAllStudents => 'View All Students';

  @override
  String get openAttendance => 'Open Attendance';

  @override
  String get progressChartsComingSoon => 'Progress charts coming soon';

  @override
  String get recordAttendance => 'Record Attendance';

  @override
  String get selectDate => 'Select Date';

  @override
  String get selectClass => 'Select Class';

  @override
  String get present => 'Present';

  @override
  String get absent => 'Absent';

  @override
  String get excused => 'Excused';

  @override
  String get submitAttendance => 'Submit Attendance';

  @override
  String get attendanceSubmitted => 'Attendance submitted successfully!';

  @override
  String get student => 'Student';

  @override
  String get presentCount => 'Present';

  @override
  String get absentCount => 'Absent';

  @override
  String get attendanceRate => 'Rate';

  @override
  String get studentSummary => 'Student Summary';

  @override
  String get export => 'Export';

  @override
  String get subscriptions => 'Subscriptions';

  @override
  String get salaries => 'Salaries';

  @override
  String get collectedThisMonth => 'Collected This Month';

  @override
  String get overdueTotal => 'Overdue Total';

  @override
  String get activeSubscriptions => 'Active Subscriptions';

  @override
  String get allRecords => 'All Records';

  @override
  String get active => 'Active';

  @override
  String get overdue => 'Overdue';

  @override
  String get daysLate => 'Days Late';

  @override
  String get amount => 'Amount';

  @override
  String get typeMode => 'Type & Mode';

  @override
  String get dueDate => 'Due Date';

  @override
  String get salariesTab => 'Salaries';

  @override
  String get totalPayroll => 'Total Payroll';

  @override
  String get paid => 'Paid';

  @override
  String get unpaid => 'Unpaid';

  @override
  String get staffMembers => 'Staff Members';

  @override
  String get staffMember => 'Staff Member';

  @override
  String get role => 'Role';

  @override
  String get status => 'Status';

  @override
  String get logRecitation => 'Log Recitation';

  @override
  String get logRecitationSubtitle =>
      'Record a student\'s memorization progress.';

  @override
  String get selectStudent => 'Select a student...';

  @override
  String get teacher => 'Teacher';

  @override
  String get date => 'Date';

  @override
  String get surah => 'Surah';

  @override
  String get recitationType => 'Recitation Type';

  @override
  String get newHifdh => 'New (Hifdh)';

  @override
  String get reviewMurajaah => 'Review (Muraja\'ah)';

  @override
  String get fromAyah => 'From Ayah';

  @override
  String get toAyah => 'To Ayah';

  @override
  String get qualityGrade => 'Quality Grade';

  @override
  String get needsWork => 'Needs Work';

  @override
  String get perfect => 'Perfect';

  @override
  String get observationsNotes => 'Observations & Notes';

  @override
  String get observationsHint =>
      'Add notes on pronunciation, tajweed rules, or areas for improvement...';

  @override
  String get cancel => 'Cancel';

  @override
  String get saveLog => 'Save Log';

  @override
  String get recitationLogSaved => 'Recitation log saved!';

  @override
  String get recitationHistory => 'Recitation History';

  @override
  String get monthlyProgress => 'Monthly Progress';

  @override
  String get sessions => 'Sessions';

  @override
  String get excellentGrade => 'Excellent';

  @override
  String get moreFilters => 'More Filters';

  @override
  String get newLessonSabaq => 'New Lesson (Sabaq)';

  @override
  String get recentRevisionSabaqi => 'Recent Revision (Sabaqi)';

  @override
  String get oldRevisionManzil => 'Old Revision (Manzil)';

  @override
  String get gradeGood => 'Good';

  @override
  String get gradeNeedsWork => 'Needs Work';

  @override
  String get hijriDate => 'Hijri: 14 Safar 1446';

  @override
  String get thisMonthBadge => '+12 this month';

  @override
  String get hijriDateShort => '12 Safar 1445';

  @override
  String get filterChipsAll => 'All';

  @override
  String get filterChipsExcellent => 'Excellent';

  @override
  String get filterChipsGood => 'Good';

  @override
  String get filterChipsNeedsWork => 'Needs Work';

  @override
  String studentsCount(int count) {
    return '$count students';
  }

  @override
  String get viewHistory => 'View History';

  @override
  String get attendanceReport => 'Attendance Report';

  @override
  String get attendanceReportSubtitle =>
      'Review and manage student attendance records.';

  @override
  String get dateRange => 'Date Range';

  @override
  String get idLabel => 'ID:';

  @override
  String get subscriptionsSubtitle => 'Manage student payments and dues.';

  @override
  String get parentLabel => 'Parent:';

  @override
  String get curriculumSubtitle => 'Manage syllabi & programs';

  @override
  String staffCount(int count) {
    return '$count active staff members';
  }

  @override
  String get locationValue => 'Cairo Main Campus';

  @override
  String get version => 'v1.0.4';

  @override
  String get tagline =>
      'Sacred tradition meets modern management. Streamlining Quranic education for institutions.';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageArabic => 'العربية';

  @override
  String get hifzRevisionAdvanced => 'Hifz Revision - Advanced';

  @override
  String get tajweedBasicsBeginners => 'Tajweed Basics - Beginners';

  @override
  String get createNewAccount => 'Create New Account';

  @override
  String get createAccount => 'Create Account';

  @override
  String get joinInstitution => 'Join the institution to start learning.';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get username => 'Username';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters';

  @override
  String get registrationSuccessful => 'Registration successful! Please login.';

  @override
  String get selectRole => 'Select Role';

  @override
  String get roleStudent => 'Student';

  @override
  String get roleTeacher => 'Teacher';

  @override
  String get roleAssistant => 'Assistant';

  @override
  String get roleSupervisor => 'Supervisor';

  @override
  String get roleAccountant => 'Accountant';

  @override
  String get roleAdmin => 'Admin';

  @override
  String get fullName => 'Full Name';

  @override
  String get passwordStrengthWeak => 'Weak';

  @override
  String get passwordStrengthFair => 'Fair';

  @override
  String get passwordStrengthGood => 'Good';

  @override
  String get passwordStrengthStrong => 'Strong';

  @override
  String get passwordRuleMinLength => '8+ chars';

  @override
  String get passwordRuleUppercase => 'Uppercase';

  @override
  String get passwordRuleLowercase => 'Lowercase';

  @override
  String get passwordRuleSpecialChar => 'Special char';

  @override
  String get roleParent => 'Parent';

  @override
  String get ayahsCount => 'Number of Ayahs';

  @override
  String ayahsCountText(int count) {
    return '$count ayahs';
  }

  @override
  String get noRecitationsFound => 'No recitations found';

  @override
  String get noRecitationsFoundSubtitle => 'Start by logging a recitation.';

  @override
  String get failedToLoadRecitations => 'Failed to load recitations';

  @override
  String get ayahsRequired => 'Number of ayahs is required';

  @override
  String get ayahsInvalid => 'Please enter a valid number of ayahs';

  @override
  String get teacherRequired => 'Teacher information is required';

  @override
  String get activate => 'Activate';

  @override
  String get activateStudentConfirm => 'Activate this student?';

  @override
  String get activateStudentConfirmSubtitle =>
      'This will grant the student access to the system.';
}
