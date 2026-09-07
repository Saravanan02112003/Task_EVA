import 'package:flutter/material.dart';
import '../models/task.dart';
import 'status_badge.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;

  const TaskCard({
    super.key,
    required this.task,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    task.id,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  StatusBadge(
                    status: task.status,
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Text(
                task.customerName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              Text(task.serviceType),

              const SizedBox(height: 7),

              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 18,
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(task.address),
                  ),
                ],
              ),

              const SizedBox(height: 5),

              Row(
                children: [
                  const Icon(
                    Icons.schedule,
                    size: 18,
                  ),
                  const SizedBox(width: 5),
                  Text(task.dateTime),
                ],
              ),

              const SizedBox(height: 7),

              Text(
                'Priority: ${task.priority}',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}