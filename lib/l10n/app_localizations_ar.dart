// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'تحفيظ';

  @override
  String get welcomeBack => 'مرحباً بعودتك';

  @override
  String get pleaseSignIn =>
      'يرجى تسجيل الدخول للوصول إلى لوحة التحكم المؤسسية.';

  @override
  String get emailAddress => 'البريد الإلكتروني';

  @override
  String get emailHint => 'admin@domain.com';

  @override
  String get password => 'كلمة المرور';

  @override
  String get passwordHint => 'أدخل كلمة المرور';

  @override
  String get forgotPassword => 'هل نسيت كلمة المرور؟';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get needHelp => 'هل تحتاج مساعدة في الوصول إلى حسابك؟';

  @override
  String get contactAdministrator => 'تواصل مع المسؤول';

  @override
  String get secureAccess => 'وصول آمن للمشرفين والمعلمين والموظفين.';

  @override
  String get dashboard => 'لوحة التحكم';

  @override
  String get overview => 'نظرة عامة';

  @override
  String get welcomeBackSubtitle => 'مرحباً بعودتك، إليك ما يحدث اليوم.';

  @override
  String get totalStudents => 'إجمالي الطلاب';

  @override
  String get activeClasses => 'الفصول النشطة';

  @override
  String get todaysAttendance => 'حضور اليوم';

  @override
  String get overdueSubscriptions => 'الاشتراكات المتأخرة';

  @override
  String get thisMonth => 'هذا الشهر';

  @override
  String get actionNeeded => 'إجراء مطلوب';

  @override
  String get recentActivity => 'النشاط الأخير';

  @override
  String get viewAll => 'عرض الكل';

  @override
  String get quickActions => 'إجراءات سريعة';

  @override
  String get markAttendance => 'تسجيل الحضور';

  @override
  String get addStudent => 'إضافة طالب';

  @override
  String get scheduleExam => 'جدولة امتحان';

  @override
  String get sendAnnouncement => 'إرسال إعلان';

  @override
  String get upcomingToday => 'القادم اليوم';

  @override
  String get completed => 'أتم';

  @override
  String get revised => 'راجع';

  @override
  String get missed => 'غاب';

  @override
  String get excellent => 'ممتاز';

  @override
  String get needsFollowUp => 'يحتاج متابعة';

  @override
  String minutesAgo(String time) {
    return 'منذ $time دقيقة';
  }

  @override
  String hoursAgo(String time) {
    return 'منذ $time ساعة';
  }

  @override
  String get classes => 'الفصول';

  @override
  String get classesManagement => 'إدارة الفصول';

  @override
  String get activeClassesSubtitle => 'إدارة ومراقبة جميع الجلسات الجارية';

  @override
  String get searchClasses => 'البحث في الفصول...';

  @override
  String get filter => 'تصفية';

  @override
  String get addClass => 'إضافة فصل';

  @override
  String get addClassTitle => 'إضافة فصل';

  @override
  String get className => 'اسم الفصل';

  @override
  String get classType => 'نوع الفصل';

  @override
  String get classMode => 'وضع الفصل';

  @override
  String get nameRequired => 'يرجى إدخال اسم الفصل';

  @override
  String get typeRequired => 'يرجى اختيار نوع الفصل';

  @override
  String get modeRequired => 'يرجى اختيار وضع الفصل';

  @override
  String get submit => 'إرسال';

  @override
  String get classCreated => 'تم إنشاء الفصل بنجاح!';

  @override
  String get classDeleted => 'تم حذف الفصل بنجاح!';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get noClassesFound => 'لا توجد فصول';

  @override
  String get noClassesFoundSubtitle =>
      'لا توجد فصول بعد. اضغط + لإضافة أول فصل.';

  @override
  String get addClassSubtitle => 'إنشاء فصل جديد';

  @override
  String get classNameHint => 'مثال: فصل القرآن أ';

  @override
  String get classTypePlaceholder => 'اختر النوع';

  @override
  String get classModePlaceholder => 'اختر الوضع';

  @override
  String get submitting => 'جارٍ الإرسال...';

  @override
  String get emailRequired => 'البريد الإلكتروني مطلوب';

  @override
  String get invalidEmail => 'أدخل بريداً إلكترونياً صحيحاً';

  @override
  String get passwordRequired => 'كلمة المرور مطلوبة';

  @override
  String get usernameRequired => 'اسم المستخدم مطلوب';

  @override
  String get usernameMinLength =>
      'يجب أن يتكون اسم المستخدم من 3 أحرف على الأقل';

  @override
  String get usernameInvalidChars =>
      'يمكن أن يحتوي اسم المستخدم على أحرف وأرقام وشرطات سفلية فقط';

  @override
  String get fullNameRequired => 'الاسم الكامل مطلوب';

  @override
  String get fullNameMinLength =>
      'يجب أن يتكون الاسم الكامل من حرفين على الأقل';

  @override
  String get passwordComplexity =>
      'يجب أن تحتوي كلمة المرور على 8 أحرف كبيرة وصغيرة ورمز خاص';

  @override
  String get confirmPasswordRequired => 'تأكيد كلمة المرور مطلوب';

  @override
  String get failedToLoadClasses => 'فشل تحميل الفصول';

  @override
  String get failedToLoadStudents => 'فشل تحميل الطلاب';

  @override
  String get checkConnectionAndRetry => 'تحقق من اتصالك وحاول مرة أخرى.';

  @override
  String get classNameTooLong => 'اسم الفصل طويل جداً';

  @override
  String get manageStaffPayroll => 'إدارة رواتب الموظفين والمدفوعات.';

  @override
  String get forOctober2023 => 'لشهر أكتوبر 2023';

  @override
  String staffMembersCount(Object count) {
    return '$count موظف';
  }

  @override
  String studentsListCount(int count) {
    return '$count طالب';
  }

  @override
  String classesCount(int count) {
    return '$count فصل';
  }

  @override
  String get delete => 'حذف';

  @override
  String get deleteClass => 'حذف الفصل';

  @override
  String deleteClassConfirmation(String name) {
    return 'هل أنت متأكد أنك تريد حذف $name؟';
  }

  @override
  String get students => 'الطلاب';

  @override
  String get searchStudents => 'البحث في الطلاب...';

  @override
  String get allStudents => 'كل الطلاب';

  @override
  String get addStudentBtn => 'إضافة طالب';

  @override
  String get noStudentsFound => 'لم يتم العثور على طلاب';

  @override
  String get pending => 'معلق';

  @override
  String joinedDate(String date) {
    return 'تاريخ الانضمام $date';
  }

  @override
  String get reports => 'التقارير';

  @override
  String get settings => 'الإعدادات';

  @override
  String get institution => 'المؤسسة';

  @override
  String get academicYear => 'السنة الأكاديمية';

  @override
  String get curriculum => 'المنهج';

  @override
  String get staffDirectory => 'دليل الموظفين';

  @override
  String get locationBranches => 'المواقع والفروع';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get pushNotifications => 'الإشعارات الفورية';

  @override
  String get pushNotificationsSubtitle => 'الحضور وتنبيهات التسميع';

  @override
  String get emailAlerts => 'تنبيهات البريد الإلكتروني';

  @override
  String get emailAlertsSubtitle => 'الملخص اليومي والإشعارات المتأخرة';

  @override
  String get appearance => 'المظهر';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get darkModeSubtitle => 'التبديل إلى السمة الداكنة';

  @override
  String get language => 'اللغة';

  @override
  String get support => 'الدعم';

  @override
  String get helpSupport => 'المساعدة والدعم';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get aboutTahfeez => 'حول تحفيظ';

  @override
  String get signOut => 'تسجيل الخروج';

  @override
  String get administrator => 'المشرف';

  @override
  String get superAdmin => 'المشرف الأعلى';

  @override
  String get edit => 'تعديل';

  @override
  String get classDetails => 'تفاصيل الفصل';

  @override
  String get classInfo => 'معلومات الفصل';

  @override
  String get studentsList => 'الطلاب';

  @override
  String get noStudentsInClass => 'لا يوجد طلاب مسجلون في هذا الفصل';

  @override
  String get typeRecitation => 'النوع: تسميع';

  @override
  String get modeInPerson => 'الحضور: حضوري';

  @override
  String get levelAdvanced => 'متقدم';

  @override
  String get assignedStaff => 'الموظفون المكلفون';

  @override
  String get primaryTeacher => 'المعلم الأساسي';

  @override
  String get assistant => 'المساعد';

  @override
  String get supervisor => 'المشرف';

  @override
  String get assignStaff => 'تكليف موظف';

  @override
  String studentsTab(int count) {
    return 'الطلاب ($count)';
  }

  @override
  String get attendance => 'الحضور';

  @override
  String get progress => 'التقدم';

  @override
  String get viewAllStudents => 'عرض كل الطلاب';

  @override
  String get openAttendance => 'فتح الحضور';

  @override
  String get progressChartsComingSoon => 'رسوم التقدم قريباً';

  @override
  String get recordAttendance => 'تسجيل الحضور';

  @override
  String get selectDate => 'اختر التاريخ';

  @override
  String get selectClass => 'اختر الفصل';

  @override
  String get present => 'حاضر';

  @override
  String get absent => 'غائب';

  @override
  String get excused => 'معذور';

  @override
  String get late => 'متأخر';

  @override
  String get submitAttendance => 'إرسال الحضور';

  @override
  String get attendanceSubmitted => 'تم إرسال الحضور بنجاح!';

  @override
  String get student => 'الطالب';

  @override
  String get presentCount => 'حاضر';

  @override
  String get absentCount => 'غائب';

  @override
  String get attendanceRate => 'النسبة';

  @override
  String get studentSummary => 'ملخص الطلاب';

  @override
  String get export => 'تصدير';

  @override
  String get subscriptions => 'الاشتراكات';

  @override
  String get salaries => 'الرواتب';

  @override
  String get collectedThisMonth => 'جمع هذا الشهر';

  @override
  String get overdueTotal => 'المبلغ المتأخر';

  @override
  String get activeSubscriptions => 'الاشتراكات النشطة';

  @override
  String get allRecords => 'كل السجلات';

  @override
  String get active => 'نشط';

  @override
  String get overdue => 'متأخر';

  @override
  String get daysLate => 'أيام التأخير';

  @override
  String get amount => 'المبلغ';

  @override
  String get typeMode => 'النوع والطريقة';

  @override
  String get dueDate => 'تاريخ الاستحقاق';

  @override
  String get salariesTab => 'الرواتب';

  @override
  String get totalPayroll => 'إجمالي الرواتب';

  @override
  String get paid => 'مدفوع';

  @override
  String get unpaid => 'غير مدفوع';

  @override
  String get staffMembers => 'موظف';

  @override
  String get staffMember => 'الموظف';

  @override
  String get role => 'الدور';

  @override
  String get status => 'الحالة';

  @override
  String get logRecitation => 'تسجيل التسميع';

  @override
  String get logRecitationSubtitle => 'تسجيل تقدم حفظ الطالب.';

  @override
  String get selectStudent => 'اختر طالباً...';

  @override
  String get teacher => 'المعلم';

  @override
  String get date => 'التاريخ';

  @override
  String get surah => 'السورة';

  @override
  String get recitationType => 'نوع التسميع';

  @override
  String get newHifdh => 'جديد (حفظ)';

  @override
  String get reviewMurajaah => 'مراجعة (مراجعة)';

  @override
  String get fromAyah => 'من آية';

  @override
  String get toAyah => 'إلى آية';

  @override
  String get qualityGrade => 'التقدير';

  @override
  String get needsWork => 'يحتاج عمل';

  @override
  String get perfect => 'مثالي';

  @override
  String get observationsNotes => 'الملاحظات والملاحظات';

  @override
  String get observationsHint =>
      'أضف ملاحظات حول النطق أو قواعد التجويد أو مجالات التحسين...';

  @override
  String get cancel => 'إلغاء';

  @override
  String get saveLog => 'حفظ السجل';

  @override
  String get recitationLogSaved => 'تم حفظ سجل التسميع!';

  @override
  String get recitationHistory => 'سجل التسميع';

  @override
  String get monthlyProgress => 'التقدم الشهري';

  @override
  String get sessions => 'جلسات';

  @override
  String get excellentGrade => 'ممتاز';

  @override
  String get moreFilters => 'المزيد من الفلاتر';

  @override
  String get newLessonSabaq => 'درس جديد (سبق)';

  @override
  String get recentRevisionSabaqi => 'مراجعة حديثة (سبيقي)';

  @override
  String get oldRevisionManzil => 'مراجعة قديمة (منزل)';

  @override
  String get gradeGood => 'جيد';

  @override
  String get gradeNeedsWork => 'يحتاج عمل';

  @override
  String get hijriDate => 'هجري: 14 صفر 1446';

  @override
  String get thisMonthBadge => '+12 هذا الشهر';

  @override
  String get hijriDateShort => '12 صفر 1445';

  @override
  String get filterChipsAll => 'الكل';

  @override
  String get filterChipsExcellent => 'ممتاز';

  @override
  String get filterChipsGood => 'جيد';

  @override
  String get filterChipsNeedsWork => 'يحتاج عمل';

  @override
  String studentsCount(int count) {
    return '$count طالب';
  }

  @override
  String get viewHistory => 'عرض السجل';

  @override
  String get attendanceReport => 'تقرير الحضور';

  @override
  String get attendanceReportSubtitle => 'راجع وأدر سجلات حضور الطلاب.';

  @override
  String get attendanceHistory => 'سجل الحضور';

  @override
  String get addAttendanceRecord => 'إضافة سجل حضور';

  @override
  String get addAttendance => 'إضافة حضور';

  @override
  String get noAttendanceHistory => 'لا يوجد سجل حضور';

  @override
  String get noAttendanceRecordsForUser =>
      'لم يتم العثور على سجلات حضور لهذا المستخدم.';

  @override
  String get attendancePercent => 'نسبة الحضور';

  @override
  String get timeline => 'الجدول الزمني';

  @override
  String get notesOptional => 'ملاحظات (اختياري)';

  @override
  String get save => 'حفظ';

  @override
  String get saving => 'جارٍ الحفظ...';

  @override
  String get noAttendanceRecordsForDate => 'لا توجد سجلات حضور لهذا التاريخ.';

  @override
  String get dateCannotBeFuture => 'لا يمكن أن يكون التاريخ في المستقبل';

  @override
  String get noStudentsToSave => 'لا يوجد طلاب للحفظ';

  @override
  String get noAttendanceRecordsToSave => 'لا توجد سجلات حضور للحفظ';

  @override
  String get dateRange => 'نطاق التاريخ';

  @override
  String get idLabel => 'المعرف:';

  @override
  String get subscriptionsSubtitle => 'إدارة مدفوعات الطلاب والمستحقات.';

  @override
  String get parentLabel => 'الولي:';

  @override
  String get curriculumSubtitle => 'إدارة المناهج والبرامج';

  @override
  String staffCount(int count) {
    return '$count موظف نشط';
  }

  @override
  String get locationValue => 'القاهرة - الحرم الرئيسي';

  @override
  String get version => 'v1.0.4';

  @override
  String get tagline =>
      'التقليد المقدس يلتقي بالإدارة الحديثة. تبسيط تعليم القرآن للمؤسسات.';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageArabic => 'العربية';

  @override
  String get hifzRevisionAdvanced => 'مراجعة الحفظ - متقدم';

  @override
  String get tajweedBasicsBeginners => 'أساسيات التجويد - مبتدئين';

  @override
  String get createNewAccount => 'إنشاء حساب جديد';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get joinInstitution => 'انضم إلى المؤسسة للبدء في التعلم.';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟';

  @override
  String get username => 'اسم المستخدم';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get passwordsDoNotMatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get passwordTooShort => 'يجب أن تتكون كلمة المرور من 6 أحرف على الأقل';

  @override
  String get registrationSuccessful => 'تم التسجيل بنجاح! يرجى تسجيل الدخول.';

  @override
  String get selectRole => 'اختر الدور';

  @override
  String get roleStudent => 'طالب';

  @override
  String get roleTeacher => 'معلم';

  @override
  String get roleAssistant => 'مساعد';

  @override
  String get roleSupervisor => 'مشرف';

  @override
  String get roleAccountant => 'محاسب';

  @override
  String get roleAdmin => 'مدير';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get passwordStrengthWeak => 'ضعيفة';

  @override
  String get passwordStrengthFair => 'مقبولة';

  @override
  String get passwordStrengthGood => 'جيدة';

  @override
  String get passwordStrengthStrong => 'قوية';

  @override
  String get passwordRuleMinLength => '8+ أحرف';

  @override
  String get passwordRuleUppercase => 'حرف كبير';

  @override
  String get passwordRuleLowercase => 'حرف صغير';

  @override
  String get passwordRuleSpecialChar => 'رمز خاص';

  @override
  String get roleParent => 'ولي أمر';

  @override
  String get ayahsCount => 'عدد الآيات';

  @override
  String ayahsCountText(int count) {
    return '$count آيات';
  }

  @override
  String get noRecitationsFound => 'لم يتم العثور على تسميعات';

  @override
  String get noRecitationsFoundSubtitle => 'ابدأ بتسجيل تسميع';

  @override
  String get failedToLoadRecitations => 'فشل تحميل سجل التسميع';

  @override
  String get ayahsRequired => 'عدد الآيات مطلوب';

  @override
  String get ayahsInvalid => 'الرجاء إدخال رقم صحيح';

  @override
  String get teacherRequired => 'معلومات المعلم مطلوبة';

  @override
  String get activate => 'تفعيل';

  @override
  String get activateStudentConfirm => 'تفعيل هذا الطالب؟';

  @override
  String get activateStudentConfirmSubtitle =>
      'سيتم منح الطالب حق الوصول إلى النظام.';

  @override
  String get studentCreated => 'تم إضافة الطالب بنجاح!';

  @override
  String get classModeOnline => 'عبر الإنترنت';

  @override
  String get classModeOffline => 'حضوري';

  @override
  String get classTypeBoys => 'بنين';

  @override
  String get classTypeGirls => 'بنات';

  @override
  String get recitationTypeRecitation => 'تسميع';

  @override
  String get assignToClass => 'تعيين إلى فصل';

  @override
  String get selectClassToAssign => 'اختر فصلاً';

  @override
  String get assignToClassSuccess => 'تم تعيين الطالب إلى الفصل بنجاح!';
}
