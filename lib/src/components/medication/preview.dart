import 'package:flutter/material.dart';

class SchedulePreview extends StatelessWidget {
  final List<DateTime> times;

  const SchedulePreview({super.key, required this.times});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Horarios programados:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: times.length,
            itemBuilder: (context, index) {
              final time = times[index];
              return ListTile(
                dense: true,
                title: Text(
                  '${time.day}/${time.month}/${time.year} - ${time.hour}:${time.minute.toString().padLeft(2, '0')}',
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
