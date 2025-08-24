class Job {
  final String id;
  final String title;
  final String description;
  final String location;
  final String createdBy;
  final List<Map<String, dynamic>> applicants;

  Job({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.createdBy,
    required this.applicants,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'location': location,
      'createdBy': createdBy,
      'applicants': applicants,
    };
  }

  factory Job.fromMap(String id, Map<String, dynamic> map) {
    return Job(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      location: map['location'] ?? '',
      createdBy: map['createdBy'] ?? '',
      applicants: (map['applicants'] as List<dynamic>?)?.map((e) => Map<String, dynamic>.from(e as Map)).toList() ?? [],
    );
  }
}
