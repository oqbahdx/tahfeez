import '../../../../l10n/app_localizations.dart';
import '../../domain/enums/attendance_status.dart';

extension AttendanceStatusL10n on AttendanceStatus {
  String localizedName(AppLocalizations l10n) {
    switch (this) {
      case AttendanceStatus.present:
        return l10n.present;
      case AttendanceStatus.absent:
        return l10n.absent;
      case AttendanceStatus.late:
        return l10n.late;
    }
  }
}
