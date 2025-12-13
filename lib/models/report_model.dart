class ReportModel {
  final String id;
  final String title;
  final String description;
  final String photoPath;
  final double latitude;
  final double longitude;
  final String status; // 'pending' atau 'done'
  final DateTime createdAt;
  final String? doneDescription;
  final String? donePhotoPath;

  ReportModel({
    required this.id,
    required this.title,
    required this.description,
    required this.photoPath,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.createdAt,
    this.doneDescription,
    this.donePhotoPath,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'photoPath': photoPath,
    'latitude': latitude,
    'longitude': longitude,
    'status': status,
    'createdAt': createdAt.millisecondsSinceEpoch,
    'doneDescription': doneDescription,
    'donePhotoPath': donePhotoPath,
  };

  static ReportModel fromJson(Map<String, dynamic> json, String id) {
    return ReportModel(
      id: id,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      photoPath: json['photoPath'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? 'pending',
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] ?? 0),
      doneDescription: json['doneDescription'],
      donePhotoPath: json['donePhotoPath'],
    );
  }
}