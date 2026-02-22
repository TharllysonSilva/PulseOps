import 'package:flutter/material.dart';
import '../tokens/colors.dart';

class StatusChip extends StatelessWidget {
  final String status;
  const StatusChip(this.status, {super.key});

  @override
  Widget build(BuildContext context) {
    Color color = AppColors.warning;

    if (status == 'resolved') color = AppColors.success;
    if (status == 'closed') color = AppColors.danger;

    return Chip(
      label: Text(status),
      backgroundColor: color.withOpacity(.15),
      labelStyle: TextStyle(color: color),
    );
  }
}