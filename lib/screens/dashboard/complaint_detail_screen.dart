import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import '../../models/complaint_model.dart';


class ComplaintDetailScreen extends StatelessWidget {
  final Complaint complaint;
  final Function(String) onStatusUpdate;
  final Function(String) onSendSMS;

  const ComplaintDetailScreen({
    super.key,
    required this.complaint,
    required this.onStatusUpdate,
    required this.onSendSMS,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor = Colors.grey;
    switch (complaint.status) {
      case 'Pending':
        statusColor = Colors.orange;
        break;
      case 'In Progress':
        statusColor = Colors.blue;
        break;
      case 'Resolved':
        statusColor = Colors.green;
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(complaint.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.message),
            onPressed: () => _showSMSDialog(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Status', complaint.status, color: statusColor),
            _buildDetailRow('Category', complaint.category),
            _buildDetailRow('Location', complaint.location),
            _buildDetailRow('User Mobile', complaint.mobile),
            _buildDetailRow('Submitted Date', 
              DateFormat('dd MMM yyyy - HH:mm').format(complaint.timestamp)),
            const SizedBox(height: 20),
            const Text(
              'Description:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(complaint.description),
            const SizedBox(height: 20),
            if (complaint.imageBase64.isNotEmpty) ...[
              const Text(
                'Attachments:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: complaint.imageBase64.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.memory(
                        base64Decode(complaint.imageBase64[index]),
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 20),
            _buildStatusDropdown(),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusDropdown() {
    return DropdownButtonFormField<String>(
      value: complaint.status,
      decoration: const InputDecoration(
        labelText: 'Update Status',
        border: OutlineInputBorder(),
      ),
      items: const [
        DropdownMenuItem(value: 'Pending', child: Text('Pending')),
        DropdownMenuItem(value: 'In Progress', child: Text('In Progress')),
        DropdownMenuItem(value: 'Resolved', child: Text('Resolved')),
      ],
      onChanged: (value) {
        if (value != null) {
          onStatusUpdate(value);
        }
      },
    );
  }

  void _showSMSDialog(BuildContext context) {
    final messageController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Send SMS Update'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: messageController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Enter your message...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Text('Recipient: ${complaint.mobile}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onSendSMS(messageController.text);
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }
}