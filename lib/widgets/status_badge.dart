import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  const StatusBadge({super.key, required this.status});
  @override
  Widget build(BuildContext context) {
    return Container(
	padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
	decoration: BoxDecoration(color: Colors.indigo.withOpacity(.1), 
	borderRadius: BorderRadius.circular(20)), child: Text(status, 
	style: const TextStyle(
	fontWeight: FontWeight.w700, 
	fontSize: 12
	)
	)
	);
  }
}
