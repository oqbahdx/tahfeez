import 'package:flutter/material.dart';
import '../core/utils/toast_helper.dart';
import '../theme/tahfeez_theme.dart';
import '../l10n/app_localizations.dart';

class LogRecitationScreen extends StatefulWidget {
  const LogRecitationScreen({super.key});

  @override
  State<LogRecitationScreen> createState() => _LogRecitationScreenState();
}

class _LogRecitationScreenState extends State<LogRecitationScreen> {
  String _recitationType = 'new';
  double _grade = 8;
  String? _selectedStudent;
  final _notesController = TextEditingController();
  int _ayahStart = 1, _ayahEnd = 5;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: TahfeezColors.background,
      appBar: AppBar(
        backgroundColor: TahfeezColors.surfaceContainerLowest,
        leading: IconButton(
          icon: const Icon(Icons.close, color: TahfeezColors.onSurfaceVariant),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.logRecitation,
          style: TahfeezTextStyles.headlineLg.copyWith(
            color: TahfeezColors.onSurface,
            fontSize: 22,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.logRecitation,
              style: TahfeezTextStyles.headlineMd.copyWith(
                color: TahfeezColors.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.logRecitationSubtitle,
              style: TahfeezTextStyles.bodyMd.copyWith(
                color: TahfeezColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),

            // Student & Teacher Row
            LayoutBuilder(
              builder: (context, constraints) {
                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    SizedBox(
                      width: constraints.maxWidth > 500
                          ? (constraints.maxWidth - 16) / 2
                          : constraints.maxWidth,
                      child: _buildDropdown(
                        label: l10n.student,
                        icon: Icons.face_outlined,
                        items: [
                          'Ahmed Al-Farsi',
                          'Fatima Rahman',
                          'Omar Khalid',
                          'Zayd ibn Thabit',
                        ],
                        value: _selectedStudent,
                        hint: l10n.selectStudent,
                        onChanged: (v) => setState(() => _selectedStudent = v),
                      ),
                    ),
                    SizedBox(
                      width: constraints.maxWidth > 500
                          ? (constraints.maxWidth - 16) / 2
                          : constraints.maxWidth,
                      child: _buildDropdown(
                        label: l10n.teacher,
                        icon: Icons.school_outlined,
                        items: [
                          'Ustadh Mahmoud (Me)',
                          'Shaykh Youssef',
                          "Mu'allimah Aisha",
                        ],
                        value: 'Ustadh Mahmoud (Me)',
                        onChanged: (v) {},
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 20),

            // Date & Surah Row
            LayoutBuilder(
              builder: (context, constraints) {
                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    SizedBox(
                      width: constraints.maxWidth > 500
                          ? (constraints.maxWidth - 16) / 2
                          : constraints.maxWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _fieldLabel(l10n.date, Icons.calendar_today_outlined),
                          const SizedBox(height: 6),
                          TextField(
                            readOnly: true,
                            decoration: const InputDecoration(
                              hintText: 'Oct 27, 2023',
                            ),
                            onTap: () async {
                              await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2030),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: constraints.maxWidth > 500
                          ? (constraints.maxWidth - 16) / 2
                          : constraints.maxWidth,
                      child: _buildDropdown(
                        label: l10n.surah,
                        icon: Icons.menu_book_outlined,
                        items: [
                          'Al-Fatihah (1)',
                          'Al-Baqarah (2)',
                          'Al-Imran (3)',
                          'An-Nisa (4)',
                        ],
                        value: 'Al-Baqarah (2)',
                        onChanged: (v) {},
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 20),

            // Type + Ayah Range
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: TahfeezColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: TahfeezColors.surfaceVariant),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _fieldLabel(l10n.recitationType, null),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: TahfeezColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _TypeOption(
                            label: l10n.newHifdh,
                            isSelected: _recitationType == 'new',
                            selectedBg: TahfeezColors.primaryContainer,
                            selectedText: TahfeezColors.onPrimary,
                            onTap: () =>
                                setState(() => _recitationType = 'new'),
                          ),
                        ),
                        Expanded(
                          child: _TypeOption(
                            label: l10n.reviewMurajaah,
                            isSelected: _recitationType == 'review',
                            selectedBg: TahfeezColors.tertiaryContainer,
                            selectedText: TahfeezColors.onTertiary,
                            onTap: () =>
                                setState(() => _recitationType = 'review'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return Row(
                        children: [
                          SizedBox(
                            width: 100,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _fieldLabel(l10n.fromAyah, null),
                                const SizedBox(height: 6),
                                TextField(
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  controller: TextEditingController(
                                    text: '$_ayahStart',
                                  ),
                                  onChanged: (v) => setState(
                                    () => _ayahStart = int.tryParse(v) ?? 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 24),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                '-',
                                style: TextStyle(
                                  color: TahfeezColors.outline,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 100,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _fieldLabel(l10n.toAyah, null),
                                const SizedBox(height: 6),
                                TextField(
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  controller: TextEditingController(
                                    text: '$_ayahEnd',
                                  ),
                                  onChanged: (v) => setState(
                                    () => _ayahEnd = int.tryParse(v) ?? 5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Grade Slider
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _fieldLabel(l10n.qualityGrade, Icons.grade_outlined),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: TahfeezColors.primaryContainer.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${_grade.round()}',
                        style: TahfeezTextStyles.titleLg.copyWith(
                          color: TahfeezColors.primaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: TahfeezColors.primaryContainer,
                    inactiveTrackColor: TahfeezColors.outlineVariant,
                    thumbColor: TahfeezColors.primaryContainer,
                    overlayColor: TahfeezColors.primaryContainer.withOpacity(
                      0.1,
                    ),
                    trackHeight: 4,
                  ),
                  child: Slider(
                    value: _grade,
                    min: 1,
                    max: 10,
                    divisions: 9,
                    onChanged: (v) => setState(() => _grade = v),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '1 (${l10n.needsWork}) - 10 (${l10n.perfect})',
                        style: TahfeezTextStyles.labelMd.copyWith(
                          color: TahfeezColors.outline,
                        ),
                      ),
                      Text(
                        '10 (${l10n.perfect})',
                        style: TahfeezTextStyles.labelMd.copyWith(
                          color: TahfeezColors.outline,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Notes
            _fieldLabel(l10n.observationsNotes, Icons.notes_outlined),
            const SizedBox(height: 6),
            TextField(
              controller: _notesController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: l10n.observationsHint,
                alignLabelWithHint: true,
              ),
            ),

            const SizedBox(height: 24),

            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: TahfeezColors.outlineVariant),
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: Text(
                    l10n.cancel,
                    style: TahfeezTextStyles.labelLg.copyWith(
                      color: TahfeezColors.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton.icon(
                  onPressed: () {
                    AppToast.success(l10n.recitationLogSaved);
                    Navigator.pop(context);
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: TahfeezColors.primaryContainer,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  icon: const Icon(Icons.save_outlined, size: 18),
                  label: Text(
                    l10n.saveLog,
                    style: TahfeezTextStyles.labelLg.copyWith(
                      color: TahfeezColors.onPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _fieldLabel(String label, IconData? icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 14, color: TahfeezColors.onSurfaceVariant),
          const SizedBox(width: 4),
        ],
        Text(
          label,
          style: TahfeezTextStyles.labelMd.copyWith(
            color: TahfeezColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required IconData icon,
    required List<String> items,
    required String? value,
    String? hint,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel(label, icon),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          hint: hint != null ? Text(hint) : null,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: TahfeezColors.outlineVariant),
            ),
            filled: true,
            fillColor: TahfeezColors.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          items: items
              .map((s) => DropdownMenuItem(value: s, child: Text(s)))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _TypeOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color selectedBg, selectedText;
  final VoidCallback onTap;

  const _TypeOption({
    required this.label,
    required this.isSelected,
    required this.selectedBg,
    required this.selectedText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? selectedBg : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TahfeezTextStyles.labelLg.copyWith(
            color: isSelected ? selectedText : TahfeezColors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
