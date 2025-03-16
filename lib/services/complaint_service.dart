import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/complaint_model.dart';

class ComplaintService {
  static const _complaintsKey = 'complaints';

  // Submit a new complaint to SharedPreferences
  Future<void> submitComplaint(Complaint complaint) async {
    final prefs = await SharedPreferences.getInstance();
    final complaints = await getComplaints();
    complaints.add(complaint);

    // Save the updated list of complaints back to SharedPreferences
    await prefs.setStringList(
      _complaintsKey,
      complaints.map((c) => jsonEncode(c.toJson())).toList(),
    );
  }

  // Retrieve all complaints from SharedPreferences
  Future<List<Complaint>> getComplaints() async {
    final prefs = await SharedPreferences.getInstance();
    final complaintStrings = prefs.getStringList(_complaintsKey) ?? [];
    
    // Deserialize complaint strings into Complaint objects
    return complaintStrings
        .map((str) => Complaint.fromJson(_parseComplaintString(str)))
        .toList();
  }

  // Update the status of a complaint based on its ID
  Future<void> updateComplaintStatus(String complaintId, String newStatus) async {
    final prefs = await SharedPreferences.getInstance();
    final complaints = await getComplaints();
    final complaintIndex = complaints.indexWhere((c) => c.id == complaintId);

    if (complaintIndex != -1) {
      // Update the status of the found complaint
      complaints[complaintIndex] = complaints[complaintIndex].copyWith(status: newStatus);

      // Save the updated complaints list
      await prefs.setStringList(
        _complaintsKey,
        complaints.map((c) => jsonEncode(c.toJson())).toList(),
      );
    }
  }

  // Helper function to parse a complaint string into a map
  Map<String, dynamic> _parseComplaintString(String str) {
    try {
      final json = jsonDecode(str);
      return {
        'id': json['id'],
        'userId': json['userId'],
        'title': json['title'],
        'description': json['description'],
        'category': json['category'],
        'location': json['location'],
        'mobile': json['mobile'],
        'imageBase64': List<String>.from(json['imageBase64']),
        'timestamp': json['timestamp'],
        'status': json['status'],
      };
    } catch (e) {
      print('Error parsing complaint: $e');
      return {};
    }
  }
}
