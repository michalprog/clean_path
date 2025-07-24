import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data_types/record.dart';
import '../providers/statistics_provider.dart';

class ChangeCommentDialog extends StatefulWidget {
  final Record record;

  const ChangeCommentDialog({super.key, required this.record});

  @override
  State<ChangeCommentDialog> createState() => _ChangeCommentDialogState();
}

class _ChangeCommentDialogState extends State<ChangeCommentDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.record.comment ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _saveComment() async {
    final newComment = _controller.text.trim();
    final updatedRecord = widget.record.copyWith(comment: newComment);

    // wywołujemy metodę z StatisticsProvider do aktualizacji komentarza
    await Provider.of<StatisticsProvider>(context, listen: false)
        .editRecordComment(updatedRecord);

    Navigator.of(context).pop(); // zamykamy popup
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Edytuj komentarz"),
      content: TextField(
        controller: _controller,
        maxLines: 3,
        decoration: const InputDecoration(
          hintText: "Wpisz swój komentarz...",
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Anuluj"),
        ),
        ElevatedButton(
          onPressed: _saveComment,
          child: const Text("Zapisz"),
        ),
      ],
    );
  }
}
