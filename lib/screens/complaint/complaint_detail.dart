import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/complaint_model.dart';

class ComplaintDetailScreen extends StatelessWidget {
  final Complaint complaint;

  const ComplaintDetailScreen({super.key, required this.complaint});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(complaint.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status: ${complaint.status}',
              style: TextStyle(
                color: complaint.status == 'Resolved' ? Colors.green : Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text('Description: ${complaint.description}'),
            const SizedBox(height: 20),
            Text('Category: ${complaint.category}'),
            const SizedBox(height: 20),
            Text('Location: ${complaint.location}'),
            const SizedBox(height: 20),
            Text('Submitted on: ${DateFormat('dd MMM yyyy – HH:mm').format(complaint.timestamp)}'),
            const SizedBox(height: 20),
            if (complaint.imageBase64.isNotEmpty) ...[
              const Text('Attachments:'),
              SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: complaint.imageBase64.map((base64) => Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Image.memory(
                          base64Decode(base64),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      )).toList(),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
