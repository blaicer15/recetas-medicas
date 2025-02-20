import 'package:flutter/material.dart';

class SchedulePreview extends StatelessWidget {
  final List<DateTime> times;

  const SchedulePreview({super.key, required this.times});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Horarios programados:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 150,
              child: ListView.builder(
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
        ),
      ),
    );
  }
}
