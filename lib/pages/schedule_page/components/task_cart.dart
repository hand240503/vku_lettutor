import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final Size size;
  final int index;
  final String title;
  final String subTitle;
  final VoidCallback? onTap;
  final Widget trailing;

  const TaskCard({
    super.key,
    required this.size,
    required this.index,
    required this.title,
    required this.subTitle,
    this.onTap, // Accept onTap
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(title),
        subtitle: Text(subTitle),
        onTap: onTap, // Handle the tap here
        trailing: trailing,
      ),
    );
  }
}
