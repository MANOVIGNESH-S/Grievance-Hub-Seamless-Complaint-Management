import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_flutter_app/models/user_model.dart';
import 'package:my_flutter_app/services/auth_service.dart';
import 'package:intl/intl.dart';
import 'package:my_flutter_app/models/complaint_model.dart';
import 'package:my_flutter_app/services/complaint_service.dart';
import 'package:my_flutter_app/screens/complaint/complaint_form.dart';
import 'package:my_flutter_app/screens/complaint/complaint_detail.dart';

class UserDashboard extends StatelessWidget {
  final User user;

  const UserDashboard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome ${user.name}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('currentUser');
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ComplaintFormScreen(user: user),
                ),
              ),
              child: const Text('File New Complaint'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Complaint>>(
                future: ComplaintService().getComplaints(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final complaints = snapshot.data?.where((c) => c.userId == user.email).toList() ?? [];

                  if (complaints.isEmpty) {
                    return const Center(
                      child: Text(
                        'No complaints found!\nTap + to file a new complaint', 
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: complaints.length,
                    itemBuilder: (context, index) {
                      if (index >= complaints.length) return const SizedBox.shrink();
                      return ComplaintCard(complaint: complaints[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ComplaintCard extends StatelessWidget {
  final Complaint complaint;

  const ComplaintCard({super.key, required this.complaint});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(complaint.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(complaint.description),
            Text('Status: ${complaint.status}'),
            Text(
                'Date: ${DateFormat('dd MMM yyyy').format(complaint.timestamp)}'),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ComplaintDetailScreen(complaint: complaint),
          ),
        ),
      ),
    );
  }
}
