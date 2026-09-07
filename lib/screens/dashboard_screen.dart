import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import 'login_screen.dart';
import 'task_list_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  Future<void> logout(BuildContext context) async {
    await StorageService().setLoggedIn(false);
    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard'),
	  actions: [IconButton(onPressed: () => logout(context),
	  icon: const Icon(Icons.logout))
	  ]),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Welcome, EVA', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          const Text('Here is your task summary', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 22),
          GridView.count(shrinkWrap: true, 
		  physics: const NeverScrollableScrollPhysics(), 
		  crossAxisCount: 2,
		  crossAxisSpacing: 12, 
		  mainAxisSpacing: 12, 
		  childAspectRatio: 1.5, children: const [
            _StatCard('Total Tasks', '10', Icons.assignment),
            _StatCard('Assigned', '4', Icons.assignment_ind),
            _StatCard('Accepted', '2', Icons.check_circle_outline),
            _StatCard('In Progress', '2', Icons.timelapse),
            _StatCard('Completed', '2', Icons.done_all),
          ]),
          const SizedBox(height: 26),
          SizedBox(width: double.infinity, 
		  height: 52, 
		  child: FilledButton.icon(onPressed: () => Navigator.push(context,
		  MaterialPageRoute(builder: (_) => const TaskListScreen())), 
		  icon: const Icon(Icons.list), 
		  label: const Text('View My Tasks'))),
        ]),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title, count;
  final IconData icon;
  const _StatCard(this.title, this.count, this.icon);
  @override
  Widget build(BuildContext context) => Card(
  child: Padding(
  padding: const EdgeInsets.all(14),
  child: Column(
  mainAxisAlignment: MainAxisAlignment.center, 
  children: [Icon(icon, size: 30, color: Colors.indigo), 
  const SizedBox(height: 7),
  Text(count, style: const TextStyle(
  fontSize: 24, fontWeight: FontWeight.bold
  )),
  Text(title, textAlign: TextAlign.center,
  style: const TextStyle(color: Colors.grey)
  )
  ])
  )
  );
}
