import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/complaint_model.dart';
import '../../services/complaint_service.dart';
import 'complaint_detail_screen.dart'; // New component
import 'package:intl/intl.dart'; // For DateFormat
import 'dart:convert'; // For base64Decode


class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final ComplaintService _complaintService = ComplaintService();
  List<Complaint> _complaints = [];
  List<Complaint> _filteredComplaints = [];
  String _searchQuery = '';
  String _selectedFilter = 'All';
  final List<String> _statusFilters = ['All', 'Pending', 'In Progress', 'Resolved'];

  @override
  void initState() {
    super.initState();
    _loadComplaints();
  }

  Future<void> _loadComplaints() async {
    _complaints = await _complaintService.getComplaints();
    _applyFilters();
  }

  void _applyFilters() {
    setState(() {
      _filteredComplaints = _complaints.where((complaint) {
        final matchesSearch = complaint.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            complaint.description.toLowerCase().contains(_searchQuery.toLowerCase());
        final matchesStatus = _selectedFilter == 'All' || complaint.status == _selectedFilter;
        return matchesSearch && matchesStatus;
      }).toList();
      _filteredComplaints.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    });
  }

  Future<void> _refreshComplaints() async {
    await _loadComplaints();
  }

  Future<void> _updateStatus(Complaint complaint, String newStatus) async {
    await _complaintService.updateComplaintStatus(complaint.id, newStatus);
    _loadComplaints();
  }

  Future<void> _sendSMS(String number, String message) async {
    final uri = Uri.parse('sms:$number?body=${Uri.encodeComponent(message)}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch SMS';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshComplaints,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search complaints...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                _searchQuery = value;
                _applyFilters();
              },
            ),
          ),
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _statusFilters.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: FilterChip(
                    label: Text(_statusFilters[index]),
                    selected: _selectedFilter == _statusFilters[index],
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilter = selected ? _statusFilters[index] : 'All';
                        _applyFilters();
                      });
                    },
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshComplaints,
              child: _filteredComplaints.isEmpty
                  ? const Center(child: Text('No complaints found'))
                  : ListView.builder(
                      itemCount: _filteredComplaints.length,
                      itemBuilder: (context, index) => _buildComplaintCard(_filteredComplaints[index]),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComplaintCard(Complaint complaint) {
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

    return Card(
      margin: const EdgeInsets.all(8),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ComplaintDetailScreen(
              complaint: complaint,
              onStatusUpdate: (newStatus) => _updateStatus(complaint, newStatus),
              onSendSMS: (message) => _sendSMS(complaint.mobile, message),
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      complaint.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      complaint.status,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                complaint.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.category, size: 16),
                  const SizedBox(width: 4),
                  Text(complaint.category),
                  const Spacer(),
                  const Icon(Icons.access_time, size: 16),
                  const SizedBox(width: 4),
                  Text(DateFormat('dd MMM yyyy').format(complaint.timestamp)),
                ],
              ),
              if (complaint.imageBase64.isNotEmpty) ...[
                const SizedBox(height: 8),
                SizedBox(
                  height: 80,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: complaint.imageBase64.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.memory(
                          base64Decode(complaint.imageBase64[index]),
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}