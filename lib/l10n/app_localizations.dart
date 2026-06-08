import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Tahfeez'**
  String get appTitle;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @pleaseSignIn.
  ///
  /// In en, this message translates to:
  /// **'Please sign in to access your institutional dashboard.'**
  String get pleaseSignIn;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'admin@domain.com'**
  String get emailHint;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get passwordHint;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @needHelp.
  ///
  /// In en, this message translates to:
  /// **'Need help accessing your account?'**
  String get needHelp;

  /// No description provided for @contactAdministrator.
  ///
  /// In en, this message translates to:
  /// **'Contact Administrator'**
  String get contactAdministrator;

  /// No description provided for @secureAccess.
  ///
  /// In en, this message translates to:
  /// **'Secure access for administrators, teachers, and staff.'**
  String get secureAccess;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @welcomeBackSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, here is what\'s happening today.'**
  String get welcomeBackSubtitle;

  /// No description provided for @totalStudents.
  ///
  /// In en, this message translates to:
  /// **'Total Students'**
  String get totalStudents;

  /// No description provided for @activeClasses.
  ///
  /// In en, this message translates to:
  /// **'Active Classes'**
  String get activeClasses;

  /// No description provided for @todaysAttendance.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Attendance'**
  String get todaysAttendance;

  /// No description provided for @overdueSubscriptions.
  ///
  /// In en, this message translates to:
  /// **'Overdue Subs.'**
  String get overdueSubscriptions;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'this month'**
  String get thisMonth;

  /// No description provided for @actionNeeded.
  ///
  /// In en, this message translates to:
  /// **'Action needed'**
  String get actionNeeded;

  /// No description provided for @recentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get recentActivity;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @markAttendance.
  ///
  /// In en, this message translates to:
  /// **'Mark Attendance'**
  String get markAttendance;

  /// No description provided for @addStudent.
  ///
  /// In en, this message translates to:
  /// **'Add Student'**
  String get addStudent;

  /// No description provided for @scheduleExam.
  ///
  /// In en, this message translates to:
  /// **'Schedule Exam'**
  String get scheduleExam;

  /// No description provided for @sendAnnouncement.
  ///
  /// In en, this message translates to:
  /// **'Send Announcement'**
  String get sendAnnouncement;

  /// No description provided for @upcomingToday.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Today'**
  String get upcomingToday;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'completed'**
  String get completed;

  /// No description provided for @revised.
  ///
  /// In en, this message translates to:
  /// **'revised'**
  String get revised;

  /// No description provided for @missed.
  ///
  /// In en, this message translates to:
  /// **'missed'**
  String get missed;

  /// No description provided for @excellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get excellent;

  /// No description provided for @needsFollowUp.
  ///
  /// In en, this message translates to:
  /// **'Needs Follow-up'**
  String get needsFollowUp;

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{time} min ago'**
  String minutesAgo(String time);

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{time} hrs ago'**
  String hoursAgo(String time);

  /// No description provided for @classes.
  ///
  /// In en, this message translates to:
  /// **'Classes'**
  String get classes;

  /// No description provided for @classesManagement.
  ///
  /// In en, this message translates to:
  /// **'Classes Management'**
  String get classesManagement;

  /// No description provided for @activeClassesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage and monitor all ongoing sessions'**
  String get activeClassesSubtitle;

  /// No description provided for @searchClasses.
  ///
  /// In en, this message translates to:
  /// **'Search classes...'**
  String get searchClasses;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @addClass.
  ///
  /// In en, this message translates to:
  /// **'Add Class'**
  String get addClass;

  /// No description provided for @addClassTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Class'**
  String get addClassTitle;

  /// No description provided for @className.
  ///
  /// In en, this message translates to:
  /// **'Class Name'**
  String get className;

  /// No description provided for @classType.
  ///
  /// In en, this message translates to:
  /// **'Class Type'**
  String get classType;

  /// No description provided for @classMode.
  ///
  /// In en, this message translates to:
  /// **'Class Mode'**
  String get classMode;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a class name'**
  String get nameRequired;

  /// No description provided for @typeRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select a class type'**
  String get typeRequired;

  /// No description provided for @modeRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select a class mode'**
  String get modeRequired;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @classCreated.
  ///
  /// In en, this message translates to:
  /// **'Class created successfully!'**
  String get classCreated;

  /// No description provided for @classDeleted.
  ///
  /// In en, this message translates to:
  /// **'Class deleted successfully!'**
  String get classDeleted;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @noClassesFound.
  ///
  /// In en, this message translates to:
  /// **'No classes found'**
  String get noClassesFound;

  /// No description provided for @noClassesFoundSubtitle.
  ///
  /// In en, this message translates to:
  /// **'No classes yet. Tap + to add your first class.'**
  String get noClassesFoundSubtitle;

  /// No description provided for @addClassSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create a new class'**
  String get addClassSubtitle;

  /// No description provided for @classNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Quran Class A'**
  String get classNameHint;

  /// No description provided for @classTypePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Select type'**
  String get classTypePlaceholder;

  /// No description provided for @classModePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Select mode'**
  String get classModePlaceholder;

  /// No description provided for @submitting.
  ///
  /// In en, this message translates to:
  /// **'Submitting...'**
  String get submitting;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get invalidEmail;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @usernameRequired.
  ///
  /// In en, this message translates to:
  /// **'Username is required'**
  String get usernameRequired;

  /// No description provided for @usernameMinLength.
  ///
  /// In en, this message translates to:
  /// **'Username must be at least 3 characters'**
  String get usernameMinLength;

  /// No description provided for @usernameInvalidChars.
  ///
  /// In en, this message translates to:
  /// **'Username can only contain letters, numbers, and underscores'**
  String get usernameInvalidChars;

  /// No description provided for @fullNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Full name is required'**
  String get fullNameRequired;

  /// No description provided for @fullNameMinLength.
  ///
  /// In en, this message translates to:
  /// **'Full name must be at least 2 characters'**
  String get fullNameMinLength;

  /// No description provided for @passwordComplexity.
  ///
  /// In en, this message translates to:
  /// **'Password must be 8+ chars with uppercase, lowercase, and a special character'**
  String get passwordComplexity;

  /// No description provided for @confirmPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Confirm password is required'**
  String get confirmPasswordRequired;

  /// No description provided for @failedToLoadClasses.
  ///
  /// In en, this message translates to:
  /// **'Failed to load classes'**
  String get failedToLoadClasses;

  /// No description provided for @failedToLoadStudents.
  ///
  /// In en, this message translates to:
  /// **'Failed to load students'**
  String get failedToLoadStudents;

  /// No description provided for @checkConnectionAndRetry.
  ///
  /// In en, this message translates to:
  /// **'Check your connection and try again.'**
  String get checkConnectionAndRetry;

  /// No description provided for @classNameTooLong.
  ///
  /// In en, this message translates to:
  /// **'Class name is too long'**
  String get classNameTooLong;

  /// No description provided for @manageStaffPayroll.
  ///
  /// In en, this message translates to:
  /// **'Manage staff payroll and payments.'**
  String get manageStaffPayroll;

  /// No description provided for @forOctober2023.
  ///
  /// In en, this message translates to:
  /// **'For October 2023'**
  String get forOctober2023;

  /// No description provided for @staffMembersCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Staff Members'**
  String staffMembersCount(Object count);

  /// No description provided for @studentsListCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Students'**
  String studentsListCount(int count);

  /// No description provided for @classesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} classes'**
  String classesCount(int count);

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteClass.
  ///
  /// In en, this message translates to:
  /// **'Delete Class'**
  String get deleteClass;

  /// No description provided for @deleteClassConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {name}?'**
  String deleteClassConfirmation(String name);

  /// No description provided for @students.
  ///
  /// In en, this message translates to:
  /// **'Students'**
  String get students;

  /// No description provided for @searchStudents.
  ///
  /// In en, this message translates to:
  /// **'Search students...'**
  String get searchStudents;

  /// No description provided for @allStudents.
  ///
  /// In en, this message translates to:
  /// **'All Students'**
  String get allStudents;

  /// No description provided for @addStudentBtn.
  ///
  /// In en, this message translates to:
  /// **'Add Student'**
  String get addStudentBtn;

  /// No description provided for @noStudentsFound.
  ///
  /// In en, this message translates to:
  /// **'No students found'**
  String get noStudentsFound;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @joinedDate.
  ///
  /// In en, this message translates to:
  /// **'Joined {date}'**
  String joinedDate(String date);

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @institution.
  ///
  /// In en, this message translates to:
  /// **'Institution'**
  String get institution;

  /// No description provided for @academicYear.
  ///
  /// In en, this message translates to:
  /// **'Academic Year'**
  String get academicYear;

  /// No description provided for @curriculum.
  ///
  /// In en, this message translates to:
  /// **'Curriculum'**
  String get curriculum;

  /// No description provided for @staffDirectory.
  ///
  /// In en, this message translates to:
  /// **'Staff Directory'**
  String get staffDirectory;

  /// No description provided for @locationBranches.
  ///
  /// In en, this message translates to:
  /// **'Location & Branches'**
  String get locationBranches;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @pushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get pushNotifications;

  /// No description provided for @pushNotificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Attendance, recitation alerts'**
  String get pushNotificationsSubtitle;

  /// No description provided for @emailAlerts.
  ///
  /// In en, this message translates to:
  /// **'Email Alerts'**
  String get emailAlerts;

  /// No description provided for @emailAlertsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Daily summary & overdue notices'**
  String get emailAlertsSubtitle;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @darkModeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Switch to dark theme'**
  String get darkModeSubtitle;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @aboutTahfeez.
  ///
  /// In en, this message translates to:
  /// **'About Tahfeez'**
  String get aboutTahfeez;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @administrator.
  ///
  /// In en, this message translates to:
  /// **'Administrator'**
  String get administrator;

  /// No description provided for @superAdmin.
  ///
  /// In en, this message translates to:
  /// **'Super Admin'**
  String get superAdmin;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @classDetails.
  ///
  /// In en, this message translates to:
  /// **'Class Details'**
  String get classDetails;

  /// No description provided for @classInfo.
  ///
  /// In en, this message translates to:
  /// **'Class Info'**
  String get classInfo;

  /// No description provided for @studentsList.
  ///
  /// In en, this message translates to:
  /// **'Students'**
  String get studentsList;

  /// No description provided for @noStudentsInClass.
  ///
  /// In en, this message translates to:
  /// **'No students enrolled in this class'**
  String get noStudentsInClass;

  /// No description provided for @typeRecitation.
  ///
  /// In en, this message translates to:
  /// **'Type: Recitation'**
  String get typeRecitation;

  /// No description provided for @modeInPerson.
  ///
  /// In en, this message translates to:
  /// **'Mode: In-Person'**
  String get modeInPerson;

  /// No description provided for @levelAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get levelAdvanced;

  /// No description provided for @assignedStaff.
  ///
  /// In en, this message translates to:
  /// **'Assigned Staff'**
  String get assignedStaff;

  /// No description provided for @primaryTeacher.
  ///
  /// In en, this message translates to:
  /// **'Primary Teacher'**
  String get primaryTeacher;

  /// No description provided for @assistant.
  ///
  /// In en, this message translates to:
  /// **'Assistant'**
  String get assistant;

  /// No description provided for @supervisor.
  ///
  /// In en, this message translates to:
  /// **'Supervisor'**
  String get supervisor;

  /// No description provided for @assignStaff.
  ///
  /// In en, this message translates to:
  /// **'Assign Staff'**
  String get assignStaff;

  /// No description provided for @studentsTab.
  ///
  /// In en, this message translates to:
  /// **'Students ({count})'**
  String studentsTab(int count);

  /// No description provided for @attendance.
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get attendance;

  /// No description provided for @progress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progress;

  /// No description provided for @viewAllStudents.
  ///
  /// In en, this message translates to:
  /// **'View All Students'**
  String get viewAllStudents;

  /// No description provided for @openAttendance.
  ///
  /// In en, this message translates to:
  /// **'Open Attendance'**
  String get openAttendance;

  /// No description provided for @progressChartsComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Progress charts coming soon'**
  String get progressChartsComingSoon;

  /// No description provided for @recordAttendance.
  ///
  /// In en, this message translates to:
  /// **'Record Attendance'**
  String get recordAttendance;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// No description provided for @selectClass.
  ///
  /// In en, this message translates to:
  /// **'Select Class'**
  String get selectClass;

  /// No description provided for @present.
  ///
  /// In en, this message translates to:
  /// **'Present'**
  String get present;

  /// No description provided for @absent.
  ///
  /// In en, this message translates to:
  /// **'Absent'**
  String get absent;

  /// No description provided for @excused.
  ///
  /// In en, this message translates to:
  /// **'Excused'**
  String get excused;

  /// No description provided for @late.
  ///
  /// In en, this message translates to:
  /// **'Late'**
  String get late;

  /// No description provided for @submitAttendance.
  ///
  /// In en, this message translates to:
  /// **'Submit Attendance'**
  String get submitAttendance;

  /// No description provided for @attendanceSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Attendance submitted successfully!'**
  String get attendanceSubmitted;

  /// No description provided for @student.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get student;

  /// No description provided for @presentCount.
  ///
  /// In en, this message translates to:
  /// **'Present'**
  String get presentCount;

  /// No description provided for @absentCount.
  ///
  /// In en, this message translates to:
  /// **'Absent'**
  String get absentCount;

  /// No description provided for @attendanceRate.
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get attendanceRate;

  /// No description provided for @studentSummary.
  ///
  /// In en, this message translates to:
  /// **'Student Summary'**
  String get studentSummary;

  /// No description provided for @export.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get export;

  /// No description provided for @subscriptions.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions'**
  String get subscriptions;

  /// No description provided for @salaries.
  ///
  /// In en, this message translates to:
  /// **'Salaries'**
  String get salaries;

  /// No description provided for @collectedThisMonth.
  ///
  /// In en, this message translates to:
  /// **'Collected This Month'**
  String get collectedThisMonth;

  /// No description provided for @overdueTotal.
  ///
  /// In en, this message translates to:
  /// **'Overdue Total'**
  String get overdueTotal;

  /// No description provided for @activeSubscriptions.
  ///
  /// In en, this message translates to:
  /// **'Active Subscriptions'**
  String get activeSubscriptions;

  /// No description provided for @allRecords.
  ///
  /// In en, this message translates to:
  /// **'All Records'**
  String get allRecords;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @overdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get overdue;

  /// No description provided for @daysLate.
  ///
  /// In en, this message translates to:
  /// **'Days Late'**
  String get daysLate;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @typeMode.
  ///
  /// In en, this message translates to:
  /// **'Type & Mode'**
  String get typeMode;

  /// No description provided for @dueDate.
  ///
  /// In en, this message translates to:
  /// **'Due Date'**
  String get dueDate;

  /// No description provided for @salariesTab.
  ///
  /// In en, this message translates to:
  /// **'Salaries'**
  String get salariesTab;

  /// No description provided for @totalPayroll.
  ///
  /// In en, this message translates to:
  /// **'Total Payroll'**
  String get totalPayroll;

  /// No description provided for @paid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paid;

  /// No description provided for @unpaid.
  ///
  /// In en, this message translates to:
  /// **'Unpaid'**
  String get unpaid;

  /// No description provided for @staffMembers.
  ///
  /// In en, this message translates to:
  /// **'Staff Members'**
  String get staffMembers;

  /// No description provided for @staffMember.
  ///
  /// In en, this message translates to:
  /// **'Staff Member'**
  String get staffMember;

  /// No description provided for @role.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @logRecitation.
  ///
  /// In en, this message translates to:
  /// **'Log Recitation'**
  String get logRecitation;

  /// No description provided for @logRecitationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Record a student\'s memorization progress.'**
  String get logRecitationSubtitle;

  /// No description provided for @selectStudent.
  ///
  /// In en, this message translates to:
  /// **'Select a student...'**
  String get selectStudent;

  /// No description provided for @teacher.
  ///
  /// In en, this message translates to:
  /// **'Teacher'**
  String get teacher;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @surah.
  ///
  /// In en, this message translates to:
  /// **'Surah'**
  String get surah;

  /// No description provided for @recitationType.
  ///
  /// In en, this message translates to:
  /// **'Recitation Type'**
  String get recitationType;

  /// No description provided for @newHifdh.
  ///
  /// In en, this message translates to:
  /// **'New (Hifdh)'**
  String get newHifdh;

  /// No description provided for @reviewMurajaah.
  ///
  /// In en, this message translates to:
  /// **'Review (Muraja\'ah)'**
  String get reviewMurajaah;

  /// No description provided for @fromAyah.
  ///
  /// In en, this message translates to:
  /// **'From Ayah'**
  String get fromAyah;

  /// No description provided for @toAyah.
  ///
  /// In en, this message translates to:
  /// **'To Ayah'**
  String get toAyah;

  /// No description provided for @qualityGrade.
  ///
  /// In en, this message translates to:
  /// **'Quality Grade'**
  String get qualityGrade;

  /// No description provided for @needsWork.
  ///
  /// In en, this message translates to:
  /// **'Needs Work'**
  String get needsWork;

  /// No description provided for @perfect.
  ///
  /// In en, this message translates to:
  /// **'Perfect'**
  String get perfect;

  /// No description provided for @observationsNotes.
  ///
  /// In en, this message translates to:
  /// **'Observations & Notes'**
  String get observationsNotes;

  /// No description provided for @observationsHint.
  ///
  /// In en, this message translates to:
  /// **'Add notes on pronunciation, tajweed rules, or areas for improvement...'**
  String get observationsHint;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @saveLog.
  ///
  /// In en, this message translates to:
  /// **'Save Log'**
  String get saveLog;

  /// No description provided for @recitationLogSaved.
  ///
  /// In en, this message translates to:
  /// **'Recitation log saved!'**
  String get recitationLogSaved;

  /// No description provided for @recitationHistory.
  ///
  /// In en, this message translates to:
  /// **'Recitation History'**
  String get recitationHistory;

  /// No description provided for @monthlyProgress.
  ///
  /// In en, this message translates to:
  /// **'Monthly Progress'**
  String get monthlyProgress;

  /// No description provided for @sessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get sessions;

  /// No description provided for @excellentGrade.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get excellentGrade;

  /// No description provided for @moreFilters.
  ///
  /// In en, this message translates to:
  /// **'More Filters'**
  String get moreFilters;

  /// No description provided for @newLessonSabaq.
  ///
  /// In en, this message translates to:
  /// **'New Lesson (Sabaq)'**
  String get newLessonSabaq;

  /// No description provided for @recentRevisionSabaqi.
  ///
  /// In en, this message translates to:
  /// **'Recent Revision (Sabaqi)'**
  String get recentRevisionSabaqi;

  /// No description provided for @oldRevisionManzil.
  ///
  /// In en, this message translates to:
  /// **'Old Revision (Manzil)'**
  String get oldRevisionManzil;

  /// No description provided for @gradeGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get gradeGood;

  /// No description provided for @gradeNeedsWork.
  ///
  /// In en, this message translates to:
  /// **'Needs Work'**
  String get gradeNeedsWork;

  /// No description provided for @hijriDate.
  ///
  /// In en, this message translates to:
  /// **'Hijri: 14 Safar 1446'**
  String get hijriDate;

  /// No description provided for @thisMonthBadge.
  ///
  /// In en, this message translates to:
  /// **'+12 this month'**
  String get thisMonthBadge;

  /// No description provided for @hijriDateShort.
  ///
  /// In en, this message translates to:
  /// **'12 Safar 1445'**
  String get hijriDateShort;

  /// No description provided for @filterChipsAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterChipsAll;

  /// No description provided for @filterChipsExcellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get filterChipsExcellent;

  /// No description provided for @filterChipsGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get filterChipsGood;

  /// No description provided for @filterChipsNeedsWork.
  ///
  /// In en, this message translates to:
  /// **'Needs Work'**
  String get filterChipsNeedsWork;

  /// No description provided for @studentsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} students'**
  String studentsCount(int count);

  /// No description provided for @viewHistory.
  ///
  /// In en, this message translates to:
  /// **'View History'**
  String get viewHistory;

  /// No description provided for @attendanceReport.
  ///
  /// In en, this message translates to:
  /// **'Attendance Report'**
  String get attendanceReport;

  /// No description provided for @attendanceReportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Review and manage student attendance records.'**
  String get attendanceReportSubtitle;

  /// No description provided for @attendanceHistory.
  ///
  /// In en, this message translates to:
  /// **'Attendance History'**
  String get attendanceHistory;

  /// No description provided for @addAttendanceRecord.
  ///
  /// In en, this message translates to:
  /// **'Add Attendance Record'**
  String get addAttendanceRecord;

  /// No description provided for @addAttendance.
  ///
  /// In en, this message translates to:
  /// **'Add Attendance'**
  String get addAttendance;

  /// No description provided for @noAttendanceHistory.
  ///
  /// In en, this message translates to:
  /// **'No attendance history'**
  String get noAttendanceHistory;

  /// No description provided for @noAttendanceRecordsForUser.
  ///
  /// In en, this message translates to:
  /// **'No attendance records found for this user.'**
  String get noAttendanceRecordsForUser;

  /// No description provided for @attendancePercent.
  ///
  /// In en, this message translates to:
  /// **'Attendance %'**
  String get attendancePercent;

  /// No description provided for @timeline.
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get timeline;

  /// No description provided for @notesOptional.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get notesOptional;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving;

  /// No description provided for @noAttendanceRecordsForDate.
  ///
  /// In en, this message translates to:
  /// **'No attendance records for this date.'**
  String get noAttendanceRecordsForDate;

  /// No description provided for @dateCannotBeFuture.
  ///
  /// In en, this message translates to:
  /// **'Date cannot be in the future'**
  String get dateCannotBeFuture;

  /// No description provided for @noStudentsToSave.
  ///
  /// In en, this message translates to:
  /// **'No students to save'**
  String get noStudentsToSave;

  /// No description provided for @noAttendanceRecordsToSave.
  ///
  /// In en, this message translates to:
  /// **'No attendance records to save'**
  String get noAttendanceRecordsToSave;

  /// No description provided for @dateRange.
  ///
  /// In en, this message translates to:
  /// **'Date Range'**
  String get dateRange;

  /// No description provided for @idLabel.
  ///
  /// In en, this message translates to:
  /// **'ID:'**
  String get idLabel;

  /// No description provided for @subscriptionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage student payments and dues.'**
  String get subscriptionsSubtitle;

  /// No description provided for @parentLabel.
  ///
  /// In en, this message translates to:
  /// **'Parent:'**
  String get parentLabel;

  /// No description provided for @curriculumSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage syllabi & programs'**
  String get curriculumSubtitle;

  /// No description provided for @staffCount.
  ///
  /// In en, this message translates to:
  /// **'{count} active staff members'**
  String staffCount(int count);

  /// No description provided for @locationValue.
  ///
  /// In en, this message translates to:
  /// **'Cairo Main Campus'**
  String get locationValue;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'v1.0.4'**
  String get version;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Sacred tradition meets modern management. Streamlining Quranic education for institutions.'**
  String get tagline;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageArabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get languageArabic;

  /// No description provided for @hifzRevisionAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Hifz Revision - Advanced'**
  String get hifzRevisionAdvanced;

  /// No description provided for @tajweedBasicsBeginners.
  ///
  /// In en, this message translates to:
  /// **'Tajweed Basics - Beginners'**
  String get tajweedBasicsBeginners;

  /// No description provided for @createNewAccount.
  ///
  /// In en, this message translates to:
  /// **'Create New Account'**
  String get createNewAccount;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @joinInstitution.
  ///
  /// In en, this message translates to:
  /// **'Join the institution to start learning.'**
  String get joinInstitution;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// No description provided for @registrationSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Registration successful! Please login.'**
  String get registrationSuccessful;

  /// No description provided for @selectRole.
  ///
  /// In en, this message translates to:
  /// **'Select Role'**
  String get selectRole;

  /// No description provided for @roleStudent.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get roleStudent;

  /// No description provided for @roleTeacher.
  ///
  /// In en, this message translates to:
  /// **'Teacher'**
  String get roleTeacher;

  /// No description provided for @roleAssistant.
  ///
  /// In en, this message translates to:
  /// **'Assistant'**
  String get roleAssistant;

  /// No description provided for @roleSupervisor.
  ///
  /// In en, this message translates to:
  /// **'Supervisor'**
  String get roleSupervisor;

  /// No description provided for @roleAccountant.
  ///
  /// In en, this message translates to:
  /// **'Accountant'**
  String get roleAccountant;

  /// No description provided for @roleAdmin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get roleAdmin;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @passwordStrengthWeak.
  ///
  /// In en, this message translates to:
  /// **'Weak'**
  String get passwordStrengthWeak;

  /// No description provided for @passwordStrengthFair.
  ///
  /// In en, this message translates to:
  /// **'Fair'**
  String get passwordStrengthFair;

  /// No description provided for @passwordStrengthGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get passwordStrengthGood;

  /// No description provided for @passwordStrengthStrong.
  ///
  /// In en, this message translates to:
  /// **'Strong'**
  String get passwordStrengthStrong;

  /// No description provided for @passwordRuleMinLength.
  ///
  /// In en, this message translates to:
  /// **'8+ chars'**
  String get passwordRuleMinLength;

  /// No description provided for @passwordRuleUppercase.
  ///
  /// In en, this message translates to:
  /// **'Uppercase'**
  String get passwordRuleUppercase;

  /// No description provided for @passwordRuleLowercase.
  ///
  /// In en, this message translates to:
  /// **'Lowercase'**
  String get passwordRuleLowercase;

  /// No description provided for @passwordRuleSpecialChar.
  ///
  /// In en, this message translates to:
  /// **'Special char'**
  String get passwordRuleSpecialChar;

  /// No description provided for @roleParent.
  ///
  /// In en, this message translates to:
  /// **'Parent'**
  String get roleParent;

  /// No description provided for @ayahsCount.
  ///
  /// In en, this message translates to:
  /// **'Number of Ayahs'**
  String get ayahsCount;

  /// No description provided for @ayahsCountText.
  ///
  /// In en, this message translates to:
  /// **'{count} ayahs'**
  String ayahsCountText(int count);

  /// No description provided for @noRecitationsFound.
  ///
  /// In en, this message translates to:
  /// **'No recitations found'**
  String get noRecitationsFound;

  /// No description provided for @noRecitationsFoundSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start by logging a recitation.'**
  String get noRecitationsFoundSubtitle;

  /// No description provided for @failedToLoadRecitations.
  ///
  /// In en, this message translates to:
  /// **'Failed to load recitations'**
  String get failedToLoadRecitations;

  /// No description provided for @ayahsRequired.
  ///
  /// In en, this message translates to:
  /// **'Number of ayahs is required'**
  String get ayahsRequired;

  /// No description provided for @ayahsInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number of ayahs'**
  String get ayahsInvalid;

  /// No description provided for @teacherRequired.
  ///
  /// In en, this message translates to:
  /// **'Teacher information is required'**
  String get teacherRequired;

  /// No description provided for @activate.
  ///
  /// In en, this message translates to:
  /// **'Activate'**
  String get activate;

  /// No description provided for @activateStudentConfirm.
  ///
  /// In en, this message translates to:
  /// **'Activate this student?'**
  String get activateStudentConfirm;

  /// No description provided for @activateStudentConfirmSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This will grant the student access to the system.'**
  String get activateStudentConfirmSubtitle;

  /// No description provided for @studentCreated.
  ///
  /// In en, this message translates to:
  /// **'Student added successfully!'**
  String get studentCreated;

  /// No description provided for @classModeOnline.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get classModeOnline;

  /// No description provided for @classModeOffline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get classModeOffline;

  /// No description provided for @classTypeBoys.
  ///
  /// In en, this message translates to:
  /// **'Boys'**
  String get classTypeBoys;

  /// No description provided for @classTypeGirls.
  ///
  /// In en, this message translates to:
  /// **'Girls'**
  String get classTypeGirls;

  /// No description provided for @recitationTypeRecitation.
  ///
  /// In en, this message translates to:
  /// **'Recitation'**
  String get recitationTypeRecitation;

  /// No description provided for @assignToClass.
  ///
  /// In en, this message translates to:
  /// **'Assign to Class'**
  String get assignToClass;

  /// No description provided for @selectClassToAssign.
  ///
  /// In en, this message translates to:
  /// **'Select a class'**
  String get selectClassToAssign;

  /// No description provided for @assignToClassSuccess.
  ///
  /// In en, this message translates to:
  /// **'Student assigned to class successfully!'**
  String get assignToClassSuccess;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
