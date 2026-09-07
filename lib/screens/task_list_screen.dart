import 'package:flutter/material.dart';
import '../models/task.dart';
import '../widgets/task_card.dart';
import 'task_details_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});
  @override State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final List<Task> tasks = [
    Task(id: 'TASK001', customerName: 'Arun Kumar', customerPhone: '9876543210', serviceType: 'AC Service', priority: 'High', dateTime: '07 Sep 2026, 10:30 AM', address: 'Navallur, Chennai', status: 'Assigned'),
    Task(id: 'TASK002', customerName: 'Rahul', customerPhone: '9876501234', serviceType: 'Washing Machine Repair', priority: 'Medium', dateTime: '07 Sep 2026, 02:00 PM', address: 'Sholinganallur, Chennai', status: 'Accepted'),
    Task(id: 'TASK003', customerName: 'Priya', customerPhone: '9876541111', serviceType: 'TV Installation', priority: 'Low', dateTime: '08 Sep 2026, 11:00 AM', address: 'Velachery, Chennai', status: 'In Progress'),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
  appBar: AppBar(
  title: const Text('My Tasks')), 
  body: ListView.builder(
  padding: const EdgeInsets.all(16),
  itemCount: tasks.length, 
  itemBuilder: (_, i) => TaskCard(
  task: tasks[i], 
  onTap: () async {
  await Navigator.push(context, MaterialPageRoute(
  builder: (_) => TaskDetailsScreen(
  task: tasks[i])));
  setState(() {}); 
  }
  )
  )
  );
}
