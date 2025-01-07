class Theme {
  final String id;
  final String name;
  final String description;

  Theme({
    required this.id,
    required this.name,
    required this.description,
  });

  factory Theme.fromFirestore(Map<String, dynamic> data, String id) {
    return Theme(
      id: id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
    );
  }
}