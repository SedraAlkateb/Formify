import 'package:flutter/material.dart';

class TimePickerField extends StatelessWidget {
  final String label;
  final String? initialText;
  final ValueChanged<TimeOfDay> onChanged;
  final TextEditingController controller;

  const TimePickerField({
    super.key,
    this.label = "الوقت",
    this.initialText,
    required this.onChanged,
    required this.controller,
  });

  String _format24(TimeOfDay t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return "$h:$m";
  }

  Future<void> _openPicker(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            alwaysUse24HourFormat: true,
          ),
          child: child!,
        );
      },
    );

    if (picked == null) return;

    final text = _format24(picked);
    controller.text = text;
    onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: () => _openPicker(context),
      decoration: InputDecoration(
        hintText: "اختر الوقت (HH:mm)",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        suffixIcon: IconButton(
          icon: const Icon(Icons.access_time),
          onPressed: () => _openPicker(context),
        ),
      ),
    );
  }
}