import 'package:flutter/material.dart';

class DetailStatusSlik extends StatelessWidget {
  final String label;
  final String status;

  const DetailStatusSlik({
    super.key,
    required this.label,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    IconData icon;
    String displayText;

    if (status == 'pending') {
      bgColor = Colors.orange.shade100;
      icon = Icons.timelapse;
      displayText = 'On Progress';
    } else if (status == 'success') {
      bgColor = Colors.green.shade100;
      icon = Icons.check_circle;
      displayText = 'Success';
    } else {
      bgColor = Colors.grey.shade300;
      icon = Icons.help_outline;
      displayText = 'Unknown';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 18, color: Colors.black54),
                  const SizedBox(width: 6),
                  Text(
                    displayText,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
