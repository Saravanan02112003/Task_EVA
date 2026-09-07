import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/task.dart';
import '../services/connectivity_service.dart';
import '../services/location_service.dart';
import '../services/storage_service.dart';

class TaskDetailsScreen extends StatefulWidget {
  final Task task;
  const TaskDetailsScreen({super.key, required this.task});
  @override State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  final notes = TextEditingController();
  final picker = ImagePicker();
  final location = LocationService();
  final storage = StorageService();
  final connectivity = ConnectivityService();
  bool loading = false;
  String syncState = 'Synced';

  @override void initState() { super.initState(); notes.text = widget.task.notes; }
  @override void dispose() { notes.dispose(); super.dispose(); }

  void message(String text) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  Future<void> acceptTask() async { setState(() => loading = true); await Future.delayed(const Duration(milliseconds: 400)); widget.task.status = 'Accepted'; setState(() => loading = false); }

  Future<void> startTask() async {
    setState(() => loading = true);
    try {
      final p = await location.getCurrentLocation();
      widget.task.startLatitude = p.latitude; widget.task.startLongitude = p.longitude; widget.task.status = 'In Progress';
      await queueOrSync(); message('Task started. Start location captured.');
    } catch (e) { message(e.toString().replaceFirst('Exception: ', '')); }
    if (mounted) setState(() => loading = false);
  }

  Future<void> addImages() async {
    final selected = await picker.pickMultiImage(imageQuality: 80);
    if (selected.isEmpty) return;
    setState(() => widget.task.images.addAll(selected.map((e) => e.path)));
    await queueOrSync();
  }

  Future<void> callCustomer() async {
    final uri = Uri(scheme: 'tel', path: widget.task.customerPhone);
    if (await canLaunchUrl(uri)) await launchUrl(uri); else message('Unable to open phone app');
  }

  Future<void> navigateCustomer() async {
    final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(widget.task.address)}');
    if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication); else message('Unable to open maps');
  }

  Future<void> queueOrSync() async {
    final online = await connectivity.isOnline();
    if (online) { setState(() => syncState = 'Synced'); }
    else { await storage.savePendingTask(widget.task.toJson()); setState(() => syncState = 'Pending'); }
  }

  Future<void> completeTask() async {
    if (notes.text.trim().isEmpty) return message('Please add notes before completing');
    if (widget.task.images.isEmpty) return message('Please add at least one image');
    if (!widget.task.customerConfirmed) return message('Please confirm customer confirmation');
    setState(() => loading = true);
    try {
      final p = await location.getCurrentLocation();
      widget.task.completionLatitude = p.latitude; widget.task.completionLongitude = p.longitude;
      widget.task.notes = notes.text.trim(); widget.task.status = 'Completed';
      await queueOrSync();
      if (mounted) { message(syncState == 'Pending' ? 'Completed offline. Waiting for sync.' : 'Task completed successfully'); Navigator.pop(context); }
    } catch (e) { message(e.toString().replaceFirst('Exception: ', '')); }
    if (mounted) setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.task;
    return Scaffold(appBar:
	AppBar(title: Text(task.id),
	actions: [Padding(
	padding: const EdgeInsets.only(right: 12), 
	child: Center(
	child: Text(syncState,
	style: const TextStyle(
	fontSize: 12, 
	fontWeight: FontWeight.w700)
	))
	)
	]), 
	body: SingleChildScrollView(
	padding: const EdgeInsets.all(16),
	child: Column(
	crossAxisAlignment: CrossAxisAlignment.start, 
	children: [
      Text(task.customerName, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
      const SizedBox(height: 5), Text(task.serviceType, style: const TextStyle(fontSize: 17)),
      const SizedBox(height: 18), 
	  _detail(
	  Icons.priority_high, 
	  'Priority', task.priority), 
	  _detail(Icons.schedule, 
	  'Date / Time', task.dateTime),
	  _detail(Icons.location_on, 'Address', task.address),
      const SizedBox(height: 12), 
	  Row(children: [
	  Expanded(child: 
	  OutlinedButton.icon(
	  onPressed: callCustomer, 
	  icon: const Icon(Icons.call), 
	  label: const Text('Call'))), 
	  const SizedBox(width: 10), 
	  Expanded(child: OutlinedButton.icon(onPressed: navigateCustomer, icon: const Icon(Icons.navigation), label: const Text('Navigate')))]),
      const SizedBox(height: 18),
      if (task.status == 'Assigned') SizedBox(width: double.infinity, height: 50, 
	  child: FilledButton(onPressed: loading ? null : acceptTask, child: const Text('Accept Task'))),
      if (task.status == 'Accepted') SizedBox(width: double.infinity, height: 50,
	  child: FilledButton(onPressed: loading ? null : startTask, child: const Text('Start Task'))),
      if (task.status == 'In Progress') ...[
        const SizedBox(height: 18), const Text('Task Notes', 
		style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), const SizedBox(height: 8),
        TextField(controller: notes, maxLines: 4, decoration: const InputDecoration(hintText: 'Enter work notes...')),
        const SizedBox(height: 14), SizedBox(width: double.infinity, height: 48, 
		child: OutlinedButton.icon(onPressed: addImages, icon: const Icon(Icons.add_a_photo), 
		label: const Text('Capture / Select Images'))),
        const SizedBox(height: 12),
        if (task.images.isNotEmpty) SizedBox(height: 100, 
		child: ListView.separated(
		scrollDirection: Axis.horizontal, itemCount: task.images.length, 
		separatorBuilder: (_, __) => const SizedBox(width: 8), 
		itemBuilder: (_, i) => ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.file(File(task.images[i]), width: 100, height: 100, fit: BoxFit.cover)))),
        const SizedBox(height: 12),
        CheckboxListTile(contentPadding: EdgeInsets.zero, 
		value: task.customerConfirmed, onChanged: (v) => setState(() => task.customerConfirmed = v ?? false), title: const Text('Customer confirmation received')),
        const SizedBox(height: 8), 
		SizedBox(width: double.infinity,
		height: 52, 
		child: FilledButton(onPressed: loading ? null : completeTask, 
		child: loading ? const SizedBox(
		width: 22,
		height: 22, 
		child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Complete Task'))),
      ],
      if (task.status == 'Completed') 
	  const Card(child: ListTile(
	  leading: Icon(Icons.check_circle, size: 32),
	  title: Text('Task Completed',
	  style: TextStyle(fontWeight: FontWeight.bold)), 
	  subtitle: Text('Completion location captured.'))),
    ])));
  }

  Widget _detail(
  IconData icon, String title, String value) => Padding(
  padding: const EdgeInsets.only(bottom: 11), 
  child: Row(
  crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(icon, size: 21), 
  const SizedBox(width: 10), Expanded(child: Text('$title\n$value'))
  ])
  );
}
