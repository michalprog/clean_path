import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/data_types/record.dart';
import '/providers/statistics_provider.dart';
import '/l10n/app_localizations.dart';
class ChangeCommentDialog extends StatefulWidget {
  final Record record;

  const ChangeCommentDialog({super.key, required this.record});

  @override
  State<ChangeCommentDialog> createState() => _ChangeCommentDialogState();
}

class _ChangeCommentDialogState extends State<ChangeCommentDialog> {
  late TextEditingController _commentController;
  late TextEditingController _dateController;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController(text: widget.record.comment ?? '');
    _selectedDate = widget.record.desactivated;
    _dateController = TextEditingController(
      text: _selectedDate == null ? '' : _formatDate(_selectedDate!),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = _formatDate(picked);
      });
    }
  }

  Future<void> _saveChanges() async {
    final newComment = _commentController.text.trim();
    final updated = widget.record.copyWith(
      comment: newComment,
      desactivated: _selectedDate,
    );

    await Provider.of<StatisticsProvider>(context, listen: false)
        .editRecordComment(updated);

    Navigator.of(context).pop();
  }

  void _cancelChanges() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with icon and title
            Row(
              children: [
                const Icon(Icons.edit_note_rounded, color: Colors.blueAccent, size: 24),
                const SizedBox(width: 8),
                Text(
                  l10n.editRecordTitle,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Comment field
            Align(
              alignment: Alignment.centerLeft,
              child: Text(l10n.commentLabel, style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _commentController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: l10n.commentHint,
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),

            // Date field
            Align(
              alignment: Alignment.centerLeft,
              child: Text(l10n.failDateLabel, style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 8),
            TextFormField(
              readOnly: true,
              controller: _dateController,
              decoration: InputDecoration(
                hintText: l10n.dateHint,
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                suffixIcon: const Icon(Icons.calendar_today),
              ),
              onTap: _pickDate,
            ),
            const SizedBox(height: 24),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _cancelChanges,
                  child: Text(l10n.cancel),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(l10n.save),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
