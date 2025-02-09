import 'dart:convert';

class Complaint {
  final String id;
  final String userId;
  final String title;
  final String description;
  final String category;
  final String location;
  final String mobile;
  final List<String> imageBase64;
  final DateTime timestamp;
  final String status;

  Complaint({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.category,
    required this.location,
    required this.mobile,
    required this.imageBase64,
    required this.timestamp,
    this.status = 'Pending',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'title': title,
        'description': description,
        'category': category,
        'location': location,
        'mobile': mobile,
        'imageBase64': imageBase64,
        'timestamp': timestamp.toIso8601String(),
        'status': status,
      };

  factory Complaint.fromJson(Map<String, dynamic> json) => Complaint(
        id: json['id'],
        userId: json['userId'],
        title: json['title'],
        description: json['description'],
        category: json['category'],
        location: json['location'],
        mobile: json['mobile'],
        imageBase64: List<String>.from(json['imageBase64']),
        timestamp: DateTime.parse(json['timestamp']),
        status: json['status'],
      );

  // Added copyWith method
  Complaint copyWith({String? status}) {
    return Complaint(
      id: id,
      userId: userId,
      title: title,
      description: description,
      category: category,
      location: location,
      mobile: mobile,
      imageBase64: imageBase64,
      timestamp: timestamp,
      status: status ?? this.status,
    );
  }
}
